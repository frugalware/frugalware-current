#!/bin/sh

. /etc/sysconfig/pm-radeon

[ -z "$method" ] && exit 1

[ "$method" != "profile" -a -n "$profile" ] && exit 1

for i in /sys/class/drm/card*/device/power_method; do
	if [ -f "$i" ]; then
		echo "$method" > "$i"
		[ "$?" -ne "0" ] && exit 1
	fi
done

for i in /sys/class/drm/card*/device/power_profile; do
	if [ -f "$i" -a -n "$profile" ]; then
		echo "$profile" > "$i"
		[ "$?" -ne "0" ] && exit 1
	fi
done

true
