#!/bin/sh

###
# = seamonkey-addon.sh(3)
# James Buren <ryuo@frugalware.org>
#
# == NAME
# seamonkey-addon.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for seamonkey addons.
#
# == EXAMPLE
# _F_seamonkey_name=adblock_plus
# _F_seamonkey_ext=-fx+tb+sm.xpi
# pkgver=0.7.5.5
# pkgrel=1
# pkgdesc="Adblock plus makes ads a thing of the past. (seamonkey version)"
# url="https://addons.mozilla.org/en-US/seamonkey/addon/1865"
# source=(https://addons.mozilla.org/en-US/seamonkey/downloads/file/30901/$_F_seamonkey_name$Fpkgversep$pkgver$_F_seamonkey_ext)
# sha1sums=('514f17e8ace564094954de8abb293843a47c637f')
# Finclude seamonkey-addon
#
# == OPTIONS
# * _F_seamonkey_name - used to organize the name of the addon, used in place
# * of the pkgname variable
# * _F_seamonkey_ext - complete file extension from the version number to the
# very end of the file name. (etc, -fx+tb+sm.xpi) defaults to .xpi
# * _F_seamonkey_up2date_url - change url used for default up2date, defaults
# * to $url
###

if [ -z "$_F_seamonkey_name" ]; then
	Fmessage "You must specify the _F_seamonkey_name variable."
	Fdie
else
	pkgname="seamonkey-$_F_seamonkey_name"
fi

[ -z "$_F_seamonkey_ext" ] && _F_seamonkey_ext=.xpi
[ -z "$_F_seamonkey_up2date_url" ] && _F_seamonkey_up2date_url=$url

###
# == OVERWRITTEN VARIABLES
# * rodepends
# * archs
# * groups
# * makedepends
# * up2date
###

rodepends=('seamonkey>=1.1')
archs=('i686' 'x86_64')
groups=('xapps-extra' 'seamonkey-addons')
makedepends=('unzip')
up2date="elinks -dump '$_F_seamonkey_up2date_url' | grep -o \
	'$_F_seamonkey_name$Fpkgversep\(.*\)$_F_seamonkey_ext' | \
	sed 's|$_F_seamonkey_name$Fpkgversep\(.*\)$_F_seamonkey_ext|\1|'"

###
# == PROVIDED FUNCTIONS
# * Fseamonkeyinstall()
###

Fseamonkeyinstall()
{
	if [ -d "$Fsrcdir/chrome" ]; then
		for i in $Fsrcdir/chrome/*; do
			Ffile chrome/`basename $i` /usr/lib/seamonkey/chrome/`basename $i`
		done
	fi
	if [ -d "$Fsrcdir/components" ]; then
		for i in $Fsrcdir/components/*; do
			Ffile components/`basename $i` /usr/lib/seamonkey/components/`basename $i`
		done
	fi
	if [ -d "$Fsrcdir/defaults/preferences" ]; then
		for i in $Fsrcdir/defaults/preferences/*; do
			Ffile defaults/preferences/`basename $i` /usr/lib/seamonkey/defaults/pref/`basename $i`
		done
	fi
	if [ -d "$Fsrcdir/defaults/pref" ]; then
		for i in $Fsrcdir/defaults/pref/*; do
			Ffile defaults/preferences/`basename $i` /usr/lib/seamonkey/defaults/pref/`basename $i`
		done
	fi
}

###
# * build() just calls Fseamonkeyinstall()
###

build()
{
	Fseamonkeyinstall
}
