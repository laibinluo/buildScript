#!/bin/bash -x

proj=$1
rev_range=$2

cd ${proj}

rev_list=$(git rev-list --reverse ${rev_range})
for rev in ${rev_list}
do
  git cherry-pick --ff ${rev}
#  git commit --amend --no-edit
done
