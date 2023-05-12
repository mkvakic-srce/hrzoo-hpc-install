#!/bin/bash

#PBS -l select=1:mpiprocs=2:ncpus=4+4:ngpus=1:ncpus=8:mem=16GB

# environment
module use /lustre/home/mkvakic/hpc-install/modulefiles
module load scientific/ray/2.3.1-rayproject

# cd
cd ${PBS_O_WORKDIR:-""}

# run
./ray-launcher.sh pytorch.py -n 4 --use-gpu True
