#!/bin/bash -x

set -e

bin_path=$(dirname $0)

branch=$1

cd .repo/manifests
git checkout ${branch}
cd ../..

${bin_path}/repo sync
