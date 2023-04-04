#!/bin/bash

# compile
module purge
module load libs/zlib
module load libs/jasper
module load libs/libpng
module load craype-x86-milan
module load PrgEnv-gnu
module swap gcc/12.1.0 gcc/11.2.0
module load cray-hdf5
module load cray-netcdf

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
printf "%s\n" 35 1 | ./configure
sed -i 's|^SFC.*|SFC             =       ftn|g' configure.wrf
sed -i 's|^SCC.*|SCC             =       cc|g' configure.wrf
./compile -j 32 em_real
