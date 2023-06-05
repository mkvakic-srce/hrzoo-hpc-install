#!/bin/bash

# mkdir
sudo mkdir -p /apps/scientific/ray/2.3.1-rayproject
sudo chown -R mkvakic:hpc /apps/scientific/ray/2.3.1-rayproject

# build
apptainer build /apps/scientific/ray/2.3.1-rayproject/image.sif ray-2.3.1-rayproject.def

# copy wrappers
cp \
  ray-launcher.sh \
  ray-cluster.sh \
  ray-head.sh \
  ray-worker.sh \
  ray-submit.sh \
  /apps/scientific/ray/2.3.1-rayproject/.
chmod 1755 /apps/scientific/ray/2.3.1-rayproject/*.sh
