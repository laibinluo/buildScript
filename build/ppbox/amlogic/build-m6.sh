#!/bin/bash -x

set -e

my_path=$(dirname $0)

BRANCH=ppbox-amlogic-m6
PRODUCT=g18ref
VARIANT=user
CHANNEL_ID_PRE=ppbox_2

source ${my_path}/build-prev.sh
source ${my_path}/build.sh
source ${my_path}/build-post.sh
