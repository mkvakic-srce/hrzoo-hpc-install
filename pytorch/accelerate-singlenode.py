# source
# - https://github.com/horovod/horovod/blob/master/examples/pytorch/pytorch_synthetic_benchmark.py

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim

from accelerate import Accelerator

from torchvision import models
from torch.utils.data import DataLoader
from torchvision.datasets import FakeData
from torchvision.transforms import ToTensor

import os
import sys
import time
import pprint
import numpy as np

def main():

    # settings
    epochs = 3
    batch_size = 256
    image_number = 256*30
    model = 'resnet50'

    # accelerator
    accelerator = Accelerator()

    # model
    model = getattr(models, model)()
    model.to(accelerator.device)

    # optimizer
    optimizer = optim.SGD(model.parameters(), lr=0.01)
    loss_function = nn.CrossEntropyLoss()

    # loader
    data = FakeData(image_number,
                    num_classes=1000,
                    transform=ToTensor())

    loader = DataLoader(data,
                        batch_size=batch_size)

    # scheduler
    scheduler = optim.lr_scheduler.ExponentialLR(optimizer, gamma=0.9)

    # prepare
    model, optimizer, loader, scheduler = accelerator.prepare(model,
                                                              optimizer,
                                                              loader,
                                                              scheduler)

    # fit
    for epoch in range(epochs):
        start = time.time()
        for batch, (images, labels) in enumerate(loader):
            optimizer.zero_grad()
            images = images.to(accelerator.device)
            labels = labels.to(accelerator.device)
            outputs = model(images)
            classes = torch.argmax(outputs, dim=1)
            loss = loss_function(outputs, labels)
            accelerator.backward(loss)
            optimizer.step()
            scheduler.step()
            if (batch%1 == 0) and ('RANK' not in os.environ or os.environ['RANK'] == '0'):
                print('--- Epoch %2i, Batch %3i: Loss = %0.2f ---' % (epoch, batch, loss,))

        if 'RANK' not in os.environ or os.environ['RANK'] == '0' :
            end = time.time()
            imgsec = image_number/(end-start)
            print('--- Epoch %2i, Finished: %0.2f img/sec ---' % (epoch, imgsec))

if __name__ == '__main__':
    main()
