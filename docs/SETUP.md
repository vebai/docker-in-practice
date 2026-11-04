# Install Docker and verify your environment

Run these commands **on your MacBook, Linux computer or WSL terminal**, not inside a sample container. Use Docker Desktop for macOS/Windows or Docker Engine and the Compose plugin on Linux.

## macOS

Install Docker Desktop using its official installer or Homebrew, then launch Docker Desktop and allow the engine to start:

```bash
brew install --cask docker-desktop
```

## Windows

Install Docker Desktop and enable WSL 2 when prompted. Use a Bash-compatible WSL terminal for the Unix-style examples. Linux users should follow Docker's current official distribution-specific installation instructions if system package names differ.

## Ubuntu — distribution packages

The book provides the Ubuntu repository route. Verify that your Ubuntu release offers these packages; otherwise use the supported Docker Engine repository instructions for your distribution.

```bash
sudo apt update
sudo apt install -y docker.io docker-compose-v2
sudo systemctl enable --now docker
```

## Fedora — distribution packages

The book uses Moby and the distro-provided Compose package:

```bash
sudo dnf install -y moby-engine docker-compose
sudo systemctl enable --now docker
```

Alternatively, use Docker's official repository and Docker CE packages. **Do not mix** distribution-maintained Docker/Moby and upstream Docker CE packages on the same host.

## Confirm the engine and Compose

```bash
docker --version
docker info
docker compose version
docker run --rm hello-world
```

Docker Desktop should show the engine running. On Linux, confirm the daemon is started. If you receive a Docker socket permission error, check the daemon and access permissions. On Linux, membership of the `docker` group gives root-equivalent access—limit it to trusted users.

## Other tools

- Git to clone the repository
- `curl` to verify HTTP responses (or use a browser)
- Node.js and npm **on your host** for the Node.js lock-file preparation steps in Chapters 3, 4 and 13
- Docker Hub account and GitHub Actions only if you decide to publish an image in Chapter 12

## Safety before starting

Check which ports are already in use (the labs commonly use 3000, 5000, 8080). Run experiments on a trusted local computer. Avoid real passwords in `.env`, Dockerfiles or shell history. Clean up containers after each isolated lab, but keep named data volumes until you intend to delete their contents.
