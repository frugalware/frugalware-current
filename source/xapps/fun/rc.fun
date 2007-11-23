#!/bin/sh

# (c) 2007 Priyank M. Gosalia <priyankmg@gmail.com>
# rc.fun for Frugalware
# distributed under GPL License

# chkconfig: 2345 50 15
# description: Frugalware Update Notifier (FUN)

source /lib/initscripts/functions

TEXTDOMAIN=fun
TEXTDOMAINDIR=/lib/initscripts/messages
actions=(restart start stop)
daemon=$"Frugalware Update Notifier daemon"
pid="pidof fund 2> /dev/null"

rc_start()
{
	start_msg
	if [ -z "$(eval $pid)" ]; then
		/usr/sbin/fund --daemon > /dev/null 
		ok $?
	else
		ok 999
	fi
}

rc_stop()
{
	stop_msg
	if [ ! -z "$(eval $pid)" ]; then
		killall fund
		ok $?
	else
		ok 999
	fi
}

rc_exec $1
