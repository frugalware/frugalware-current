#!/bin/sh

###
# = firefox-i18n.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# firefox-i18n.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for Firefox language packages.
#
# == EXAMPLE
# --------------------------------------------------
# _F_firefox_lang=it
# pkgver=2.0
# pkgrel=1
# pkgdesc="Italian language support for Firefox"
# Finclude firefox-i18n
# sha1sums=('0b8a517c87e9e2c0143eb60f10ce0e07316eb733')
# --------------------------------------------------
#
# == OVERWRITTEN VARIABLES
# * up2date
# * source()
# * pkgname
# * url
# * rodepends()
# * makedepends()
# * groups()
# * archs()
###

up2date="2.0"
source=(http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$pkgver/linux-i686/xpi/$_F_firefox_lang.xpi)
pkgname=firefox-$_F_firefox_lang
url="http://www.mozilla.org/projects/l10n/mlp.html"
rodepends=('firefox>=2.0')
makedepends=('unzip')
groups=('locale-extra')
archs=('i686' 'x86_64')

###
# == PROVIDED FUNCTIONS
# * build()
###
build()
{
	unzip -qqo $_F_firefox_lang.xpi
	sed -i 's|chrome/||' chrome.manifest
	Ffilerel chrome.manifest /usr/lib/firefox/chrome/$_F_firefox_lang.manifest
	Ffilerel chrome/$_F_firefox_lang.jar /usr/lib/firefox/chrome/$_F_firefox_lang.jar
}
