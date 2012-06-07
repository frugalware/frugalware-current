#!/bin/sh

add_argument()
{
	if [ -z "$ARGS" ]; then
		ARGS="$1"
	else
		ARGS="$ARGS $1"
	fi
}

modprobe cpuid
modprobe msr

source /etc/sysconfig/tpc

exec tpc $ARGS
