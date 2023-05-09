#!/bin/bash

# exit if not LOCAL_RANK_ID == 0
if [[ PALS_LOCAL_RANKID -ne 0 ]]; then
  exit 0
fi

# uuids to device numbers & ngpus
device_ids=""
devices=$(egrep -o 'GPU-.*' $PBS_NODEFILE.env | tr ',' ' ')
for device in $devices; do
  ngpus=$((ngpus+1))
  device_id=$(nvidia-smi -L | grep $device | egrep -o 'GPU [0-3]' | sed 's/GPU //g')
  device_ids+=$device_id,
done
export CUDA_VISIBLE_DEVICES=${device_ids::-1}

# address & port
export MASTER_NODE=$(head -1 $PBS_NODEFILE)
export MASTER_ADDR=$(ssh -f $MASTER_NODE ifconfig hsn0 | egrep -o 'inet [0-9.]+' | sed 's/inet //g')
RANDOM=$(egrep -o '^[0-9]+' <<< $PBS_JOBID)
export MASTER_PORT=$((1024+RANDOM*190/100))

# run
singularity exec \
  --nv \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  $IMAGE_PATH \
    torchrun \
      --nproc_per_node=auto \
      --nnodes=$(sort --unique $PBS_NODEFILE | wc -l) \
      --node_rank=${PALS_NODEID}\
      --rdzv_id=$(egrep -o '^[0-9]+' <<< $PBS_JOBID) \
      --rdzv_backend=c10d \
      --rdzv_endpoint="${MASTER_ADDR}:${MASTER_PORT}" \
      $@
