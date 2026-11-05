#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
base="$VROOT/examples/chapter-12-container-cicd/ci-flask"; name=bookval-ch12-ci
port="${VALIDATION_PORT_BASE:-18100}"; port=$((port+12))
if [[ "${1:-run}" == cleanup ]]; then cleanup_names "$name"; exit 0; fi
begin_chapter 12 'Local CI image build and smoke test (no registry push)'
step 'prerequisites' ensure_prerequisites
step 'port-free' must_be_free "$port"
step 'unique-container' must_not_exist "$name"
step 'build-flask' docker build -t bookval-ch12-flask "$base"
step 'run-flask' docker run -d --name "$name" -p "127.0.0.1:${port}:5000" bookval-ch12-flask
step 'smoke-http' http_contains "$port" / 'Hello from Docker!'
step 'sample-workflow-exists' test -f "$base/.github/workflows/build.example.yml"
step 'container-cleanup' cleanup_names "$name"
echo 'MANUAL/OPTIONAL: publish-and-pull in Docker Hub/GitHub Actions is NOT tested by this offline script.' | tee -a "$LOGFILE"
complete_chapter
