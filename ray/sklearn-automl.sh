#!/bin/bash

#PBS -l select=12:ngpus=1:ncpus=4
#PBS -e output/
#PBS -o output/

# environment
module load scientific/ray/2.4.0-rayproject

# cd
cd ${PBS_O_WORKDIR:-""}

# run
ray-launcher.sh sklearn-automl.py
