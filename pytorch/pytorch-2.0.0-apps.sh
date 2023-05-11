#!/bin/bash

# version
version="2.0.0"

# base_dir
base_dir="/apps/scientific/pytorch/$version"

# mkdir
sudo mkdir -p $base_dir
sudo chown -R mkvakic:hpc $base_dir

# build
apptainer build $base_dir/image.sif pytorch-$version.def

# copy wrappers
cp run-command.sh $base_dir/.
cp run-singlegpu.sh $base_dir/.
cp torchrun-multinode.sh $base_dir/.
cp torchrun-singlenode.sh $base_dir/.
chmod 1755 $base_dir/*.sh
