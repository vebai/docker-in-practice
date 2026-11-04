# Chapter 7 — Docker Health Checks

## Before you begin
This standalone Node.js application has a `/health` endpoint and a Dockerfile health check. `curl` is installed **inside** its Alpine-based image.

## Build and verify application health
From the repository root:

```bash
cd examples/chapter-07-health-checks
docker build -t book-health .
docker run -d --name book-health -p 127.0.0.1:3000:3000 book-health
curl -f http://localhost:3000/health
docker inspect --format='{{.State.Health.Status}}' book-health
```

Expect `OK`; health may be `starting` briefly before becoming `healthy`.

## Controlled unhealthy example
```bash
docker build -f broken.Dockerfile -t book-health-broken .
docker run -d --name book-health-broken -p 127.0.0.1:3001:3000 book-health-broken
docker inspect --format='{{.State.Health.Status}}' book-health-broken
docker inspect --format='{{json .State.Health}}' book-health-broken
```

After the retry threshold, expect `unhealthy` because the health probe requests a deliberately missing path. **Running does not equal healthy.** Docker does not restart a running container solely because it becomes unhealthy.

## Cleanup
```bash
docker rm -f book-health book-health-broken
```
