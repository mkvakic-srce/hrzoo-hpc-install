#!/bin/bash

#PBS -q cray_cpu
#PBS -l nodes=1:ppn=8
#PBS -l mem=32GB
#PBS -l walltime=60
#PBS -o output/
#PBS -e output/

# module
module purge
module load craype-x86-milan
module load PrgEnv-gnu
module load cray-pals
module load cp2k/2022.1-gnu
module list

echo "Hello world"
# export NSLOTS=$( wc -l < $PBS_NODEFILE )
# mpiexec -n $NSLOTS echo "Hello"
