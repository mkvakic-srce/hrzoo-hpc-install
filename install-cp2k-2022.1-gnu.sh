#!/bin/bash

# module
module purge
module load cmake
module load craype-x86-milan
module load PrgEnv-gnu
module load cray-fftw
module unload gcc
module load gcc/11.2.0

# mkdir & cd
# sudo mkdir -p /apps/cp2k
cd /apps/cp2k

# wget, tar & cd
git clone -b support/v2022.1 --recursive https://github.com/cp2k/cp2k.git 2022.1-gnu
cd 2022.1-gnu

# toolchain
cd tools/toolchain
./install_cp2k_toolchain.sh -j 16 \
  --mpi-mode=mpich \
  --math-mode=cray \
  --gpu-ver=no \
  --libint-lmax=5 \
  --with-cmake=system \
  --with-elpa=no \
  --with-gsl=no \
  --with-spglib=no \
  --with-sirius=no
cd -

# make
cp tools/toolchain/install/arch/* arch/.
source tools/toolchain/install/setup
make -j 16 ARCH=local VERSION="psmp" clean
make -j 16 ARCH=local VERSION="psmp"
