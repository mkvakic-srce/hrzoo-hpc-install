#!/bin/bash

# environment
module load cray-pals

# cd
cd ${PBS_O_WORKDIR:-""}

# head ip address
export HEAD_PORT=$(shuf -i 10000-60000 -n 1)
export HEAD_IP_ADDRESS=$(ip -f inet addr show hsn0 | egrep -m 1 -o 'inet [0-9.]{1,}' | sed 's/inet //')
export RAY_ADDRESS="${HEAD_IP_ADDRESS}:${HEAD_PORT}"

# ray vars
export RAY_CLIENT_SERVER_PORT=$((HEAD_PORT+1))
export RAY_MIN_WORKER_PORT=$((RAY_CLIENT_SERVER_PORT+1))
export RAY_MAX_WORKER_PORT=$((RAY_CLIENT_SERVER_PORT+100))
export RAY_TMPDIR="${HOME}/ray_tmp"

# sleep var
export SLEEP_DT=5

# apptainer command
export APP_COMMAND="apptainer exec --nv --pwd /host_pwd --bind ${PWD}:/host_pwd $IMAGE_PATH"

# hosts
head_host=$( head -1 ${PBS_NODEFILE} )
worker_hosts=$( sort -u ${PBS_NODEFILE} | sed "/${head_host}/d" | tr '\n' ',' )
worker_hosts=$( echo "${worker_hosts}," )
submit_host=$head_host
hosts="${head_host},${worker_hosts:0:-1}${submit_host}"

# exit if no file given
if [[ $# -eq 0 ]]; then
  echo "[$(date +%d-%m-%Y' '%H:%M:%S)] ray-launcher.sh: no arguments given"
  exit 1
else
  # otherwise launch
  echo "[$(date +%d-%m-%Y' '%H:%M:%S)] ray-launcher.sh: launching"
  mpiexec \
    --hosts ${hosts} \
    --cpu-bind none \
    ray-cluster.sh $@
fi
