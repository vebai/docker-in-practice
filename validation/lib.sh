#!/usr/bin/env bash
# Shared deterministic validation helpers. Source from chapter scripts only.
set -Eeuo pipefail

VROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VOUT="${VROOT}/validation/results"
VWORK="${VROOT}/validation/work"
mkdir -p "$VOUT" "$VWORK"
CHAPTER=""
CURRENT_STEP=""
LOGFILE=""

begin_chapter() {
  CHAPTER="$(printf '%02d' "$1")"
  local title="$2"
  LOGFILE="${VOUT}/chapter-${CHAPTER}.log"
  rm -f "${VOUT}/chapter-${CHAPTER}.pass" "${VOUT}/chapter-${CHAPTER}.fail"
  {
    printf 'Chapter %s: %s\nDate: %s\nRepository: %s\n\n' "$CHAPTER" "$title" "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$VROOT"
    docker version --format 'Client={{.Client.Version}} Server={{.Server.Version}}' 2>&1 || true
    docker compose version 2>&1 || true
  } > "$LOGFILE"
  echo
  echo "========== Chapter $CHAPTER — $title =========="
  echo "Log: $LOGFILE"
}

fail_step() {
  local status="${1:-1}"
  [[ "$status" -ne 0 ]] || status=1
  printf 'FAILED: chapter=%s step=%s exit=%s\n' "$CHAPTER" "$CURRENT_STEP" "$status" | tee -a "$LOGFILE"
  printf 'chapter=%s\nstep=%s\nexit=%s\nlog=%s\n' "$CHAPTER" "$CURRENT_STEP" "$status" "$LOGFILE" > "${VOUT}/chapter-${CHAPTER}.fail"
  echo "--- Last 35 lines of chapter log ---"
  tail -n 35 "$LOGFILE"
  echo "--- STOPPED at checkpoint [$CURRENT_STEP] ---"
  echo "Inspect named bookval-* resources before cleanup; logs are preserved."
  echo "After correcting the issue, run: ./validation/ch${CHAPTER}.sh cleanup"
  echo "Then rerun this chapter:       ./validation/run-all.sh --chapter ${CHAPTER}"
  exit "$status"
}

step() {
  CURRENT_STEP="$1"; shift
  printf '\n>>> [%s.%s] ' "$CHAPTER" "$CURRENT_STEP" | tee -a "$LOGFILE"
  printf '%s ' "$@" | tee -a "$LOGFILE"
  printf '\n' | tee -a "$LOGFILE"
  if "$@" 2>&1 | tee -a "$LOGFILE"; then
    printf 'PASS [%s.%s]\n' "$CHAPTER" "$CURRENT_STEP" | tee -a "$LOGFILE"
  else
    local status=$?
    fail_step "$status"
  fi
}

complete_chapter() {
  printf '\nPASS: chapter %s\n' "$CHAPTER" | tee -a "$LOGFILE"
  printf 'chapter=%s\nstatus=PASS\nlog=%s\n' "$CHAPTER" "$LOGFILE" > "${VOUT}/chapter-${CHAPTER}.pass"
  echo "Finished chapter $CHAPTER; lab-owned containers cleaned where applicable."
}

ensure_prerequisites() {
  command -v docker >/dev/null || { echo 'Docker CLI missing' >&2; return 1; }
  command -v curl >/dev/null || { echo 'curl missing' >&2; return 1; }
  docker info >/dev/null 2>&1 || { echo 'Docker daemon not accessible' >&2; return 1; }
}

must_be_free() {
  local port="$1"
  if command -v lsof >/dev/null && lsof -nP -iTCP:"$port" -sTCP:LISTEN 2>/dev/null | grep -q LISTEN; then
    echo "Host port $port is already occupied. Use VALIDATION_PORT_BASE (see README) or stop ONLY the unrelated service if authorised." >&2
    return 1
  fi
  if command -v python3 >/dev/null; then
    python3 - "$port" <<'PY'
import socket,sys
p=int(sys.argv[1]); s=socket.socket()
try: s.bind(('127.0.0.1', p))
except OSError as e:
    print(f'Host port {p} unavailable: {e}', file=sys.stderr); sys.exit(1)
finally: s.close()
PY
  fi
}

