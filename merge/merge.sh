#!/bin/bash -x

set -e

bin_path=$(dirname $0)

branch=$(git --git-dir=.repo/manifests/.git symbolic-ref HEAD)
branch=${branch##*/}

merge_from=$(git --git-dir=.repo/manifests/.git config branch.${branch}.mergefrom)
merge_log=$(git --git-dir=.repo/manifests/.git config branch.${branch}.mergelog)

#${bin_path}/repo sync

git --git-dir .repo/manifests/.git cat-file -p ${merge_log}:version.txt > version1.txt

${bin_path}/repo forall $* -p -c git rev-parse ${merge_from} > version2.txt

# pick 

awk -v bin_path=${bin_path} -f ${bin_path}/pick.awk version1.txt version2.txt

# upload

awk -f ${bin_path}/upload.awk version1.txt version2.txt

if [ "$*" == "" ]; then
  msg="merged all"
  awk -f ${bin_path}/pickver.awk version2.txt version1.txt > version3.txt
  mv -f version3.txt version2.txt
else
  msg="merged $*"
fi

cd .repo/manifests

git checkout ${merge_log}
mv -f ../../version2.txt version.txt
if ! git diff --cached --exit-code ; then
  git add version.txt
  git commit -m "${msg}"
  #git push
fi
git checkout ${branch}

cd ../..

