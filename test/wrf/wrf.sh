#!/bin/bash

#PBS -q cpu
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
time mpiexec -np $( wc -l < $PBS_NODEFILE ) wrf.exe
