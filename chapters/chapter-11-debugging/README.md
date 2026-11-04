# Chapter 11 — Diagnose Broken Containers

## Before you begin
This controlled failure uses Alpine and deliberately omits `curl`. It should be run **only in the example directory**.

## Build a broken image and gather evidence
From the repository root:

```bash
cd examples/chapter-11-debugging
docker build -f broken.Dockerfile -t book-debug-broken .
docker run --name book-debug-broken book-debug-broken
docker ps -a
docker logs book-debug-broken
docker inspect --format='{{.State.ExitCode}}' book-debug-broken
```

Expected exit code: `127`, because the script calls `curl` but the image does not contain that command.

## Apply the smallest fix
```bash
docker build -f fixed.Dockerfile -t book-debug-fixed .
docker run --name book-debug-fixed book-debug-fixed
docker inspect --format='{{.State.ExitCode}}' book-debug-fixed
```

Expected exit code: `0`. The fix adds the missing package rather than hiding or restarting the failing command.

## Cleanup
```bash
docker rm -f book-debug-broken book-debug-fixed
docker image rm book-debug-broken book-debug-fixed
```

Check actual names before removing resources; do not run broad prune commands.
