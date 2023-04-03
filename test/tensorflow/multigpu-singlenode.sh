#!/bin/bash

#PBS -q gpu
#PBS -l select=1:ncpus=32:ngpus=1:mem=10GB
#PBS -o output/
#PBS -e output/

# pozovi modul
module use /lustre/home/mkvakic/hpc-install/modulefiles
module load scientific/tensorflow/2.11.0-ngc

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-"${PWD}"}

# potjeraj skriptu
apptainer exec \
  --nv \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  tensorflow_22.02-tf2-py3.sif \
    python3 multigpu-singlenode.py \
      --batch-size 256 \
      --num-warmup-batches 10 \
      --num-batches-per-iter 10 \
      --num-iters 10
