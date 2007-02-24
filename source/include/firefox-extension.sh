#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# firefox-extension.sh for Frugalware
# distributed under GPL License

# provides an Fxpiinstall() function + overwrites build() to just call it

pkgname=firefox-$_F_firefox_ext
rodepends=('firefox>=2.0')
groups=('xapps-extra' 'firefox-extensions')
archs=('i686' 'x86_64')

Fxpiinstall()
{
	[ -z "$_F_firefox_ext" ] && _F_firefox_ext="$pkgname"
	[ -n "$_F_firefox_name" ] && mv $_F_firefox_name $_F_firefox_ext-$pkgver.xpi
	if [ -z "$_F_firefox_nocurly" ]; then
		Fmkdir /usr/lib/firefox/extensions/\{$_F_firefox_id\}
		cd $Fdestdir/usr/lib/firefox/extensions/\{$_F_firefox_id\}
	else
		Fmkdir /usr/lib/firefox/extensions/$_F_firefox_id
		cd $Fdestdir/usr/lib/firefox/extensions/$_F_firefox_id
	fi
	unzip -qqo $Fsrcdir/$_F_firefox_ext-$pkgver.xpi || return 1
	Fpatchall
	if [ -z "$_F_firefox_nocurly" ]; then
		Ffile /usr/lib/firefox/extensions/\{$_F_firefox_id\}/chrome.manifest
	else
		Ffile /usr/lib/firefox/extensions/$_F_firefox_id/chrome.manifest
	fi
}

build()
{
	Fxpiinstall
}
