#!/usr/bin/env bash
set -Eeuo pipefail

DELAY=2
MAX_DELAY=64
CONTINUE=-1

while [ ${CONTINUE} -ne 0 ] ; do

  if [ ${DELAY} -gt ${MAX_DELAY} ] ; then
    echo "Exceeded max delay ${MAX_DELAY}s, not waiting for another ${DELAY}s."
    exit 1
  fi

  if [ ${CONTINUE} -ge 0 ] ; then
    echo "${CONTINUE} test(s) failed."
  fi
  echo "Waiting ${DELAY}s for services to start."
  sleep ${DELAY}
  CONTINUE=0

  netstat -tuln
  (netstat -tuln | grep 143) || CONTINUE=$((${CONTINUE} + $?))
  (netstat -tuln | grep 993) || CONTINUE=$((${CONTINUE} + $?))
  (netstat -tuln | grep 110) || CONTINUE=$((${CONTINUE} + $?))
  (netstat -tuln | grep 995) || CONTINUE=$((${CONTINUE} + $?))

  DELAY=$((${DELAY} + ${DELAY}))
done

echo "All services are ready."
