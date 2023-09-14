#!/bin/bash

#PBS -l select=2:ngpus=2:ncpus=16
#PBS -e output/
#PBS -o output/

# environment
module load scientific/ray/2.4.0-rayproject

# cd
cd ${PBS_O_WORKDIR:-""}

# run
ray-launcher.sh tune-tensorflow.py
