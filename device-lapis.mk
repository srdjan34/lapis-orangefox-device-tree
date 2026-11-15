# Xiaomi Redmi Note 15 Pro 5G - lapis
# Standalone MediaTek device configuration

$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Lapis launched on Android 15 even when recovery is built on Android 16.
PRODUCT_SHIPPING_API_LEVEL := 35
