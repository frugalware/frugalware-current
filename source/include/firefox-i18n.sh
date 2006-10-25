#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# firefox-i18n.sh for Frugalware
# distributed under GPL License

# provides a common up2date, source and build for firefox i18n packages

up2date="2.0"
source=(http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$pkgver/linux-i686/xpi/$lang.xpi)
pkgname=firefox-$lang
url="http://www.mozilla.org/projects/l10n/mlp.html"
rodepends=('firefox>=2.0')
makedepends=('unzip')
groups=('locale-extra')
archs=('i686' 'x86_64')

build()
{
	unzip -qqo $lang.xpi
	sed -i 's|chrome/||' chrome.manifest
	Ffilerel chrome.manifest /usr/lib/firefox/chrome/$lang.manifest
	Ffilerel chrome/$lang.jar /usr/lib/firefox/chrome/$lang.jar
}
