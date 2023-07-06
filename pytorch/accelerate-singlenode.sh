#!/bin/bash

# uuids to device numbers
device_ids=""
for device in $(echo $CUDA_VISIBLE_DEVICES | tr ',' ' '); do
  device_id=$(nvidia-smi -L | grep $device | egrep -o 'GPU [0-3]' | sed 's/GPU //g')
  device_ids+=$device_id,
done
export CUDA_VISIBLE_DEVICES=${device_ids//,$/}

# ngpus
ngpus=$(grep -o '[0-9]' <<< $CUDA_VISIBLE_DEVICES | wc -l)

# run
apptainer run \
  --nv \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  $IMAGE_PATH \
    accelerate launch \
      --num_cpu_threads_per_process $((NCPUS/ngpus)) \
      $@
