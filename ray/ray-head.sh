#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# head
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] ray-head.sh: starting on node $(hostname)"
apptainer exec \
    --nv \
    --pwd /host_pwd \
    --bind ${PWD}:/host_pwd \
    $IMAGE_PATH ray start \
        --head \
        --block \
        --num-cpus=$((NCPUS+1)) \
        --num-gpus=$(grep -o GPU <<< $CUDA_VISIBLE_DEVICES | wc -l) \
        --include-dashboard=False \
        --node-ip-address=${HEAD_IP_ADDRESS} \
        --port=${HEAD_PORT} \
        --ray-client-server-port=${RAY_CLIENT_SERVER_PORT} \
        --min-worker-port=${RAY_MIN_WORKER_PORT} \
        --max-worker-port=${RAY_MAX_WORKER_PORT} \
        --log-style=record > $RAY_LOG_PATH 2>&1
