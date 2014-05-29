#!/bin/bash -x

VERSION=${PUB_NAME%_*}
VERSION=${VERSION##*_}

source ${bin_path}/build-post.sh
