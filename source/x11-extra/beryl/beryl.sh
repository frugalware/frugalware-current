#!/bin/sh

if [ -e /etc/sysconfig/beryl ]; then
	. /etc/sysconfig/beryl
fi

if [ "$ENABLE_BERYL" == "1" ]; then
	export KDEWM=beryl-manager
	# hack!
	export LIBXCB_ALLOW_SLOPPY_LOCK=1
fi
