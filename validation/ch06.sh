#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
volume=bookval-ch06-data; network=bookval-ch06-net; db=bookval-ch06-db
cleanup() {
  cleanup_names "$db"
  if docker network inspect "$network" >/dev/null 2>&1; then docker network rm "$network" || return 1; fi
  if docker volume inspect "$volume" >/dev/null 2>&1; then docker volume rm "$volume" || return 1; fi
}
if [[ "${1:-run}" == cleanup ]]; then cleanup; exit 0; fi
begin_chapter 6 'Named-volume persistence and Docker DNS isolation'
step 'prerequisites' ensure_prerequisites
step 'unique-db' must_not_exist "$db"
step 'new-volume' bash -c '! docker volume inspect "$1" >/dev/null 2>&1' _ "$volume"
step 'new-network' bash -c '! docker network inspect "$1" >/dev/null 2>&1' _ "$network"
step 'create-volume' docker volume create "$volume"
step 'write-data' docker run --rm -v "$volume:/data" alpine:3.24 sh -c 'echo hello > /data/message.txt'
step 'verify-persistence' bash -c '[[ "$(docker run --rm -v "$1:/data" alpine:3.24 cat /data/message.txt)" == hello ]]' _ "$volume"
step 'create-network' docker network create "$network"
step 'run-database' docker run -d --name "$db" --network "$network" -e POSTGRES_PASSWORD=example-password postgres:15-alpine
wait_db() {
  local i
  for i in $(seq 1 35); do
    if docker run --rm --network "$network" postgres:15-alpine pg_isready -h "$db" -U postgres; then return 0; fi
    sleep 2
  done
  return 1
}
step 'network-name-resolution' wait_db
step 'isolation-expected-failure' expect_failure docker run --rm postgres:15-alpine pg_isready -h "$db" -U postgres
step 'network-inspection' docker network inspect "$network"
step 'owned-resource-cleanup' cleanup
complete_chapter
