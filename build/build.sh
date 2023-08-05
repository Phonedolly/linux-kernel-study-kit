#!/bin/bash

echo "configure build output path..."

KERNEL_TOP_PATH="$(cd "$(dirname "$0")"; pwd -P)"
OUTPUT_PATH="$KERNEL_TOP_PATH/out" # use custom build artifact path
echo "Output Path: ${OUTPUT_PATH}"

KERNEL=kernel7l
BUILD_LOG_PATH="$KERNEL_TOP_PATH/build.log"

echo "move to kernel source tree..."
cd linux

echo "make defconfig..."
make O=$OUTPUT_PATH ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig

echo "kernel build..."
make O=$OUTPUT_PATH ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs -j3 2>&1 | tee $BUILD_LOG_PATH
