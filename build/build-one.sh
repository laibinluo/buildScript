#!/bin/bash -x

mkdir -p ${PUB_DIR}

rm -rf ${OUT_DIR}/${OTA_FILE}
rm -rf ${OUT_DIR}/${TGT_FILE}

make -j4 otapackage

mv -f ${OUT_DIR}/${OTA_FILE} ${PUB_DIR}/${PUB_NAME}.zip
if [ -z "${QUICK}" ]; then
  mv -f ${OUT_DIR}/${TGT_FILE} ${PUB_DIR}/${TGT_NAME}.zip
fi

if [ ! -z "${NUM_MAJOR}" ]; then
  ${OTA_TOOL} -i ${PUB_MAJOR}/${TGT_NAME}.zip ${PUB_DIR}/${TGT_NAME}.zip ${PUB_DIR}/${PUB_NAME}-from-${NUM_MAJOR}.zip
fi
if [ ! "${NUM_MAJOR}" == "${NUM_MINOR}" ]; then
  ${OTA_TOOL} -i ${PUB_MINOR}/${TGT_NAME}.zip ${PUB_DIR}/${TGT_NAME}.zip ${PUB_DIR}/${PUB_NAME}-from-${NUM_MINOR}.zip
fi
