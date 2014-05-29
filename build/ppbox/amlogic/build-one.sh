#!/bin/bash -x

PUB_DIR=${DIR_CURRENT}/${CHANNEL}

if [ ! -z "${NUM_MAJOR}" ]; then
 PUB_MAJOR=${DIR_MAJOR}/${CHANNEL} 
fi

if [ ! "${NUM_MAJOR}" == "${NUM_MINOR}" ]; then
 PUB_MAJOR=${DIR_MINOR}/${CHANNEL} 
fi

source ${bin_path}/build-one.sh

make clean_third_dso || true
rm ${OUT_DIR}/system/build.prop
