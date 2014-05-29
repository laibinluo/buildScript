#!/bin/bash -x

# prepare publish directory

DIR_BRANCH=${DIR_ROOT}/${BRANCH}
URL_BRANCH=${URL_ROOT}/${BRANCH}

if [ ! -d ${DIR_BRANCH} ]; then
  mkdir -p ${DIR_BRANCH}/all
  mkdir -p ${DIR_BRANCH}/pub
  mkdir -p ${DIR_BRANCH}/quick
  ln -s $(pwd) ${DIR_BRANCH}/workdir
  ln -s ${bin_path}/subdir.php ${DIR_BRANCH}/index.php
fi

if [ -z "${QUICK}" ]; then
  DIR_CURRENT=${DIR_BRANCH}/all/${NUM_CURRENT}
  URL_CURRENT=${URL_BRANCH}/all/${NUM_CURRENT}
else
  DIR_CURRENT=${DIR_BRANCH}/quick
  URL_CURRENT=${URL_BRANCH}/quick
fi

if [ -z "${QUICK}" -a -e ${DIR_BRANCH}/major ]; then
  DIR_MAJOR=${DIR_BRANCH}/major
  NUM_MAJOR=$(readlink ${DIR_MAJOR})
  NUM_MAJOR=$(basename ${NUM_MAJOR})
  DIR_MINOR=${DIR_BRANCH}/minor
  NUM_MINOR=$(readlink ${DIR_MINOR})
  NUM_MINOR=$(basename ${NUM_MINOR})
fi

# sync repos

if [ ! -d .repo ]; then
  ${bin_path}/repo init -u ${REPO_URL} --reference ~/mirror/ppbox/amlogic
  cd .repo/manifests
  git checkout -b ${BRANCH} origin/${BRANCH}
  cd ../..
fi

${bin_path}/repo sync

if [ ! -z ${QUICK} ]; then
  GERRIT_PROJECT=$(${bin_path}/repo list | grep ${GERRIT_PROJECT}$ | cut -d ' ' -f 1)
  ${bin_path}/repo download ${GERRIT_PROJECT} ${GERRIT_CHANGE_NUMBER}/${GERRIT_PATCHSET_NUMBER}
  git --git-dir="${GERRIT_PROJECT}"/.git show HEAD > diff.txt
else
  # also make ver.txt
  if ! ${bin_path}/diff.sh > diff.txt; then
    iconv -f utf8 -t gb2312 diff.txt -o diff.gb2312.txt
    exit 0
  fi
fi

iconv -f utf8 -t gb2312 diff.txt -o diff.gb2312.txt

mkdir -p ${DIR_CURRENT}

if [ ! -z "${NUM_MAJOR}" ]; then
  ln -s ../../pub/${NUM_MAJOR} ${DIR_CURRENT}/from-major
fi
if [ ! "${NUM_MAJOR}" == "${NUM_MINOR}" ]; then
  ln -s ../../pub/${NUM_MINOR} ${DIR_CURRENT}/from-minor
fi

# prepare build environment

OUT_DIR=out/target/product/${PRODUCT}

TGT_FILE=obj/PACKAGING/target_files_intermediates/${PRODUCT}-target_files-*.zip
TGT_NAME=${PRODUCT}-target_files-${VARIANT}.${USER}

OTA_FILE=${PRODUCT}-ota-*.zip

OTA_TOOL=./build/tools/releasetools/ota_from_target_files

source build/envsetup.sh 

lunch ${PRODUCT}-${VARIANT}
