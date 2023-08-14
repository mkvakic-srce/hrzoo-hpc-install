#!/bin/bash

# base_dir
base_dir="/apps/scientific/dask/2023.7.0-ghcr"

# mkdir
sudo mkdir -p $base_dir
sudo chown -R mkvakic:hpc $base_dir

# build
apptainer build $base_dir/image.sif dask-2023.7.0-ghcr.def

# copy wrappers
cp \
  dask-launcher.sh \
  dask-cluster.sh \
  dask-scheduler.sh \
  dask-worker.sh \
  dask-submit.sh \
  $base_dir/.
chmod 1755 $base_dir/*.sh
