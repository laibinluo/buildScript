#!/bin/bash -x

bin_path=$(pwd)

echo ${bin_path}

repo forall -p -c ${bin_path}/pick.sh

