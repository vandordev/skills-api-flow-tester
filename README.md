# skills-api-flow-tester

Portable packaging repo for the `api-flow-tester` skill across `Codex`, `Claude`, `Copilot`, and `Gemini`.

## What This Repo Contains

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

## Platform Outputs

- `adapters/codex/`: `SKILL.md`, `agents/openai.yaml`, and shared references
- `adapters/claude/`: `CLAUDE.md` and shared references
- `adapters/copilot/`: `copilot-instructions.md` and shared references
- `adapters/gemini/`: `GEMINI.md` and shared references

Platform-specific installation notes live in:

- `docs/install-codex.md`
- `docs/install-claude.md`
- `docs/install-copilot.md`
- `docs/install-gemini.md`

## Guarantees

Behavioral parity across platforms is defined in `docs/compatibility-contract.md`.

Phase 1 guarantees:

- one canonical source of truth in `core/`
- thin adapters for four target agents
- repeatable adapter generation
- repository-level validation and parity checks

## Current Scope

This repository packages the skill and validates its structure. It does not yet provide a `dist/` packaging format or platform-native installer automation.
