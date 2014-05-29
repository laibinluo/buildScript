#!/bin/bash -x

set -e

bin_path=$(dirname $0)/../..

manifest=ssh://192.168.13.202/ppbox/google/platform/manifest.git

if [ "$1" == "" ]; then
  branch="master"
else
  branch=$1
fi

${bin_path}/create.sh ${manifest} ${branch}
