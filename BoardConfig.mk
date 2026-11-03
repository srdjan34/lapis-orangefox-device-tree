# Xiaomi Redmi Note 15 Pro 5G
# Device codename: lapis
# MediaTek MT6878
# OrangeFox Recovery - Android 16

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_BOARD_PLATFORM := mt6878
TARGET_BOOTLOADER_BOARD_NAME := mt6878

# Boot image format
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION)

# Kernel
TARGET_NO_KERNEL := true

# DTB - original stock MediaTek DTB
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := device/xiaomi/lapis/prebuilt/dtb

# Vendor boot - recovery is a separate v4 fragment
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864

# Recovery filesystem table
TARGET_RECOVERY_FSTAB := device/xiaomi/lapis/recovery.fstab
BOARD_VENDOR_SEPOLICY_DIRS += device/xiaomi/lapis/sepolicy

# Device assertion
TARGET_OTA_ASSERT_DEVICE := lapis
TW_INCLUDE_CRYPTO := true

# Copy MediaTek recovery hardware init script into recovery ramdisk
BOARD_RECOVERY_IMAGE_PREPARE += mkdir -p $(TARGET_RECOVERY_ROOT_OUT); cp -f device/xiaomi/lapis/init.recovery.mt6878.rc $(TARGET_RECOVERY_ROOT_OUT)/init.recovery.mt6878.rc;
TARGET_SUPPORTS_64_BIT_APPS := true

# OrangeFox display
TARGET_SCREEN_WIDTH := 1280
TARGET_SCREEN_HEIGHT := 2772
TW_THEME := portrait_hdpi

# Use MediaTek ConfigFS USB init, exclude legacy AOSP USB init
TW_EXCLUDE_DEFAULT_USB_INIT := true
