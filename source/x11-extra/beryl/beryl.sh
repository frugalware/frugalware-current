#!/bin/sh

if [ -e /etc/sysconfig/beryl ]; then
	. /etc/sysconfig/beryl
fi

if [ "$ENABLE_BERYL" == "1" ]; then
	export KDEWM=beryl-manager
fi
