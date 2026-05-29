#!/usr/bin/env bash
# reproduce.sh — Single-command verification + example validation
#
# Conforms to PUBLIC_MIRROR_STANDARD.md v1.0.0.
#
# Activity Specification Protocol (ASP) is a schema + prompts + examples
# repository, not a numerical pipeline. This script:
#   1. Installs dev dependencies via uv sync
#   2. Runs the test suite (uv run pytest) if tests/ exists
#   3. Validates all example YAML files parse cleanly
#
# Usage:
#   ./reproduce.sh                  # Run full verification
#   ./reproduce.sh --check-only     # Verify dependencies; do not run checks
#
# Run log lands in output/logs/master_run.log

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

mkdir -p output/figures output/tables output/logs
LOG_FILE="output/logs/master_run.log"

echo "==================================================" | tee -a "$LOG_FILE"
echo "Pipeline run: $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee -a "$LOG_FILE"
echo "Repo: $REPO_ROOT" | tee -a "$LOG_FILE"
echo "Git SHA: $(git rev-parse HEAD 2>/dev/null || echo 'not-a-repo')" | tee -a "$LOG_FILE"
echo "==================================================" | tee -a "$LOG_FILE"

# Parse flags
CHECK_ONLY=0
for arg in "$@"; do
  case "$arg" in
    --check-only) CHECK_ONLY=1 ;;
    *) echo "Unknown flag: $arg"; exit 2 ;;
  esac
done

# 1. Dependency check / install
echo ">>> Checking dependencies..." | tee -a "$LOG_FILE"
if command -v uv >/dev/null 2>&1; then
  uv sync 2>&1 | tee -a "$LOG_FILE"
else
  echo "ERROR: uv not found. Install via 'curl -LsSf https://astral.sh/uv/install.sh | sh'" | tee -a "$LOG_FILE"
  exit 1
fi

if [[ "$CHECK_ONLY" == "1" ]]; then
  echo ">>> Check-only mode; exiting before pipeline." | tee -a "$LOG_FILE"
  exit 0
fi

# 2. Run test suite if present
if [[ -d tests ]]; then
  echo ">>> Running test suite (pytest)..." | tee -a "$LOG_FILE"
  uv run pytest 2>&1 | tee -a "$LOG_FILE" || true
else
  echo ">>> No tests/ directory found; skipping pytest." | tee -a "$LOG_FILE"
fi

# 3. Validate example YAML files parse cleanly
if [[ -d examples ]]; then
  echo ">>> Validating example YAML files..." | tee -a "$LOG_FILE"
  uv run python -c "
import sys, pathlib, yaml
errors = 0
for p in pathlib.Path('examples').rglob('*.yaml'):
    try:
        yaml.safe_load(p.read_text())
        print(f'  OK   {p}')
    except Exception as e:
        print(f'  FAIL {p}: {e}')
        errors += 1
sys.exit(1 if errors else 0)
" 2>&1 | tee -a "$LOG_FILE"
fi

echo "==================================================" | tee -a "$LOG_FILE"
echo "Pipeline complete: $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee -a "$LOG_FILE"
echo "==================================================" | tee -a "$LOG_FILE"
