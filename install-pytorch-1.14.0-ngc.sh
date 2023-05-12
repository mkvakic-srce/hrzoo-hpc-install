#!/bin/bash

# mkdir
sudo mkdir -p /apps/scientific/pytorch/1.14.0-ngc
sudo chown -R mkvakic:hpc /apps/scientific/pytorch/1.14.0-ngc

# build
apptainer build /apps/scientific/pytorch/1.14.0-ngc/image.sif pytorch-1.14.0-ngc.def

# copy wrappers
cp run-singlenode.sh /apps/scientific/pytorch/1.14.0-ngc/.
chmod 1755 /apps/scientific/pytorch/1.14.0-ngc/*.sh
