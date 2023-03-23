#!/bin/bash
# https://github.com/open-mpi/mpi-test-suite#running-the-mpi-testsuite

#PBS -q cray_cpu
#PBS -l select=4:ncpus=1
#PBS -l walltime=10
#PBS -o output/
#PBS -e output/

module use ../../modulefiles
module load utils/gengetopt
module load utils/openmpi
module list
ompi_info
exit 0

mpiexec -np 4 mpi-test-suite/mpi_test_suite \
  -t "Bcast"
