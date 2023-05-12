#!/bin/bash

#PBS -q gpu
#PBS -l select=1:ncpus=32:ngpus=1:mem=10GB
#PBS -o output/
#PBS -e output/

# pozovi modul
module load scientific/tensorflow/2.10.1-ngc

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-""}

# potjeraj skriptu
run-singlenode.sh benchmark.py \
      --strategy 1 \
      --images $((256*10)) \
      --batch_size 256 \
      --epochs 10
