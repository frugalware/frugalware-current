#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# koffice-l10n.sh for Frugalware
# distributed under GPL License

# common url, up2date, source() and build() for koffice-l10n pkgs

url="http://www.koffice.org/"
up2date="lynx -dump $url |grep current|sed 's/.*e \(.*\) i.*/\1/'"
source=(ftp://ftp.kde.org/pub/kde/stable/koffice-$pkgver/src/koffice-l10n/$pkgname-$pkgver.tar.bz2)
build()
{
	Fbuild
	Frm /usr/share/locale/$lang/LC_MESSAGES/kdgantt.mo
}
