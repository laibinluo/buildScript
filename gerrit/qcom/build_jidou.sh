#!/bin/bash

set -e

repo sync

./makeQucii -t Alto4NA update-api

param=$1
if [ -z $param ]; then
  param="-p"
fi

if [ $param = "-n" ]; then
    ./makeQucii -t Alto4NA -n
    #echo ---------------
else
    ./makeQucii -t Alto4NA
    #echo ++++++
fi

./makeQucii -t Alto4NA clean_third_dso

./makeQucii -t Alto4NA jidou_apk
#./makeQucii -t Alto4NA -B mm packages/jidou/apks/

./makeQucii -t Alto4NA snod

cd build/

rm -rf Qucii_8939_44/

rm -f Qucii_8939_44.zip

./CopyImg.sh Alto4NA

tmp=`date +%Y%m%d%H%M`

zip -r /home/wwy/build_Rom_realse/Qucii_8939_44_${tmp}.zip Qucii_8939_44/

cd -

./makeQucii -t Alto4NA clean_third_dso
#
#
