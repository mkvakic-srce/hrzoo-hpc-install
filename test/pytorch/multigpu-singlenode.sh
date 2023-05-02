#!/bin/bash

#PBS -q gpu
#PBS -l ngpus=4
#PBS -l ncpus=16
#PBS -o output/
#PBS -e output/

# pozovi modul
module load scientific/pytorch/1.14.0-ngc

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-""}

# potjeraj skriptu korištenjem torchrun-singlenode.sh
torchrun-singlenode.sh multigpu-singlenode.py
