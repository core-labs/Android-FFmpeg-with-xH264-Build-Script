#!/usr/bin/env bash
sh build_x264.sh

cd ./../../source/ffmpeg

export NDK=~/Library/Android/sdk/ndk-bundle
export TOOLCHAIN=${NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
export PLATFORM=${NDK}/platforms/android-14/arch-arm
export SYSROOT=${TOOLCHAIN}/sysroot/
export PREFIX=./../output/ffmpeg/armeabi_v7a #编译结果的目录 最终生成的编译结果

EXTRA_DIR=./../../source/output/libx264/armeabi
# 加入x264编译库
EXTRA_CFLAGS="-I./${EXTRA_DIR}/include"
EXTRA_LDFLAGS="-L./${EXTRA_DIR}/lib"


./configure \
    --target-os=linux \
    --prefix=${PREFIX} \
    --enable-cross-compile \
    --enable-runtime-cpudetect \
    --arch=arm \
    --extra-cflags="-I$PLATFORM/usr/include" \
    --cc=${TOOLCHAIN}/bin/arm-linux-androideabi-gcc \
    --cross-prefix=${TOOLCHAIN}/bin/arm-linux-androideabi- \
    --nm=${TOOLCHAIN}/bin/arm-linux-androideabi-nm \
    --sysroot=${PLATFORM} \
    --enable-gpl \
    --enable-version3 \
    --enable-small \
    --enable-encoders \
    --enable-libx264 \
    --enable-encoder=libx264 \
    --enable-muxers \
    --enable-muxer=mov \
    --enable-muxer=ipod \
    --enable-muxer=psp \
    --enable-muxer=mp4 \
    --enable-muxer=avi \
    --enable-decoders \
    --enable-decoder=aac \
    --enable-decoder=aac_latm \
    --enable-decoder=h264 \
    --enable-decoder=mpeg4 \
    --enable-demuxers \
    --enable-demuxer=h264 \
    --enable-demuxer=mov \
    --enable-parsers \
    --enable-parser=aac \
    --enable-parser=ac3 \
    --enable-parser=h264 \
    --enable-protocol=file \
    --enable-protocol=rtmp \
    --enable-bsf=aac_adtstoasc \
    --enable-bsf=h264_mp4toannexb \
    --enable-zlib \
    --enable-static \
    --enable-postproc \
    --enable-avdevice \
    --disable-shared \
    --disable-asm \
    --disable-doc \
    --disable-ffprobe \
    --disable-ffplay \
    --disable-ffmpeg \
    --disable-ffserver \
    --disable-debug \
    --disable-stripping \
    --extra-cflags=${EXTRA_CFLAGS} \
    --extra-ldflags=${EXTRA_LDFLAGS}


make clean
make -j4
make install

${TOOLCHAIN}/bin/arm-linux-androideabi-ld -rpath-link=${PLATFORM}/usr/lib -L${PLATFORM}/usr/lib \
-L${PREFIX}/lib -soname libffmpeg.so -shared \
-nostdlib -Bsymbolic --whole-archive --no-undefined -o ${PREFIX}/libffmpeg.so \
    ${EXTRA_DIR}/lib/libx264.a \
    libavcodec/libavcodec.a \
    libavfilter/libavfilter.a \
    libswresample/libswresample.a \
    libavformat/libavformat.a \
    libavutil/libavutil.a \
    libswscale/libswscale.a \
    libpostproc/libpostproc.a \
    libavdevice/libavdevice.a \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker ${TOOLCHAIN}/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
