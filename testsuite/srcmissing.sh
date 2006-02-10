#!/bin/bash

# fake variable for fwmakepkg
CHROOT=1

. /etc/makepkg.conf
. /usr/lib/frugalware/fwmakepkg

strip_url()
{
	echo $1 | sed 's|^.*://.*/||g'
}

if [ "$#" != 1 ]; then
	echo "$0: searches for missing source files"
	echo "usage: $0 <startdir>"
	exit 1
fi

startdir=$1

cd $startdir
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
			if [ "$1" = "--download" ]; then
				echo "downloading $file..."
				$FTPAGENT $j
			fi
		fi
	done
	cd - >/dev/null
done
