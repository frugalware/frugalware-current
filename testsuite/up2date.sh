#!/bin/bash

check()
{
	for i in *
	do
		cd $i
		for j in *
		do
			[ -d $j ] || continue
			cd $j
			sh -x -c 'source /usr/lib/frugalware/fwmakepkg; source FrugalBuild' 2>&1|grep -q '+ lynx' && \
				echo "$j is buggy"
			cd ..
		done
		cd ..
	done
}

if [ "$#" -lt 1 ]; then
	echo "searches for old-style up2dates"
	echo "usage: $0 <startdir>"
	exit 1
fi

cd $1

cd source
check
cd ../extra/source
check
