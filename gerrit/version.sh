#!/bin/bash -x

bin_path=$(dirname $0)

branch=$1
out=$2

cd .repo/manifests
git checkout ${branch}
cd ../..
${bin_path}/repo forall -p -c "git rev-parse \${REPO_RREV}" > ${out}.tmp
mv -f ${out}.tmp ${out}
