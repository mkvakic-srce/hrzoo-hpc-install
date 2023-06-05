#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# ray log path
export RAY_LOG_PATH="${PBS_JOBID}-ray-${PALS_NODEID}.log"

# node ip address
export NODE_IP_ADDRESS=$(ip -f inet addr show hsn0 | egrep -m 1 -o 'inet [0-9.]{1,}' | sed 's/inet //')

# CUDA_VISIBLE_DEVICES
export CUDA_VISIBLE_DEVICES=$(grep CUDA_VISIBLE_DEVICES < $PBS_NODEFILE.env | sed 's/CUDA_VISIBLE_DEVICES=//g')

# cluster
sleep $((SLEEP_DT*PALS_NODEID))
case $PALS_NODEID in
  0) 
    ray-head.sh &
    ray-submit.sh $@
    ;;
  *)
    ray-worker.sh &
    ;;
esac
