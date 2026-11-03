$(call inherit-product, vendor/twrp/config/common.mk)

PRODUCT_DEVICE := lapis
PRODUCT_NAME := twrp_lapis
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := Redmi Note 15 Pro 5G
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_RELEASE_NAME := lapis

$(call inherit-product, device/xiaomi/lapis/device-lapis.mk)
