#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# thunderbird-i18n.sh for Frugalware
# distributed under GPL License

# provides a common up2date, source and build for thunderbird i18n packages

up2date="1.5"

source=(http://ftp.mozilla.org/pub/mozilla.org/thunderbird/releases/$pkgver/linux-i686$junk/xpi/$llang.xpi \
	lang-$pkgname.txt)

build()
{
	Fmkdir /usr/lib/thunderbird
	cd $Fdestdir/usr/lib/thunderbird
	unzip -o $Fsrcdir/$llang.xpi
	rm -rf defaults install.rdf chrome/chromelist.txt
	mv chrome.manifest $lang.manifest
	Ffile /usr/lib/thunderbird/chrome/lang/lang-$pkgname.txt
}
