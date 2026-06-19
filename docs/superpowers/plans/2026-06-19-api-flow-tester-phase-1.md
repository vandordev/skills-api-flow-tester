# API Flow Tester Phase 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the phase 1 multi-agent packaging repo for `api-flow-tester` with one canonical core, four thin adapters, and simple sync and validation automation.

**Architecture:** Keep the canonical workflow under `core/`, generate or refresh platform outputs under `adapters/`, and enforce consistency with shell-based sync, validation, and parity checks. Keep phase 1 dependency-free by using flat metadata, copied shared references, and test scripts written in shell.

**Tech Stack:** Markdown, YAML, Bash, core Unix tools (`awk`, `grep`, `sed`, `sha256sum`, `cmp`, `diff`)

---

## File Structure

- `core/SKILL.md`: canonical workflow behavior for the skill
- `core/metadata.yaml`: flat metadata used by sync and validation
- `core/references/`: shared examples copied into each adapter
- `adapters/codex/SKILL.md`: generated Codex skill file
- `adapters/codex/agents/openai.yaml`: generated Codex UI metadata
- `adapters/claude/CLAUDE.md`: generated Claude adapter
- `adapters/copilot/copilot-instructions.md`: generated Copilot adapter
- `adapters/gemini/GEMINI.md`: generated Gemini adapter
- `scripts/sync.sh`: renders adapters from the core
- `scripts/validate.sh`: validates required files, metadata, and unresolved placeholders
- `scripts/check-parity.sh`: checks adapter parity against core hashes and shared references
- `tests/test_core_assets.sh`: checks the canonical assets exist and contain expected markers
- `tests/test_sync.sh`: verifies sync creates all adapter outputs and copied references
- `tests/test_validate.sh`: verifies validation passes on good state and fails on a poisoned state
- `tests/test_parity.sh`: verifies parity passes on clean state and fails after divergence
- `docs/compatibility-contract.md`: cross-platform behavior contract
- `docs/install-codex.md`: Codex install instructions
- `docs/install-claude.md`: Claude install instructions
- `docs/install-copilot.md`: Copilot install instructions
- `docs/install-gemini.md`: Gemini install instructions

### Task 1: Establish Canonical Core Content

**Files:**
- Create: `core/SKILL.md`
- Create: `core/metadata.yaml`
- Create: `core/references/example-flow.md`
- Create: `core/references/example-negative-flow.md`
- Create: `core/references/example-otp-flow.md`
- Create: `core/references/flow-test-env.example`
- Create: `tests/test_core_assets.sh`

- [ ] **Step 1: Write the failing core-assets test**

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

test -f "$ROOT/core/SKILL.md"
test -f "$ROOT/core/metadata.yaml"
test -f "$ROOT/core/references/example-flow.md"
test -f "$ROOT/core/references/example-negative-flow.md"
test -f "$ROOT/core/references/example-otp-flow.md"
test -f "$ROOT/core/references/flow-test-env.example"

grep -q '^name: api-flow-tester$' "$ROOT/core/metadata.yaml"
grep -q '^display_name: API Flow Tester$' "$ROOT/core/metadata.yaml"
grep -q '^description: Run and maintain multi-step HTTP API test flows\\.$' "$ROOT/core/metadata.yaml"
grep -q '^default_prompt: Use \\$api-flow-tester to run, create, or update a multi-step HTTP API flow and report each step clearly\\.$' "$ROOT/core/metadata.yaml"
grep -q '^supported_modes: full-run,dry-run,partial-run$' "$ROOT/core/metadata.yaml"

