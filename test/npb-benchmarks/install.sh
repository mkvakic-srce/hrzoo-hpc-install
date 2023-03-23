#!/bin/bash

# module
module load craype-x86-milan
module load PrgEnv-gnu
module unload gcc
module load gcc/10.3.0

# clone
wget -nc https://www.nas.nasa.gov/assets/npb/NPB3.4.2.tar.gz
tar xf NPB3.4.2.tar.gz --keep-old-files

# cd, configure
cd NPB3.4.2/NPB3.4-MPI
cp config/NAS.samples/make.def.gcc_mpich config/make.def
sed -i "s|FFLAGS	= -O3|FFLAGS  = -fallow-argument-mismatch -O3|g" config/make.def
make veryclean
make lu NPROCS=64 CLASS="D"
