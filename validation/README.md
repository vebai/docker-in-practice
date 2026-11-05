# Docker in Practice — chapter-by-chapter validation suite

This optional **engineering validation harness** checks the exercises in the public
`vebai/docker-in-practice` companion repository. It runs **on your Mac/Linux host**.
Do not run it inside a container or AWS CloudShell.

## Install

Unzip the `validation/` folder into the root of your existing local
`docker-in-practice` clone, beside `examples/`, `chapters/`, and `tests/`.

```bash
cd ~/Downloads/book-validation-20261104/docker-in-practice
chmod +x validation/*.sh
./validation/run-all.sh --list
./validation/run-all.sh --status
```

## Use it

You have already validated Chapters 3–4 manually. To begin with **Chapter 5**:

```bash
./validation/run-all.sh --chapter 05
```

When you are happy with Chapter 5, validate Chapters 6–9 automatically:

```bash
./validation/run-all.sh --from 06 --to 09
```

For an end-to-end validation pass (includes downloading base images, database
containers and running the final three-service stack):

```bash
./validation/run-all.sh --from 01 --to 13
```

If a run stops at Chapter 7, for example:

1. Inspect `validation/results/chapter-07.log` and the named `bookval-ch07-*`
   containers with `docker logs` / `docker inspect`.
2. Correct the environment, script or book exercise based on the evidence.
3. Run `./validation/ch07.sh cleanup` to remove **only** that chapter's named
   validation containers (after recording any useful logs).
4. Resume from Chapter 7: `./validation/run-all.sh --from 07`.

To verify a single chapter, run `./validation/ch07.sh`, or
`./validation/run-all.sh --chapter 07`.

## Checkpoints and evidence

Each script prints steps named like `>>> [05.build-app]`. The first unexpected
failure immediately stops the run, writes:

- `validation/results/chapter-NN.log`: complete command output
- `validation/results/chapter-NN.fail`: the first failed checkpoint and log path
- `validation/results/chapter-NN.pass`: written **only** after all automated
  checkpoints in that chapter succeed

Run `./validation/run-all.sh --status` to see which chapters passed, failed or are still untested.

There is **no silent automatic retry** of a failed step, except bounded HTTP /
health readiness probes. Failed lab containers and Compose services are left
running for diagnosis. Successful chapters clean up only their owned lab
containers, volumes and networks; Docker images are retained for rebuild speed.

A `PASS` from Chapter 12 means its **local image and HTTP checks** passed, not
that GitHub Actions or a remote registry push was run. The optional registry
publishing exercise and any book-to-repository text comparison still need
separate manual verification. Chapters 1–13 passing does **not** independently
prove that the paperback manuscript has been reconciled.

## Safe isolation

- Validation container names start with `bookval-chNN-*`.
- Compose projects use `bookval-ch10` and `bookval-ch13`.
- Host ports normally use 18102–18113, instead of common ports 3000/5000/8080.
- Change the port range if required:

  ```bash
  VALIDATION_PORT_BASE=19100 ./validation/run-all.sh --from 05 --to 09
  ```

- To avoid editing book examples, Chapters 10 and 13 use disposable copies of
  their Compose files under `validation/work/` and remap only the host port.
- Chapter 13 tests persistence by running `compose down` **without** `-v`, then
  starting again and querying the saved todo item. It removes only its own
  temporary project and volume **after** persistence is verified.
- The scripts never execute `docker system prune`, never modify an unrelated
  named container, never publish an image, and never create AWS resources.
- The scripts don't require the Docker daemon to be restarted. They **do not**
  install or upgrade Docker, Node or system packages.
- Chapters 6, 10 and 13 start databases with example passwords. Use only a
  disposable local environment, not a shared or production server.
- Chapter 13 requires more Docker memory than basic single-container tests.
  Your previously reported ~1.94 GiB Docker VM may need its allocation raised
  before this chapter. Check the five pre-existing running containers first.

## Limitations

The suite passed **Bash syntax and harness-flow tests** before the first live run. On 4 November 2026 the author supplied MacBook logs showing automated **Chapters 05–13 passing** against a Docker Engine. Chapters 01–04 have not yet been proven by the new runner, although Chapters 03–04 passed comparable manual exercises. See `docs/VALIDATION-EVIDENCE-2026-11-04.md` for precise scope. The assistant has not independently executed Docker Engine in its own environment.

No automatic script fully substitutes for the book's exercise in deliberate
failure interpretation, security decisions, or production registry workflows.
