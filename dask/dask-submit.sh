#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# run
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] dask-submit.sh: running on node $(hostname)"
apptainer exec \
    --nv \
    --pwd /host_pwd \
    --bind ${PWD}:/host_pwd \
    $IMAGE_PATH python3 $@
