#!/bin/bash

#PBS -q gpu
#PBS -l select=2:ngpus=2:ncpus=8
#PBS -o output/
#PBS -e output/

# env
module load scientific/pytorch/2.0.0

# cd
cd ${PBS_O_WORKDIR:-""}

# run
accelerate-multinode.sh accelerate-multinode.py
