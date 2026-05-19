#!/usr/bin/env bash
#
# run-first.sh — the one-command bootstrap for pipeline-demo.
#
# Run this once after `git clone`. It does, in order:
#
#   1. npm install      — pulls @jahbini/pipeline from GitHub
#   2. npm run setup    — drops override.yaml from the package's
#                          override.test.yaml, then creates .venv
#                          and pip-installs MLX (mlx, mlx-lm,
#                          mlx-metal at pinned versions)
#   3. npm run demo     — runs the 9-step test pipeline; ends with
#                          step9_handoff printing a friendly
#                          orientation message
#
# When step 3 finishes you'll know everything works. From there,
# `npm run demo` re-runs the pipeline, `npm run ui` launches the
# web UI, and `npm run clean` wipes runtime artifacts so you can
# start fresh.
#
set -euo pipefail
cd "$(dirname "$0")"

banner() {
  echo
  echo "════════════════════════════════════════════════════════════════════"
  echo "  $1"
  echo "════════════════════════════════════════════════════════════════════"
}

banner "1/3  npm install — pulling @jahbini/pipeline from GitHub"
npm install

banner "2/3  npm run setup — override.yaml + .venv with MLX (slow first time)"
npm run setup

banner "3/3  npm run demo — running the 9-step test pipeline"
npm run demo

echo
echo "Done. Edit override.yaml to switch pipelines, or run \`npm run ui\`"
echo "to launch the local web UI on http://127.0.0.1:4311."
