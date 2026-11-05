#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
base="$VROOT/examples/chapter-11-debugging"; bad=bookval-ch11-broken; good=bookval-ch11-fixed
if [[ "${1:-run}" == cleanup ]]; then cleanup_names "$bad" "$good"; exit 0; fi
begin_chapter 11 'Missing curl: break, diagnose, correct exit code'
step 'prerequisites' ensure_prerequisites
step 'unique-containers' must_not_exist "$bad" "$good"
step 'build-broken' docker build -f "$base/broken.Dockerfile" -t bookval-ch11-broken "$base"
step 'expected-exit-127' expect_exit 127 docker run --name "$bad" bookval-ch11-broken
step 'broken-logs' docker logs "$bad"
step 'broken-exit-evidence' docker inspect --format '{{.State.ExitCode}}' "$bad"
step 'build-fixed' docker build -f "$base/fixed.Dockerfile" -t bookval-ch11-fixed "$base"
step 'expected-fixed-exit-zero' expect_exit 0 docker run --name "$good" bookval-ch11-fixed
step 'fixed-exit-evidence' bash -c '[[ "$(docker inspect --format "{{.State.ExitCode}}" "$1")" == 0 ]]' _ "$good"
step 'cleanup' cleanup_names "$bad" "$good"
complete_chapter
