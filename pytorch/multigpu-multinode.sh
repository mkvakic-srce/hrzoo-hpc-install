#!/bin/bash

#PBS -q gpu
#PBS -l select=8:ngpus=1:ncpus=4

# pozovi module
module load scientific/pytorch/1.14.0-ngc
module load cray-pals

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-""}

# potjeraj skriptu korištenjem torchrun-multinode.sh
mpiexec --cpu-bind none torchrun-multinode.sh multigpu-multinode.py
