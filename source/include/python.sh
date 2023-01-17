#!/bin/sh

###
# = python.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# python.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for python packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=newt
# # pkgver, pkgrel, pkgdesc, url, depends, groups, archs, up2date, source
# sha1sums=('ef783a28a0ba0ec7015bb4cf06b10cd42bbb3aa3')
# Finclude python
#
# build()
# {
#         Fcd
#         tar -xzvf newt-$pkgver.tar.gz
#         cd newt-$pkgver
#         Fsed "-O2" "$CFLAGS" Makefile.in
#         Fsed "python2\.4" "python$_F_python_ver" Makefile.in
#         Fbuild
# }
# --------------------------------------------------
#
# == OVERWRITTEN VARIABLES
# * _F_python3_libdir
# * _F_python3_ver
###

if [ -e /usr/bin/python3 ]; then
	_F_python3_libdir=`python3 -c "import sysconfig; print(sysconfig.get_path('platlib')[1:])"`
	_F_python3_ver=`python3 -c 'import sysconfig; print(sysconfig.get_python_version())'`
fi

###
# == PROVIDED FUNCTIONS
# * _F_python3_getlibdir
# * _F_python3_getver
###


_F_python3_getlibdir()
{
	 python3 -c "import sysconfig; print(sysconfig.get_path('platlib')[1:])"
}

_F_python3_getver()
{
	python3 -c 'import sysconfig; print(sysconfig.get_python_version())'
}
