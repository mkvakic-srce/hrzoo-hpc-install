#!/bin/bash

#PBS -q gpu
#PBS -l select=1:ncpus=32:ngpus=4:mem=10GB
#PBS -o output/
#PBS -e output/

# pozovi modul
module load scientific/tensorflow/2.10.1-ngc

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-""}

# potjeraj skriptu
run-singlenode.sh benchmark.py \
      --strategy 2 \
      --images 10240 \
      --batch_size 512 \
      --epochs 10 \
      --use_fp16
