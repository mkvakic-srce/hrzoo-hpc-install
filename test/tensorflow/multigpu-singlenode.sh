#!/bin/bash

#PBS -q gpu
#PBS -l select=1:ncpus=8:ngpus=1:mem=10GB
#PBS -o output/
#PBS -e output/

# pozovi modul
module load scientific/tensorflow/2.10.1-ngc

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-""}

# potjeraj skriptu
batch_size=256
run-singlenode.sh benchmark.py \
      --strategy 2 \
      --images $((256*10)) \
      --batch_size $batch_size \
      --epochs 10 
echo "batch_size: $batch_size"
