#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

SOC=sm1
BOARD=sm1_bananapim5_v1
UBOOT_BIN="${SCRIPT_DIR}/uboot-bins/u-boot.bin"

LINEAGE_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
DEVICE_PATH="${LINEAGE_ROOT}/device/bananapi/m5"
VENDOR_PATH="${LINEAGE_ROOT}/vendor/bananapi/m5"

[[ -d "${VENDOR_PATH}" ]] && mkdir -p "${VENDOR_PATH}/radio"

./collect-m5_binaries-git-refboard.sh "$SOC" "$BOARD"
[[ -d "${VENDOR_PATH}" ]] && cp "$UBOOT_BIN" "${VENDOR_PATH}/radio/bootloader.img"

if [[ -d "${DEVICE_PATH}" ]]; then
    cd "$DEVICE_PATH" && ./setup-makefiles.py
fi
if [[ -d "${VENDOR_PATH}" ]]; then
    cd "$VENDOR_PATH"
    SHA_HEAD=$(git -C "${SCRIPT_DIR}/../u-boot" rev-parse HEAD)
    git add -A
    git commit -m "radxa0: Update bootloader image prebuilt" \
               -m "* As of ${SHA_HEAD}
fi
