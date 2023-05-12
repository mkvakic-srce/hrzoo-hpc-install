#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# ports
rp () {
  shuf -i 10000-65535 -n 1
}
port=$(rp)
node_manager_port=$(rp)
object_manager_port=$(rp)
ray_client_server_port=$(rp)
aedis_shard_ports=$(rp)
min_worker_port=$(rp)
max_worker_port=$(( min_worker_port + 100 ))

# slingshot ip adress
head_ip_address=$( ip -f inet addr show hsn0 | egrep -m 1 -o 'inet [0-9.]{1,}' | sed 's/inet //' )

# head
echo "[$(date +%d-%m-%Y' '%H:%M:%S)] ray-head.sh: starting on rank $PALS_RANKID"
apptainer exec \
  --pwd /host_pwd \
  --bind ${PWD}:/host_pwd \
  $IMAGE_PATH ray start \
    --head \
    --block \
    --include-dashboard False \
    --port=$port \
    --node-ip-address=$head_ip_address \
    --node-manager-port=$node_manager_port \
    --object-manager-port=$object_manager_port \
    --ray-client-server-port=$ray_client_server_port \
    --redis-shard-ports=$redis_shard_ports \
    --min-worker-port=$min_worker_port \
    --max-worker-port=$max_worker_port \
    --log-style=record \
    --num-gpus=0 \
    --num-cpus $((NCPUS-1)) > $RAY_LOG_PATH 2>&1
