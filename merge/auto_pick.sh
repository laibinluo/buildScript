#!/bin/bash -x

set -e

PROJECT=${REPO_PROJECT}
BRANCH=${PROJECT//\//_}
WORK_PATH=$(pwd)
MERGE_PATH=~/PPBox/pptv_m81/merge
echo ${REPO_PATH}

mkdir -p ${MERGE_PATH}
echo ${REPO_PATH}
echo ${WORK_PATH}
echo ${BRANCH}

cd ${WORK_PATH}

git checkout --no-track -b ${BRANCH} ppbox/ppbox-amlogic-m6  || true

git rebase --onto ppbox/ppbox-amlogic-m8  ppbox/jb-mr1-amlogic-g42 || true
git branch --set-upstream ${BRANCH}  ppbox/ppbox-amlogic-m8 || true 

while [[ -f .git/MERGE_RR ]]; do 

  AUTHOR=$(awk -F : 'NR==1 {print $2}' .git/rebase-apply/info)
  AUTHOR=${AUTHOR# }

  cat .git/rebase-apply/info >> ${MERGE_PATH}/${AUTHOR}.txt
  cat .git/rebase-apply/info >> ${MERGE_PATH}/error.txt

  cat .git/rebase-apply/original-commit >> ${MERGE_PATH}/${AUTHOR}.txt
  echo ${PROJECT} >> ${MERGE_PATH}/${AUTHOR}.txt
  echo ${REPO_PATH} >> ${MERGE_PATH}/${AUTHOR}.txt

  cat .git/rebase-apply/original-commit >> ${MERGE_PATH}/error.txt
  echo ${PROJECT} >> ${MERGE_PATH}/error.txt
  echo ${REPO_PATH} >> ${MERGE_PATH}/error.txt

  echo "--------------------------------------------------------" >> ${MERGE_PATH}/${AUTHOR}.txt
  echo "--------------------------------------------------------" >> ${MERGE_PATH}/error.txt
  git rebase --skip || true

done;

cd -

