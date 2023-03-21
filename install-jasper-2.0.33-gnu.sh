#!/bin/bash

# module
module purge
module load libpng
module load craype-x86-milan
module load PrgEnv-gnu

# mkdir
sudo mkdir -p /apps/libs/jasper
sudo chown mkvakic:hpc /apps/libs/jasper

# wget, tar & cd
wget -nc https://github.com/jasper-software/jasper/archive/refs/tags/version-2.0.33.tar.gz
tar xf version-2.0.33.tar.gz
cd jasper-version-2.0.33

# configure, make, intall
cmake -G "Unix Makefiles" \
  -H"$(pwd)" \
  -B"$(pwd)/build" \
  -DCMAKE_INSTALL_PREFIX="/apps/libs/jasper/2.0.33-gnu"
cmake --build "$(pwd)/build"
cmake --build "$(pwd)/build" --target install
