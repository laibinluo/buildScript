#!/bin/bash -x

PUB_NAME=`make help | awk -F= '{ if ($1 == "BUILD_ID") print $2; }'`

# PPBOX

CHANNEL=ppbox

export CHANNEL_ID=${CHANNEL_ID_PRE}001

source ${my_path}/build-one.sh

# SUNING

if [ -z "${QUICK}" ]; then

CHANNEL=suning

export CHANNEL_ID=${CHANNEL_ID_PRE}002

source ${my_path}/build-one.sh

fi # [ -z "${QUICK}" ]
