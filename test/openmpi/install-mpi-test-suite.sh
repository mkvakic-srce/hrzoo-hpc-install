#!/bin/bash

# module
module use ../../modulefiles
module load utils/gengetopt
module load utils/openmpi

# clone
git clone https://github.com/open-mpi/mpi-test-suite

# configure
cd mpi-test-suite
./autogen.sh
./configure CC=mpicc
make all
