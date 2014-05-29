#!/bin/bash -x

DIR_BRANCH=$(pwd)
BRANCH=$(basename ${DIR_BRANCH})

DIR_ALL=${DIR_BRANCH}/all
DIR_PUB=${DIR_BRANCH}/pub

NUM_CURRENT=$1
if [ -z "${NUM_CURRENT}" ]; then
  NUM_CURRENT=$(readlink ${DIR_BRANCH}/last)
  NUM_CURRENT=$(basename ${NUM_CURRENT})
fi

DIR_CURRENT=${DIR_ALL}/${NUM_CURRENT}

read VER_CURRENT < ${DIR_CURRENT}/version
read VER_MINOR < ${DIR_BRANCH}/minor/version || true

VER_MINOR_PREFIX=${VER_MINOR%.*}
VER_CURRENT_PREFIX=${VER_CURRENT%.*}

rm -f ${DIR_PUB}/${VER_CURRENT}
ln -s ../all/${NUM_CURRENT} ${DIR_PUB}/${VER_CURRENT}
rm -f ${DIR_BRANCH}/minor
ln -s pub/${VER_CURRENT} ${DIR_BRANCH}/minor
if [ "${VER_CURRENT_PREFIX}" != "${VER_MINOR_PREFIX}" ]; then
  rm -f ${DIR_BRANCH}/major
  ln -s pub/${VER_CURRENT} ${DIR_BRANCH}/major
fi

cd ${DIR_BRANCH}/workdir

cd .repo/manifests
git tag ${BRANCH}/${VER_CURRENT} $(cat ${DIR_CURRENT}/manifest)
git push origin tags/${BRANCH}/${VER_CURRENT}:${BRANCH}/${VER_CURRENT}
cd ../..
