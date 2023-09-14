#!/bin/bash

# base_dir
base_dir="/apps/scientific/ray/2.4.0-rayproject"

# mkdir
sudo mkdir -p ${base_dir}
sudo chown -R mkvakic:hpc ${base_dir}
sudo chown -R mkvakic:hpc ${base_dir//$(basename ${base_dir})}

# build
apptainer build ${base_dir}/image.sif ray-2.4.0-rayproject.def

# copy wrappers
cp \
  ray-launcher.sh \
  ray-cluster.sh \
  ray-worker.sh \
  ray-submit.sh \
  ray-head.sh \
  ${base_dir}/.
chmod 1755 /apps/scientific/ray/2.4.0-rayproject/*.sh
