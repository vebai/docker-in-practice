# Chapter 3 — Writing Practical Dockerfiles

## Before you begin
Docker must be running. Node.js and npm are needed **on your host** only for the Node lock file. Run each build from the stated example directory.

## Static site: Dockerfile and Nginx
```bash
cd examples/chapter-03-dockerfiles/static-site
docker build -t book-static-site .
docker run -d --name book-static-site -p 127.0.0.1:8080:80 book-static-site
curl -f http://localhost:8080
docker rm -f book-static-site
```

Expect **Hello from Docker!** in the HTML response.

## Node.js image and dependency caching
From the repository root:

```bash
cd examples/chapter-03-dockerfiles/node-demo
npm install
docker build -t book-node-demo .
docker run -d --name book-node-demo -p 127.0.0.1:8080:3000 book-node-demo
curl -f http://localhost:8080
docker rm -f book-node-demo
```

`npm install` creates the lock file needed by the supplied `npm ci` Dockerfile. Rebuild without editing to observe cache reuse. Keep `node_modules/` out of the image context.

## Python image
From the repository root:

```bash
cd examples/chapter-03-dockerfiles/python-demo
docker build -t book-python-demo .
docker run -d --name book-python-demo -p 127.0.0.1:8080:8000 book-python-demo
curl -f http://localhost:8080
docker rm -f book-python-demo
```

The example uses Flask's development server for local learning, not production. Verify the actual Docker image and exit state with `docker ps -a` and `docker logs` if either example fails.

## If HTTP verification fails or a host port is occupied

Inspect the lab container first with `docker ps -a`, `docker logs` and
`docker port`. On macOS, `lsof -nP -iTCP:8080 -sTCP:LISTEN` identifies a
process already listening on port 8080. Choose a free *host* port such as
18080 rather than stopping unrelated processes; leave the image's internal
port unchanged. For HTTP startup races, wait for the application startup
message and retry with `curl --noproxy '*'` before changing the Dockerfile.

These steps were observed during the November 2026 Intel Mac live validation.

## Cleanup
Use only the named lab containers above. Images may remain cached; remove them individually if no longer required. Running these three examples sequentially avoids port 8080 conflicts.
