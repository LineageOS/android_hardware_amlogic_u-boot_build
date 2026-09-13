#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

for script in build_kvim3 build_kvim3l; do
    cd "$SCRIPT_DIR"
    "${SCRIPT_DIR}/${script}.sh"
done
