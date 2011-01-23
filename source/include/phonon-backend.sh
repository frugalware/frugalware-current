#!/bin/sh

###
# = phonon-backend.sh(3)
# Michel Hermier <hermier@frugalware.org>
#
# == NAME
# kde.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for phonon backend packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=phonon-backend-xine
# pkgrel=1
# pkgdesc="Phonon xine backend."
# archs=('i686' 'x86_64' 'ppc')
#
# Finclude phonon-backend
# depends=("${depends[@]}" 'xine-lib')
# sha1sums=('978102346592424865ddbf44fc666334cb3606f1')
# --------------------------------------------------
#
# == OPTIONS
# * _F_phonon_ver (defaults to the current phonon version)
# * _F_phonon_backend_name (defaults to $pkgname)
# * _F_phonon_backend_pkgver (defaults to $pkgver or if not set to
#   $_F_phonon_ver)
###

if [ -z "$_F_phonon_ver" ]; then
	_F_phonon_ver=4.4.4
fi

if [ -z "$_F_phonon_backend_name" ]; then
	_F_phonon_backend_name="$pkgname"
fi

if [ -z "$_F_phonon_backend_pkgver" ]; then
	if [ -z "$pkgver" ]; then
		_F_phonon_backend_pkgver="$_F_phonon_ver"
	else
		_F_phonon_backend_pkgver="$pkgver"
	fi
fi

###
# == OVERWRITTEN VARIABLES
# * groups (defaults to xmultimedia-extra and phonon-backend)
# * depends (appends phonon)
# * url (defaults to phonon site url)
# * _F_kde_defaults
# * _F_kde_name
# * _F_kde_pkgver
# * _F_kde_dirname
###

if [ -z "$url" ]; then
	url="http://phonon.kde.org"
fi

groups=('xmultimedia-extra' 'phonon-backend')
depends=("${depends[@]}" "phonon>=$_F_phonon_ver")

if [ -z "$url" ]; then
	url="http://phonon.kde.org"
fi

_F_kde_defaults=1
_F_kde_name="$_F_phonon_backend_name"
_F_kde_pkgver="$_F_phonon_backend_pkgver"
_F_kde_folder="stable/phonon/$_F_phonon_backend_name"
Finclude kde

