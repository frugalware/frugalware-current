#!/bin/sh

###
# = openoffice-dict.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# openoffice-dict.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for OpenOffice.org dictionary packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=openoffice.org-dict-de
# _F_openoffice_name=de_DE
# dictoptions=('nodict' 'nohyph')
# pkgver=20031107
# pkgrel=2
# pkgdesc="German dictionary for OpenOffice.org."
# rodepends=('openoffice.org')
# groups=('locale-extra')
# archs=('i686' 'x86_64')
# Finclude openoffice-dict
# sha1sums=('31a96c0de139056cf3a0a525c68d6bdf2ce79bae')
# --------------------------------------------------
#
# == OPTIONS
# * _F_openoffice_name: the code of the language in some xx_YY format
# * dictoptions(): possible values: nodict, nohyph, noth for disabling the
# installation of the dictionary, the hyphenation and/or the thesaurus files.
###

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
# * install
###
url="ftp://ftp.services.openoffice.org/pub/OpenOffice.org/contrib/dictionaries/"
# no way to determine pkgver automatically :-/
up2date="$pkgver"
source=(ftp://ftp.services.openoffice.org/pub/OpenOffice.org/contrib/dictionaries/$_F_openoffice_name-pack.zip)
install=$Fincdir/openoffice-dict.install

# don't document this, should not be used from FrugalBuilds
_F_openoffice_option() {
	local i
	for i in ${dictoptions[@]}; do
		local uc=`echo $i | tr [:lower:] [:upper:]`
		local lc=`echo $i | tr [:upper:] [:lower:]`
		if [ "$uc" = "$1" -o "$lc" = "$1" ]; then
			echo $1
			return
		fi
	done
}

###
# == APPENDED VARIABLES
# * genscriptlet to options()
###
options=(${options[@]} 'genscriptlet')

###
# == PROVIDED FUNCTIONS
# * Fopenoffice_dictbuild()
###
Fopenoffice_dictbuild()
{
	for i in *.zip
	do
		unzip -qqn $i
	done

	if [ ! "`_F_openoffice_option NODICT`" ]; then
		if [ -e $_F_openoffice_name.aff ]; then
			Ffile /usr/lib/openoffice.org/share/dict/ooo/$_F_openoffice_name.aff
		fi
		if [ -e $_F_openoffice_name.dic ]; then
			Ffile /usr/lib/openoffice.org/share/dict/ooo/$_F_openoffice_name.dic
		fi
	fi
	if [ ! "`_F_openoffice_option NOHYPH`" ]; then
		if [ -e hyph_$_F_openoffice_name.dic ]; then
			Ffile /usr/lib/openoffice.org/share/dict/ooo/hyph_$_F_openoffice_name.dic
		fi
	fi
	if [ ! "`_F_openoffice_option NOTH`" ]; then
		if [ -e th_$_F_openoffice_name.dat ]; then
			Ffile /usr/lib/openoffice.org/share/dict/ooo/th_$_F_openoffice_name.dat
		fi
		if [ -e th_$_F_openoffice_name.idx ]; then
			Ffile /usr/lib/openoffice.org/share/dict/ooo/th_$_F_openoffice_name.idx
		fi
	fi
}

###
# * build() just calls Fopenoffice_dictbuild()
###
build()
{
	Fopenoffice_dictbuild
}
