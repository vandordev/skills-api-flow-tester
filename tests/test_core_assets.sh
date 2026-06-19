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
grep -q '^description: Run and maintain multi-step HTTP API test flows\.$' "$ROOT/core/metadata.yaml"
grep -q '^default_prompt: Use \$api-flow-tester to run, create, or update a multi-step HTTP API flow and report each step clearly\.$' "$ROOT/core/metadata.yaml"
grep -q '^supported_modes: full-run,dry-run,partial-run$' "$ROOT/core/metadata.yaml"

grep -q '^## Running a Flow$' "$ROOT/core/SKILL.md"
grep -q '^## Partial Run Rules$' "$ROOT/core/SKILL.md"
grep -q '^## Failure Handling$' "$ROOT/core/SKILL.md"
grep -q 'If you create a new flow at `tests/flows/<flow-name>/flow.md`, also create `tests/flows/<flow-name>/.env.example`.' "$ROOT/core/SKILL.md"
grep -q 'The `.env.example` file is required for new secret-backed flows and must list every placeholder-backed input with blank or example-safe values only.' "$ROOT/core/SKILL.md"
grep -q 'If secret values will live in `.env`, `.env.*`, or per-flow secret files, make sure the real secret files are ignored by git before writing them.' "$ROOT/core/SKILL.md"
grep -q 'If the ignore rule is missing, ask before editing a tracked `.gitignore`, then add the required entries so `.env` and relevant `.env.*` files do not get committed.' "$ROOT/core/SKILL.md"
grep -q 'Do not ignore `.env.example`; it must stay committable so users can discover the required keys safely.' "$ROOT/core/SKILL.md"
grep -q 'Do not put real secrets or secret-like example values in `.env.example`; every value there must be blank or clearly safe to commit.' "$ROOT/core/SKILL.md"
grep -q 'If keys change in `.env`, `.env.*`, or per-flow secret files, update `.env.example` in the same change so the committed example stays in sync.' "$ROOT/core/SKILL.md"
grep -q '^# Commit this as tests/flows/<flow-name>/.env.example for every new secret-backed flow\.$' "$ROOT/core/references/flow-test-env.example"
grep -q '^# Keep real secret files such as `.env`, `.env.local`, `.env.staging`, and `.env.production` ignored by git\.$' "$ROOT/core/references/flow-test-env.example"
grep -q '^# Do not ignore `.env.example`; it should stay safe to commit\.$' "$ROOT/core/references/flow-test-env.example"
grep -q '^# Keep every value blank or obviously safe; do not place real or secret-like example values here\.$' "$ROOT/core/references/flow-test-env.example"
grep -q '^# If keys change in real secret files, update this file in the same change so it stays in sync\.$' "$ROOT/core/references/flow-test-env.example"
grep -q '^# Pair this flow with `.env.example` in the same flow directory when you create a new secret-backed flow\.$' "$ROOT/core/references/example-flow.md"
