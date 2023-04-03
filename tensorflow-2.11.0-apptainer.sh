#!/bin/bash

# mkdir
sudo mkdir -p /apps/scientific/tensorflow/2.11.0-ngc
sudo chown -R mkvakic:hpc /apps/scientific/tensorflow/2.11.0-ngc

# build
# apptainer build /apps/scientific/tensorflow/2.11.0-ngc/image.sif tensorflow-2.11.0-apptainer.def

# copy wrappers
cp run-singlenode.sh /apps/scientific/tensorflow/2.11.0-ngc/.
chmod 1755 /apps/scientific/tensorflow/2.11.0-ngc/*.sh
