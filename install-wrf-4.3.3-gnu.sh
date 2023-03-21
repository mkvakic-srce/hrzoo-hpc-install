#!/bin/bash

# compile
module purge
module load zlib
module load jasper
module load libpng
module load craype-x86-milan
module load PrgEnv-gnu
module unload gcc
module load gcc/11.2.0
module load cray-netcdf
module load cray-hdf5

# mkdir
sudo mkdir -p /apps/scientific/wrf
sudo chown -R mkvakic:hpc /apps/scientific/wrf

# cd, clone
cd /apps/scientific/wrf
git clone -b v4.3.3 --recursive https://github.com/wrf-model/WRF 4.3.3-gnu

# WRF
cd 4.3.3-gnu
export HDF5=$HDF5_DIR
export NETCDF=$NETCDF_DIR
./clean -aa
printf "%s\n" 34 1 | ./configure
./compile -j 16 em_real
