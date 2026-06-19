# API Flow Tester Multi-Agent Design

## Summary

This project will package `api-flow-tester` as a portable skill that can be used across `Codex`, `Claude`, `Copilot`, and `Gemini`.

The design uses a hybrid model:

- one agent-agnostic source of truth for workflow behavior
- thin per-platform adapters
- lightweight sync and validation scripts to keep adapters aligned

## Goals

- Keep the workflow definition in one place
- Support four target agents with minimal duplication
- Make behavior consistent across platforms
- Keep installation and packaging explicit per platform
- Keep future workflow updates cheap and low-risk

## Non-Goals

- Building a fully generic skill framework for arbitrary skills
- Solving marketplace or public distribution for every platform on day one
- Guaranteeing identical runtime capabilities across agents beyond the compatibility contract

## Core Decision

The repository will use a `hybrid` architecture:

- `core/` stores the canonical workflow content and shared references
- `adapters/` stores platform-specific rendered or maintained outputs
- `scripts/` keeps adapters synchronized and validated
- `docs/` explains compatibility and installation

This avoids duplicated workflow logic while keeping platform integration simple.

## Repository Structure

```text
skills-api-flow-tester/
  core/
    SKILL.md
    metadata.yaml
    references/
      example-flow.md
      example-negative-flow.md
      example-otp-flow.md
      flow-test-env.example
  adapters/
    codex/
      SKILL.md
      agents/
        openai.yaml
    claude/
      CLAUDE.md
    copilot/
      copilot-instructions.md
    gemini/
      GEMINI.md
  scripts/
    sync.sh
    validate.sh
    check-parity.sh
  tests/
    fixtures/
    snapshots/
  docs/
    compatibility-contract.md
    install-codex.md
    install-claude.md
    install-copilot.md
    install-gemini.md
    superpowers/
      specs/
        2026-06-19-api-flow-tester-multi-agent-design.md
```

## Source Of Truth

`core/` is the only place where workflow behavior is edited manually.

### `core/SKILL.md`

Contains the canonical behavior for:

- trigger conditions
- repository discovery
- flow format
- sensitive input handling
- execution modes
- variable capture
- assertions and negative tests
- partial run rules
- flow creation and update rules
- failure handling
- output style

### `core/metadata.yaml`

Contains structured metadata reused by adapters, such as:

- `name`
- `display_name`
- `description`
- `default_prompt`
- trigger phrases
- supported modes
- platform notes when needed

### `core/references/`

Contains shared examples and reference material used by all adapters.

## Adapter Model

Each target agent gets its own adapter directory.

### Codex

`adapters/codex/` contains:

- `SKILL.md`
- `agents/openai.yaml`

This is the most native target and should be treated as the reference platform for packaging quality, but not as the source of truth.

### Claude

`adapters/claude/CLAUDE.md` contains the workflow in the instruction format most suitable for Claude usage.

### Copilot

`adapters/copilot/copilot-instructions.md` contains the workflow in a format suitable for repository-level Copilot instructions.

### Gemini

`adapters/gemini/GEMINI.md` contains the workflow in the instruction format suitable for Gemini usage.

## Adapter Boundaries

Adapters may contain:

- platform-specific metadata
- invocation wording
- platform-required file names and file layout
- platform-specific installation notes or references

Adapters must not redefine:

- workflow behavior
- environment resolution rules
- capture and assertion rules
- secret handling policy
- minimum output contract

## Sync Model

The sync process should be intentionally simple.

### `scripts/sync.sh`

Responsibilities:

- read `core/SKILL.md`
- read `core/metadata.yaml`
- render or refresh files under `adapters/`
- copy shared references where required

The script should use lightweight templating or token replacement only. It should not become a general-purpose build system.

## Validation Model

### `scripts/validate.sh`

Checks:

- required files exist
- referenced files exist
- no unresolved placeholders remain
- metadata fields required by each adapter are present

### `scripts/check-parity.sh`

Checks compatibility guarantees across all adapters.

The parity check should verify that the following semantics remain aligned:

- when the skill should be invoked
- supported execution modes
- secret handling expectations
- minimum run summary output
- required user-confirmation cases

## Compatibility Contract

`docs/compatibility-contract.md` defines the behavioral contract shared across platforms.

It must specify:

- supported user intents
- expected inputs
- supported modes: full run, dry run, partial run
- secret handling rules
- failure handling rules
- minimum reporting format
- situations that require asking the user before proceeding

This contract is the canonical definition of cross-platform parity.

## Packaging And Installation

The project must support explicit install paths per platform rather than pretending one distribution mechanism works for all four.

### Packaging Rules

- `core/` is never installed directly by end users
- `adapters/` contains platform-specific consumable files
- `dist/` can be added later if a final packaged output is needed
- install documentation lives under `docs/`

### Install Documentation

Provide one short operational document per platform:

- `docs/install-codex.md`
- `docs/install-claude.md`
- `docs/install-copilot.md`
- `docs/install-gemini.md`

Each document should explain:

- which files to use
- where to place them
- whether restart or reload is needed
- known limitations for that platform

## Data Flow

The authoring flow for this repository is:

1. edit `core/SKILL.md`, `core/metadata.yaml`, or shared references
2. run `scripts/sync.sh`
3. run `scripts/validate.sh`
4. run `scripts/check-parity.sh`
5. review resulting adapter outputs

This keeps manual edits concentrated in one place and reduces drift.

## Error Handling

The repository design should fail early when:

- a required adapter file cannot be rendered
- metadata required by one platform is missing
- a reference file path is broken
- an adapter diverges from the compatibility contract

Validation failures should be explicit and localize the problem to a file and check.

## Testing Strategy

The initial repository should test packaging integrity rather than runtime HTTP execution.

Phase 1 checks:

- sync produces all adapter files
- validation detects missing fields and unresolved placeholders
- parity checks detect semantic drift

Optional later checks:

- snapshot tests for rendered adapters
- fixture-based tests for sync behavior

## Implementation Phases

### Phase 1

- create repository structure
- add canonical workflow content to `core/`
- add adapter directories
- add basic sync and validation scripts
- add compatibility and install docs

### Phase 2

- refine adapter wording per platform
- add parity checks
- add snapshot tests

### Phase 3

- add `dist/` outputs if packaging needs become more formal
- add release/versioning conventions if distribution expands

## Trade-Offs

### Why not fully manual adapters

Manual duplication is faster to start but creates drift risk immediately.

### Why not a full generator

A full generator adds schema and tooling complexity too early for a single skill.

### Why hybrid

Hybrid keeps one behavioral source of truth while allowing platform-specific packaging to stay simple and explicit.

## Open Decisions Deferred

These items can be finalized during implementation without changing the architecture:

- exact `metadata.yaml` schema
- whether `dist/` is needed in phase 1
- whether adapter files are fully generated or partially templated
- exact validation tooling choices

## Recommended Next Step

Implement phase 1 only:

- scaffold the repository
- import the canonical workflow into `core/`
- build thin adapters for the four target agents
- add sync and validation scripts
- document installation paths

This is the smallest design that keeps the project maintainable as the skill evolves.
