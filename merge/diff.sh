#!/bin/bash -x

set -e

bin_path=$(dirname $0)

branch=$(git --git-dir=.repo/manifests/.git symbolic-ref HEAD)
branch=${branch##*/}

merge_from=$(git --git-dir=.repo/manifests/.git config branch.${branch}.mergefrom)
merge_log=$(git --git-dir=.repo/manifests/.git config branch.${branch}.mergelog)

git --git-dir .repo/manifests/.git cat-file -p ${merge_log}:version.txt > version1.txt

${bin_path}/repo forall $* -p -c git rev-parse ${merge_from} > version2.txt

if [ "$*" == "" ]; then
  all=1
fi

awk -vall=${all} -f ${bin_path}/diff.awk version1.txt version2.txt

rm -f version1.txt version2.txt
