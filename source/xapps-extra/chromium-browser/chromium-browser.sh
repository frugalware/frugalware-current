#!/bin/sh
export CHROME_WRAPPER=/usr/lib/chromium/chromium
export CHROME_DESKTOP=chromium-browser.desktop
exec /usr/lib/chromium/chromium $@
