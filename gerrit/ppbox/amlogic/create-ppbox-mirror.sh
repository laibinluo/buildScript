#!/bin/bash -x

set -e

mkdir -p ppbox/amlogic
cd ppbox/amlogic

PATH=~/bin:${PATH}

MANIFEST=ssh://innrom.pptv.com/ppbox/amlogic/platform/manifest.git

if [ ! -d .repo ]; then
  repo init --mirror -u ${MANIFEST}
fi
repo sync

cd platform
git clone --mirror ${MANIFEST}
cd ..

cd .repo/manifests
git checkout ppbox-amlogic-m3
cd ../..
repo sync

cd .repo/manifests
git checkout ppbox-amlogic-m6
cd ../..
repo sync

cd .repo/manifests
git checkout ppbox-amlogic-mx
cd ../..
repo sync

