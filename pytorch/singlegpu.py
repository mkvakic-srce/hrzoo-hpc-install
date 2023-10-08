# source
# - https://github.com/horovod/horovod/blob/master/examples/pytorch/pytorch_synthetic_benchmark.py

import os
import time

import torch
import torch.nn as nn
import torch.optim as optim

from torch.utils.data import DataLoader

from torchvision.models import resnet50
from torchvision.datasets import FakeData
from torchvision.transforms import ToTensor

def main():

    # vars
    batch = 256
    samples = 256*100
    epochs = 1

    # model
    model = resnet50(weights=None)
    model.cuda()
    optimizer = optim.SGD(model.parameters(), lr=0.001)
    loss_fn = nn.CrossEntropyLoss()

    # data
    dataset = FakeData(samples,
                       num_classes=1000,
                       transform=ToTensor())
    loader = DataLoader(dataset,
                        batch_size=batch,
                        shuffle=False,
                        num_workers=1,
                        pin_memory=True)

    # train
    for epoch in range(epochs):
        start = time.time()
        for batch, (images, labels) in enumerate(loader):
            images = images.cuda()
            labels = labels.cuda()
            outputs = model(images)
            classes = torch.argmax(outputs, dim=1)
            loss = loss_fn(outputs, labels)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
            if (batch%10 == 0):
                print('--- Epoch %i, Batch %3i / 3%i, Loss = %0.2f ---' % (epoch,
                                                                           batch,
                                                                           len(loader),
                                                                           loss.item()))
        elapsed = time.time()-start
        imgsec = samples/elapsed
        print('--- Epoch %i finished: %0.2f img/sec ---' % (epoch,
                                                            imgsec))

if __name__ == "__main__":
    main()
