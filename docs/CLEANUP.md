# Clean up Docker learning resources

Each chapter README lists its own container names. Inspect what exists before removing anything:

```bash
docker ps -a
docker image ls
docker volume ls
docker network ls
```

For Compose exercises, from their own example directory:

```bash
docker compose down
```

This removes the Compose containers and network but retains named volumes. If and only if you intend to **permanently delete the lab database contents**:

```bash
docker compose down -v
```

Use individual `docker rm`, `docker image rm`, `docker network rm` and `docker volume rm` commands for named lab resources after verifying they are no longer needed. Never use `docker system prune --volumes` as a routine cleanup step on a shared machine.
