# Chapter 6 — Volumes and Docker Networks

## Before you begin
Docker Engine must be running. These exercises use named resources `book-data` and `book-app-network` to avoid colliding with your own containers.

## Prove a named volume survives container replacement
```bash
docker volume create book-data
docker run --rm -v book-data:/data alpine:3.24 sh -c 'echo hello > /data/message.txt'
docker run --rm -v book-data:/data alpine:3.24 cat /data/message.txt
```

Expect `hello`. Both disposable containers have been removed; the value persists in the Docker-managed volume.

## Check service-name networking
```bash
docker network create book-app-network
docker run -d --name book-db --network book-app-network -e POSTGRES_PASSWORD=example-password postgres:15-alpine
docker run --rm --network book-app-network postgres:15-alpine pg_isready -h book-db -U postgres
docker network inspect book-app-network
```

The first database readiness check may fail while PostgreSQL starts; repeat after a short delay. **Expect:** `book-db:5432 - accepting connections` once ready. This proves the network path and service-name resolution, not application credentials or database correctness.

## Deliberate network isolation
Try the readiness probe *without* `--network book-app-network` and inspect the name-resolution error. Do not connect the database to all networks just to mask an incorrect configuration.

## Cleanup
```bash
docker rm -f book-db
docker network rm book-app-network
```

The volume `book-data` is intentionally retained. Only when its contents are no longer needed:

```bash
docker volume rm book-data
```
