#!/bin/bash -x

date

bin_path=$(dirname $0)/../..

cd git/ppbox/amlogic

${bin_path}/update.sh ics-amlogic-mbox

${bin_path}/update.sh jb-mr1-amlogic-g42

${bin_path}/update.sh jb-mr1-amlogic-g42-20131126
