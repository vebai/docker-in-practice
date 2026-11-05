#!/usr/bin/env bash
source "$(dirname "$0")/lib.sh"
base="$VROOT/examples/chapter-05-environment-and-secrets"
work="$VWORK/ch05"; port="${VALIDATION_PORT_BASE:-18100}"; port=$((port+5))
a=bookval-ch05-default; b=bookval-ch05-override; c=bookval-ch05-file
if [[ "${1:-run}" == cleanup ]]; then
  cleanup_names "$a" "$b" "$c"
  if [[ -d "$work" ]]; then rm -f "$work/.env" "$work/secret.txt"; rmdir "$work" 2>/dev/null || true; fi
  exit 0
fi
begin_chapter 5 'Environment variables, env file and BuildKit secret'
step 'prerequisites' ensure_prerequisites
step 'port-free' must_be_free "$port"
step 'unique-containers' must_not_exist "$a" "$b" "$c"
step 'build-app' docker build -t bookval-ch05-env "$base/env-demo"
step 'default-start' docker run -d --name "$a" -p "127.0.0.1:${port}:3000" bookval-ch05-env
step 'default-response' http_contains "$port" / 'Hello from MyApp on port 3000'
step 'default-cleanup' cleanup_names "$a"
step 'override-start' docker run -d --name "$b" -p "127.0.0.1:${port}:8080" -e PORT=8080 -e APP_NAME=ProductionApp bookval-ch05-env
step 'override-response' http_contains "$port" / 'Hello from ProductionApp on port 8080'
step 'override-cleanup' cleanup_names "$b"
mkdir -p "$work"
step 'copy-example-env' cp "$base/env-demo/.env.example" "$work/.env"
step 'envfile-start' docker run -d --name "$c" -p "127.0.0.1:${port}:5000" --env-file "$work/.env" bookval-ch05-env
step 'envfile-response' http_contains "$port" / 'Hello from EnvFileApp on port 5000'
step 'envfile-cleanup' cleanup_names "$c"
step 'secret-prepare' bash -c 'printf "not-a-real-secret\\n" > "$1"' _ "$work/secret.txt"
step 'secret-build' env DOCKER_BUILDKIT=1 docker build --secret "id=mysecret,src=$work/secret.txt" -t bookval-ch05-secret "$base/buildkit-secret"
step 'secret-remove' rm -f "$work/secret.txt" "$work/.env"
complete_chapter
