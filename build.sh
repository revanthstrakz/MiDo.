#!/bin/sh

ROOT_PATH=$PWD

export KBUILD_BUILD_USER=adesh15
export KBUILD_BUILD_HOST=reactor
export ARCH=arm64
export SUBARCH=arm64
export IMAGE="out/arch/${ARCH}/boot/Image.gz-dtb";
export ZIPDIR="/home/adesikha15/zip";

rm -rf $ZIPDIR/*.zip

if [ "$CLANG" == "yes" ]
then
export CLANG_PATH=/home/adesikha15/clang/clang-4639204/bin
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export TCHAIN_PATH="/home/adesikha15/gcc-4.9/bin/aarch64-linux-android-"
export CROSS_COMPILE="${CCACHE} ${TCHAIN_PATH}"
export CLANG_TCHAIN="/home/adesikha15/clang/clang-4639204/bin/clang"
export KBUILD_COMPILER_STRING="$(${CLANG_TCHAIN} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')"
export FINAL_ZIP="${ZIPDIR}/Feather-mido-clang-$(date +"%Y%m%d")-$(date +"%H%M%S").zip"

make clean O=out/
make mrproper O=out/
make CC=clang mido_defconfig O=out/
else
TOOLCHAIN=/home/adesikha15/toolchain/bin/aarch64-linux-
export CROSS_COMPILE="${CCACHE} ${TOOLCHAIN}"
export FINAL_ZIP="${ZIPDIR}/Feather-mido-$(date +"%Y%m%d")-$(date +"%H%M%S").zip"

make clean O=out/
make mrproper O=out/
make mido_defconfig O=out/
fi

#TG send message function
#export CHAT_ID="-318772221 $CHAT_ID";
export CHAT_ID="-1001163172007 $CHAT_ID";

function sendTG()
{
for f in $CHAT_ID
do
bash ~/reactor/send_tg.sh $f $@
done
}

START=$(date +"%s");
if [ "$CLANG" == "yes" ]
then
sendTG "Starting $(date +%Y%m%d) Feather Clang [build]($BUILD_URL)."
make CC=clang -j16 O=out/
else
sendTG "Starting $(date +%Y%m%d) Feather [build]($BUILD_URL)."
make -j8 O=out/
fi
END=$(date +"%s")
DIFF=$((END - START))
echo "Build took $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds.";

if [ ! -f "${IMAGE}" ]; then
    echo -e "Build failed :P";
    sendTG "KERNEL BUILD FAILED, RIP in pieces.";
    sendTG "@Adesh15, check console fast.";
    exit 1;
else
    echo "Build Succesful!";
    echo "Copying kernel image";
    rm "$ZIPDIR/Image.gz-dtb";
    cp -v "${IMAGE}" "${ZIPDIR}/";
    cd "${ZIPDIR}"
    zip -r9 "${FINAL_ZIP}" *;
    size=$(du -sh $FINAL_ZIP | awk '{print $1}')
    fileid=$(~/gdrive upload --parent 1pJw20jsAAna1ziqjH7xUJoJaMbxPcqpp ${FINAL_ZIP} | tail -1 | awk '{print $2}')
    sendTG "[Google Drive](https://drive.google.com/uc?id=$fileid&export=download)"
    sendTG "FileSize - $size"
    sendTG "Kernal lelo frandz";
    sendTG "${POST_MESSAGE}";
fi

cd $ROOT_PATH
