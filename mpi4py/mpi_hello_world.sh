#!/bin/bash

#PBS -l select=8:ncpus=1
#PBS -l place=scatter

# environment
module load PrgEnv-gnu
module load cray-mpich-abi
module load cray-pals
module load cray-pmi
export APPTAINERENV_LD_LIBRARY_PATH="${CRAY_LD_LIBRARY_PATH}:${LD_LIBRARY_PATH}:/opt/cray/pe/pals/1.2.3/lib"
# export APPTAINERENV_LD_LIBRARY_PATH="${CRAY_LD_LIBRARY_PATH}:\$LD_LIBRARY_PATH:/opt/cray/pe/pals/1.2.3/lib"
# export APPTAINERENV_LD_LIBRARY_PATH="${CRAY_LD_LIBRARY_PATH}:\$LD_LIBRARY_PATH:/opt/cray/pe/pals/1.2.3/lib"

# ldd
singularity exec \
  --bind /opt \
  --bind /run \
  mpi4py-install \
    ldd /myapp/mpi_hello_world

# mpi_hello_world
mpiexec \
  singularity exec \
    --bind /opt \
    --bind /run \
    --bind /usr/lib64 \
    mpi4py-install \
      /myapp/mpi_hello_world
