#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# worker
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] ray-worker.sh: starting on node $(hostname)"
apptainer exec \
    --nv \
    --pwd /host_pwd \
    --bind ${PWD}:/host_pwd \
    $IMAGE_PATH ray start \
    --block \
    --num-cpus=${NCPUS} \
    --num-gpus=$(grep -o GPU <<< $CUDA_VISIBLE_DEVICES | wc -l) \
    --node-ip-address=${NODE_IP_ADDRESS} \
    --log-style=record \
    --address=$RAY_ADDRESS > $RAY_LOG_PATH 2>&1
