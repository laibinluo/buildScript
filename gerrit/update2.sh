#!/bin/bash -x

bin_path=$(dirname $0)

branch=$1

cd .repo/manifests
git checkout ${branch}
git pull
cd ../..
