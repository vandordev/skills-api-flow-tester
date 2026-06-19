# API Flow Tester

`api-flow-tester` is a reusable skill for running, debugging, creating, and updating multi-step HTTP API test flows across `Codex`, `Claude`, `Copilot`, and `Gemini`.

## Why This Exists

Manual API testing breaks down quickly when a request sequence depends on data captured from earlier responses. Login tokens, user IDs, OTP codes, and resource IDs often get copied around by hand, then drift across notes, shell history, and one-off curl commands.

This skill gives agents a repeatable way to work through those flows step by step, while keeping placeholders, captures, assertions, and secret handling consistent.

## What This Skill Does

- Runs multi-step API flows in order
- Supports full run, dry run, and partial run
- Captures values from one response and reuses them in later requests
- Validates statuses, headers, and JSON-path expectations
- Keeps reusable flow definitions separate from environment-specific secrets
- Packages the same workflow for `Codex`, `Claude`, `Copilot`, and `Gemini`

## Who This Is For

- Engineers who test auth, onboarding, checkout, CRUD, or approval flows across multiple endpoints
- Teams that want reusable API flow definitions instead of ad-hoc curl snippets
- Users who want the same skill behavior available in more than one agent harness

## Installation

Installation differs by harness. If you use more than one, install `api-flow-tester` separately for each one.

### Codex

- Copy `adapters/codex/` into your Codex skills directory as `api-flow-tester/`.
- Keep `SKILL.md`, `agents/openai.yaml`, and `references/` together.
- Restart or reload Codex so the skill is rediscovered.

Tell Codex:

```text
Fetch and follow installation instructions from https://raw.githubusercontent.com/vandordev/skills-api-flow-tester/refs/heads/main/docs/install-codex.md
```

### Claude

- Copy `adapters/claude/CLAUDE.md` and `adapters/claude/references/` into the instruction location you use for Claude.
- Preserve the relative layout so `CLAUDE.md` and `references/` stay together.
- Restart or reload the Claude session before use.

Tell Claude:

```text
Fetch and follow installation instructions from https://raw.githubusercontent.com/vandordev/skills-api-flow-tester/refs/heads/main/docs/install-claude.md
```

### Copilot

- Copy `adapters/copilot/copilot-instructions.md` and `adapters/copilot/references/` into the custom-instructions location you use for Copilot.
- Preserve the relative layout so the references remain available beside the instruction file.
- Reload the editor window before use.

Tell Copilot:

```text
Fetch and follow installation instructions from https://raw.githubusercontent.com/vandordev/skills-api-flow-tester/refs/heads/main/docs/install-copilot.md
```

### Gemini

- Copy `adapters/gemini/GEMINI.md` and `adapters/gemini/references/` into the instruction location you use for Gemini.
- Preserve the file name `GEMINI.md`.
- Refresh or restart Gemini before use.

Tell Gemini:

```text
Fetch and follow installation instructions from https://raw.githubusercontent.com/vandordev/skills-api-flow-tester/refs/heads/main/docs/install-gemini.md
```

## Quick Usage

After installation, ask your agent to use `api-flow-tester` when you want to:

- run an existing multi-step API flow
- dry-run a flow before sending requests
- debug why a chained request sequence fails
- create a reusable flow from an endpoint sequence
- update a flow after API contract changes

## Platform Outputs

- `adapters/codex/`: `SKILL.md`, `agents/openai.yaml`, and shared references
- `adapters/claude/`: `CLAUDE.md` and shared references
- `adapters/copilot/`: `copilot-instructions.md` and shared references
- `adapters/gemini/`: `GEMINI.md` and shared references

## Detailed Install Docs

- `docs/install-codex.md`
- `docs/install-claude.md`
- `docs/install-copilot.md`
- `docs/install-gemini.md`

## Repository Layout

- `core/`: the canonical workflow, metadata, and shared references
- `adapters/`: rendered platform-specific outputs
- `scripts/`: repo entrypoints for sync, validation, parity, and test runs
- `tests/`: shell checks for phase 1 repository behavior
- `docs/`: install guides, compatibility contract, design, and implementation plan

## Working Model

Edit the skill in `core/`. Do not edit generated adapter files by hand unless you are debugging the generator.

The normal authoring flow is:

1. Update `core/SKILL.md`, `core/metadata.yaml`, or `core/references/`.
2. Run `bash scripts/sync.sh`.
3. Run `bash scripts/validate.sh`.
4. Run `bash scripts/check-parity.sh`.
5. Run `bash tests/test_repo.sh`.

## Entry Points

- `bash scripts/sync.sh`: regenerate all platform adapters from `core/`
- `bash scripts/validate.sh`: verify required files, metadata, and unresolved markers
- `bash scripts/check-parity.sh`: confirm generated adapters still match the canonical core
- `bash scripts/test.sh`: run the repository test suite
- `bash tests/test_repo.sh`: run the end-to-end phase 1 verification path
