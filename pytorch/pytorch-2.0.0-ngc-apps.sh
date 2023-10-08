#!/bin/bash

# base_dir
base_dir="/apps/scientific/pytorch/2.0.0-ngc"

# mkdir
sudo mkdir -p $base_dir
sudo chown -R mkvakic:hpc $base_dir

# build
apptainer build $base_dir/image.sif pytorch-2.0.0-ngc.def

# copy wrappers
cp run-command.sh $base_dir/.
cp run-singlegpu.sh $base_dir/.
cp torchrun-singlenode.sh $base_dir/.
cp torchrun-multinode.sh $base_dir/.
cp torchrun-multinode-exec.sh $base_dir/.
cp accelerate-multinode.sh $base_dir/.
cp accelerate-multinode-exec.sh $base_dir/.
chmod 1755 $base_dir/*.sh
