#!/bin/bash -x

date

bin_path=$(dirname $0)/../..

cd git/ppbox/amlogic

${bin_path}/version.sh ppbox-amlogic-m3 /var/www/version/ppbox-amlogic-m3.txt

${bin_path}/version.sh ppbox-amlogic-m6 /var/www/version/ppbox-amlogic-m6.txt

${bin_path}/version.sh ppbox-amlogic-mx /var/www/version/ppbox-amlogic-mx.txt
