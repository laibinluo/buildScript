#!/bin/bash -x

set -e
bin_path=$(dirname $0)

cd ~/mirror
${bin_path}/repo sync

bugid=$(echo ${GERRIT_CHANGE_SUBJECT} | cut -d ']' -f 1 | cut -d '-' -f  2)

echo "{ \"body\": \"Change Merged, To View: ${GERRIT_CHANGE_URL}\"}" | curl -H "Content-Type:application/json" -d "@-" -u ppbox-rom:Room1234567 http://bugfree:8989/rest/api/latest/issue/PPBOX-${bugid}/comment

