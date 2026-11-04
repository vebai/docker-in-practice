# Chapter 13 — Final Project

## What you will run
A Node.js todo API, PostgreSQL for persistent data and Redis for a short-lived todo-list cache. Compose manages their networking, database volume, health checks and startup dependencies.

## Before you begin
Docker and Docker Compose must be running. You need Node.js and npm installed **on your host** to generate the initial dependency lock file. Use only the supplied demonstration credentials in a trusted local learning environment.

## Build and start
From the repository root:

```bash
cd examples/chapter-13-final-project
npm install
cp .env.example .env
docker compose config --quiet
docker compose build
docker compose up -d
docker compose ps
```

`npm install` creates `package-lock.json` for the Dockerfile's `npm ci` step. The HTTP port binds to `127.0.0.1` for local testing. The `.env` is ignored by Git and must never contain real production credentials. On first startup, wait for PostgreSQL and Redis health checks before testing the API.

## Verify application behaviour
```bash
curl -f http://localhost:3000/health
curl -f -X POST http://localhost:3000/todos \
  -H 'Content-Type: application/json' \
  -d '{"task":"Learn Docker"}'
curl -f http://localhost:3000/todos
docker compose logs --tail=50 app
```

Expected: `/health` returns `{"status":"ok"}`, the POST returns the created todo, and GET returns a list including it. **The process health endpoint checks HTTP responsiveness; the POST/GET checks additionally prove actual database and cache paths.**

## Verify persistence without deleting data
```bash
docker compose down
docker compose up -d
curl -f http://localhost:3000/todos
```

The todo should still exist because PostgreSQL data is stored in the named volume. A restart can require waiting for health checks.

## Troubleshooting
Inspect `docker compose ps -a`, then `docker compose logs --tail=50 db`, `redis` and `app`. Check that the database URL uses hostname `db`, not `localhost`, from inside the app. If `npm ci` reports a missing lock file, run `npm install` in this example directory before rebuilding.

## Cleanup
```bash
docker compose down
```

This retains todo data in the PostgreSQL volume. **Only if you deliberately want to erase all local todo data**, run `docker compose down -v`. Remove `.env` when done and avoid committing it.
