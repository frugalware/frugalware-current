#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# firefox-i18n.sh for Frugalware
# distributed under GPL License

# provides a common up2date, source and build for firefox i18n packages

up2date="wget -O - -q ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/|grep '>[0-9\.]*/'|sed -n 's|.*>\([0-9\.]*\)/.*|\1|;$ p'"
source=(http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$pkgver/linux-i686/xpi/$lang.xpi)

build()
{
	unzip -qqo $lang.xpi
	sed -i 's|chrome/||' chrome.manifest
	Ffilerel chrome.manifest /usr/lib/firefox/chrome/$lang.manifest
	Ffilerel chrome/$lang.jar /usr/lib/firefox/chrome/$lang.jar
}
