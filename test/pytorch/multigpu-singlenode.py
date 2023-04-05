# source
# - https://github.com/horovod/horovod/blob/master/examples/pytorch/pytorch_synthetic_benchmark.py
# - https://pytorch.org/tutorials/intermediate/dist_tuto.html

import argparse
import torch.backends.cudnn as cudnn
import torch.nn.functional as F
import torch.optim as optim
import torch.utils.data.distributed
from torchvision import models
import torch.multiprocessing as mp

import sys
import time
import numpy as np

# set up mp
size = os.environ('CUDA_VISIBLE_DEVICES')
print(size)
sys.exit('--- exiting on 20 ---')

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
                    default=10)
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

for epoch in range(args.epochs):
    begin = time.time()
    for batches in range(args.images//args.batch_size):
        benchmark_step()
    end = time.time()
    imgsec = args.images//(end-begin)
    print('--- Epoch %i: %0.2f img/sec ---' % (epoch, imgsec))
