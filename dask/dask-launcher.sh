#!/bin/bash

# environment
module load cray-pals

# cd
cd ${PBS_O_WORKDIR:-""}

# sleep var
export SLEEP_DT=5

# scheduler vars
export SCHEDULER_PROTOCOL='tcp'
export SCHEDULER_INTERFACE='hsn0'
export SCHEDULER_IP=$(ip -f inet addr show $SCHEDULER_INTERFACE | egrep -m 1 -o 'inet [0-9.]{1,}' | sed 's/inet //')
export SCHEDULER_PORT=$(shuf -i 10000-60000 -n 1)
export SCHEDULER_ADDRESS="${SCHEDULER_IP}:${SCHEDULER_PORT}"

# apptainer command
export APP_COMMAND="apptainer exec --nv --pwd /host_pwd --bind ${PWD}:/host_pwd $IMAGE_PATH"

# hosts
if [ ! -z $CUDA_VISIBLE_DEVICES ]; then
  ngpus=$(egrep -o 'GPU-[a-z0-9\-]+' <<< $CUDA_VISIBLE_DEVICES | wc -l)
  worker_hosts=$( seq 1 $ngpus | xargs -Inone cat ${PBS_NODEFILE} | sort | tr '\n' ',' )
else
  worker_hosts=$(tr '\n' ',' < ${PBS_NODEFILE})
fi
scheduler_host=$(head -1 ${PBS_NODEFILE})
submit_host=$scheduler_host
hosts="${scheduler_host},${worker_hosts:0:-1},${submit_host}"

# exit if no file given
if [[ $# -eq 0 ]]; then
  echo "[$(date +%d-%m-%Y' '%H:%M:%S)] dask-launcher.sh: no arguments given"
  exit 1
else
  # otherwise launch
  echo "[$(date +%d-%m-%Y' '%H:%M:%S)] dask-launcher.sh: launching"
  mpiexec \
    --hosts ${hosts} \
    --cpu-bind none \
    dask-cluster.sh $@
fi
