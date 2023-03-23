#!/bin/bash

# mkdir
sudo mkdir -p /apps/libs/numactl
sudo chown -R mkvakic:hpc /apps/libs/numactl

# wget
wget -nc https://github.com/numactl/numactl/releases/download/v2.0.16/numactl-2.0.16.tar.gz
tar xf numactl-2.0.16.tar.gz --keep-old-files

# configure, make
cd numactl-2.0.16/
./configure --prefix /apps/libs/numactl/2.0.16-gnu 2>&1 | tee config.out
make
make install
