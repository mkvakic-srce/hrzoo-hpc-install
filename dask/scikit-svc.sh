#!/bin/bash

#PBS -l select=4:ncpus=4
#PBS -l place=scatter

# environment
module load scientific/dask/2023.7.0-ghcr

# cd
cd ${PBS_O_WORKDIR:-""}

# run
dask-launcher.sh scikit-svc.py
