#!/bin/bash 

my_path=$(dirname $0)

#local_apks=$(find ${my_path} -name "*.apk")
#local_apks=bloxorz_tv.apk
work_path=${my_path}

if [ $# != 1 ]; then
	echo "Usage: apks.sh input1"
	exit;
fi

local_apks=$1
local_extension=${local_apks##*.}

if [ ${local_extension} != "apk" ]; then
	echo "input file is not .apk"
	exit;
fi

function unzip_apk()
{
	tmp_apks=$1
	apk_dir=${tmp_apks%%.apk}
	mk_file=${apk_dir##*/}.mk
	work_path=${tmp_apks%/*}

	unzip -o -q $1 -d $apk_dir

	java -jar AXMLPrinter2.jar ${apk_dir}/AndroidManifest.xml > ${apk_dir}/main.xml
	package_name=$(xpath -q -e '/manifest/@package' ${apk_dir}/main.xml)
	eval $package_name

	echo "LOCAL_LIBDIR := "$package > ${work_path}/${mk_file}
	echo "include	\$(BUILD_THIRD_APK)" >> ${work_path}/${mk_file}

	rm -rf ${apk_dir}
	echo $mk_file
}

for apk in ${local_apks}
do
	unzip_apk ${apk}
done

