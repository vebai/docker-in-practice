# Docker in Practice

**Companion repository for *Docker in Practice: A Practical Guide to Images, Containers, Dockerfiles, Compose, Registries, and Debugging* by Victor Ebai.**

## What you will achieve with the book

An application that works on your laptop can fail elsewhere because its dependencies, configuration or runtime environment differ. *Docker in Practice* gives you a practical way to package applications consistently, understand how containers behave and diagnose problems using evidence rather than guesswork.

Through hands-on exercises, you will learn to:

- **Build repeatable images** using Dockerfiles, build caching and multi-stage builds.
- **Run and configure containers** with environment variables, safer secret-handling practices, persistent volumes and networks.
- **Operate and troubleshoot applications** with health checks, CPU and memory limits, container state, exit codes and logs.
- **Run connected services** with Docker Compose and prepare container images for CI/CD pipelines.

The final project combines Node.js, PostgreSQL and Redis into a multi-container application you can build, start, inspect, troubleshoot and shut down safely. The aim is to give you the confidence to understand **what Docker is doing, why a container failed and how to verify a fix**.

## How this repository supports the book

The book is fully self-contained. This repository provides ready-to-use application files, Dockerfiles, Compose configurations and chapter-by-chapter lab guides so you can concentrate on practising the workflows rather than recreating every file by hand.

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

**Use the supplied files:** Clone this repository and start in the matching chapter README. The files are deliberately small and editable; the book explains the underlying concepts and engineering decisions.

```bash
git clone https://github.com/vebai/docker-in-practice.git
cd docker-in-practice
```

## Optional automated chapter validation

The reader-facing book is self-contained. The optional `validation/` directory
contains one shell script per chapter and a master runner with named
checkpoints, captured logs and safe, chapter-scoped cleanup.

From the repository root, on your Mac/Linux workstation with Docker running:

```bash
chmod +x validation/*.sh
./validation/run-all.sh --list
./validation/run-all.sh --status
./validation/run-all.sh --chapter 05
```

To continue after a successful Chapter 5:

```bash
./validation/run-all.sh --from 06
```

**Failure handling:** inspect `validation/results/chapter-NN.log` and the
named `bookval-chNN-*` resources *before* running
`./validation/chNN.sh cleanup` and resuming with `--from NN`. The scripts
avoid unrelated containers and do not publish registry images or create AWS
resources. A chapter PASS covers only the automated checks; deliberate
manual investigation and Chapter 12's optional remote publication exercise
remain separate. See [Validation guide](validation/README.md) and
[Recorded coverage](docs/VALIDATION-EVIDENCE-2026-11-04.md).

## Safe verification and cleanup

Check names and ownership before deleting containers, images, networks or volumes. `docker compose down` keeps named volumes, while `docker compose down -v` **deletes** their stored data. Do not use broad prune commands on a shared machine.

See [Troubleshooting](docs/TROUBLESHOOTING.md) and [Cleaning up](docs/CLEANUP.md). The [local file validator](tests/validate-files.sh) checks example file syntax and documentation links without running Docker.

**Security:** No real credentials belong in this repository. `.env.example` contains illustrative values only. The optional registry-publishing workflow is provided as a template under `examples/` and is **not activated** automatically.
