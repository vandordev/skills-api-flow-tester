#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$ROOT/tests/test_core_assets.sh"
bash "$ROOT/tests/test_sync.sh"
bash "$ROOT/tests/test_validate.sh"
bash "$ROOT/tests/test_parity.sh"

echo "all tests passed"
