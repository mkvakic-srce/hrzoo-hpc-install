#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# sleep
sleep $((PALS_RANKID*SLEEP_DT))

# CUDA_VISIBLE_DEVICES
ndevice=$( [[ PALS_NODEID -eq 0 ]] && echo $((PALS_LOCAL_RANKID-1)) || echo $((PALS_LOCAL_RANKID+1)) )
export CUDA_VISIBLE_DEVICES=$(egrep -o 'GPU-[a-z0-9-]{1,}' $PBS_NODEFILE.env | sed "${ndevice}q;d")

# worker
export RAY_ADDRESS=$( cat $RAY_TMPDIR/ray/ray_current_cluster )
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] ray-worker.sh: starting on rank $PALS_RANKID - $CUDA_VISIBLE_DEVICES"
apptainer exec \
  --nv \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  $IMAGE_PATH ray start \
    --block \
    --num-cpus 8 \
    --log-style=record \
    --address $RAY_ADDRESS > $RAY_LOG_PATH 2>&1
