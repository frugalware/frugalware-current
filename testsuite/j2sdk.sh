#!/bin/bash

if [ "$#" -lt 1 ]; then
	echo "searches for packages compiled with a closed source compiler"
	echo "usage: $0 <startdir>"
	exit 1
fi

cd $1/source

# TODO: don't exclude extra
for i in `ls |grep -v extra`
do
	find $i -name FrugalBuild |xargs grep '^[^#].*j2sdk'
done|sed 's|.*/\([^/]*\)/FrugalBuild.*|\1|'|sort -u
