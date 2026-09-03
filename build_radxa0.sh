#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

BOARD=g12a_radxa0_v1
FIP_DIR=fip-radxa-zero
UBOOT_BIN="${SCRIPT_DIR}/uboot-bins/u-boot.bin"

LINEAGE_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
DEVICE_PATH="${LINEAGE_ROOT}/device/radxa/radxa0"
VENDOR_PATH="${LINEAGE_ROOT}/vendor/radxa/radxa0"

[[ -d "${VENDOR_PATH}" ]] && mkdir -p "${VENDOR_PATH}/radio"

./build.sh "$BOARD"
./generate-bins-new.sh "$FIP_DIR" ../u-boot/build/u-boot.bin "${BOARD}-base"
[[ -d "${VENDOR_PATH}" ]] && cp "$UBOOT_BIN" "${VENDOR_PATH}/radio/bootloader.img"

if [[ -d "${DEVICE_PATH}" ]]; then
    cd "$DEVICE_PATH" && ./setup-makefiles.py
fi
if [[ -d "${VENDOR_PATH}" ]]; then
    cd "$VENDOR_PATH" && git add -A && git commit -m "radxa0: Update bootloader image prebuilt"
fi
