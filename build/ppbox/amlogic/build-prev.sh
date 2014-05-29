#!/bin/bash -x

bin_path=$(dirname $0)/../..

if [ -z "${DIR_ROOT}" ]; then
  DIR_ROOT=/var/www/package
fi
if [ -z "${URL_ROOT}" ]; then
  URL_ROOT=http://192.168.13.80/package
fi

REPO_URL=ssh://innrom.pptv.com/ppbox/amlogic/platform/manifest.git

NUM_CURRENT=${BUILD_NUMBER}
unset BUILD_NUMBER
unset BUILD_ID

if [ ! -z ${QUICK} ]; then
  GERRIT_PROJECT=${GERRIT_PROJECT#ppbox/amlogic/}
fi

source ${bin_path}/build-prev.sh
