#!/bin/bash

#PBS -q gpu
#PBS -l select=32:ngpus=1:ncpus=4
#PBS -e output/
#PBS -o output/
#PBS -M marko.kvakic@srce.hr
#PBS -m bae

# pozovi module
module load scientific/pytorch/1.14.0-ngc

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-""}

# potjeraj skriptu korištenjem torchrun-multinode.sh
torchrun-multinode.sh multigpu-multinode.py
