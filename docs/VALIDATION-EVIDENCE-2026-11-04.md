# Validation evidence — Docker in Practice

Maintainer validation snapshot: 4 November 2026, Intel Mac (macOS 15.7.9), Docker Engine 20.10.11, Docker Compose v2.2.1. Live console results were reviewed in the authoring session. The log files under `validation/results/` are generated locally and deliberately excluded from the public repository.

| Chapter | Observed coverage | Evidence status |
|---|---|---|
| 01 | Docker hello-world succeeded; deliberate image-pull failure not yet confirmed with chapter runner | Partial |
| 02 | Chapter runner not yet confirmed | Pending |
| 03 | Nginx, Node.js and Python image builds, application HTTP 200 responses and cleanup | Manual PASS |
| 04 | Go single/multi-stage builds (347 MB vs 17.5 MB), HTTP 200; Node frontend built, 63 MB, HTTP 200 | Manual PASS |
| 05 | Environment defaults, overrides, env file and BuildKit secret | Automated PASS |
| 06 | Named-volume persistence, Docker DNS, expected isolation failure, cleanup | Automated PASS |
| 07 | Healthy HTTP probe and deliberately unhealthy image | Automated PASS |
| 08 | Requested CPU and memory limit configuration and observed usage | Automated PASS |
| 09 | Container logging, timestamp output and log driver | Automated PASS |
| 10 | Three-service Compose, Nginx HTTP, PostgreSQL query, logs and cleanup | Automated PASS |
| 11 | Missing curl failure (127), corrected image exit 0 and cleanup | Automated PASS |
| 12 | Local Flask image build, container HTTP smoke test and inactive workflow file presence | Local automated PASS; registry publication not tested |
| 13 | Node.js API, PostgreSQL, Redis, create/read todo, persistence after Compose down/up, health and cleanup | Automated PASS |

## Evidence boundaries

A passing image build does not prove HTTP behaviour. A running container does not prove application health. A successful local CI smoke test does not prove that a remote workflow ran or that an image was pushed to Docker Hub. Chapter 13's /health check tests HTTP responsiveness; POST/GET and restart tests provide separate application and persistence evidence.

**Remaining before full publication sign-off:** run Chapter 1–2 chapter scripts, reconcile the printed manuscript with the repository, conduct an optional real registry-publishing test with appropriate credentials, and confirm final KDP trim size and pagination. Static checks and per-chapter scripts should also run on supported current Docker Desktop versions beyond the tested engine.
