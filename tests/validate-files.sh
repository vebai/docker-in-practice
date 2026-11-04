#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 tests/check_repo.py
if command -v node >/dev/null 2>&1; then
  while IFS= read -r -d '' file; do node --check "$file"; done < <(find examples -name '*.js' -print0)
  echo 'Node.js syntax: OK'
else
  echo 'Node.js unavailable: skipped JavaScript syntax checking'
fi
if command -v bash >/dev/null 2>&1; then
  bash -n publish-to-github.sh
fi
printf 'Repository static validation: PASS (no Docker resources launched)\n'
