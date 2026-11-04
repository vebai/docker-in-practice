# Troubleshooting Docker exercises

Use evidence before changing a configuration:

```bash
docker ps -a
docker inspect <container-name>
docker logs <container-name>
docker image ls
docker network ls
docker volume ls
```

Check the exact image tag, container state, exit code, logs, published ports, mount paths, network membership and health status. A container may be **running** but **unhealthy**; an exited container may still have logs. `docker exec` requires a running container.

For a Compose exercise, run these commands from the folder containing `compose.yaml`:

```bash
docker compose ps -a
docker compose logs --tail=50
docker compose config --quiet
```

If a Node Dockerfile uses `npm ci`, generate and retain a `package-lock.json` by running `npm install` in that *example directory* before building. If a port is already allocated, inspect the current listener instead of deleting unrelated containers. If a volume appears empty, check whether the correct volume is mounted and whether the data was written to that path.

Never paste real secrets into shared diagnostic logs. Prefer the smallest justified fix; then re-run the same verification that failed.
