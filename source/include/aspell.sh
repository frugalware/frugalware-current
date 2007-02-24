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
# # Maintainer: VMiklos <vmiklos@frugalware.org>
#
# _F_aspell_lang=de
# pkgver=20030222r1
# pkgrel=1
# pkgdesc="GNU Aspell 0.60 German Word List Package"
# Finclude aspell
# --------------------------------------------------
#
# == OPTIONS
# * _F_aspell_ver (defaults to 6): the dictionary is made for this version of aspell
###
[ -z "$_F_aspell_ver" ] && _F_aspell_ver=6

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
archs=('i686' 'x86_64')
up2date="lynx -dump http://ftp.gnu.org/pub/gnu/aspell/dict/$_F_aspell_lang/\?M=D|grep aspell$_F_aspell_ver-$_F_aspell_lang|sed -n -e \"s/aspell$_F_aspell_ver-$_F_aspell_lang-//\" -e 's/\.tar\..* / /' -e 's/-/r/' -e '1p'|cut -d ] -f 3|cut -d ' ' -f 1"
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
