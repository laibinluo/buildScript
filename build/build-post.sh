#!/bin/bash -x

echo ${URL_CURRENT} > url.txt

echo ${VERSION} > ${DIR_CURRENT}/version

if [ -z "${QUICK}" ]; then

  rm -f ${DIR_BRANCH}/last
  ln -s all/${NUM_CURRENT} ${DIR_BRANCH}/last
  
  cd .repo/versions
  cp -f ../../diff.txt .
  git add ver.txt diff.txt
  git commit -m "build finish ${BUILD_TAG}" || true
  cd ../..

fi

cp -f diff.txt ${DIR_CURRENT}/diff.txt

if [ -z "${QUICK}" ]; then

  ${bin_path}/repo manifest -r -o default.xml

  cp -f default.xml ${DIR_CURRENT}/manifest.xml

  BUILD_LOG_BRANCHE=build/${BRANCH}
  
  cd .repo/manifests
  git checkout ${BUILD_LOG_BRANCHE} || git checkout -b ${BUILD_LOG_BRANCHE}
  cp -f ../../default.xml .
  git add default.xml
  git commit -m "build finish ${BUILD_TAG}"  || true
  echo $(git rev-parse HEAD) > ${DIR_CURRENT}/manifest
  git checkout ${BRANCH}
  cd ../..

fi

echo Finish!!!
