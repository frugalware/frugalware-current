#!/bin/sh

###
# = e17-cvs.sh(3)
# Andras Voroskoi <voroskoi@frugalware.org>
#
# == NAME
# e17-cvs.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for our e17 cvs snapshot packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=etk
# pkgver=20061124
# pkgrel=1
# pkgdesc="EFL toolkit for E17."
# depends=('edje>=0.5.0.036')
# groups=('e17-extra' 'e17-misc')
# archs=('i686' 'x86_64')
# Finclude e17-cvs
# sha1sums=('dee50d16e86bdd5fed5ba4601c95bc86b8e621b4')
# --------------------------------------------------
#
# == OPTIONS
# * _F_e17_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
###
if [ -z "$_F_e17_name" ]; then
	_F_e17_name=$pkgname
fi

###
# == OVERWRITTEN VARIABLES
# * url
# * source()
# * up2date
###
url="www.get-e.org/"
source=(http://ftp.frugalware.org/pub/other/e17/packages/$_F_e17_name/$_F_e17_name-$pkgver.tar.gz)
up2date="lynx -dump http://frugalware.org/~voroskoi/e17.up2date |sed -n '1 p'"

###
# == APPENDED VARIABLES
# * cvs to makedepends()
###

makedepends=(${makedepends[@]} 'cvs')

###
# == PROVIDED FUNCTIONS
# * build()
###
build() {
	Fcd $_F_e17_name
	export NOCONFIGURE="yes"
	./autogen.sh || Fdie
	Fbuild
}
