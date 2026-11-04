#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
owner="vebai"
repo="docker-in-practice"
if ! command -v git >/dev/null || ! command -v gh >/dev/null; then
  echo 'Install git and GitHub CLI (gh) before publishing.' >&2; exit 1
fi
gh auth status >/dev/null
bash tests/validate-files.sh
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo 'This directory already belongs to a Git repository. Review manually before pushing.' >&2; exit 1
fi
if gh repo view "${owner}/${repo}" >/dev/null 2>&1; then
  echo "GitHub repository ${owner}/${repo} already exists. No changes made." >&2; exit 1
fi
read -r -p "Create PUBLIC repository ${owner}/${repo} and push the contents? Type yes: " answer
[ "$answer" = yes ] || { echo 'Cancelled.'; exit 1; }
git init -b main
git add .
git diff --cached --check
git commit -m 'Add Docker in Practice companion learning repository'
gh repo create "${owner}/${repo}" --public --source=. --remote=origin --push
printf '\nPublished: https://github.com/%s/%s\n' "$owner" "$repo"
