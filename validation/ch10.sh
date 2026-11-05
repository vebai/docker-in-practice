#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
work="$VWORK/ch10"; file="$work/compose.yaml"; project=bookval-ch10
port="${VALIDATION_PORT_BASE:-18100}"; port=$((port+10))
compose() { docker compose -p "$project" -f "$file" "$@"; }
cleanup() {
  if [[ -f "$file" ]]; then compose down -v --remove-orphans || return; fi
  rm -rf "$work"
}
if [[ "${1:-run}" == cleanup ]]; then cleanup; exit 0; fi
begin_chapter 10 'Compose: Nginx, Node process and PostgreSQL'
step 'prerequisites' ensure_prerequisites
step 'compose-plugin' docker compose version
step 'port-free' must_be_free "$port"
step 'new-working-copy' bash -c '[[ ! -e "$1" ]]' _ "$work"
mkdir -p "$work"
step 'copy-compose' cp "$VROOT/examples/chapter-10-docker-compose/compose.yaml" "$file"
step 'remap-host-port' python3 -c 'from pathlib import Path; import sys; p=Path(sys.argv[1]); t=p.read_text(); assert "127.0.0.1:8080:80" in t; p.write_text(t.replace("127.0.0.1:8080:80",f"127.0.0.1:{sys.argv[2]}:80"))' "$file" "$port"
step 'compose-config' compose config --quiet
step 'compose-up' compose up -d
step 'web-http' http_contains "$port" / 'Welcome to nginx!'
step 'postgres-query' compose exec -T db psql -U postgres -d postgres -c 'SELECT version();'
step 'compose-ps' compose ps
step 'compose-logs' compose logs --tail 25
step 'owned-resource-cleanup' cleanup
complete_chapter
