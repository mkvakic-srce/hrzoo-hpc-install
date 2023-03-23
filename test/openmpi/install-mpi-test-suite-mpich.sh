#!/bin/bash

# module
module use ../../modulefiles
module load utils/gengetopt
module load PrgEnv-gnu
module unload gcc
module load gcc/10.3.0

# clone
git clone https://github.com/open-mpi/mpi-test-suite mpi-test-suite-mpich

# configure
cd mpi-test-suite-mpich
./autogen.sh
./configure CC=mpicc
make clean
make all
