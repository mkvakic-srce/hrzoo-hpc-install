#!/bin/bash

#PBS -l select=1:ngpus=2:ncpus=2
#PBS -l place=scatter

# environment
module load scientific/dask/2023.7.0-ghcr

# cd
cd ${PBS_O_WORKDIR:-""}

# run
export TF_FORCE_GPU_ALLOW_GROWTH="true"
dask-launcher.sh tensorflow-scikeras.py
