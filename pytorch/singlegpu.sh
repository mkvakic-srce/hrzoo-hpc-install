#!/bin/bash

#PBS -q gpu
#PBS -l ngpus=1
#PBS -o output/
#PBS -e output/

# pozovi modul
module load scientific/pytorch/1.14.0-ngc

# pomakni se u direktorij gdje se nalazi skripta
cd ${PBS_O_WORKDIR:-""}

# potjeraj skriptu korištenjem run-singlegpu.sh
run-singlegpu.sh singlegpu.py \
  --images 25600 \
  --batch_size 256 \
  --epochs 1
