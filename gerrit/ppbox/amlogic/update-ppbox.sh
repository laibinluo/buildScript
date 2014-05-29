#!/bin/bash -x

date

bin_path=$(dirname $0)/../..

bin_path2=$(dirname $0)

cd git

${bin_path}/update.sh default

cd ppbox/amlogic

${bin_path}/update2.sh ppbox-amlogic-m3

${bin_path}/update2.sh ppbox-amlogic-m6

${bin_path}/update2.sh ppbox-amlogic-mx

cd ../..

cd ..

${bin_path2}/version.sh > version.log 2>&1
