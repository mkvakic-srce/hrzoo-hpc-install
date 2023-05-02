# source
# - https://github.com/horovod/horovod/blob/master/examples/pytorch/pytorch_synthetic_benchmark.py

import argparse
import torch.backends.cudnn as cudnn
import torch.nn.functional as F
import torch.optim as optim
import torch.utils.data.distributed
from torchvision import models

import sys
import time
import numpy as np

# Benchmark settings
parser = argparse.ArgumentParser(description='PyTorch Synthetic Benchmark',
                                 formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("-i",
                    "--images",
                    type=int,
                    help="image number",
                    default=1024)
parser.add_argument('--batch_size',
                    type=int,
                    default=32,
                    help='input batch size')
parser.add_argument("-e",
                    "--epochs",
                    type=int,
                    help="epochs",
                    default=1)
parser.add_argument('--model',
                    type=str,
                    default='resnet50',
                    help='model to benchmark')
args = parser.parse_args()

# model
model = getattr(models, args.model)()
model.cuda()

lr_scaler = 1
optimizer = optim.SGD(model.parameters(), lr=0.01 * lr_scaler)

cudnn.benchmark = True

# data
data = torch.randn(args.batch_size, 3, 224, 224)
target = torch.LongTensor(args.batch_size).random_() % 1000
data, target = data.cuda(), target.cuda()

# fit
def benchmark_step():
    optimizer.zero_grad()
    output = model(data)
    loss = F.cross_entropy(output, target)
    loss.backward()
    optimizer.step()
    return loss.item()

for epoch in range(args.epochs):
    begin = time.time()
    for batches in range(args.images//args.batch_size):
        loss = benchmark_step()
        if (batches%10 == 0):
            print('--- Epoch %2i, Batch %3i: Loss = %0.2f ---' % (epoch,
                                                                  batches,
                                                                  loss,))
    end = time.time()
    imgsec = args.images//(end-begin)
    print('--- Epoch %2i finished: %0.2f img/sec ---' % (epoch, imgsec))
