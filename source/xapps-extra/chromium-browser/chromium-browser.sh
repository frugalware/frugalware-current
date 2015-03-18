#!/bin/sh
export CHROME_WRAPPER=/usr/lib/chromium/chromium
export CHROME_DESKTOP=chromium-browser.desktop

CHROME_GLOBAL_FLAGS="--ssl-version-min=tls1"

if [ -e "/usr/lib/chromium/PepperFlash/libpepflashplayer.so" ]
then
	CHROME_USER_FLAGS+="--ppapi-flash-path=/usr/lib/chromium/PepperFlash/libpepflashplayer.so "
fi

if [ -e "/usr/lib/chromium/PepperFlash/manifest.json" ]
then
	CHROME_USER_FLAGS+="--ppapi-flash-version=`grep version /usr/lib/chromium/PepperFlash/manifest.json | egrep -o '[0-9.]+'` "
fi

exec /usr/lib/chromium/chromium $CHROME_GLOBAL_FLAGS $CHROME_USER_FLAGS $@
