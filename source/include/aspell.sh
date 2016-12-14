#!/bin/sh

###
# = aspell.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# aspell.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for aspell dictonary packages.
#
# == EXAMPLE
# --------------------------------------------------
# # Compiling Time:  SBU
# # Maintainer: Miklos Vajna <vmiklos@frugalware.org>
#
# _F_aspell_lang=de
# pkgver=20030222r1
# pkgrel=1
# pkgdesc="GNU Aspell 0.60 German Word List Package"
# Finclude aspell
# --------------------------------------------------
#
# == OPTIONS
# * _F_aspell_lang: the language of the dictionary
# * _F_aspell_ver (defaults to 6, or to 5, if pkgver starts with '0.5'): the dictionary is made for this version of aspell
# * _F_aspell_noverstrip: don't unset _F_aspell_ver even if it is '5'
###
if [ -z "$_F_aspell_ver" ]; then
	if [ "${pkgver:0:3}" == "0.5" ]; then
		_F_aspell_ver=5
	else
		_F_aspell_ver=6
	fi
fi
[ "$_F_aspell_ver" = "5" ] && [ -z "$_F_aspell_noverstrip" ] && unset _F_aspell_ver

###
# == OVERWRITTEN VARIABLES
# * pkgname
# * url
# * depends()
# * groups()
# * archs()
# * up2date
# * source()
# * signatures
###
pkgname=aspell$_F_aspell_ver-$_F_aspell_lang
url="http://aspell.net/"
depends=('aspell>=0.60')
groups=('locale-extra')
archs=('x86_64')
up2date="lynx -dump ftp://ftp.gnu.org/pub/gnu/aspell/dict/$_F_aspell_lang/|grep aspell$_F_aspell_ver-$_F_aspell_lang.*bz2$|sed -n 's/.*aspell$_F_aspell_ver-$_F_aspell_lang-\(.*\).t.*/\1/;s/-/r/;$ p'"
source=(ftp://ftp.gnu.org/gnu/aspell/dict/$_F_aspell_lang/$pkgname-${pkgver/r/-}.tar.bz2)
signatures=($source.sig)

###
# == PROVIDED FUNCTIONS
# * build()
###
build()
{
	Fcd $pkgname-${pkgver/r/-}
	./configure

	make || return 1

	Fmakeinstall
}
