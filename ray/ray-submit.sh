#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# sleep until others wake up
nnodes=$(sort -u $PBS_NODEFILE | wc -l)
sleep $((SLEEP_DT*nnodes))

# chmod
chmod 700 $RAY_TMPDIR

# run
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] ray-submit.sh: running on node $(hostname)"
apptainer exec \
    --nv \
    --pwd /host_pwd \
    --bind ${PWD}:/host_pwd \
    $IMAGE_PATH python3 $@

# kill cluster
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] ray-submit.sh: stopping cluster on node $(hostname)"
pbsdsh -- $APP_COMMAND ray stop --force 2>/dev/null
