#!/bin/bash -x

set -e

####test 
REPO_PROJECT=platform/build
REPO_PATH=build

WORK_PATH=/home/elnino/share/mtk8665/jidou_sdk_test
gerrit_git_dir=zmj/${REPO_PROJECT}
branch=zmj_r5.1

WORK_BAK=/home/elnino/share/mtk8665/jidou_sdk_bak


if [ ! -d ${WORK_PATH}/${REPO_PATH} ]; then
  echo ${REPO_PROJECT} >> ${WORK_PATH}/miss.txt
fi

cd ${WORK_PATH}/${REPO_PATH}

echo ${WORK_PATH}/${REPO_PATH}

echo $(pwd)
echo ${gerrit_git_dir}

#exit 0;

## 移除.gitignore文件
file_ignores=$(find $WORK_PATH/$REPO_PATH -name .gitignore)

for file in $file_ignores
do
    echo $file
    dir_tmp=${file%/*} 
    dir_tmp=${dir_tmp##${WORK_PATH}/}
    mkdir -p ${WORK_BAK}/${dir_tmp}
    mv $file ${WORK_BAK}/${dir_tmp}/

    echo ${dir_tmp}
    echo ${WORK_BAK}/${dir_tmp}/
done

echo "=====================移除文件结束================================"

#exit 0

##init project
git init 
git add .
git commit -m "init project"

###还原.gitignore文件
echo $file_ignores
for file_ignore in $file_ignores
do 
    echo $file_ignore
    dir_tmp=${file_ignore%/*}   
    dir_tmp=${dir_tmp##${WORK_PATH}/}
    mv ${WORK_BAK}/${dir_tmp}/.gitignore ${WORK_PATH}/${dir_tmp}/
done

echo "@@@@@@@@@@@@@@@@@@@@@@还原文件结束@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
#exit 0

git add .
git commit --allow-empty -m "add .gitignore"

###提交到服务器
git checkout -b ${branch} HEAD || true

ssh gerrit gerrit create-project -n ${gerrit_git_dir} || true
git remote add jidou ssh://gerrit/${gerrit_git_dir}.git || true  

git push jidou refs/heads/${branch}:refs/heads/${branch}

cd -

###移除已经创建的工程
mkdir -p $WORK_BAK/$REPO_PATH
cp -R  ${WORK_PATH}/${REPO_PATH}/* $WORK_BAK/$REPO_PATH/ 
rm -rf ${WORK_PATH}/${REPO_PATH}

echo "##################### END #############################"

   




