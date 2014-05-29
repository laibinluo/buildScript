#!/bin/bash -x

set -e

bin_path=$(dirname $0)/../..

manifest=ssh://innrom.pptv.com/ppbox/amlogic/platform/manifest.git

if [ "$1" == "" ]; then
  branch="ppbox-amlogic-m3 ppbox-amlogic-mx"
else
  branch=$1
fi

${bin_path}/create.sh ${manifest} ${branch}
