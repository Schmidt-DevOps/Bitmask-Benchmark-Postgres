#!/usr/bin/env bash

if [[ -z $FIXTURES ]]; then
  echo "ENV var FIXTURES is not set."
  exit 1
fi

RESULTS_FILE=results-"$FIXTURES".txt

function cleanup {
  docker exec -i $(docker ps -q -f name=postgres-bitmask-benchmark) psql -U postgres <<<$(<get_storage_space.sql) >>"${RESULTS_FILE}"
  echo
  echo "Now have a look at results.txt and pull the data you are looking for."
  exit 0
}

trap cleanup INT

echo "Hit CTRL-c to stop recording after the container has settled."
while true; do
  docker stats "$(docker ps -q -f name=postgres-bitmask-benchmark)" --no-stream | grep -v CONTAINER >>"${RESULTS_FILE}"
  sleep 0.01
done
