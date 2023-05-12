#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# sleep
nnodes=$( wc -l < $PBS_NODEFILE )
sleep $((nnodes*SLEEP_DT))

# chmod
chmod 700 $RAY_TMPDIR

# run
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] ray-run.sh: running on rank $PALS_RANKID"
export RAY_ADDRESS=$( cat $RAY_TMPDIR/ray/ray_current_cluster )
apptainer exec \
  --nv \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  $IMAGE_PATH python3 $@

# stop
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] ray-run.sh: stopping on rank $PALS_RANKID"
apptainer exec \
  --nv \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  $IMAGE_PATH ray stop --force
