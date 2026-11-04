# Docker in Practice

**Companion GitHub repository** for *Docker in Practice: A Practical Guide to Images, Containers, Dockerfiles, Compose, Registries, and Debugging* by **Victor Ebai**.

The book is fully self-contained. This repository gives you convenient, practical files for the book's exercises, so you can build images, run containers, inspect evidence, deliberately reproduce faults, verify fixes and clean up safely.

**Working method:** Build → Observe → Break → Diagnose → Fix → Verify.

## Before you begin

Read the [setup guide](docs/SETUP.md) to install Docker Engine or Docker Desktop, verify Compose and configure your terminal. A Docker Hub or GitHub account is optional until the image-publishing chapter.

Verify Docker before using the exercises:

```bash
docker --version
docker compose version
docker run --rm hello-world
```

The examples are intended for a **local, disposable learning environment**. Do not expose practice credentials or open lab ports to public networks.

## Choose a chapter

| Chapter | Exercise | Starting point |
|---|---|---|
| [01](chapters/chapter-01-first-container/README.md) | Run your first container | No project files required |
| [02](chapters/chapter-02-images-and-containers/README.md) | Pull, run and inspect an image | Independent |
| [03](chapters/chapter-03-dockerfiles/README.md) | Build static, Node.js and Python images | [Three runnable projects](examples/chapter-03-dockerfiles/) |
| [04](chapters/chapter-04-multi-stage-builds/README.md) | Compare Go image sizes | [Go project](examples/chapter-04-multi-stage-builds/go-demo/) |
| [05](chapters/chapter-05-environment-and-secrets/README.md) | Configure a Node.js container | [Environment example](examples/chapter-05-environment-and-secrets/env-demo/) |
| [06](chapters/chapter-06-volumes-and-networks/README.md) | Test persistence and DNS networking | Independent, disposable |
| [07](chapters/chapter-07-health-checks/README.md) | Verify healthy and unhealthy containers | [Node health-check example](examples/chapter-07-health-checks/) |
| [08](chapters/chapter-08-resource-limits/README.md) | Inspect CPU and memory limits | Independent, disposable |
| [09](chapters/chapter-09-container-logs/README.md) | Read and filter log evidence | Independent, disposable |
| [10](chapters/chapter-10-docker-compose/README.md) | Run a three-service stack | [Compose example](examples/chapter-10-docker-compose/) |
| [11](chapters/chapter-11-debugging/README.md) | Diagnose a broken container | [Controlled failure](examples/chapter-11-debugging/) |
| [12](chapters/chapter-12-container-cicd/README.md) | Build, test and optionally push an image | [CI example](examples/chapter-12-container-cicd/) |
| [13](chapters/chapter-13-final-project/README.md) | Run Node.js, PostgreSQL and Redis | [Final project](examples/chapter-13-final-project/) |

Each chapter README gives the starting directory, commands to run, expected evidence, troubleshooting and targeted cleanup. Chapter examples generally run independently. The final project combines the skills into a complete multi-service application.

## Two ways to work

**Follow the book:** Read the chapter, predict the outcome, use its commands, then compare your result with the expected evidence.

**Use the supplied files:** Clone this repository and start in the matching chapter README. The files are intentionally small and editable; the original book explains the mental models and engineering decisions in greater depth.

```bash
git clone https://github.com/vebai/docker-in-practice.git
cd docker-in-practice
```

This URL becomes available after the repository is published. If you are using the downloadable ZIP, extract it and open the `docker-in-practice` folder instead.

## Safe verification and cleanup

Check names and ownership before deleting containers, images, networks or volumes. `docker compose down` keeps named volumes, while `docker compose down -v` **deletes** their stored data. Do not use broad prune commands on a shared machine.

See [Troubleshooting](docs/TROUBLESHOOTING.md) and [Cleaning up](docs/CLEANUP.md). The [local file validator](tests/validate-files.sh) checks example file syntax and documentation links without running Docker.

**Security:** No real credentials belong in this repository. `.env.example` contains illustrative values only. The optional registry-publishing workflow is provided as a template under `examples/` and is **not activated** automatically.
