#!/bin/sh

###
# = firefox-extension.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# firefox-extension.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for Firefox extension packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgver=1.01
# pkgrel=1
# pkgdesc="Display WML (Wireless Markup Language) content."
# url="https://addons.mozilla.org/firefox/1843/"
# up2date="elinks -dump $url |grep xpi$|sed 's/.*g-\(.*\)-.*/\1/'"
# source=(http://releases.mozilla.org/pub/mozilla.org/extensions/firebug/\
# firebug-$pkgver-fx+fl.xpi chrome.manifest)
# _F_firefox_ext=firebug
# _F_firefox_id="firebug@software.joehewitt.com"
# _F_firefox_name="$_F_firefox_ext-$pkgver-fx+fl.xpi"
# _F_firefox_nocurly=1
# Finclude firefox-extension
# sha1sums=('f2d188ae2a952fa8326d1bf1364a14079013fd19'\
#           'e1ad5704e87a6cd3e8e49728a3b1fe53c832ba9f')
# --------------------------------------------------
#
# NOTE: For the first time, you need to install the extension as a user
# manually and take the chrome.manifest from your ~/.mozilla/firefox directory.
#
# == OPTIONS
# * _F_firefox_ext: name of the extension
# * _F_firefox_id: id of the extension
# * _F_firefox_num: number assigned by mozilla website (if not set, url,
# up2date, and source must be manually set)
# * _F_firefox_name: if not set, the name of the source must be in a
# $_F_firefox_ext-$pkgver.xpi form
# * _F_firefox_nocurly: set this if the is not in curly brackets
#
# == OVERWRITTEN VARIABLES
# * pkgname
# * rodepends()
# * groups()
# * archs()
# * url (only if _F_firefox_num is set)
# * up2date (only if _F_firefox_num is set)
# * source (only if _F_firefox_num is set)
###
pkgname=firefox-$_F_firefox_ext
rodepends=('firefox>=3.6')
groups=('xapps-extra' 'firefox-extensions')
archs=('i686' 'x86_64' 'ppc')
if [ -n "$_F_firefox_num" ]; then
	url="https://addons.mozilla.org/en-US/firefox/addon/$_F_firefox_num/"
	up2date="curl -s -k '$url' | sed -n 's|.*Version \(\S*\)<.*|\1|p'"
	source=(http://releases.mozilla.org/pub/mozilla.org/addons/$_F_firefox_num/$_F_firefox_name)
fi

###
# == PROVIDED FUNCTIONS
# * Fxpiinstall()
###
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
	unzip -qqo $Fsrcdir/$_F_firefox_ext-$pkgver.xpi || Fdie
	chmod 644 install.rdf || Fdie
	Fpatchall
	if [ -z "$_F_firefox_nocurly" ]; then
		Ffile /usr/lib/firefox/extensions/\{$_F_firefox_id\}/chrome.manifest
	else
		Ffile /usr/lib/firefox/extensions/$_F_firefox_id/chrome.manifest
	fi
	Fdirschmod  /usr/lib/firefox/extensions 755
	Ffileschmod /usr/lib/firefox/extensions 644
}

###
# * build() just calls Fxpiinstall()
###
build()
{
	Fxpiinstall
}
