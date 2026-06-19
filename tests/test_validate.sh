#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
LOG_FILE="$TMP_DIR/validate-poisoned.log"
trap 'rm -rf "$TMP_DIR"' EXIT

"$ROOT/scripts/sync.sh" >/dev/null
"$ROOT/scripts/validate.sh"

cp -R "$ROOT" "$TMP_DIR/repo"
printf 'BROKEN_MARKER: poison adapter\n' >> "$TMP_DIR/repo/adapters/claude/CLAUDE.md"

if "$TMP_DIR/repo/scripts/validate.sh" >"$LOG_FILE" 2>&1; then
  echo "expected validation to fail on poisoned adapter"
  exit 1
fi

grep -q 'unresolved marker' "$LOG_FILE"
