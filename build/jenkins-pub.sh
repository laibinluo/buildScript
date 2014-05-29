#!/bin/bash 

if [ $# != 1 ]; then
	echo "Usage: auto_pub.sh input1"
	exit
fi

input=$1
build=${input##*-}

wget http://jenkins/user/laibinluo/my-views/view/ROM/job/ppbox-rom-daily-build-amlogic-${build}/build?token=build_${build}

