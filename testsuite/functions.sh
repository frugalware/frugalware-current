#!/bin/bash

in_array()
{
	needle=$1
	shift 1
	# array() undefined
	[ -z "$1" ] && return 1
	for i in $*
	do
		[ "$i" == "$needle" ] && return 0
	done
	return 1
}

check_option()
{
	local i
	for i in ${options[@]}; do
		local uc=`echo $i | tr [:lower:] [:upper:]`
		local lc=`echo $i | tr [:upper:] [:lower:]`
		if [ "$uc" = "$1" -o "$lc" = "$1" ]; then
			echo $1
			return
		fi
	done
}

strip_url()
{
	echo "$@" | sed 's|^.*://.*/||g'
}
