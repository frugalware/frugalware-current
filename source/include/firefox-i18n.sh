#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# firefox-i18n.sh for Frugalware
# distributed under GPL License

# provides a common up2date, source and build for firefox i18n packages

up2date="2.0"
source=(http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$pkgver/linux-i686/xpi/$_F_firefox_lang.xpi)
pkgname=firefox-$_F_firefox_lang
url="http://www.mozilla.org/projects/l10n/mlp.html"
rodepends=('firefox>=2.0')
makedepends=('unzip')
groups=('locale-extra')
archs=('i686' 'x86_64')

build()
{
	unzip -qqo $_F_firefox_lang.xpi
	sed -i 's|chrome/||' chrome.manifest
	Ffilerel chrome.manifest /usr/lib/firefox/chrome/$_F_firefox_lang.manifest
	Ffilerel chrome/$_F_firefox_lang.jar /usr/lib/firefox/chrome/$_F_firefox_lang.jar
}
