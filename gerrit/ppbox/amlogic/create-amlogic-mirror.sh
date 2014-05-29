#!/bin/bash -x

mkdir -p ppbox/amlogic
cd ppbox/amlogic

PATH=~/bin:$PATH

MANIFEST=ssh://git@source.amlogic.com/pptv/platform/manifest.git

# mirror sync

if [ ! -d .repo ]; then
  repo init --mirror -u ${MANIFEST}
fi
repo sync

# mirror clone manifest

cd platform
git clone --mirror${MANIFEST}
cd ..

# clone branches

cd .repo/manifests
git checkout ics-amlogic-mbox
cd ../..
repo sync

cd .repo/manifests
git checkout jb-mr1-amlogic-g42
cd ../..
repo sync

cd .repo/manifests
git checkout jb-mr1-amlogic-g42-20131126
cd ../..
repo sync

# add branches

cd .repo/manifests
git checkout ics-amlogic-mbox
cd ../..
repo forall -c git branch --no-track ppbox-amlogic-m3 ics-amlogic-mbox

cd .repo/manifests
git checkout jb-mr1-amlogic-g42
cd ../..
repo forall -c git branch --no-track ppbox-amlogic-m6 jb-mr1-amlogic-g42

cd .repo/manifests
git checkout jb-mr1-amlogic-g42-20131126
cd ../..
repo forall -c git branch --no-track ppbox-amlogic-mx jb-mr1-amlogic-g42-20131126

# clone manifest

git clone platform/manifest.git

# add manifest branches

cd manifest
git checkout -b ppbox-amlogic-m3 origin/ics-amlogic-mbox
cd ..

cd manifest
git checkout -b ppbox-amlogic-m6 origin/jb-mr1-amlogic-g42
cd ..

cd manifest
git checkout -b ppbox-amlogic-mx origin/jb-mr1-amlogic-g42-20131126
cd ..

rm -rf manifest
