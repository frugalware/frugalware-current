#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Illegal number of parameters"
        exit
fi

xzgrep -q -a $(sha1sum $1 | cut -d ' ' -f1) $2 || echo "Recorded sha1sum for file $1 doesn't match"
