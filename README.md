# OrangeFox for Xiaomi Redmi Note 15 Pro 5G (`lapis`)

Lapis uses a v4 `vendor_boot` image with a `PLATFORM` fragment and a separate
`recovery` fragment. The platform fragment contains the first-stage fstab and
kernel modules. Build with LZ4 legacy ramdisk compression to match stock.

## Build and package

Use the [OrangeFox Android 16 manifest](https://gitlab.com/OrangeFox/Manifest/-/tree/fox_16.0)
with this tree at `device/xiaomi/lapis`. Copy `vendor_boot.img` from the Xiaomi
Fastboot ROM that matches the target phone's installed firmware. Use the
Android `unpack_bootimg` and `mkbootimg` tools with vendor boot v4 support.

```sh
stock=device/xiaomi/lapis/prebuilt/stock_vendor_boot.img
mkdir -p device/xiaomi/lapis/prebuilt/dtb
cp /path/to/matching/stock/vendor_boot.img "$stock"
stock_parts=$(mktemp -d)
unpack_bootimg --boot_img "$stock" --out "$stock_parts"
cp "$stock_parts/dtb" device/xiaomi/lapis/prebuilt/dtb/lapis.dtb

export FOX_BUILD_DEVICE=lapis
source build/envsetup.sh
lunch twrp_lapis-bp2a-eng
m vendorbootimage

python3 device/xiaomi/lapis/repack_vendor_boot.py \
  "$stock" "$ANDROID_PRODUCT_OUT/vendor_boot.img" \
  "$ANDROID_PRODUCT_OUT/vendor_boot-lapis.img"
```

The repacked image keeps the stock DTB, boot parameters and platform ramdisk.
The script replaces only the recovery fragment. Stock firmware images and
the extracted DTB stay local.

## First device test

Use an unlocked Lapis with the matching stock `vendor_boot.img` available for
rollback. Check the product and current slot in bootloader fastboot. Use the
repacked `vendor_boot-lapis.img` on that slot only. The modified image has a
different hash from the stock AVB descriptor.

```sh
fastboot getvar product
fastboot getvar current-slot
fastboot flash vendor_boot /path/to/vendor_boot-lapis.img
fastboot reboot recovery
```

Check whether OrangeFox reaches its main screen and whether Android still
boots from the tested slot. If recovery fails, record whether the OrangeFox
splash appeared, the output of the fastboot commands, and the active slot
after the failure. If available, save `/tmp/recovery.log` or `/sys/fs/pstore`.
To roll back, flash the matching stock `vendor_boot.img` to the original test
slot explicitly, since the device may have switched slots after failed boots.
