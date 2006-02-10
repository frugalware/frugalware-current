#!/bin/bash

# fake variable for fwmakepkg
CHROOT=1

. /etc/makepkg.conf
. /usr/lib/frugalware/fwmakepkg

strip_url()
{
	echo $1 | sed 's|^.*://.*/||g'
}

echo "searching for missing source files..."

for i in `find source extra -maxdepth 5 -name FrugalBuild`
do
	cd `dirname $i` || continue
	unset source
	source FrugalBuild || echo "errors parsing the FrugalBuild"
	for j in ${source[@]}
	do
		file=`strip_url $j`
		if [ ! -e "$file" ]; then
			echo "`dirname $i`: $file is missing"
		fi
	done
	cd - >/dev/null
done
