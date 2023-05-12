#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# exit if no file given
if [ $# -eq 0  ]; then
  echo "[$(date +%d-%m-%Y' '%H:%M:%S)] ray-launcher.sh: no arguments given"
  exit 1
else
  # environment
  module load cray-pals

  # mpiexec
  echo "[$(date +%d-%m-%Y' '%H:%M:%S)] ray-launcher.sh: launching"
  mpiexec -np $(wc -l < $PBS_NODEFILE) ./ray-cluster.sh $@
fi