must_not_exist() {
  local name
  for name in "$@"; do
    if docker container inspect "$name" >/dev/null 2>&1; then
      echo "Container '$name' already exists: inspect it before deleting anything. Use ch${CHAPTER}.sh cleanup ONLY if it belongs to this suite." >&2
      return 1
    fi
  done
}

http_contains() {
  local port="$1" path="$2" expected="$3" output="" i
  for i in $(seq 1 20); do
    if output=$(curl --noproxy '*' --connect-timeout 2 --max-time 5 -fsS "http://127.0.0.1:${port}${path}" 2>/dev/null); then
      printf '%s\n' "$output"
      if [[ "$output" == *"$expected"* ]]; then return 0; fi
      echo "HTTP succeeded but expected text '$expected' was absent" >&2
      return 1
    fi
    sleep 2
  done
  echo "No expected HTTP response on 127.0.0.1:${port}${path} after 20 attempts" >&2
  return 1
}

http_code() {
  local port="$1" path="$2" expected="$3" actual i
  for i in $(seq 1 20); do
    actual=$(curl --noproxy '*' --connect-timeout 2 --max-time 5 -sS -o /dev/null -w '%{http_code}' "http://127.0.0.1:${port}${path}" 2>/dev/null) || actual="000"
    if [[ "$actual" == "$expected" ]]; then echo "HTTP $actual on ${path}"; return 0; fi
    sleep 2
  done
  echo "Expected HTTP $expected; got $actual" >&2
  return 1
}

expect_failure() {
  local code=0
  "$@" && code=0 || code=$?
  if [[ "$code" -eq 0 ]]; then echo 'Unexpected success: command should fail' >&2; return 1; fi
  echo "Expected failure observed (exit=$code)"
}

expect_exit() {
  local expected="$1"; shift
  local code=0
  "$@" && code=0 || code=$?
  [[ "$code" -eq "$expected" ]] || { echo "Expected exit $expected; got $code" >&2; return 1; }
  echo "Expected exit code $expected observed"
}

wait_health() {
  local name="$1" expected="$2" i got
  for i in $(seq 1 35); do
    got=$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}no-healthcheck{{end}}' "$name" 2>/dev/null) || got=missing
    if [[ "$got" == "$expected" ]]; then echo "$name health=$got"; return 0; fi
    sleep 3
  done
  echo "Expected $name health '$expected'; last value '$got'" >&2
  docker inspect --format '{{json .State.Health}}' "$name" || true
  return 1
}

assert_equal() {
  local expected="$1" actual="$2"
  [[ "$expected" == "$actual" ]] || { echo "Expected '$expected', got '$actual'" >&2; return 1; }
  echo "Verified value: $actual"
}

assert_smaller() {
  local big small
  big=$(docker image inspect -f '{{.Size}}' "$1") || return
  small=$(docker image inspect -f '{{.Size}}' "$2") || return
  echo "Image sizes (bytes): $1=$big; $2=$small"
  [[ "$small" -lt "$big" ]] || { echo 'Multi-stage image is not smaller' >&2; return 1; }
}

cleanup_names() {
  local name
  for name in "$@"; do
    if docker container inspect "$name" >/dev/null 2>&1; then
      docker rm -f "$name" || return 1
    fi
  done
}

cleanup_chapter() {
  echo "Cleanup for chapter ${1}; limited to named bookval-* resources."
}

require_minimum_memory() {
  local mem
  mem=$(docker info --format '{{.MemTotal}}' 2>/dev/null || echo 0)
  if [[ "$mem" -lt 3221225472 ]]; then
    echo "Docker VM memory appears below 3 GiB ($mem bytes); final multi-service Compose test may fail."
    echo "Increase Docker Desktop memory before Chapter 13 if feasible (existing containers will be interrupted by engine restart)."
    # Informational only: let the real deployment reveal resource/compatibility issues.
  fi
}
