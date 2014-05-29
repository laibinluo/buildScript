#!/bin/bash -x

set -e

bin_path=$(dirname $0)

manifest=$1

branch=$2

if [ ! -d .repo ]; then
  ${bin_path}/repo init -u ${manifest}
else
  manifest1=$(git config --file=.repo/manifests.git/config remote.origin.url)
  if [ ! "${manifest1}" == "${manifest}" ]; then
    echo "manifest not match old"
    exit 1
  fi
fi

shift

for branch in $*; do
  cd .repo/manifests
  git checkout ${branch}
  cd ../..
  ${bin_path}/repo sync
done
