#!/bin/bash

#PBS -q cray_cpu
#PBS -l select=2:ncpus=8:mem=10GB
#PBS -l walltime=10
#PBS -o output/
#PBS -e output/

module load cray-pals
module load scientific/cp2k/2022.1-gnu

mpiexec -np 2 --ppn 8 cp2k.psmp -i $PBS_O_WORKDIR/H2O-64.inp
