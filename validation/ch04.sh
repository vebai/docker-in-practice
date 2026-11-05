#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
port="${VALIDATION_PORT_BASE:-18100}"; port=$((port+4))
base="$VROOT/examples/chapter-04-multi-stage-builds"
go=bookval-ch04-go; frontend=bookval-ch04-frontend
if [[ "${1:-run}" == cleanup ]]; then cleanup_names "$go" "$frontend"; exit 0; fi
begin_chapter 4 'Go and Node frontend multi-stage builds'
step 'prerequisites' ensure_prerequisites
step 'host-port-free' must_be_free "$port"
step 'unique-containers' must_not_exist "$go" "$frontend"
step 'build-go-single' docker build -f "$base/go-demo/single.Dockerfile" -t bookval-ch04-go-single "$base/go-demo"
step 'build-go-multi' docker build -f "$base/go-demo/multi.Dockerfile" -t bookval-ch04-go-multi "$base/go-demo"
step 'smaller-runtime-image' assert_smaller bookval-ch04-go-single bookval-ch04-go-multi
step 'go-image-history' docker history bookval-ch04-go-multi
step 'run-go' docker run -d --name "$go" -p "127.0.0.1:${port}:8080" bookval-ch04-go-multi
step 'go-http' http_contains "$port" / 'Hello from Docker!'
step 'go-cleanup' cleanup_names "$go"
step 'frontend-deps' npm --prefix "$base/node-frontend-demo" ci
step 'build-frontend' docker build -t bookval-ch04-frontend "$base/node-frontend-demo"
step 'run-frontend' docker run -d --name "$frontend" -p "127.0.0.1:${port}:80" bookval-ch04-frontend
step 'frontend-http' http_contains "$port" / 'Multi-stage frontend example'
step 'frontend-cleanup' cleanup_names "$frontend"
complete_chapter
