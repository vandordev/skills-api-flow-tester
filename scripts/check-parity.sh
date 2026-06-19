#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CORE_HASH="$(sha256sum "$ROOT/core/SKILL.md" | awk '{print $1}')"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

check_hash_line() {
  local file="$1"
  grep -q "source_sha256: $CORE_HASH" "$file" || {
    echo "hash mismatch: $file" >&2
    exit 1
  }
}

check_hash_line "$ROOT/adapters/codex/SKILL.md"
check_hash_line "$ROOT/adapters/claude/CLAUDE.md"
check_hash_line "$ROOT/adapters/copilot/copilot-instructions.md"
check_hash_line "$ROOT/adapters/gemini/GEMINI.md"

cp -R "$ROOT" "$TMP_DIR/repo"
"$TMP_DIR/repo/scripts/sync.sh" >/dev/null

cmp -s "$ROOT/adapters/codex/SKILL.md" "$TMP_DIR/repo/adapters/codex/SKILL.md" || { echo "hash mismatch: $ROOT/adapters/codex/SKILL.md" >&2; exit 1; }
cmp -s "$ROOT/adapters/codex/agents/openai.yaml" "$TMP_DIR/repo/adapters/codex/agents/openai.yaml" || { echo "hash mismatch: $ROOT/adapters/codex/agents/openai.yaml" >&2; exit 1; }
cmp -s "$ROOT/adapters/claude/CLAUDE.md" "$TMP_DIR/repo/adapters/claude/CLAUDE.md" || { echo "hash mismatch: $ROOT/adapters/claude/CLAUDE.md" >&2; exit 1; }
cmp -s "$ROOT/adapters/copilot/copilot-instructions.md" "$TMP_DIR/repo/adapters/copilot/copilot-instructions.md" || { echo "hash mismatch: $ROOT/adapters/copilot/copilot-instructions.md" >&2; exit 1; }
cmp -s "$ROOT/adapters/gemini/GEMINI.md" "$TMP_DIR/repo/adapters/gemini/GEMINI.md" || { echo "hash mismatch: $ROOT/adapters/gemini/GEMINI.md" >&2; exit 1; }

for adapter in codex claude copilot gemini; do
  cmp -s "$ROOT/core/references/example-flow.md" "$ROOT/adapters/$adapter/references/example-flow.md" || { echo "reference mismatch: $adapter example-flow" >&2; exit 1; }
  cmp -s "$ROOT/core/references/example-negative-flow.md" "$ROOT/adapters/$adapter/references/example-negative-flow.md" || { echo "reference mismatch: $adapter example-negative-flow" >&2; exit 1; }
  cmp -s "$ROOT/core/references/example-otp-flow.md" "$ROOT/adapters/$adapter/references/example-otp-flow.md" || { echo "reference mismatch: $adapter example-otp-flow" >&2; exit 1; }
  cmp -s "$ROOT/core/references/flow-test-env.example" "$ROOT/adapters/$adapter/references/flow-test-env.example" || { echo "reference mismatch: $adapter flow-test-env" >&2; exit 1; }
done

grep -q '^# Compatibility Contract$' "$ROOT/docs/compatibility-contract.md" || { echo "missing compatibility contract heading" >&2; exit 1; }
grep -q '^# Install For Codex$' "$ROOT/docs/install-codex.md" || { echo "missing codex install doc heading" >&2; exit 1; }
grep -q '^# Install For Claude$' "$ROOT/docs/install-claude.md" || { echo "missing claude install doc heading" >&2; exit 1; }
grep -q '^# Install For Copilot$' "$ROOT/docs/install-copilot.md" || { echo "missing copilot install doc heading" >&2; exit 1; }
grep -q '^# Install For Gemini$' "$ROOT/docs/install-gemini.md" || { echo "missing gemini install doc heading" >&2; exit 1; }

echo "parity ok"
