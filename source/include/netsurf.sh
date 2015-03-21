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
# archs=('i686' 'x86_64')
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
[ -z "$_F_netsurf_ext" ] && _F_netsurf_ext='-src.tar.gz'
[ -z "$_F_archive_name" ] && _F_archive_name=$_F_netsurf_name

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
# * archs()
# * _F_cd_path
###
if [ "$_F_netsurf_project" -eq 1 ]; then
	url="http://www.netsurf-browser.org/projects/$_F_netsurf_name"
	up2date="Flastarchive http://download.netsurf-browser.org/libs/releases/ $_F_netsurf_ext"
	source=("http://download.netsurf-browser.org/libs/releases/$_F_netsurf_name-$pkgver$_F_netsurf_ext")
	_F_cd_path="$_F_netsurf_name-$pkgver"
else
	url="http://www.netsurf-browser.org"	
	up2date="Flastarchive http://download.netsurf-browser.org/netsurf/releases/source/ -src.tar.gz"
	source=("http://download.netsurf-browser.org/netsurf/releases/source/$_F_netsurf_name-$pkgver$_F_netsurf_ext")
fi
archs=('i686' 'x86_64')

if [ $pkgname != "netsurf-buildsystem" ] ; then
  makedepends=(${makedepends[@]} 'netsurf-buildsystem')
fi

###
# == PROVIDED FUNCTIONS
# * Fbuildnetsurfproject
###
Fbuildnetsurf() {
	Fpatchall
	Fcd
	Fsed '_BSD_SOURCE' '_DEFAULT_SOURCE' Makefile
	if [ "$_F_netsurf_project" -eq 1 ]; then
		make PREFIX=/usr COMPONENT_TYPE="lib-shared" || Fdie
		make PREFIX=/usr DESTDIR="$Fdestdir" COMPONENT_TYPE="lib-shared" install || Fdie
	fi
}

###
# * build() just calls Fbuildnetsurf
###
build() {
	Fbuildnetsurf
}
