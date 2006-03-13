#!/bin/bash

if [ "$#" -lt 1 ]; then
	echo "searches for duplicates packages"
	echo "usage: $0 <startdir>"
	exit 1
fi

find $1/source -mindepth 2 -maxdepth 2 -type d|sed 's|.*/\([^/]*\)|\1|'|sort|uniq -d
find $1/extra/source -mindepth 2 -maxdepth 2 -type d|sed 's|.*/\([^/]*\)|\1|'|sort|uniq -d
