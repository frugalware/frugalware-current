#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# thunderbird-i18n.sh for Frugalware
# distributed under GPL License

# provides a common up2date, source and build for thunderbird i18n packages

up2date="1.5"

source=(http://ftp.mozilla.org/pub/mozilla.org/thunderbird/releases/$pkgver/linux-i686/xpi/$llang.xpi)

build()
{
	unzip -qqo $llang.xpi
	sed -i 's|chrome/||' chrome.manifest
	Ffilerel chrome.manifest /usr/lib/thunderbird/chrome/$llang.manifest
	Ffilerel chrome/$llang.jar /usr/lib/thunderbird/chrome/$llang.jar
}
