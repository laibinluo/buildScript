#!/bin/bash -x

set -e

my_path=$(dirname $0)

BRANCH=ppbox-amlogic-m8
PRODUCT=k200
VARIANT=user
CHANNEL_ID_PRE=ppbox_3
export BOARD_REVISION=b_2G

source ${my_path}/build-prev.sh
source ${my_path}/build.sh
source ${my_path}/build-post.sh
