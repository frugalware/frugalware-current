#!/bin/sh

# (c) 2005 Miklos Vajna <vmiklos@frugalware.org>
# openoffice-i18n.sh for Frugalware
# distributed under GPL License

# common up2date and source() for openoffice.org language packs

resdir=/usr/lib/ooo-2.0/program/resource/
dictdir=/usr/lib/ooo-2.0/share/dict/ooo/

up2date="lynx -dump http://ftp.frugalware.org/pub/other/openoffice.org-i18n/|sed -n 's|.*/\(.*\)/|\1|;$ p'"

source=(http://ftp.frugalware.org/pub/other/openoffice.org-i18n/$pkgver/$pkgname-$pkgver.tar.bz2 \
	http://ftp.services.openoffice.org/pub/OpenOffice.org/contrib/dictionaries/$dictname.zip)

Fresinstall()
{
	Fmkdir $resdir
	cp -a *$lang.res $Fdestdir$resdir || Fdie
}
