#!/bin/sh

export QTDIR=/usr/lib/qt
export PATH=$PATH:$QTDIR/bin
export QMAKESPEC=$QTDIR/mkspecs/linux-g++
export UIC_PATH=$QTDIR/bin/uic
export QT_XFT=true
export MANPATH=$MANPATH:$QTDIR/man
if [ -z "$PKG_CONFIG_PATH" ]; then
	export PKG_CONFIG_PATH=$QTDIR/lib/pkgconfig
else
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$QTDIR/lib/pkgconfig
fi

