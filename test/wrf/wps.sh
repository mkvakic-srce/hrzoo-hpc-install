#!/bin/bash

#PBS -q cray_cpu
#PBS -l nodes=1:ppn=1
#PBS -l mem=32GB
#PBS -l walltime=60
#PBS -o output/
#PBS -e output/

module use --append /apps/modulefiles/libs
module load wrf

echo "Hello world"
