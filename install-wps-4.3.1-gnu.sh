#!/bin/bash


# compile
module purge
module load zlib
module load libpng
module load jasper
module load craype-x86-milan
module load PrgEnv-gnu
module unload gcc
module load gcc/11.2.0
module load cray-netcdf
module load cray-hdf5

# mkdir
sudo mkdir -p /apps/scientific/wps
sudo chown -R mkvakic:hpc /apps/scientific/wps

# cd, clone
cd /apps/scientific/wps
git clone -b v4.3.1 --recursive https://github.com/wrf-model/WPS 4.3.1-gnu

# WPS
cd 4.3.1-gnu
./clean -aa
export WRF_DIR="../../wrf/4.3.3-gnu"
export NETCDF=$NETCDF_DIR
printf "%s\n" 3 | ./configure
sed -i "s|COMPRESSION_LIBS    =|COMPRESSION_LIBS    = -L${LIBPNGLIB} |g" configure.wps
sed -i "s|COMPRESSION_INC     =|COMPRESSION_INC     = -I${LIBPNGINC} |g" configure.wps
./compile

# WPS_GEOG
wget -nc https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
tar xf geog_high_res_mandatory.tar.gz --keep-old-files
