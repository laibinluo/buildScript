#!/bin/bash -x

set -e

#REPO_PATH=external/chromium_org/sdch/open-vcdiff
#REPO_PROJECT=platform/external/chromium_org/sdch/open-vcdiff
WORK_PATH=${REPO_PATH}
BACK_PATH=${REPO_PATH%/*}

echo ${WORK_PATH}
echo ${BACK_PATH}
echo ${SOURCE_PATH}

cd ${WORK_PATH}

rm -rf .git/

git init 

git add .

git commit --allow-empty -m "init project"

git checkout -b jidou_r4.4.4 HEAD || true

ssh gerrit gerrit create-project -n ${REPO_PROJECT} || true

git remote add jidou /data/review/git/${REPO_PROJECT}.git || true 

git push jidou refs/heads/jidou_r4.4.4:refs/heads/jidou_r4.4.4

echo "push success"

#git log
#
#if [ $? != 0 ]; then
# #  git commit --allow-empty -m "init project"
#  # git checkout -b jidou_r4.4.4 HEAD || true
#
# echo "log != 0"  
#
#else 
#   
#  echo "log = 0"
#
#fi

cd -



#mkdir -p ../repo_back/${BACK_PATH}

#mv ${WORK_PATH}/  ../repo_back/${BACK_PATH}


