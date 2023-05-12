#!/bin/bash

#PBS -q cpu
#PBS -l select=32:ncpus=1:mem=100GB
#PBS -o output/
#PBS -e output/

module load cray-pals
module load scientific/wrf/4.3.3-gnu

# change to working dir
cd $PBS_O_WORKDIR

# real
mpiexec -np 32 real.exe
