# build.sh
# created at 2023-08-05
# Build Kernel for 32bit Raspberry Pi OS on Raspberry Pi 4

#!/bin/bash

echo "configure build output path..."

KERNEL_TOP_PATH="$(cd "$(dirname "$0")"; pwd -P)"
OUTPUT_PATH="$KERNEL_TOP_PATH/out" # use custom build artifact path
echo "Output Path: ${OUTPUT_PATH}"

KERNEL=kernel8
BUILD_LOG_PATH="$KERNEL_TOP_PATH/build.log"

echo "move to kernel source tree..."
cd linux

echo "make defconfig..."
make O=$OUTPUT_PATH ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2711_defconfig

echo "kernel build..."
make O=$OUTPUT_PATH ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs -j16 2>&1 | tee $BUILD_LOG_PATH

echo "move to tmp as sdcard..."
cd $OUTPUT_PATH

echo "delete previous out.tar.gz"
rm mnt/out.tar.gz

echo "mount partitionk..."
mkdir mnt
mkdir mnt/fat32
mkdir mnt/fat32/overlays
mkdir mnt/ext4
env PATH=$PATH make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=mnt/ext4 modules_install

echo "copy kernel and device tree blobs to sdcard..."
cp mnt/fat32/$KERNEL.img mnt/fat32/$KERNEL-backup.img
cp arch/arm64/boot/Image mnt/fat32/$KERNEL.img
cp arch/arm64/boot/dts/broadcom/*.dtb mnt/fat32/
cp arch/arm64/boot/dts/overlays/*.dtb* mnt/fat32/overlays/
cp arch/arm64/boot/dts/overlays/README mnt/fat32/overlays/

echo "compressing output files..."
cd mnt
tar -zcvf out.tar.gz *

echo "clean up..."
rm -r fat32 ext4

echo "complete!"
echo "result is in out/mnt/out.tar.gz"
