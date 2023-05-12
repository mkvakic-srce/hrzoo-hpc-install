#!/bin/bash

# module
module load craype-x86-milan
module load PrgEnv-cray

# clone
wget -nc https://www.nas.nasa.gov/assets/npb/NPB3.4.2.tar.gz
tar xf NPB3.4.2.tar.gz --keep-old-files
cp -r NPB3.4.2 NPB3.4.2-cray

# cd, configure
cd NPB3.4.2-cray/NPB3.4-MPI
cp config/make.def.template config/make.def
sed -i "s|^FMPI_LIB *=|FMPI_LIB = -L${CRAY_MPICH_DIR}/lib -lmpi|g" config/make.def
sed -i "s|^FMPI_INC *=|FMPI_INC = -L${CRAY_MPICH_DIR}/include|g" config/make.def
make lu NPROCS=256 CLASS="D"
make lu NPROCS=256 CLASS="B"
make bt NPROCS=256 CLASS="D"
make cg NPROCS=256 CLASS="D"
