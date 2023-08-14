#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# dask log path
export DASK_LOG_PATH="${PBS_JOBID}-dask-node${PALS_NODEID}.log"

# node ip address
export NODE_IP_ADDRESS=$(ip -f inet addr show $SCHEDULER_INTERFACE | egrep -m 1 -o 'inet [0-9.]{1,}' | sed 's/inet //')

# CUDA_VISIBLE_DEVICES
export CUDA_VISIBLE_DEVICES=$(grep CUDA_VISIBLE_DEVICES 2>/dev/null < $PBS_NODEFILE.env | sed 's/CUDA_VISIBLE_DEVICES=//g')

# node sleep
sleep $((SLEEP_DT*PALS_NODEID))

# scheduler & submit
if [ $PALS_NODEID -eq 0 ]; then
  dask-scheduler.sh &
  dask-submit.sh $@ &
fi

# workers (depending on GPU)
if [ -z $CUDA_VISIBLE_DEVICES ]; then
  dask-worker.sh &
else
  for device in $(tr ',' '\n' <<< $CUDA_VISIBLE_DEVICES); do
    device_id=$(nvidia-smi -L | grep $device | egrep -o 'GPU [0-3]' | sed 's/GPU //g')
    CUDA_VISIBLE_DEVICES=$device_id dask-worker.sh &
  done
fi