grep -q '^## Running a Flow$' "$ROOT/core/SKILL.md"
grep -q '^## Partial Run Rules$' "$ROOT/core/SKILL.md"
grep -q '^## Failure Handling$' "$ROOT/core/SKILL.md"
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test_core_assets.sh`
Expected: failure on the first missing file check because `core/` has not been created yet.

- [ ] **Step 3: Write the minimal canonical implementation**

Create the directories:

```bash
mkdir -p core/references tests
```

Create `core/metadata.yaml` with flat, dependency-free fields:

```yaml
name: api-flow-tester
display_name: API Flow Tester
description: Run and maintain multi-step HTTP API test flows.
default_prompt: Use $api-flow-tester to run, create, or update a multi-step HTTP API flow and report each step clearly.
supported_modes: full-run,dry-run,partial-run
trigger_phrases: run-flow,debug-flow,create-flow,update-flow,dry-run-flow,partial-run-flow
targets: codex,claude,copilot,gemini
```

Seed `core/SKILL.md` from the existing local skill source:

```bash
cp /home/alfarizi/.agents/skills/api-flow-tester/SKILL.md core/SKILL.md
```

Seed the shared references:

```bash
cp /home/alfarizi/.agents/skills/api-flow-tester/references/example-flow.md core/references/example-flow.md
cp /home/alfarizi/.agents/skills/api-flow-tester/references/example-negative-flow.md core/references/example-negative-flow.md
cp /home/alfarizi/.agents/skills/api-flow-tester/references/example-otp-flow.md core/references/example-otp-flow.md
cp /home/alfarizi/.agents/skills/api-flow-tester/references/flow-test-env.example core/references/flow-test-env.example
```

Create `tests/test_core_assets.sh` from Step 1 and mark it executable:

```bash
chmod +x tests/test_core_assets.sh
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `bash tests/test_core_assets.sh`
Expected: no output and exit code `0`.

- [ ] **Step 5: Commit**

```bash
git add core tests/test_core_assets.sh
git commit -m "feat: add canonical api-flow-tester core assets"
```

### Task 2: Implement Adapter Sync

**Files:**
- Create: `scripts/sync.sh`
- Create: `tests/test_sync.sh`
- Create: `adapters/codex/SKILL.md`
- Create: `adapters/codex/agents/openai.yaml`
- Create: `adapters/codex/references/example-flow.md`
- Create: `adapters/codex/references/example-negative-flow.md`
- Create: `adapters/codex/references/example-otp-flow.md`
- Create: `adapters/codex/references/flow-test-env.example`
- Create: `adapters/claude/CLAUDE.md`
- Create: `adapters/claude/references/example-flow.md`
- Create: `adapters/claude/references/example-negative-flow.md`
- Create: `adapters/claude/references/example-otp-flow.md`
- Create: `adapters/claude/references/flow-test-env.example`
- Create: `adapters/copilot/copilot-instructions.md`
- Create: `adapters/copilot/references/example-flow.md`
- Create: `adapters/copilot/references/example-negative-flow.md`
- Create: `adapters/copilot/references/example-otp-flow.md`
- Create: `adapters/copilot/references/flow-test-env.example`
- Create: `adapters/gemini/GEMINI.md`
- Create: `adapters/gemini/references/example-flow.md`
- Create: `adapters/gemini/references/example-negative-flow.md`
- Create: `adapters/gemini/references/example-otp-flow.md`
- Create: `adapters/gemini/references/flow-test-env.example`

- [ ] **Step 1: Write the failing sync test**

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

rm -rf "$ROOT/adapters"
"$ROOT/scripts/sync.sh"

test -f "$ROOT/adapters/codex/SKILL.md"
test -f "$ROOT/adapters/codex/agents/openai.yaml"
test -f "$ROOT/adapters/claude/CLAUDE.md"
test -f "$ROOT/adapters/copilot/copilot-instructions.md"
test -f "$ROOT/adapters/gemini/GEMINI.md"

grep -q '^<!-- Generated by scripts/sync.sh; source_sha256: ' "$ROOT/adapters/codex/SKILL.md"
grep -q '^# Generated by scripts/sync.sh; source_sha256: ' "$ROOT/adapters/codex/agents/openai.yaml"
grep -q '^# API Flow Tester for Claude$' "$ROOT/adapters/claude/CLAUDE.md"
grep -q '^# API Flow Tester for Copilot$' "$ROOT/adapters/copilot/copilot-instructions.md"
grep -q '^# API Flow Tester for Gemini$' "$ROOT/adapters/gemini/GEMINI.md"

for adapter in codex claude copilot gemini; do
  test -f "$ROOT/adapters/$adapter/references/example-flow.md"
  test -f "$ROOT/adapters/$adapter/references/example-negative-flow.md"
  test -f "$ROOT/adapters/$adapter/references/example-otp-flow.md"
  test -f "$ROOT/adapters/$adapter/references/flow-test-env.example"
done
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test_sync.sh`
Expected: failure because `scripts/sync.sh` does not exist yet.

- [ ] **Step 3: Write the minimal sync implementation**

Create `scripts/sync.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CORE_DIR="$ROOT/core"
ADAPTERS_DIR="$ROOT/adapters"

