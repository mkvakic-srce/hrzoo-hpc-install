#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# log path extension for gpu
log_ext=$( [ -z $CUDA_VISIBLE_DEVICES ] && echo "" || echo "-gpu${CUDA_VISIBLE_DEVICES}")

# nworkers, nthreads
nworkers=$( [ -z $CUDA_VISIBLE_DEVICES ] && echo ${NCPUS} || echo 1 )
nthreads=$( [ -z $CUDA_VISIBLE_DEVICES ] && echo 1 || echo ${NCPUS} )

# memory
job_nodect=$(qstat -f ${PBS_JOBID} | grep Resource_List.nodect | egrep -o '[0-9]+')
job_mem=$(qstat -f ${PBS_JOBID} | grep Resource_List.mem | egrep -o '[0-9]+')
memory_per_node=$(echo "scale=2;(${job_mem}-5)/${job_nodect}" | bc)
memory_per_worker=$([ -z $job_mem ] && echo 2 || echo "scale=2;${memory_per_node}/${nworkers}" | bc)

# worker
gpu_message=$( [ ! -z $CUDA_VISIBLE_DEVICES ] && echo "gpu ${CUDA_VISIBLE_DEVICES}" )
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] dask-worker.sh: starting on node $(hostname) ${gpu_message}"
apptainer exec \
    --nv \
    --pwd /host_pwd \
    --bind ${PWD}:/host_pwd \
    $IMAGE_PATH dask worker \
        --no-dashboard \
        --nworkers ${nworkers} \
        --nthreads ${nthreads} \
        --memory-limit "${memory_per_worker} GiB" \
        "${SCHEDULER_IP}:${SCHEDULER_PORT}" \
        > ${DASK_LOG_PATH//.log/-worker${log_ext}.log} 2>&1
