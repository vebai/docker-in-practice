#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
name=bookval-ch08-limits
if [[ "${1:-run}" == cleanup ]]; then cleanup_names "$name"; exit 0; fi
begin_chapter 8 'CPU and memory limits without stressing the host'
step 'prerequisites' ensure_prerequisites
step 'unique-container' must_not_exist "$name"
step 'run-with-limits' docker run -d --name "$name" --memory=256m --cpus=0.5 alpine:3.24 sh -c 'while true; do sleep 5; done'
step 'assert-memory' bash -c '[[ "$(docker inspect --format "{{.HostConfig.Memory}}" "$1")" == 268435456 ]]' _ "$name"
step 'assert-cpus' bash -c '[[ "$(docker inspect --format "{{.HostConfig.NanoCpus}}" "$1")" == 500000000 ]]' _ "$name"
step 'observed-usage' docker stats --no-stream "$name"
step 'oom-state' docker inspect --format 'OOMKilled={{.State.OOMKilled}} ExitCode={{.State.ExitCode}}' "$name"
step 'cleanup' cleanup_names "$name"
complete_chapter
