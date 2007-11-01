#!/bin/sh

dbuslaunch="`which dbus-launch 2>/dev/null`"
if [ "`whoami`" != "fst"  -a "`whoami`" != "root" ]; then
	if [ -n "$dbuslaunch" ] && [ -x "$dbuslaunch" ] && [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  	   	eval `$dbuslaunch --auto-syntax --exit-with-session`
	fi
fi
