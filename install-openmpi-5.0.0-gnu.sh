#!/bin/bash

# compile
module purge
module load craype-x86-milan
module load PrgEnv-gnu
module unload gcc
module load gcc/11.2.0

# mkdir
sudo mkdir -p /apps/utils/openmpi
sudo chown -R mkvakic:hpc /apps/utils/openmpi

# wget
wget -nc https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.0rc10.tar.bz2
tar xf openmpi-5.0.0rc10.tar.bz2 --keep-old-files

# configure, make
cd openmpi-5.0.0rc10
./configure --prefix /apps/utils/openmpi/5.0.0rc10-gnu 2>&1 | tee config.out
make -j 64 all 2>&1 | tee make.out
make -j 64 install 2>&1 | tee install.out
