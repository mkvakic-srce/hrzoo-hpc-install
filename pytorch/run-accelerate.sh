#!/bin/bash

#PBS -q gpu
#PBS -l select=2:ngpus=1:ncpus=8
#PBS -o output/
#PBS -e output/

# env
module load scientific/pytorch/1.14.0-ngc

# cd
cd ${PBS_O_WORKDIR:-""}

# run
# run-command.sh \
#   accelerate launch \
#     --num_cpu_threads_per_process 4 \
#     run-accelerate.py
run-command.sh pip list | grep accel
