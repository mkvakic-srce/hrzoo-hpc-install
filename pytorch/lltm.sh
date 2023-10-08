#!/bin/bash

#PBS -l ngpus=1
#PBS -l ncpus=8

module load scientific/pytorch/2.0.0-ngc

cd ${PBS_O_WORKDIR:-""}

export MAX_JOBS=${NCPUS}

run-singlegpu.sh lltm.py
