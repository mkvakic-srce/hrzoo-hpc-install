#!/bin/bash

# mkdir
sudo mkdir -p /apps/scientific/ray/2.4.0-rayproject
sudo chown -R mkvakic:hpc /apps/scientific/ray/2.4.0-rayproject

# build
apptainer build /apps/scientific/ray/2.4.0-rayproject/image.sif ray-2.4.0-rayproject.def

# copy wrappers
cp \
  ray-launcher.sh \
  ray-cluster.sh \
  ray-head.sh \
  ray-worker.sh \
  ray-submit.sh \
  /apps/scientific/ray/2.4.0-rayproject/.
chmod 1755 /apps/scientific/ray/2.4.0-rayproject/*.sh
