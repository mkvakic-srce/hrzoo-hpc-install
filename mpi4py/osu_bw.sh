#!/bin/bash

#PBS -l select=8:ncpus=1
#PBS -l place=scatter

# environment
module load PrgEnv-gnu
module load cray-mpich-abi
module load cray-pals
module load cray-pmi
export APPTAINERENV_LD_LIBRARY_PATH="${CRAY_LD_LIBRARY_PATH}:${LD_LIBRARY_PATH}:/opt/cray/pe/pals/1.2.3/lib"

# run
hosts=($(sort --unique $PBS_NODEFILE))
nhosts=$(wc -l < $PBS_NODEFILE)
for i in $(seq 0 $((nhosts-1))); do
  for j in $(seq $((i+1)) $((nhosts-1))); do
    hostss="${hosts[$i]},${hosts[$j]}"
    echo "---- $hostss ----"
    mpiexec \
      --hosts $hostss \
      singularity exec \
        --bind /opt \
        --bind /run \
        --bind /usr/lib64 \
        mpi4py-install \
          /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw -i 1000 | \
            while read line; do echo "${hostss//,/ } $line"; done
  done
done
