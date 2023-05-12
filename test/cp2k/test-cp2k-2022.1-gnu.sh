#!/bin/bash

#PBS -q cray_cpu
#PBS -l select=4:ncpus=8:mem=10GB
#PBS -l walltime=1000
#PBS -o output/
#PBS -e output/

module load cray-pals
module load scientific/cp2k/2022.1-gnu

mpiexec -n 4 cp2k.psmp -i $PBS_O_WORKDIR/H2O-64.inp
# mpiexec -np 32 --ppn 8 cp2k.psmp -i $PBS_O_WORKDIR/H2O-64.inp
