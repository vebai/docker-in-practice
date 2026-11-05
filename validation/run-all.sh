#!/usr/bin/env bash
set -Eeuo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
from=1; to=13; only=''; list=false; show_status=false
usage() {
  cat <<'HELP'
Usage: ./validation/run-all.sh [--from NN] [--to NN] [--chapter NN] [--list]
  --from NN       Start at chapter NN (e.g. --from 05 after completed Ch. 3–4)
  --to NN         Stop after chapter NN
  --chapter NN    Run just one chapter and stop
  --list          Show available validation scripts
  --status        Show per-chapter PASS / FAIL / NOT RUN markers

Each chapter writes validation/results/chapter-NN.log and a .pass or .fail marker.
Stops at the first failed checkpoint; no silent skipping of failed chapters.
Use ./validation/chNN.sh cleanup to remove ONLY validation-owned resources.
IMPORTANT: The full run may download images and create disposable lab resources.
No registry image is published and no AWS resources are created.
HELP
}
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --from) from=$((10#$2)); shift 2;;
    --to) to=$((10#$2)); shift 2;;
    --chapter) only=$((10#$2)); shift 2;;
    --list) list=true; shift;;
    --status) show_status=true; shift;;
    --help|-h) usage; exit 0;;
    *) echo "Unknown argument: $1" >&2; usage; exit 2;;
  esac
done
if $show_status; then
  for n in $(seq 1 13); do
    printf -v padded '%02d' "$n"
    if [[ -f "$DIR/results/chapter-${padded}.fail" ]]; then
      reason=$(grep '^step=' "$DIR/results/chapter-${padded}.fail" || true)
      printf '%s  FAIL (%s)\n' "$padded" "$reason"
    elif [[ -f "$DIR/results/chapter-${padded}.pass" ]]; then
      printf '%s  PASS\n' "$padded"
    else
      printf '%s  NOT RUN\n' "$padded"
    fi
  done
  exit 0
fi
if $list; then
  for n in $(seq -w 1 13); do printf '%s  %s\n' "$n" "$DIR/ch${n}.sh"; done
  exit 0
fi
if [[ -n "$only" ]]; then from=$only; to=$only; fi
if ((from < 1 || to > 13 || from > to)); then echo 'Invalid chapter range (01–13)' >&2; exit 2; fi
[[ -x "$DIR/ch01.sh" ]] || { echo 'Scripts are not executable. Run: chmod +x validation/*.sh'; exit 2; }
for n in $(seq "$from" "$to"); do
  printf -v padded '%02d' "$n"
  "$DIR/ch${padded}.sh"
done
printf '\nALL SELECTED CHAPTERS PASSED: %02d through %02d\n' "$from" "$to"
echo 'Review remaining manual scope (registry publication / manuscript comparison) before final sign-off.'
