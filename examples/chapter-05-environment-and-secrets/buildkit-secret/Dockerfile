# syntax=docker/dockerfile:1
FROM alpine:3.24

RUN --mount=type=secret,id=mysecret \
    test -f /run/secrets/mysecret && echo "Secret was available during build"
