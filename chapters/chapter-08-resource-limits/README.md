# Chapter 8 — CPU and Memory Limits

## Before you begin
This local exercise intentionally restricts CPU and memory. On shared machines, avoid stressing resources or creating a deliberate out-of-memory condition unless you have permission.

## Apply and observe limits
```bash
docker run -d --name book-limits --memory=256m --cpus=0.5 alpine:3.24 sh -c 'while true; do sleep 5; done'
docker inspect --format='Memory={{.HostConfig.Memory}} NanoCPUs={{.HostConfig.NanoCpus}}' book-limits
docker stats --no-stream book-limits
```

Expect the `inspect` result to show the requested limits. `docker stats` shows observed usage, which may be low for this idle example. Inspect limits separately from observed CPU and memory use.

## Diagnose resource-related exits
```bash
docker ps -a
docker inspect --format='{{.State.OOMKilled}}' book-limits
docker inspect --format='{{.State.ExitCode}}' book-limits
```

An OOM-killed container may report `OOMKilled=true` and exit code 137, but 137 alone does not prove an OOM event.

## Cleanup
```bash
docker rm -f book-limits
```
