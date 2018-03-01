#!/bin/sh

CCACHE=$(command -v ccache)

TOOLCHAIN=/home/adesikha15/aarch64-linux-android/bin/aarch64-cortex_a53-linux-android-

export CROSS_COMPILE="${CCACHE} ${TOOLCHAIN}"

export ARCH=arm64

export KBUILD_BUILD_USER=adesh15
export KBUILD_BUILD_HOST=reactor

make clean O=out/
make mrproper O=out/

make mido_defconfig O=out/

make -j8 O=out/
