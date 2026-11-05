#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
name=bookval-ch09-logs
if [[ "${1:-run}" == cleanup ]]; then cleanup_names "$name"; exit 0; fi
begin_chapter 9 'Container stdout logs, timestamps and logging driver'
step 'prerequisites' ensure_prerequisites
step 'unique-container' must_not_exist "$name"
step 'start-logging' docker run -d --name "$name" alpine:3.24 sh -c 'i=0; while true; do echo "$(date): Log line $i"; i=$((i+1)); sleep 2; done'
logs_nonempty() {
  local i
  for i in $(seq 1 10); do
    docker logs "$name" 2>&1 | grep -q 'Log line' && return 0
    sleep 2
  done
  return 1
}
step 'stdout-generated' logs_nonempty
step 'last-lines' docker logs --tail 5 "$name"
step 'timestamped-lines' docker logs --timestamps "$name"
step 'log-driver' docker inspect --format '{{.HostConfig.LogConfig.Type}}' "$name"
step 'cleanup' cleanup_names "$name"
complete_chapter
