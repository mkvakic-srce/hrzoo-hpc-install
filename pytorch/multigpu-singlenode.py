# source
# - https://pytorch.org/tutorials/intermediate/dist_tuto.html
# - https://pytorch.org/vision/main/generated/torchvision.datasets.FakeData.html
# - https://tuni-itc.github.io/wiki/Technical-Notes/Distributed_dataparallel_pytorch/#setting-up-the-same-model-with-distributeddataparallel

import time

import torch
import torch.nn as nn
import torch.optim as optim
import torch.distributed as dist

from torch.utils.data import DataLoader
from torch.utils.data.distributed import DistributedSampler
from torch.nn.parallel import DistributedDataParallel

from torchvision.models import resnet50
from torchvision.datasets import FakeData
from torchvision.transforms import ToTensor

def main():

    # vars
    batch = 256
    samples = 25600
    epochs = 1

    # init
    dist.init_process_group("nccl")
    rank = dist.get_rank()
    ngpus = torch.cuda.device_count()

    # model
    model = resnet50(weights=None)
    model = model.to(rank)
    model = DistributedDataParallel(model,
                                    device_ids=[rank])
    optimizer = optim.SGD(model.parameters(),
                          lr=0.001)
    loss_fn = nn.CrossEntropyLoss()

    # data
    dataset = FakeData(samples,
                       num_classes=1000,
                       transform=ToTensor())
    sampler = DistributedSampler(dataset)
    loader = DataLoader(dataset,
                        batch_size=batch,
                        sampler=sampler,
                        shuffle=False,
                        num_workers=2,
                        pin_memory=True,)

    # train
    for epoch in range(epochs):
        start = time.time()
        for batch, (images, labels) in enumerate(loader):
            images = images.to(rank)
            labels = labels.to(rank)
            outputs = model(images)
            classes = torch.argmax(outputs, dim=1)
            loss = loss_fn(outputs, labels)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()
            if (rank == 0) and (batch%10 == 0):
                print('--- Epoch %i, Batch %i/%i, Loss = %0.2f ---' % (epoch,
                                                                       batch,
                                                                       len(loader),
                                                                       loss.item()))
        if (rank == 0):
            elapsed = time.time()-start
            imgsec = samples/elapsed
            print('--- Epoch %i finished: %0.2f img/sec ---' % (epoch,
                                                                imgsec))

    # clean
    dist.destroy_process_group()

if __name__ == "__main__":
    main()
