#!/bin/bash

# uuids to device numbers & ngpus
device_ids=""
for device in $(echo $CUDA_VISIBLE_DEVICES | tr ',' ' '); do
  ngpus=$((ngpus+1))
  device_id=$(nvidia-smi -L | grep $device | egrep -o 'GPU [0-3]' | sed 's/GPU //g')
  device_ids+=$device_id,
done
export CUDA_VISIBLE_DEVICES=${device_ids::-1}

# address & port
export MASTER_ADDR="127.0.0.1"
export MASTER_PORT=$(shuf -i 10000-60000 -n 1)

# nccl
export NCCL_DEBUG=INFO
# export NCCL_SOCKET_IFNAME=hsn
# export NCCL_SOCKET_NTHREADS=4
# export NCCL_NSOCKS_PERTHREAD=8

# run
singularity exec \
  --nv \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  $IMAGE_PATH \
  torchrun \
    --nnodes=1 \
    --nproc_per_node=$ngpus \
    --master_addr=${MASTER_ADDR} \
    --master_port=${MASTER_PORT} \
    $@
