#!/bin/bash

# base_dir
base_dir="/apps/scientific/tensorflow/2.10.1-ngc"

# mkdir
sudo mkdir -p $base_dir
sudo chown -R mkvakic:hpc $base_dir

# build
apptainer build $base_dir/image.sif tensorflow-2.10.1-ngc.def

# copy wrappers
cp \
  run-singlenode.sh \
  run-multinode-exec.sh \
  run-multinode.sh \
  $base_dir/.
chmod 1755 $base_dir/*.sh
