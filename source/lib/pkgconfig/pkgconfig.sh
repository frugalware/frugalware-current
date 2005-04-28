#!/bin/sh

if [ -z "$PKG_CONFIG_PATH" ]; then
	export PKG_CONFIG_PATH=/usr/lib/pkgconfig
else
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/lib/pkgconfig
fi

if [ -d /usr/local/lib/pkgconfig ] ; then
	PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
fi

if [ -d /usr/X11R6/lib/pkgconfig ] ; then
	PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/X11R6/lib/pkgconfig
fi

export PKG_CONFIG_PATH
