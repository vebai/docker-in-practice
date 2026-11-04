# Chapter 1 — Why Docker Exists

## Before you begin
Install and verify Docker using the [setup guide](../../docs/SETUP.md).

## Run, observe and inspect
```bash
docker run --rm hello-world
docker ps -a
docker image ls
```

**Expect:** `Hello from Docker!` and a local `hello-world` image. `--rm` removes the completed test container, so `docker ps -a` may not list it.

## Break and diagnose
```bash
docker run --rm image-that-does-not-exist
```

Expect a pull error. Read the exact image reference and registry error before changing anything. Do not interpret a registry failure as proof that Docker Engine is broken.

## Cleanup
The disposable container has already been removed by `--rm`. The downloaded `hello-world` image may remain cached and is safe to keep for later labs.
