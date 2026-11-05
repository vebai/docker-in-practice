#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
work="$VWORK/ch13"; file="$work/compose.yaml"; project=bookval-ch13
port="${VALIDATION_PORT_BASE:-18100}"; port=$((port+13))
compose() { docker compose -p "$project" -f "$file" "$@"; }
cleanup() {
  if [[ -f "$file" ]]; then compose down -v --remove-orphans || return; fi
  if [[ -d "$work" ]]; then rm -rf "$work"; fi
}
if [[ "${1:-run}" == cleanup ]]; then cleanup; exit 0; fi
begin_chapter 13 'Todo API + PostgreSQL + Redis, restart persistence and cleanup'
step 'prerequisites' ensure_prerequisites
step 'compose-plugin' docker compose version
step 'memory-advisory' require_minimum_memory
step 'port-free' must_be_free "$port"
step 'new-working-copy' bash -c '[[ ! -e "$1" ]]' _ "$work"
mkdir -p "$work"
step 'copy-source' cp -R "$VROOT/examples/chapter-13-final-project/." "$work/"
step 'create-disposable-env' cp "$work/.env.example" "$work/.env"
step 'remap-host-port' python3 -c 'from pathlib import Path; import sys; p=Path(sys.argv[1]); t=p.read_text(); assert "127.0.0.1:3000:3000" in t; p.write_text(t.replace("127.0.0.1:3000:3000",f"127.0.0.1:{sys.argv[2]}:3000"))' "$file" "$port"
step 'generate-lockfile' bash -c 'cd "$1" && npm install' _ "$work"
step 'compose-config' compose config --quiet
step 'compose-build' compose build
step 'compose-up' compose up -d
step 'api-ready' http_contains "$port" /health '"status":"ok"'
step 'create-todo' bash -c 'curl --noproxy "*" -fsS -X POST "http://127.0.0.1:$1/todos" -H "Content-Type: application/json" -d '\''{"task":"Learn Docker"}'\'' | grep -F "Learn Docker"' _ "$port"
step 'verify-todo' http_contains "$port" /todos 'Learn Docker'
step 'retain-volume-on-down' compose down
step 'restart' compose up -d
step 'api-ready-after-restart' http_contains "$port" /health '"status":"ok"'
step 'data-persisted' http_contains "$port" /todos 'Learn Docker'
step 'postgres-service-healthy' compose exec -T db pg_isready -U user -d app
step 'redis-service-healthy' compose exec -T redis redis-cli ping
step 'compose-logs' compose logs --tail 30
step 'owned-resource-cleanup' cleanup
complete_chapter
