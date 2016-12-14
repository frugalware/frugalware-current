#!/bin/sh

###
# = pecl.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# pecl.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for PHP PECL packages.
#
# == EXAMPLE
# --------------------------------------------------
# _F_pecl_name="ncurses"
# pkgver=1.0.0
# pkgdesc="Terminal screen handling and optimization package for PHP."
# depends=('php>=5.2.0' 'ncurses')
# Finclude pecl
# archs=('x86_64')
# pkgrel=2
# sha1sums=('bd57c58806d72baa23c20f4d078c0196f7c2c309')
# --------------------------------------------------
#
# == OPTIONS
# * _F_pecl_name: The name of the PECL extension.
# == OVERWRITTEN VARIABLES
# * pkgname
# * pkgrel
# * url
# * groups()
# * archs()
# * up2date
# * source()
###
pkgname=php-pecl-$_F_pecl_name
url="http://pecl.php.net/package/$_F_pecl_name"
groups=('devel-extra')
archs=('x86_64')
_F_archive_name=$_F_pecl_name
up2date="Flasttar $url"
source=(http://pecl.php.net/get/$_F_pecl_name-$pkgver.tgz)

###
# == PROVIDED FUNCTIONS
# * Fbuildpecl()
###
Fbuildpecl()
{
	Fcd $_F_pecl_name-$pkgver
	Fpatchall
	phpize || Fdie
	Fmake
	cd modules
	Fexerel /usr/lib/php/$_F_pecl_name.so
}

###
# * build() just calls Fbuildskel()
###
build()
{
	Fbuildpecl
}
