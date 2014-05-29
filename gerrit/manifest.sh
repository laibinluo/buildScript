#!/bin/bash -x

bin_path=$(dirname $0)

if [ ! -d manifest ]; then
git init --bare manifest.git
fi

root=${PWD}

if [ ! -d ~/clone/manifest ]; then
mkdir -p ~/clone
cd ~/clone
git clone ${root}/manifest.git
fi

cd ${root}

cat > default.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<manifest>

  <remote  name="ppbox"
           fetch="." />
  <default revision="master"
           remote="ppbox"
           sync-j="1" />

EOF

find . -type d -name "*.git" -exec echo "<project name=\"{}\" />" \; >> default.xml 
sed -i "s/\.\///g" default.xml
sed -i "s/\.git//g" default.xml

echo >> default.xml
echo "</manifest>" >> default.xml

cd ~/clone/manifest
mv -f ${root}/default.xml .
git add default.xml
git commit -m "update default.xml"
git push origin master:master
