#!/bin/bash

# CUDA_VISIBLE_DEVICES
device_ids=""
devices=$(egrep -o 'GPU-.*' $PBS_NODEFILE.env | tr ',' ' ')
for device in $devices; do
  ngpus=$((ngpus+1))
  device_id=$(nvidia-smi -L | grep $device | egrep -o 'GPU [0-3]' | sed 's/GPU //g')
  device_ids+=$device_id,
done
export CUDA_VISIBLE_DEVICES=${device_ids::-1}

# run
singularity exec \
  --nv \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  $IMAGE_PATH \
  python3 -m torch.distributed.launch \
      --master_addr=${MASTER_ADDR} \
      --master_port=${MASTER_PORT} \
      --nnodes=$(sort -u $PBS_NODEFILE | wc -l) \
      --node_rank=${PALS_NODEID} \
      --nproc_per_node=auto \
      $@
