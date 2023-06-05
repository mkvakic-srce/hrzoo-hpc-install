# source
# - https://docs.ray.io/en/latest/train/examples/pytorch/torch_resnet50_example.html#torch-fashion-mnist-ex
# - https://pytorch.org/vision/stable/generated/torchvision.datasets.FakeData.html#torchvision.datasets.FakeData

import os
import sys
import time
import pprint
import argparse
import datetime

from typing import Dict
from ray.air import session

import torch
from torch import nn
from torch.utils.data import DataLoader
from torchvision import datasets
from torchvision.models import resnet50
from torchvision.transforms import ToTensor

import ray.train as train
from ray.train.torch import TorchTrainer
from ray.air.config import ScalingConfig

training_data = datasets.FakeData(
    size=2560,
    transform=ToTensor(),
)

test_data = datasets.FakeData(
    size=256,
    transform=ToTensor(),
)

def train_epoch(dataloader, model, loss_fn, optimizer):
    size = len(dataloader.dataset) // session.get_world_size()
    model.train()
    for batch, (X, y) in enumerate(dataloader):
        # Compute prediction error
        pred = model(X)
        loss = loss_fn(pred, y)

        # Backpropagation
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        if batch % 100 == 0:
            loss, current = loss.item(), batch * len(X)
            print(f"loss: {loss:>7f}  [{current:>5d}/{size:>5d}]")


def validate_epoch(dataloader, model, loss_fn):
    size = len(dataloader.dataset) // session.get_world_size()
    num_batches = len(dataloader)
    model.eval()
    test_loss, correct = 0, 0
    with torch.no_grad():
        for X, y in dataloader:
            pred = model(X)
            test_loss += loss_fn(pred, y).item()
            correct += (pred.argmax(1) == y).type(torch.float).sum().item()
    test_loss /= num_batches
    correct /= size
    print(
        f"Test Error: \n "
        f"Accuracy: {(100 * correct):>0.1f}%, "
        f"Avg loss: {test_loss:>8f} \n"
    )
    return test_loss


def train_func(config: Dict):
    batch_size = config["batch_size"]
    lr = config["lr"]
    epochs = config["epochs"]

    worker_batch_size = batch_size // session.get_world_size()

    # Create data loaders.
    train_dataloader = DataLoader(training_data, batch_size=worker_batch_size)
    test_dataloader = DataLoader(test_data, batch_size=worker_batch_size)

    train_dataloader = train.torch.prepare_data_loader(train_dataloader)
    test_dataloader = train.torch.prepare_data_loader(test_dataloader)

    # Create model.
    model = resnet50()
    model = train.torch.prepare_model(model)

    loss_fn = nn.CrossEntropyLoss()
    optimizer = torch.optim.SGD(model.parameters(), lr=lr)

    loss_results = []

    for _ in range(epochs):
        train_epoch(train_dataloader, model, loss_fn, optimizer)
        loss = validate_epoch(test_dataloader, model, loss_fn)
        loss_results.append(loss)
        session.report(dict(loss=loss))

    # return required for backwards compatibility with the old API
    # TODO(team-ml) clean up and remove return
    return loss_results


def train_resnet50():

    # node & worker info
    resources = ray.cluster_resources()
    gpus = int(resources['GPU'])
    cpus = int(resources['CPU'])
    resources_per_worker = {'GPU': 1,
                            'CPU': (cpus-1)//gpus}

    # scaling_config
    scaling_config = ScalingConfig(use_gpu=True,
                                   num_workers=gpus,
                                   resources_per_worker=resources_per_worker)

    # trainer
    trainer = TorchTrainer(train_func,
                           scaling_config=scaling_config,
                           train_loop_config={"lr": 1e-3,
                                              "epochs": 3,
                                              "batch_size": 256})
    result = trainer.fit()
    print(f"Results: {result.metrics}")


if __name__ == "__main__":
    import ray
    ray.init(address='auto',
             _node_ip_address=os.environ['NODE_IP_ADDRESS'])
    train_resnet50()
