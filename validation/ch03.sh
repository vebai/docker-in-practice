#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
port="${VALIDATION_PORT_BASE:-18100}"; port=$((port+3))
base="$VROOT/examples/chapter-03-dockerfiles"
static=bookval-ch03-static; node=bookval-ch03-node; python=bookval-ch03-python
if [[ "${1:-run}" == cleanup ]]; then cleanup_names "$static" "$node" "$python"; exit 0; fi
begin_chapter 3 'Three Dockerfiles: Nginx, Node.js and Flask'
step 'prerequisites' ensure_prerequisites
step 'host-port-free' must_be_free "$port"
step 'unique-containers' must_not_exist "$static" "$node" "$python"
step 'build-static' docker build -t bookval-ch03-static "$base/static-site"
step 'run-static' docker run -d --name "$static" -p "127.0.0.1:${port}:80" bookval-ch03-static
step 'static-http' http_contains "$port" / 'Hello from Docker!'
step 'static-cleanup' cleanup_names "$static"
step 'npm-dependencies' npm --prefix "$base/node-demo" ci
step 'build-node' docker build -t bookval-ch03-node "$base/node-demo"
step 'run-node' docker run -d --name "$node" -p "127.0.0.1:${port}:3000" bookval-ch03-node
step 'node-http' http_contains "$port" / 'Hello from Docker!'
step 'node-cleanup' cleanup_names "$node"
step 'build-python' docker build -t bookval-ch03-python "$base/python-demo"
step 'run-python' docker run -d --name "$python" -p "127.0.0.1:${port}:8000" bookval-ch03-python
step 'python-http' http_contains "$port" / 'Hello from Docker!'
step 'python-cleanup' cleanup_names "$python"
complete_chapter
