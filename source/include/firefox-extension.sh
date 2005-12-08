#!/bin/sh

# (c) 2005 Miklos Vajna <vmiklos@frugalware.org>
# firefox-extension.sh for Frugalware
# distributed under GPL License

# provides an Fxpiinstall() function + overwrites bulid() to just call it

Fxpiinstall()
{
	Fmkdir /usr/lib/firefox/extensions/\{$extid\}
	cd $Fdestdir/usr/lib/firefox/extensions/\{$extid\}
	unzip -qqo $Fsrcdir/$extname-$pkgver.xpi || return 1
	Ffile /usr/lib/firefox/extensions/\{$extid\}/chrome.manifest
}

build()
{
	Fxpiinstall
}
