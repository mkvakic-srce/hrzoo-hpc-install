#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# scheduler
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] dask-scheduler.sh: starting on node $(hostname)"
apptainer exec \
    --nv \
    --pwd /host_pwd \
    --bind ${PWD}:/host_pwd \
    $IMAGE_PATH dask scheduler \
        --host $SCHEDULER_IP \
        --port $SCHEDULER_PORT \
        --protocol $SCHEDULER_PROTOCOL \
        --no-dashboard \
        --no-jupyter \
        --no-show \
        > ${DASK_LOG_PATH//.log/-scheduler.log} 2>&1
