#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
name=bookval-ch02-nginx; port="${VALIDATION_PORT_BASE:-18100}"
port=$((port+2))
if [[ "${1:-run}" == cleanup ]]; then cleanup_names "$name"; exit 0; fi
begin_chapter 2 'Images, containers, inspect and invalid tag'
step 'prerequisites' ensure_prerequisites
step 'port-free' must_be_free "$port"
step 'unique-container' must_not_exist "$name"
step 'pull-nginx' docker pull nginx:alpine
step 'run-nginx' docker run -d --name "$name" -p "127.0.0.1:${port}:80" nginx:alpine
step 'http-smoke' http_contains "$port" / 'Welcome to nginx!'
step 'inspect' docker inspect --format 'Running={{.State.Running}} Image={{.Image}}' "$name"
step 'logs' docker logs "$name"
step 'expected-invalid-tag' expect_failure docker run --rm nginx:this-tag-should-not-exist-12345
step 'cleanup' cleanup_names "$name"
complete_chapter
