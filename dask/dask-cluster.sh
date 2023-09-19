#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# dask log path
export DASK_LOG_PATH="${PBS_JOBID}-dask-node${PALS_NODEID}.log"

# node ip address
export NODE_IP_ADDRESS=$(ip -f inet addr show $SCHEDULER_INTERFACE | egrep -m 1 -o 'inet [0-9.]{1,}' | sed 's/inet //')

# CUDA_VISIBLE_DEVICES
export CUDA_VISIBLE_DEVICES=$(grep CUDA_VISIBLE_DEVICES 2>/dev/null < $PBS_NODEFILE.env | sed 's/CUDA_VISIBLE_DEVICES=//g')

# sleep
sleep $((SLEEP_DT*PALS_RANKID))

# scheduler and submit rank
scheduler_rank=0
submit_rank=$((PMI_SIZE-1))

# ranks
case $PALS_RANKID in
  $scheduler_rank)
    dask-scheduler.sh
    ;;
  $submit_rank)
    dask-submit.sh $@
    ;;
  *)
    if [ -z $CUDA_VISIBLE_DEVICES ]; then
      dask-worker.sh
    else
      CUDA_VISIBLE_DEVICES=( $( egrep -o 'GPU-[a-z0-9\-]+' ${PBS_NODEFILE}.env ) )
      array_id=$( [ $PALS_NODEID -eq 0 ] && echo $((PALS_LOCAL_RANKID-1)) || echo ${PALS_LOCAL_RANKID} )
      device=${CUDA_VISIBLE_DEVICES[$array_id]}
      device_id=$(nvidia-smi -L | grep $device | egrep -o 'GPU [0-3]' | sed 's/GPU //g')
      CUDA_VISIBLE_DEVICES=$device_id dask-worker.sh
    fi
    ;;
esac