read_meta() {
  local key="$1"
  awk -F': ' -v key="$key" '$1 == key { print substr($0, length($1) + 3); exit }' "$CORE_DIR/metadata.yaml"
}

copy_references() {
  local adapter_dir="$1"
  mkdir -p "$adapter_dir/references"
  cp "$CORE_DIR"/references/* "$adapter_dir/references/"
}

render_markdown_adapter() {
  local output_file="$1"
  local title="$2"
  local intro="$3"
  local source_hash="$4"

  mkdir -p "$(dirname "$output_file")"
  {
    printf '<!-- Generated by scripts/sync.sh; source_sha256: %s -->\n\n' "$source_hash"
    printf '# %s\n\n' "$title"
    printf '%s\n\n' "$intro"
    printf '## Canonical Workflow\n\n'
    cat "$CORE_DIR/SKILL.md"
  } > "$output_file"
}

NAME="$(read_meta name)"
DISPLAY_NAME="$(read_meta display_name)"
DESCRIPTION="$(read_meta description)"
DEFAULT_PROMPT="$(read_meta default_prompt)"
SOURCE_HASH="$(sha256sum "$CORE_DIR/SKILL.md" | awk '{print $1}')"

rm -rf "$ADAPTERS_DIR"

mkdir -p "$ADAPTERS_DIR/codex/agents"
{
  printf '<!-- Generated by scripts/sync.sh; source_sha256: %s -->\n\n' "$SOURCE_HASH"
  cat "$CORE_DIR/SKILL.md"
} > "$ADAPTERS_DIR/codex/SKILL.md"

cat > "$ADAPTERS_DIR/codex/agents/openai.yaml" <<EOF
# Generated by scripts/sync.sh; source_sha256: $SOURCE_HASH
interface:
  display_name: "$DISPLAY_NAME"
  short_description: "$DESCRIPTION"
  default_prompt: "$DEFAULT_PROMPT"

policy:
  allow_implicit_invocation: true
EOF

copy_references "$ADAPTERS_DIR/codex"

render_markdown_adapter \
  "$ADAPTERS_DIR/claude/CLAUDE.md" \
  "API Flow Tester for Claude" \
  "Use this file as the reusable Claude instruction for repeatable multi-step HTTP API flow testing." \
  "$SOURCE_HASH"
copy_references "$ADAPTERS_DIR/claude"

render_markdown_adapter \
  "$ADAPTERS_DIR/copilot/copilot-instructions.md" \
  "API Flow Tester for Copilot" \
  "Use this file as the repository-level Copilot instruction for repeatable multi-step HTTP API flow testing." \
  "$SOURCE_HASH"
copy_references "$ADAPTERS_DIR/copilot"

render_markdown_adapter \
  "$ADAPTERS_DIR/gemini/GEMINI.md" \
  "API Flow Tester for Gemini" \
  "Use this file as the reusable Gemini instruction for repeatable multi-step HTTP API flow testing." \
  "$SOURCE_HASH"
copy_references "$ADAPTERS_DIR/gemini"

printf 'Synced %s adapters for %s\n' "4" "$NAME"
```

Create `tests/test_sync.sh` from Step 1 and mark both files executable:

```bash
chmod +x scripts/sync.sh tests/test_sync.sh
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `bash tests/test_sync.sh`
Expected: `Synced 4 adapters for api-flow-tester` and exit code `0`.

- [ ] **Step 5: Commit**

```bash
git add adapters scripts/sync.sh tests/test_sync.sh
git commit -m "feat: generate multi-agent adapters from core"
```

### Task 3: Implement Validation

**Files:**
- Create: `scripts/validate.sh`
- Create: `tests/test_validate.sh`

- [ ] **Step 1: Write the failing validation test**

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

"$ROOT/scripts/sync.sh" >/dev/null
"$ROOT/scripts/validate.sh"

cp -R "$ROOT" "$TMP_DIR/repo"
printf 'BROKEN_MARKER: poison adapter\n' >> "$TMP_DIR/repo/adapters/claude/CLAUDE.md"

if "$TMP_DIR/repo/scripts/validate.sh" >/tmp/validate-poisoned.log 2>&1; then
  echo "expected validation to fail on poisoned adapter"
  exit 1
fi

grep -q 'unresolved marker' /tmp/validate-poisoned.log
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test_validate.sh`
Expected: failure because `scripts/validate.sh` does not exist yet.

- [ ] **Step 3: Write the minimal validation implementation**

Create `scripts/validate.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_files=(
  "$ROOT/core/SKILL.md"
  "$ROOT/core/metadata.yaml"
  "$ROOT/core/references/example-flow.md"
  "$ROOT/core/references/example-negative-flow.md"
  "$ROOT/core/references/example-otp-flow.md"
  "$ROOT/core/references/flow-test-env.example"
  "$ROOT/adapters/codex/SKILL.md"
  "$ROOT/adapters/codex/agents/openai.yaml"
  "$ROOT/adapters/claude/CLAUDE.md"
  "$ROOT/adapters/copilot/copilot-instructions.md"
  "$ROOT/adapters/gemini/GEMINI.md"
)

required_meta_keys=(
  "name"
  "display_name"
  "description"
  "default_prompt"
  "supported_modes"
  "trigger_phrases"
  "targets"
)

for file in "${required_files[@]}"; do
  test -f "$file" || { echo "missing required file: $file" >&2; exit 1; }
done

for key in "${required_meta_keys[@]}"; do
  grep -q "^$key: " "$ROOT/core/metadata.yaml" || { echo "missing metadata key: $key" >&2; exit 1; }
done

if ! grep -q 'allow_implicit_invocation: true' "$ROOT/adapters/codex/agents/openai.yaml"; then
  echo "codex openai.yaml missing allow_implicit_invocation" >&2
  exit 1
fi

while IFS= read -r file; do
  if grep -nE 'BROKEN_MARKER|UNRESOLVED_PLACEHOLDER|\\{\\{UNRESOLVED\\}\\}' "$file"; then
    echo "unresolved marker in: $file" >&2
    exit 1
  fi
done < <(find "$ROOT/adapters" "$ROOT/docs" -type f \\( -name '*.md' -o -name '*.yaml' \\))

echo "validation ok"
```

Create `tests/test_validate.sh` from Step 1 and mark both files executable:

```bash
chmod +x scripts/validate.sh tests/test_validate.sh
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `bash tests/test_validate.sh`
Expected: `validation ok` on the clean tree, then a failing poisoned run that is caught by the test.

- [ ] **Step 5: Commit**

```bash
git add scripts/validate.sh tests/test_validate.sh
git commit -m "feat: add repository validation checks"
```

### Task 4: Add Compatibility Docs And Parity Checks

**Files:**
- Create: `docs/compatibility-contract.md`
- Create: `docs/install-codex.md`
- Create: `docs/install-claude.md`
- Create: `docs/install-copilot.md`
- Create: `docs/install-gemini.md`
- Create: `scripts/check-parity.sh`
- Create: `tests/test_parity.sh`

- [ ] **Step 1: Write the failing parity test**

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"$ROOT/scripts/sync.sh" >/dev/null
"$ROOT/scripts/check-parity.sh"

printf '\nparity drift\n' >> "$ROOT/adapters/gemini/GEMINI.md"

if "$ROOT/scripts/check-parity.sh" >/tmp/parity-drift.log 2>&1; then
  echo "expected parity check to fail after adapter drift"
  exit 1
fi

grep -q 'hash mismatch' /tmp/parity-drift.log
git checkout -- "$ROOT/adapters/gemini/GEMINI.md"
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test_parity.sh`
Expected: failure because `scripts/check-parity.sh` and the docs do not exist yet.

- [ ] **Step 3: Write the compatibility and install documents plus parity implementation**

Create `docs/compatibility-contract.md`:

```md
# Compatibility Contract

## Supported User Intents

- Run an existing multi-step API flow
- Dry-run a flow without sending requests
- Partially run selected steps
- Create a new reusable flow file
- Update an existing reusable flow file
- Debug capture, assertion, auth, or step-order failures

## Behavioral Guarantees

- The skill must treat `core/SKILL.md` as the canonical workflow behavior
- All adapters must support full run, dry run, and partial run
- All adapters must preserve secret-redaction behavior
- All adapters must stop on unresolved required placeholders before execution
- All adapters must ask before production-side-effect execution

## Minimum Run Summary

- Step name
- Request method and path
- Execution mode when not full run
- Response status
- Assertion result
- Captured variable names
```

Create `docs/install-codex.md`:

```md
# Install For Codex

1. Copy `adapters/codex/` into your Codex skills directory as `api-flow-tester/`.
2. Keep `SKILL.md`, `agents/openai.yaml`, and `references/` together.
3. Restart or reload Codex so the skill is rediscovered.
```

Create `docs/install-claude.md`:

```md
# Install For Claude

1. Copy `adapters/claude/CLAUDE.md` and the adjacent `references/` directory into the instruction location you use for Claude.
2. Preserve relative paths so the references remain available beside `CLAUDE.md`.
3. Reload the workspace or restart the Claude session before use.
```

Create `docs/install-copilot.md`:

```md
# Install For Copilot

1. Copy `adapters/copilot/copilot-instructions.md` into the repository or workspace location you use for Copilot custom instructions.
2. Copy the adjacent `references/` directory with it.
3. Reload the editor window so Copilot picks up the new instructions.
```

Create `docs/install-gemini.md`:

```md
# Install For Gemini

1. Copy `adapters/gemini/GEMINI.md` and the adjacent `references/` directory into the Gemini instruction location you use.
2. Preserve the file name `GEMINI.md`.
3. Restart or refresh Gemini before using the adapter.
```

Create `scripts/check-parity.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CORE_HASH="$(sha256sum "$ROOT/core/SKILL.md" | awk '{print $1}')"

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
```

Create `tests/test_parity.sh` from Step 1 and mark both files executable:

```bash
chmod +x scripts/check-parity.sh tests/test_parity.sh
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `bash tests/test_parity.sh`
Expected: `parity ok` on the clean tree, then a failing second parity run that is caught by the test after the adapter file is modified.

- [ ] **Step 5: Commit**

```bash
git add docs scripts/check-parity.sh tests/test_parity.sh
git commit -m "feat: add adapter parity checks and install docs"
```

### Task 5: Final Verification And Developer Entry Points

**Files:**
- Create: `tests/test_repo.sh`
- Create: `scripts/test.sh`

- [ ] **Step 1: Write the failing end-to-end test runner check**

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"$ROOT/scripts/test.sh"
```

Save this as `tests/test_repo.sh`.

- [ ] **Step 2: Run the test to verify it fails**

Run: `bash tests/test_repo.sh`
Expected: failure because `scripts/test.sh` does not exist yet.

- [ ] **Step 3: Write the minimal repo test runner**

Create `scripts/test.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$ROOT/tests/test_core_assets.sh"
bash "$ROOT/tests/test_sync.sh"
bash "$ROOT/tests/test_validate.sh"
bash "$ROOT/tests/test_parity.sh"

echo "all tests passed"
```

Make the new scripts executable:

```bash
chmod +x scripts/test.sh tests/test_repo.sh
```

- [ ] **Step 4: Run the full verification suite**

Run these commands in order:

```bash
bash tests/test_repo.sh
bash scripts/sync.sh
bash scripts/validate.sh
bash scripts/check-parity.sh
git status --short
```

Expected:

- `all tests passed`
- `Synced 4 adapters for api-flow-tester`
- `validation ok`
- `parity ok`
- only the expected tracked files appear before the final commit

- [ ] **Step 5: Commit**

```bash
git add scripts/test.sh tests/test_repo.sh
git commit -m "chore: add repository test runner"
```

## Self-Review

### Spec Coverage

- `core/` as the single source of truth is implemented in Task 1.
- thin per-platform adapters are implemented in Task 2.
- sync, validation, and parity automation are implemented in Tasks 2 through 4.
- compatibility and install docs are implemented in Task 4.
- a simple verification path for phase 1 is implemented in Task 5.

### Placeholder Scan

- No deferred implementation markers are present in the tasks themselves.
- Every task has explicit file paths, code, commands, and expected outcomes.

### Type And Naming Consistency

- Metadata keys remain flat and stable across tasks: `name`, `display_name`, `description`, `default_prompt`, `supported_modes`, `trigger_phrases`, and `targets`.
- Adapter file names match the approved design: `SKILL.md`, `openai.yaml`, `CLAUDE.md`, `copilot-instructions.md`, and `GEMINI.md`.
- The verification commands use the same script paths defined earlier in the plan.
