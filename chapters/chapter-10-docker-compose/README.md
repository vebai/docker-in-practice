# Chapter 10 — Docker Compose

## Before you begin
Use modern `docker compose` syntax. This example runs **Nginx, a demonstration Node process and PostgreSQL** on a local Docker network. The web port binds to `127.0.0.1` so it is local-only. The password is deliberately fake; do not expose this stack or use its credential outside a disposable lab.

## Start and verify the stack
From the repository root:

```bash
cd examples/chapter-10-docker-compose
docker compose config --quiet
docker compose up -d
docker compose ps
curl -f http://localhost:8080
docker compose logs --tail=25
docker compose exec db psql -U postgres -d postgres -c 'SELECT version();'
```

Expect the default Nginx page and a PostgreSQL version response. The Node `app` service is a demonstration process, not a web API; the Nginx page does not proxy to it.

## Deliberate port conflict
Start another container on host port 18080, then temporarily change the `web` host mapping to `18080:80` and observe the Compose error. Restore the original `compose.yaml` afterwards. Prefer making a copy of the file for this test.

## Cleanup and retained data
```bash
docker compose down
```

Named `db-data` volume persists. **Only to discard local database data**:

```bash
docker compose down -v
```

The `-v` option deletes the PostgreSQL data volume. Use it only when that data is no longer needed.
