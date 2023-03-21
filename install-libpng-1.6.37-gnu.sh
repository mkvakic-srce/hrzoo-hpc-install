#!/bin/bash


# module
module purge
module load zlib
module load craype-x86-milan
module load PrgEnv-gnu

# mkdir & cd
sudo mkdir -p /apps/libs/libpng
sudo chown mkvakic:hpc /apps/libs/libpng

# cd, wget, tar, cd
wget -nc https://github.com/glennrp/libpng/archive/refs/tags/v1.6.37.tar.gz
tar xf v1.6.37.tar.gz --keep-old-files
cd libpng-1.6.37

# configure, make, install
./configure --prefix /apps/libs/libpng/1.6.37-gnu
make clean
make check
make install
