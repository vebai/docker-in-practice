#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
if [[ "${1:-run}" == cleanup ]]; then echo 'Chapter 01 uses --rm: no lab containers retained.'; exit 0; fi
begin_chapter 1 'First container and deliberate image error'
step 'prerequisites' ensure_prerequisites
step 'hello-world' docker run --rm hello-world
step 'expected-image-error' expect_failure docker run --rm nginx:this-tag-should-not-exist-12345
complete_chapter
