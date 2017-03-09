#!/usr/bin/env bash
cd ./../../source/x264

 NDK=~/Library/Android/sdk/ndk-bundle
 TOOLCHAIN=${NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
 PLATFORM=${NDK}/platforms/android-14/arch-arm
 PREFIX=./../output/libx264/armeabi


./configure \
    --prefix=${PREFIX} \
    --enable-static \
    --enable-shared \
    --enable-pic \
    --disable-asm \
    --disable-cli \
    --host=arm-linux \
    --cross-prefix=${TOOLCHAIN}/bin/arm-linux-androideabi- \
    --sysroot=${PLATFORM}

make clean
make -j8
make install
