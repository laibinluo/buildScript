#!/bin/bash -x

set -e

my_path=$(dirname $0)

BRANCH=ppbox-amlogic-m3
PRODUCT=f16ref
VARIANT=eng
CHANNEL_ID_PRE=ppbox_1

source ${my_path}/build-prev.sh

make -j8

cd kernel/

make meson_reff16_defconfig
make -j4 uImage
cp arch/arm/boot/uImage ../${OUT_DIR}

make meson_reff16_recovery_defconfig
make -j4 uImage
cp arch/arm/boot/uImage ../${OUT_DIR}/uImage_recovery

cd ..

source ${my_path}/build.sh
source ${my_path}/build-post.sh
