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
