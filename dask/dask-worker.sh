#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# log path extension for gpu
log_ext=$( [ -z $CUDA_VISIBLE_DEVICES ] && echo "" || echo "-gpu${CUDA_VISIBLE_DEVICES}")

# worker
gpu_message=$( [ ! -z $CUDA_VISIBLE_DEVICES ] && echo "gpu ${CUDA_VISIBLE_DEVICES}" )
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] dask-worker.sh: starting on node $(hostname) ${gpu_message}"
nworkers=$( [ -z $CUDA_VISIBLE_DEVICES ] && echo ${NCPUS} || echo 1 )
nthreads=$( [ -z $CUDA_VISIBLE_DEVICES ] && echo 1 || echo ${NCPUS} )
apptainer exec \
    --nv \
    --pwd /host_pwd \
    --bind ${PWD}:/host_pwd \
    $IMAGE_PATH dask worker \
        --no-dashboard \
        --nworkers $nworkers \
        --nthreads $nthreads \
        "${SCHEDULER_IP}:${SCHEDULER_PORT}" \
        > ${DASK_LOG_PATH//.log/-worker${log_ext}.log} 2>&1
