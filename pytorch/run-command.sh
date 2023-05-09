#!/bin/bash

# uuids to device numbers
device_ids=""
for device in $(echo $CUDA_VISIBLE_DEVICES | tr ',' ' '); do
  device_id=$(nvidia-smi -L | grep $device | egrep -o 'GPU [0-3]' | sed 's/GPU //g')
  device_ids+=$device_id,
done
export CUDA_VISIBLE_DEVICES=${device_ids//,$/}

# run
apptainer exec \
  --nv \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  $IMAGE_PATH $@
