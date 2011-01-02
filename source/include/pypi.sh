#!/bin/sh

###
# = pypi.sh(3)
# James Buren <ryuo@frugalware.org>
#
# == NAME
# pypi.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for pypi packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=pygtkhelpers
# pkgver=0.4.2
# pkgrel=1
# pkgdesc="A library to assist the building of PyGTK applications."
# rodepends=('pygtk')
# groups=('xlib-extra')
# archs=('i686' 'x86_64' 'ppc')
# Finclude pypi
# sha1sums=('24af2eb1d5631a4565a4a867a2f6bb5820926001')
# == OPTIONS
# * _F_pypi_ext (defaults to .tar.gz): set to file extension used by the package
###
[ -z "$_F_pypi_ext" ] && _F_pypi_ext='.tar.gz'

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
###
url="http://pypi.python.org/pypi/$pkgname"
up2date="Flastarchive http://pypi.python.org/packages/source/${pkgname:0:1}/$pkgname $_F_pypi_ext"
source=(http://pypi.python.org/packages/source/${pkgname:0:1}/$pkgname/$pkgname-$pkgver$_F_pypi_ext)
