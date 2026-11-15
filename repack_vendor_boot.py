#!/usr/bin/env python3
"""Replace the recovery fragment in a stock Lapis vendor_boot v4 image."""

import argparse
import shlex
import subprocess
import tempfile
from pathlib import Path


PARTITION_SIZE = 64 * 1024 * 1024
LZ4_LEGACY_MAGIC = bytes.fromhex("02214c18")


def unpack_image(image, directory):
    output = subprocess.check_output(
        ["unpack_bootimg", "--boot_img", image, "--out", directory, "--format=mkbootimg"],
        text=True,
    )
    args = shlex.split(output)
    options = {}
    recovery_indices = []
    for index in range(0, len(args), 2):
        option, value = args[index:index + 2]
        options[option] = value
        if option == "--header_version" and value != "4":
            raise ValueError(f"Expected a vendor_boot v4 image: {image}")
        if option != "--vendor_ramdisk_fragment":
            continue
        if options.get("--ramdisk_name") == "recovery" and options.get("--ramdisk_type") in ("2", "RECOVERY"):
            recovery_indices.append(index + 1)
        options.clear()
    if len(recovery_indices) != 1:
        raise ValueError(f"Expected one RECOVERY fragment named recovery: {image}")
    return args, recovery_indices[0]


def repack(stock, built, output):
    if output.exists():
        raise ValueError(f"Output already exists: {output}")

    with tempfile.TemporaryDirectory(prefix=".lapis-vendor-boot-", dir=output.parent.resolve()) as temp:
        work_dir = Path(temp)
        stock_args, stock_recovery_index = unpack_image(stock, work_dir / "stock")
        built_args, built_recovery_index = unpack_image(built, work_dir / "built")
        recovery = Path(built_args[built_recovery_index])
        with recovery.open("rb") as stream:
            if stream.read(4) != LZ4_LEGACY_MAGIC:
                raise ValueError("Recovery fragment must use LZ4 legacy. Rebuild with BOARD_RAMDISK_USE_LZ4 := true.")

        stock_args[stock_recovery_index] = str(recovery)
        candidate = work_dir / "vendor_boot.img"
        subprocess.run(["mkbootimg", *stock_args, "--vendor_boot", candidate], check=True)
        if candidate.stat().st_size > PARTITION_SIZE:
            raise ValueError("Repacked image exceeds the 64 MiB vendor_boot partition")
        output.hardlink_to(candidate)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("stock", type=Path, help="Stock vendor_boot.img from the target firmware")
    parser.add_argument("built", type=Path, help="vendor_boot.img produced by mka vendorbootimage")
    parser.add_argument("output", type=Path, help="Path for the repacked image")
    args = parser.parse_args()
    try:
        repack(args.stock, args.built, args.output)
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        parser.exit(1, f"{error}\n")


if __name__ == "__main__":
    main()
