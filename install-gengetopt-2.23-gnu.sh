#!/bin/bash

# compile
module purge
# module load craype-x86-milan
# module load PrgEnv-gnu
# module unload gcc
# module load gcc/10.3.0

# mkdir
sudo mkdir -p /apps/utils/gengetopt
sudo chown -R mkvakic:hpc /apps/utils/gengetopt

# wget
wget -nc https://ftp.gnu.org/gnu/gengetopt/gengetopt-2.23.tar.xz
tar xf gengetopt-2.23.tar.xz --keep-old-files

# configure, make
cd gengetopt-2.23
sh ./configure --prefix /apps/utils/gengetopt/2.23-gnu 2>&1 | tee config.out
make
make install
