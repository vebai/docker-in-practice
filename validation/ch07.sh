#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
base="$VROOT/examples/chapter-07-health-checks"; port="${VALIDATION_PORT_BASE:-18100}"; port=$((port+7))
good=bookval-ch07-healthy; bad=bookval-ch07-unhealthy
if [[ "${1:-run}" == cleanup ]]; then cleanup_names "$good" "$bad"; exit 0; fi
begin_chapter 7 'Healthy and deliberately unhealthy containers'
step 'prerequisites' ensure_prerequisites
step 'port-free' must_be_free "$port"
step 'unique-containers' must_not_exist "$good" "$bad"
step 'build-healthy' docker build -t bookval-ch07-healthy "$base"
step 'run-healthy' docker run -d --name "$good" -p "127.0.0.1:${port}:3000" bookval-ch07-healthy
step 'healthy-http' http_contains "$port" /health 'OK'
step 'health-status' wait_health "$good" healthy
step 'build-broken' docker build -f "$base/broken.Dockerfile" -t bookval-ch07-broken "$base"
step 'run-broken' docker run -d --name "$bad" bookval-ch07-broken
step 'wait-for-unhealthy' wait_health "$bad" unhealthy
step 'inspect-evidence' docker inspect --format '{{json .State.Health}}' "$bad"
step 'cleanup' cleanup_names "$good" "$bad"
complete_chapter
