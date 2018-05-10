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
#
# --------------------------------------------------
# pkgname=pygtkhelpers
# pkgver=0.4.2
# pkgrel=1
# pkgdesc="A library to assist the building of PyGTK applications."
# rodepends=('pygtk')
# groups=('xlib-extra')
# archs=('x86_64')
# Finclude pypi
# sha1sums=('24af2eb1d5631a4565a4a867a2f6bb5820926001')
# --------------------------------------------------
#
# == OPTIONS
# * _F_pypi_name (defaults to $pkgname): set to name used in pypi
# * _F_pypi_ext (defaults to .tar.gz): set to file extension used by the package
# * _F_pypi_nopypi ( default to nothing): when set to yes up2date=() , source=() and url=()
# from pypi is ignored and you can define custom ones
###

if [ -z "$_F_pypi_name" ]; then
	_F_pypi_name="$pkgname"
fi

if [ -z "$_F_pypi_ext" ]; then
	_F_pypi_ext='.tar.gz'
fi

if [ -z "$_F_archive_name" ]; then
	_F_archive_name="$_F_pypi_name"
fi

###
# == OVERWRITTEN VARIABLES
# * url (if not set)
# * up2date
# * source()
###
if [ -z "$_F_pypi_nopypi" ]; then
	[ -z "$url" ] && url="http://pypi.python.org/pypi/$_F_pypi_name"
	up2date="Flastarchive https://pypi.python.org/pypi/${_F_pypi_name}/json $_F_pypi_ext"
	source=(https://files.pythonhosted.org/packages/source/${_F_pypi_name:0:1}/$_F_pypi_name/$_F_archive_name-$pkgver$_F_pypi_ext)
fi

if [ -z "$archs" ]; then
	archs=('x86_64')
fi

