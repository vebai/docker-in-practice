# Chapter 2 — Images, Containers and Registries

## Before you begin
Docker Engine must be running. This is independent of the other example directories.

## Run an image and inspect its container
```bash
docker pull nginx:alpine
docker run -d --name docker-book-nginx -p 127.0.0.1:8080:80 nginx:alpine
docker ps
curl -f http://localhost:8080
docker inspect docker-book-nginx
docker logs docker-book-nginx
```

**Expect:** an Nginx HTML response. `docker ps` shows the published local port. `docker inspect` exposes the container's actual configuration and state.

## Deliberate failure
```bash
docker run --rm nginx:this-tag-should-not-exist-12345
```

Expect an image manifest or pull error. Compare its image reference with the successful image. Inspect the error message before trying another tag.

## Cleanup
```bash
docker rm -f docker-book-nginx
```

Only remove this explicitly named lab container. The image can remain cached.
