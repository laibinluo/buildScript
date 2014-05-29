#!/bin/bash -x

set -e

bin_path=$(dirname $0)

branch=$(git --git-dir=.repo/manifests/.git symbolic-ref HEAD)
branch=${branch##*/}

merge_branch ${branch}

merge_log=merge/${merge_log}

${bin_path}/repo forall -p -c git rev-parse m/${branch} > version.txt

cd .repo/manifests

git config branch.${branch}.mergefrom ${merge_from}
git config branch.${branch}.mergelog ${merge_log}
git config branch.${merge_log}.remote $(git config branch.${branch}.remote)
git config branch.${merge_log}.merge refs/heads/${merge_log}

git checkout --orphan ${merge_log}
git rm -rf .
mv ../../version.txt .
git add version.txt
git commit -m "init version"
#git push
git checkout ${branch}

cd ../..
