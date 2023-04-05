#!/bin/bash

#PBS -q gpu
#PBS -l select=1:ncpus=32:ngpus=2
#PBS -o output/
#PBS -e output/

# pozovi modul
module use ../../modulefiles
module load scientific/pytorch/1.14.0-ngc

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-""}

# potjeraj skriptu
apptainer exec \
  --nv \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  $( echo $IMAGE_PATH ) python3 multigpu-singlenode.py \
    --images 10240 \
    --batch_size 256 \
    --epochs 5
