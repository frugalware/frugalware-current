#!/bin/sh

###
# = launchpad.sh(3)
# Devil505 <devil505linux@gmail.com>
#
# == NAME
# launchpad.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages hosted at launchpad
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=dexter
# pkgver=0.15.1
# pkgrel=1
# pkgdesc="Dexter, a sexy, simple address book with end users in mind."
# depends=('pygtk' 'dbus-python' 'postler' 'python-distutils-extra' 'vobject' 'pyenchant' 'storm')
# makedepends=('intltool')
# groups=('xapps-extra')
# archs=('i686' 'x86_64')
# _F_launchpad_dirname="dexter-rolodex"
# _F_launchpad_sep="_"
# _F_launchpad_branch="0.x"
# Finclude launchpad
# _F_cd_path="dexter-rolodex"
# sha1sums=('0de257bb0b82becd1cf6886313a55a359d8e662b')
# --------------------------------------------------
#
# == OPTIONS
# * _F_launchpad_name (defaults to $pkgname): if you want to use a custom
# package name (for example the upstream name contains uppercase letters) then
# use this to declare the real name
# * _F_launchpad_dirname (defaults to $_F_launchpad_name): if the
# source tarball uses a name different to the launchpad name, then use
# this option to declare the project name
# * _F_launchpad_ext (defaults to .tar.gz): extension of the source tarball
# * _F_launchpad_sep ( defaults to - ): used for source() only right now. As example
# for an "baz_1.2.3.tar.gz" tarball you should use _F_launchpad_sep="_" , for empty
# values use _F_launchpad_sep="None" that way you can dowload such foo1234.tgz
# _F_launchpad_branch ( defaults to trunk): indicate the branch, trunk for most cases
###

if [ -z "$_F_launchpad_name" ]; then
	_F_launchpad_name=$pkgname
fi

if [ -z "$_F_launchpad_dirname" ]; then
	_F_launchpad_dirname="$_F_launchpad_name"
fi

if [ -z "$_F_launchpad_ext" ]; then
	_F_launchpad_ext=".tar.gz"
fi

if [ -z "$_F_launchpad_sep" ]; then
	_F_launchpad_sep="-"
fi

if [ -n "$_F_launchpad_sep" ] && [ "$_F_launchpad_sep" = "None" ]; then
        _F_launchpad_sep=""
fi

if [ -z "$_F_launchpad_branch" ]; then
	_F_launchpad_sep="trunk"
fi
###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
###
url="https://launchpad.net/$_F_launchpad_dirname"
_F_archive_name="$_F_launchpad_name"
Fpkgversep="$_F_launchpad_sep"
up2date="Flasttar $url"
source=($url/$_F_launchpad_branch/$pkgver/+download/${_F_launchpad_name}${_F_launchpad_sep}${pkgver//_/-}${_F_launchpad_ext})
