#!/bin/bash

#PBS -q gpu
#PBS -l select=2:ngpus=2:ncpus=8
#PBS -l place=scatter

# pozovi module
module load scientific/pytorch/2.0.0-ngc

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-""}

# potjeraj skriptu korištenjem torchrun-multinode.sh
export PATH=${PWD}:${PATH}
distributed-multinode.sh multigpu-multinode.py
