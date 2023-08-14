#!/bin/bash

#PBS -q gpu
#PBS -l select=2:ncpus=8:ngpus=2:mem=10GB
#PBS -l place=free
#PBS -o output/
#PBS -e output/

# pozovi modul
module load scientific/tensorflow/2.10.1-ngc

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-""}

# potjeraj skriptu
run-multinode.sh multigpu-multinode.py
