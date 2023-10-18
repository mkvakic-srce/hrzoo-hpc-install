#!/bin/bash

# environment
module load cray-pals

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

# run
singularity exec \
  --nv \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  $IMAGE_PATH \
  python3 -m torch.distributed.launch \
    --master_addr=${MASTER_ADDR} \
    --master_port=${MASTER_PORT} \
    --nnodes=1 \
    --node_rank=0 \
    --nproc_per_node=auto \
    $@
