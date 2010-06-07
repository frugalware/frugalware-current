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
# * _F_netsurf_project (defaults to true): whether to treat this package as
# a netsurf project or not
###
[ -z "$_F_netsurf_name"    ] && _F_netsurf_name=$pkgname
[ -z "$_F_netsurf_project" ] && _F_netsurf_project=true

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
###
url="http://www.netsurf-browser.org"
if [ $_F_netsurf_project ]; then
	url="$url/projects/$_F_netsurf_name"
	up2date="Flastarchive $url -src.tar.gz"
	source=("${url/$_F_netsurf_name/releases/}/$_F_netsurf_name-$pkgver-src.tar.gz")
else
	up2date="Flasttar $url/downloads/gtk"
	source=("$url/downloads/releases/$_F_netsurf_name-$pkgver-src.tar.gz")
fi

###
# == PROVIDED FUNCTIONS
# * Fbuildnetsurfproject
###

Fbuildnetsurfproject() {
	Fcd
	make PREFIX=/usr || Fdie
	make PREFIX=/usr DESTDIR="$Fdestdir" install || Fdie
}

###
# * build() just calls Fbuildnetsurfproject (only if a netsurf project)
###

if [ $_F_netsurf_project ]; then
	build() {
		Fbuildnetsurfproject
	}
fi
