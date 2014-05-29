#!/bin/bash -x

set -e

bin_path=$(dirname $0)/../..

function merge_branch()
{
  if [ "$1" == "ppbox-amlogic-m3" ]; then
      merge_from=ppbox/ics-amlogic-mbox
      merge_log=ppbox-amlogic-m3
  else
      merge_from=ppbox/jb-mr1-amlogic-g42-20131126
      merge_log=ppbox-amlogic-mx
  fi
}

export -f merge_branch

${bin_path}/init.sh
