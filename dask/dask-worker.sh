#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# sleep additionally because worker needs to be on the scheduler node too
sleep $SLEEP_DT

# log path extension for gpu
log_ext=$( [ -z $CUDA_VISIBLE_DEVICES ] && echo "" || echo "-gpu${CUDA_VISIBLE_DEVICES}")

# worker
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] dask-worker.sh: starting on node $(hostname)"
nworkers=1
nthreads=$( [ -z $CUDA_VISIBLE_DEVICES ] && echo $NCPUS || echo 1 )
apptainer exec \
    --nv \
    --pwd /host_pwd \
    --bind ${PWD}:/host_pwd \
    $IMAGE_PATH dask worker \
        --no-dashboard \
        --nworkers 1 \
        --nthreads $nthreads \
        "${SCHEDULER_IP}:${SCHEDULER_PORT}" \
        > ${DASK_LOG_PATH//.log/-worker${log_ext}.log} 2>&1
