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

# ngpus
ngpus=$(qstat -f $PBS_JOBID | grep 'Resource_List.ngpus' | egrep -o '[0-9]{1,}')

# run
singularity exec \
  --nv \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  $IMAGE_PATH \
    accelerate launch \
      --multi_gpu \
      --gpu_ids $CUDA_VISIBLE_DEVICES \
      --main_process_ip ${MASTER_ADDR} \
      --main_process_port ${MASTER_PORT} \
      --machine_rank ${PALS_NODEID} \
      --num_machines $(sort -u $PBS_NODEFILE | wc -l) \
      --num_processes $ngpus \
      $@
