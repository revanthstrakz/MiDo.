#!/bin/sh
<<<<<<< HEAD

# Copyright (C) 2018 Adesh Ikhar (Adesh15)
# SPDX-License-Identifier: GPL-3.0-only
=======
# Copyright (C) 2018 Adesh Ikhar (Adesh15)
>>>>>>> ad/oreo-mr1

export TERM=xterm

source ~/mystuff/.creds
source ~/mystuff/common
onLogin

<<<<<<< HEAD
=======
CLEAN="$1"

>>>>>>> ad/oreo-mr1
#TG send message function
export CHAT_ID="$MY_CHAT $CHAT_ID"

ROOT_PATH=$PWD

KERNEL_NAME="Feather"
DEVICE="mido"
export KBUILD_BUILD_USER=adesh15
export KBUILD_BUILD_HOST=reactor
export ARCH=arm64
export SUBARCH=arm64
IMAGE="${ROOT_PATH}/out/arch/${ARCH}/boot/Image.gz-dtb"
ZIPDIR="/home/adesh15/zip"

clean()
{
echoText "Cleaning Up"
rm -rf $ZIPDIR/*.zip
rm -rf $ZIPDIR/Image*
}
<<<<<<< HEAD
=======

>>>>>>> ad/oreo-mr1
defconfig()
{
export CLANG_PATH=/home/adesh15/clang/clang-7.0.2/bin
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export TCHAIN_PATH="/home/adesh15/gcc-4.9/bin/aarch64-linux-android-"
export CROSS_COMPILE="${CCACHE} ${TCHAIN_PATH}"
export CLANG_TCHAIN="/home/adesh15/clang/clang-7.0.2/bin/clang"
export KBUILD_COMPILER_STRING="$(${CLANG_TCHAIN} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')"
FINAL_VER="${KERNEL_NAME}-${DEVICE}-clang"
FINAL_ZIP="${FINAL_VER}-$(date +"%Y%m%d").zip"
<<<<<<< HEAD
make clean O=out/
make mrproper O=out/
=======
if [ "$CLEAN" == "clean" ]
then
echoText "Building Clean"
make clean O=out/
make mrproper O=out/
fi
>>>>>>> ad/oreo-mr1
echoText "Generating Defconfig"
make CC=clang mido_defconfig O=out/
}

<<<<<<< HEAD

=======
>>>>>>> ad/oreo-mr1
compile()
{
echoText "Compiling Kernel"
tgm "Building \`${FINAL_VER}\`"
make CC=clang -j$(nproc --all) O=out/
<<<<<<< HEAD

=======
>>>>>>> ad/oreo-mr1
}

zipit()
{
echo "Copying kernel image"
cd "${ZIPDIR}"
cp -v "${IMAGE}" "${ZIPDIR}"
cd "${ZIPDIR}"
zip -r9 "${FINAL_ZIP}" *
SIZE=$(du -sh $FINAL_ZIP | awk '{print $1}')
fileid=$(~/gdrive upload --parent ${KERNEL_BUILDS} ${FINAL_ZIP} | tail -1 | awk '{print $2}')
FILE="[${FINAL_ZIP}](https://drive.google.com/uc?id=$fileid&export=download)"
BUILD_INFO="
Download File:
$FILE
SIZE: $SIZE"
}

START=$(date +"%s")
clean
defconfig
compile
if [ ! -f "${IMAGE}" ]; then
reportError "Kernel compilation failed"
tgm "Build Failed @Adesh15"
else
reportSuccess "Build Successful"
zipit
END=$(date +"%s")
DIFF=$((END - START))
echoText "Build successfull in $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds."
tgm "Build successfull in $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds."
tgm "$BUILD_INFO"
fi

cd $ROOT_PATH
