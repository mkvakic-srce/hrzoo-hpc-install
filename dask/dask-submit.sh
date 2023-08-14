#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# sleep until others wake up
nnodes=$(sort -u $PBS_NODEFILE | wc -l)
sleep $((SLEEP_DT*(nnodes+1)))

# run
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] dask-submit.sh: running on node $(hostname)"
apptainer exec \
    --nv \
    --pwd /host_pwd \
    --bind ${PWD}:/host_pwd \
    $IMAGE_PATH python3 $@

# kill scheduler
pkill -f 'dask scheduler'
