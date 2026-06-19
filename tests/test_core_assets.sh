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
