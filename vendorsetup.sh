#!/bin/bash

FDEVICE="lapis"

FOX_DEVICE_TREE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export FOX_REFERENCE_VENDOR_BOOT_IMAGE="${FOX_DEVICE_TREE_DIR}/prebuilt/stock_vendor_boot.img"
export FOX_VENDOR_BOOT_RECOVERY=1

fox_get_target_device() {
    local chkdev
    chkdev=$(echo "$BASH_SOURCE" | grep -w "$FDEVICE")
    if [ -n "$chkdev" ]; then
        FOX_BUILD_DEVICE="$FDEVICE"
    fi
}

if [ -z "$1" ] && [ -z "$FOX_BUILD_DEVICE" ]; then
    fox_get_target_device
fi

if [ "$1" = "$FDEVICE" ] || [ "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
    export FOX_AB_DEVICE=1
    export FOX_USE_BASH_SHELL=1
    export FOX_USE_SED_BINARY=1
    export FOX_USE_TAR_BINARY=1
    export FOX_ENABLE_APP_MANAGER=1
    export FOX_USE_NANO_EDITOR=1
fi
