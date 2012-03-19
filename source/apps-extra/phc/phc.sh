#!/bin/sh

. /etc/sysconfig/phc

[ -z "$VIDS" -o -z "$1" ] && exit 1

set_vids()
{
	for i in /sys/devices/system/cpu/cpu*/cpufreq/phc_vids; do
		if [ -f "$i" ]; then
			echo "$1" > "$i"
			[ "$?" -ne "0" ] && exit 1
		fi
	done
	true
}

case $1 in
	set)
		set_vids "$VIDS"
		;;
	reset)
		[ -f "/sys/devices/system/cpu/cpu0/cpufreq/phc_default_vids" ] || exit 1
		set_vids "$(< /sys/devices/system/cpu/cpu0/cpufreq/phc_default_vids)"
		;;
esac
