#!/bin/bash

# compile
# module load craype-x86-milan
# module load PrgEnv-gnu
# module unload gcc
# module load gcc/10.3.0

# mkdir
sudo mkdir -p /apps/libs/numactl
sudo chown -R mkvakic:hpc /apps/libs/numactl

# wget
wget -nc https://github.com/numactl/numactl/releases/download/v2.0.12/numactl-2.0.12.tar.gz
tar xf numactl-2.0.12.tar.gz --keep-old-files

# configure, make
cd numactl-2.0.12/
./configure --prefix /apps/libs/numactl/2.0.12-gnu 2>&1 | tee config.out
make
make install
