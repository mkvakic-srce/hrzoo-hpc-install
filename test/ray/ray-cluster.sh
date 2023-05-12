#!/bin/bash

# cd
cd ${PBS_O_WORKDIR:-""}

# vars
export RAY_TMPDIR="${HOME}"
# export RAY_LOG_TO_STDERR=1
export RAY_LOG_PATH="${PBS_JOBID}-ray-${PALS_RANKID}.log"
export RAY_CLIENT_RECONNECT_GRACE_PERIOD=5
export SLEEP_DT=5

# cluster
case $PALS_RANKID in
  0) ./ray-head.sh ;;
  1) ./ray-submit.sh $@ ;;
  *) ./ray-worker.sh ;;
esac
