#!/bin/sh

###
# = lib32.sh(3)
# James Buren <ryuo@frugalware.org>
#
# == NAME
# lib32.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for lib32 packages.
#
# == EXAMPLE
# --------------------------------------------------
# _F_lib32_name=glibc
# pkgver=2.22_3
# depends=()
# sha1sums=('1a158f01985f1ff32b08a06d82697a4b04cf49a8')
# Finclude lib32
# --------------------------------------------------
#
# == OPTIONS
# * _F_lib32_name (no default, must be specified): the name of the i686 package
# to repackage for lib32
# * _F_lib32_dirs (defaults to lib:lib32 usr/lib:usr/lib32): a list of colon
# delimited pairs. the first is the original directory name and the second is the
# new directory name.
###
if [ -z "$_F_lib32_name" ]
then
	Fmessage "_F_lib32_name must be specified before including lib32!"
	Fdie
fi
if [ -z "$_F_lib32_dirs" ]
then
	_F_lib32_dirs=('lib:lib32' 'usr/lib:usr/lib32')
fi

###
# == OVERWRITTEN VARIABLES
# * pkgname
# * pkgdesc
# * pkgrel
# * groups()
# * url
# * _F_archive_name
# * up2date
# * archs()
# * source()
###
pkgname=lib32-$_F_lib32_name
pkgdesc="lib32 package for $_F_lib32_name"
pkgrel=1
groups=('lib32-extra')
url="http://frugalware.org"
_F_archive_name="$_F_lib32_name"
up2date="Flastarchive http://ftp.frugalware.org/pub/frugalware/frugalware-current/frugalware-i686/ -i686.fpm"
archs=('!i686' 'x86_64')
source=(http://ftp.frugalware.org/pub/frugalware/frugalware-current/frugalware-i686/$_F_archive_name-${pkgver//_/-}-i686.fpm)

###
# == PROVIDED FUNCTIONS
# * Fbuildlib32()
###
Fbuildlib32()
{
	tar -xf "$_F_archive_name-${pkgver//_/-}-i686.fpm" || Fdie
	for i in "${_F_lib32_dirs[@]}"
	do
		old="${i%:*}"
		new="${i#*:}"
		if [ -d "$old/" ]
		then
			Fmkdir `dirname "$new/"`
			Fcprel "$old/" "$new/"
		fi
	done
}

###
# * build() just calls Fbuildlib32()
###
build()
{
	Fbuildlib32
}
