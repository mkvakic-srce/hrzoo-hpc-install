#!/bin/bash

#PBS -q gpu
#PBS -l select=64:ncpus=1:mem=10GB
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
mpiexec -np 64 wrf.exe
