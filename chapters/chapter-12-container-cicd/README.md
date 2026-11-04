# Chapter 12 — Build and Publish Images

## Before you begin
This chapter separates **local image verification** from **publishing an image to a registry**. Publishing needs your own Docker Hub account and explicit registry credentials; it is optional.

## Build and smoke-test the Flask image locally
From the repository root:

```bash
cd examples/chapter-12-container-cicd/ci-flask
docker build -t book-ci-flask:test .
docker run -d --name book-ci-flask -p 127.0.0.1:5000:5000 book-ci-flask:test
curl -f http://localhost:5000/
docker rm -f book-ci-flask
```

Expected: `Hello from Docker!`.

## Optional GitHub Actions publishing
The example `.github/workflows/build.example.yml` lives **inside this example directory** and therefore is not automatically active in the root repository. To run it, copy and adapt the workflow into `.github/workflows/build.yml` of **your own practice repository**, set up Docker Hub secrets `DOCKER_USERNAME` and `DOCKER_TOKEN`, and review permissions, registry, branch and action versions first.

Pull requests should build and test but should not push an image. Publishing can create public images, so enable it only with your explicit authorisation. The accompanying GitLab CI example is also inactive by default and assumes a suitable Docker-enabled runner.

## Verify a published image
Check the workflow's build/test steps, then check your registry's image tag and digest. A successful build alone does not prove that the image was pushed or is deployable. Never commit a registry access token.

## Cleanup
Remove the named local lab container and any images you explicitly created. Registry images are managed separately and are **not** removed by local `docker image rm`.
