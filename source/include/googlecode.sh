#!/bin/sh

###
# = googlecode.sh(3)
# Bouleetbil <bouleetbil@frogdev.info>
#
# == NAME
# googlecode.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages hosted at google.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=rubyripper
# pkgver=0.5.0
# pkgrel=1
# pkgdesc="A secure audiodisc ripper for Linux."
# depends=('cdparanoia' 'ruby-gettext' 'ruby-gtk2' 'cd-discid' 'flac' \
#	 'ogmtools' 'lame'  'vorbisgain' 'mp3gain' 'normalize' )
# groups=('xapps-extra')
# archs=('x86_64')
# _F_googlecode_ext=".tar.bz2"
# Finclude googlecode
# options=('scriptlet')
# sha1sums=('27fa2cdfe02d7d7ab4be3e7fc53df462aee61ea8')
# Fconfopts+="  --enable-lang-all --enable-gtk2 --enable-cli "
# --------------------------------------------------
#
# == OPTIONS
# * _F_googlecode_name (defaults to $pkgname): if you want to use a custom
# package name (for example the upstream name contains uppercase letters) then
# use this to declare the real name
# * _F_googlecode_dirname (defaults to $_F_googlecode_name): if the
# source tarball uses a name different to the googlecode name, then use
# this option to declare the project name
# * _F_googlecode_pkgver (defaults to $pkgver): Some packages are called foo-1.2.3
# but the source is called different from $pkgver, e.g: foo-123 or vfoo_1_2_3, in such
# a case _F_googlecode_pkgver may help to avoid custom $source
# * _F_googlecode_ext (defaults to .tar.gz): extension of the source tarball
# * _F_googlecode_sep ( defaults to - ): used for source() only right now. As example
# for an "baz_1.2.3.tar.gz" tarball you should use _F_googlecode_sep="_" , for empty
# values use _F_googlecode_sep="None" that way you can dowload such foo1234.tgz
###

if [ -z "$_F_googlecode_name" ]; then
	_F_googlecode_name=$pkgname
fi

if [ -z "$_F_googlecode_dirname" ]; then
	_F_googlecode_dirname="$_F_googlecode_name"
fi

if [ -z "$_F_googlecode_pkgver" ]; then
        _F_googlecode_pkgver=${pkgver//_/-}
fi

if [ -z "$_F_googlecode_ext" ]; then
	_F_googlecode_ext=".tar.gz"
fi

if [ -z "$_F_googlecode_sep" ]; then
	_F_googlecode_sep="-"
fi

if [ -n "$_F_googlecode_sep" ] && [ "$_F_googlecode_sep" = "None" ]; then
        _F_googlecode_sep=""
fi
###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
###
url="http://code.google.com/p/$_F_googlecode_dirname"
_F_archive_name="$_F_googlecode_name"
Fpkgversep="$_F_googlecode_sep"
up2date="Flastarchive http://code.google.com/p/$_F_googlecode_dirname/downloads/list $_F_googlecode_ext"
source=(http://${_F_googlecode_dirname}.googlecode.com/files/${_F_googlecode_name}${_F_googlecode_sep}${_F_googlecode_pkgver}${_F_googlecode_ext})
