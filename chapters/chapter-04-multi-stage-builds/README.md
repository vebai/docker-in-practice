# Chapter 4 — Multi-stage Builds

## Before you begin
Docker Engine must be running. The Go example includes a complete source file; the compiler runs **inside the builder image**, so Go is not required on the host.

## Build both Go images
From the repository root:

```bash
cd examples/chapter-04-multi-stage-builds/go-demo
docker build -f single.Dockerfile -t book-go-single .
docker build -f multi.Dockerfile -t book-go-multi .
docker image ls book-go-single book-go-multi
docker history book-go-multi
```

The multi-stage image should be smaller because it does not include Go build tools. Check actual sizes instead of assuming a fixed number of MB.

## Verify the built application
```bash
docker run -d --name book-go-web -p 127.0.0.1:8080:8080 book-go-multi
curl -f http://localhost:8080
docker rm -f book-go-web
```

Expect **Hello from Docker!**.

## Optional Node.js frontend build
From the repository root:

```bash
cd examples/chapter-04-multi-stage-builds/node-frontend-demo
npm install
docker build -t book-frontend-multi .
docker run -d --name book-frontend -p 127.0.0.1:8080:80 book-frontend-multi
curl -f http://localhost:8080
docker rm -f book-frontend
```

Here `npm run build` produces a small `dist/` directory, which the final Nginx image serves. The Node build image does not appear in the final runtime image. Run one port-8080 lab at a time.

## If the build fails
Inspect `COPY --from=builder` paths. The source exercise deliberately misspells an artefact; the error should point at the missing path, not an AWS or network problem.
