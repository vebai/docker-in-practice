# Chapter 5 — Environment Variables and Secrets

## Before you begin
Use a disposable local Docker environment. Never commit real `.env` files or plaintext secret material. Example values are demonstrations, not production credentials.

## Build and run with defaults
From the repository root:

```bash
cd examples/chapter-05-environment-and-secrets/env-demo
docker build -t book-env-demo .
docker run -d --name book-env-default -p 127.0.0.1:3000:3000 book-env-demo
curl -f http://localhost:3000
docker rm -f book-env-default
```

Expected: `Hello from MyApp on port 3000`.

## Override and use an environment file
```bash
docker run -d --name book-env-override -p 127.0.0.1:8080:8080 -e PORT=8080 -e APP_NAME=ProductionApp book-env-demo
curl -f http://localhost:8080
docker rm -f book-env-override
cp .env.example .env
docker run -d --name book-env-file -p 127.0.0.1:5000:5000 --env-file .env book-env-demo
curl -f http://localhost:5000
docker rm -f book-env-file
rm -f .env
```

Check that the greeting and port reflect the selected configuration. Inspect environment variables **only with disposable demonstration values**; real secrets may appear in inspection output.

## Optional BuildKit secret mount
The `buildkit-secret/Dockerfile` demonstrates a temporary secret mount without writing the secret to an image layer. Use only an invented local test value and delete the temporary secret file afterwards.

```bash
cd ../buildkit-secret
printf 'not-a-real-secret\n' > secret.txt
docker build --secret id=mysecret,src=./secret.txt -t book-buildkit-secret .
rm -f secret.txt
```

The build prints that the secret file was available; its value is not echoed. `ARG` and `ENV` are not a secure substitute for build secrets.
