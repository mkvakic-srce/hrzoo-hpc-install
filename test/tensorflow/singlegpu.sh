#!/bin/bash

#PBS -q gpu
#PBS -l select=1:ncpus=32:ngpus=1:mem=10GB
#PBS -o output/
#PBS -e output/

# pozovi modul
module load scientific/tensorflow/2.11.0-ngc

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-""}

# potjeraj skriptu
../../run-singlenode.sh singlegpu.py \
      --batch-size 256 \
      --num-warmup-batches 10 \
      --num-batches-per-iter 10 \
      --num-iters 10
