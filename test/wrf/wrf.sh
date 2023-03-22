#!/bin/bash

#PBS -q cray_cpu
#PBS -l select=16:ncpus=1:mem=1GB
#PBS -l place=free
#PBS -l walltime=20
#PBS -o output/
#PBS -e output/

module load cray-pals
module load scientific/wrf/4.3.3-gnu

# change to working dir
cd $PBS_O_WORKDIR

# real
ln -sf $WRF_HOME/run/*.TBL .
ln -sf $WRF_HOME/run/RRTM* .
ln -sf $WRF_HOME/run/CAMtr_* .
mpiexec -np 16 wrf.exe
