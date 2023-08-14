#!/bin/bash

#PBS -q gpu
#PBS -l select=1:ncpus=16:ngpus=2:mem=10GB
#PBS -o output/
#PBS -e output/

# pozovi modul
module load scientific/tensorflow/2.10.1-ngc

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-""}

# potjeraj skriptu
run-singlenode.sh multigpu-singlenode.py
