# Chapter 9 — Container Logs and Log Drivers

## Before you begin
This is a local, disposable logging exercise. Avoid printing real credentials or personal information into container logs.

## Generate and inspect stdout logs
```bash
docker run -d --name book-log-demo alpine:3.24 sh -c 'i=0; while true; do echo "$(date): Log line $i"; i=$((i+1)); sleep 2; done'
docker logs book-log-demo
docker logs --tail 5 book-log-demo
docker logs --since 10s book-log-demo
docker logs --timestamps book-log-demo
docker inspect --format='{{.HostConfig.LogConfig.Type}}' book-log-demo
```

To follow logs live, run `docker logs -f book-log-demo` and press `Ctrl+C` to return to the shell.

## Why logs can be absent
`docker logs` reads the container's stdout/stderr streams as supported by its log driver. A process that writes only to a file inside a container may produce no useful `docker logs` output. Inspect the application logging destination before changing the log driver.

## Cleanup
```bash
docker rm -f book-log-demo
```

Do not overwrite a host-wide Docker daemon configuration just to perform this exercise. The book discusses log rotation; per-container settings are safer for learning.
