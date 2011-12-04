#!/bin/sh

###
# = amsn.sh(3)
# Gabriel Craciunescu <crazy@frugalware.org>
#
# == NAME
# amsn.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for amsn plugins packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=amsn-plugin-amsnplus
# _F_amsn_name="amsnplus"
# pkgver=2.6.1
# pkgrel=1
# pkgdesc="aMSN plus plugin similar to MSN Plus!"
# _F_sourceforge_ext=".zip"
# _F_sourceforge_dirname="amsn"
# _F_sourceforge_name="$_F_amsn_name"
# _F_amsn_clean_files=(Makefile Snapshot.exe snapshot.c)
# Finclude sourceforge amsn
# archs=('i686')
# sha1sums=('62ec1c2b6a70e1c01d7d52d4a5a6418b99f5d720')
# --------------------------------------------------
#
# == OPTIONS
# * _F_achive_name: (defaults to $_F_amsn_name) see util.sh
# * _F_amsn_name: no default it HAS to be set because we use amsn-plugin-xxxx as $pkgname
# * _F_amsn_clean_files: lists files have to be removed from package (e.g: foo.exe )
###

if [ -z "$_F_amsn_name" ]; then
        Fmessage "You have to set _F_amsn_name!!"
	Fmessage "Issue man amsn.sh for more info"
	exit 1
fi

if [ -z "$_F_archive_name" ]; then
	_F_archive_name=$_F_amsn_name
fi

###
# == OVERWRITTEN VARIABLES
# * groups
# * up2date
###

up2date="Flastarchive 'http://sourceforge.net/projects/amsn/files/amsn-plugins/0.97/' '\.zip'"
groups=('xapps-extra' 'amsn-plugins')

###
# == APPENDED VARIABLES
# * amsn to depends()
###
depends=(${depends[@]} 'amsn')

###
# == PROVIDED FUNCTIONS
# * Famsn_clean_files(): deletes all files from _F_amsn_clean_files
###
Famsn_clean_files()
{
        if [ -n "$_F_amsn_clean_files" ]; then
		for broken in "${_F_amsn_clean_files[@]}"
		do
			Frm usr/share/amsn/plugins/$_F_amsn_name/$broken
		done
	fi
}

###
# * Fbuild_amsn()
###
Fbuild_amsn()
{

	Fmkdir usr/share/amsn/plugins
	Fcpr $_F_amsn_name usr/share/amsn/plugins

	# Some files are not world readable, so let's fix them
	chmod -R a+r $Fdestdir/usr/share/amsn/plugins/* || Fdie

	# Clean some junk
	find $Fdestdir -name ".svn" | xargs rm -rf || Fdie
	find $Fdestdir -name "CVS" | xargs rm -rf || Fdie
	find $Fdestdir -name ".git" | xargs rm -rf || Fdie

	# Clean more junk
	Famsn_clean_files
}


###
# * build(): just calls Fbuild_amsn()
###
build()
{
        Fbuild_amsn
}

