#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
LOG_FILE="$TMP_DIR/parity-drift.log"
trap 'rm -rf "$TMP_DIR"' EXIT

"$ROOT/scripts/sync.sh" >/dev/null
"$ROOT/scripts/check-parity.sh"

cp -R "$ROOT" "$TMP_DIR/repo"
printf '\nparity drift\n' >> "$TMP_DIR/repo/adapters/gemini/GEMINI.md"

if "$TMP_DIR/repo/scripts/check-parity.sh" >"$LOG_FILE" 2>&1; then
  echo "expected parity check to fail after adapter drift"
  exit 1
fi

grep -q 'hash mismatch' "$LOG_FILE"
