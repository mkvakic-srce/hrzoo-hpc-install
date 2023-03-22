#!/bin/bash

#PBS -q cray_cpu
#PBS -l select=1:ncpus=1:mem=20GB
#PBS -l walltime=600
#PBS -o output/
#PBS -e output/

module use /lustre/home/mkvakic/hpc-install/modulefiles
module load scientific/wrf/4.3.3-gnu

# change to working dir
cd $PBS_O_WORKDIR

# real
real.exe
