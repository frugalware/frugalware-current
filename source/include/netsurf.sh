#!/bin/sh

###
# = skel.sh(3)
# James Buren <ryuo@frugalware.org>
#
# == NAME
# netsurf.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages related to and including netsurf.
#
# == EXAMPLE
# pkgname=libparserutils
# pkgver=0.0.2
# pkgrel=1
# pkgdesc="A library for building efficient parsers, written in C."
# Finclude netsurf
# depends=('glibc')
# groups=('lib-extra')
# archs=('i686' 'x86_64' 'ppc')
# sha1sums=('cf2c6dcbcace5c22645c26dc60c1eb4c9c9a15a0')
#
# == OPTIONS
# * _F_netsurf_name (defaults to $pkgname): supply the name to use for the
# source directory and tar ball
# * _F_netsurf_project (defaults to 1): whether to treat this package as
# a netsurf project or not
###
[ -z "$_F_netsurf_name"    ] && _F_netsurf_name=$pkgname
[ -z "$_F_netsurf_project" ] && _F_netsurf_project=1

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
# * archs()
###
url="http://www.netsurf-browser.org"
if [ "$_F_netsurf_project" -eq 1 ]; then
	url="$url/projects/$_F_netsurf_name"
	up2date="Flastarchive $url -src.tar.gz"
	source=("${url/$_F_netsurf_name/releases/}/$_F_netsurf_name-$pkgver-src.tar.gz")
else
	up2date="Flastarchive $url/downloads/gtk -src.tar.gz"
	source=("$url/downloads/releases/$_F_netsurf_name-$pkgver-src.tar.gz")
fi
archs=('i686' 'x86_64' 'ppc')

###
# == PROVIDED FUNCTIONS
# * Fbuildnetsurfproject
###

Fbuildnetsurf() {
	if [ "$_F_netsurf_project" -eq 1 ]; then
		Fsed "-O2" "$CFLAGS" build/makefiles/Makefile.gcc
	else
		Fsed "-O2" "$CFLAGS" Makefile.defaults
	fi
	make PREFIX=/usr || Fdie
	make PREFIX=/usr DESTDIR="$Fdestdir" install || Fdie
}

###
# * build() just calls Fbuildnetsurf
###

build() {
	Fbuildnetsurf
}
