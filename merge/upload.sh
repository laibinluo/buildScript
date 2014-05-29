#!/bin/bash -x

proj=$1
rrev=$2

branch=$(git --git-dir=.repo/manifests/.git symbolic-ref HEAD)
branch=${branch##*/}

cd ${proj}

lrev=$(git rev-parse HEAD)

if [ "${lrev}" == "${rrev}" ]; then # fast forward
  git push ppboxrom HEAD:${branch}
else
  git push ppboxrom HEAD:refs/for/${branch}
fi
