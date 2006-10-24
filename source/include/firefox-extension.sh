#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# firefox-extension.sh for Frugalware
# distributed under GPL License

# provides an Fxpiinstall() function + overwrites build() to just call it

rodepends=('firefox>=2.0')
groups=('xapps-extra' 'firefox-extensions')
archs=('i686' 'x86_64')

Fxpiinstall()
{
	[ -z "$extname" ] && extname="$pkgname"
	[ -n "$_F_firefox_name" ] && mv $_F_firefox_name $extname-$pkgver.xpi
	Fmkdir /usr/lib/firefox/extensions/\{$extid\}
	cd $Fdestdir/usr/lib/firefox/extensions/\{$extid\}
	unzip -qqo $Fsrcdir/$extname-$pkgver.xpi || return 1
	Fpatchall
	Ffile /usr/lib/firefox/extensions/\{$extid\}/chrome.manifest

	unset _F_firefox_name
}

build()
{
	Fxpiinstall
}
