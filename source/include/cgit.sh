#!/bin/sh

Finclude provider

###
# = cgit.sh(3)
# Michel Hermier <ihermier@frugalware.org>
#
# == NAME
# cgit.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages reachable via cgit.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=scim-uim
# pkgver=0.1.4
# pkgrel=1
# pkgdesc="UIM input method for SCIM."
# _F_cgit_dirname="scim"
# Finclude cgit
# url="http://www.scim-im.org/"
# purl="http://cgit.net/project/showfiles.php?group_id=108454"
# depends=('scim>=1.4.4' 'uim')
# options=('scriptlet')
# groups=('xapps-extra')
# archs=('i686' 'x86_64')
# sha1sums=('9023c205cb1623e749bd5ca7baf721c55f36f279')
# --------------------------------------------------
###

USE_DEVEL="${USE_DEVEL:-"n"}"

###
# == OPTIONS
# * _F_cgit_url (required): Base cgit url.
# * _F_cgit_dirname (defaults to $pkgname): dirname where the pkg is avalable. 
# * _F_cgit_scmurl (required if USE_DEVEL): Base git url for cloning.


# * _F_cgit_dirname (default to $pkgname): if the source
# tarball uses a name different to the cgit project name, then use this
# option to declare the project name
# * _F_cgit_sep (defaults to "-"): used for source() and up2date. As example
# for an "baz_1.2.3.tar.gz" tarball you should use _F_cgit_sep="_", for empty
# values use _F_cgit_sep="None" that way you can dowload such foo1234.tgz
# * _F_cgit_pkgver (defaults to $pkgver): Some packages are called foo-1.2.3
# but the source is called different from $pkgver, e.g: foo-123 or foo-12.3, in such
# a case _F_cgit_pkgver may help to avoid custom $source
# * _F_cgit_subdir (defaults to ""): in case the source tarball
# is in some subdirectory under the files of the project. Example:
# "/fsarchiver-src/"
###

_F_provider_name='cgit' \
_F_provider_default_ext='.tar.bz2' \
Fprovider_init

#echo "dirname: $_F_cgit_dirname"
if [ -z "${_F_cgit_dirname}" ]; then
	_F_cgit_dirname="${pkgname}"
fi

#echo "name: $_F_cgit_name"
if [ -z "${_F_cgit_name}" ]; then
	_F_cgit_name="$(basename "${_F_cgit_dirname}")"
fi

# fixme
#echo "pkgver: $_F_cgit_pkgver"
if [ -z "$_F_cgit_pkgver" ]; then
	_F_cgit_pkgver="$pkgver"
fi

###
# * _F_cgit_ext (defaults to .tar.bz2): extension of the source tarball.
#   Cgit do not allways show the links but actually supports it, so change
#   the default value, if really necessary.
#   Do not use:
#   - .tar.gz: Using it produce signatures that vary with time.
#   - .tar.xz: Until it is really wide spreaded (explicitly supported)
###
if [ -z "$_F_cgit_ext" ]; then
	_F_cgit_ext=".tar.bz2"
fi

if [ -z "$_F_cgit_sep" ]; then
	_F_cgit_sep="$Fpkgversep"
fi

if [ -n "$_F_cgit_sep" ] && [ "$_F_cgit_sep" = "None" ]; then
	_F_cgit_sep=""
fi

if [ -z "$_F_cgit_pkgurl" ]; then
	_F_cgit_pkgurl="$_F_cgit_url/$_F_cgit_dirname"
fi

###
# == OVERWRITTEN VARIABLES
# * url
# * _F_archive_name
# * Fpkgversep
# * pkgver (defaults to sanitised version of _F_cgit_pkgver if not set)
# * up2date
# * source() 
# * _F_scm_type
# * _F_scm_url
###
if [ -z "$url" ]; then
	url="$_F_cgit_pkgurl"
fi
if [ -z "$_F_archive_name" ]; then
	_F_archive_name="$_F_cgit_name"
fi
Fpkgversep=$_F_cgit_sep
if [ -z "$pkgver" ]; then
	pkgver="$(Fsanitizeversion "$_F_cgit_pkgver")"
fi

if Fuse DEVEL; then
	_F_scm_type="git"
	_F_scm_url="$_F_cgit_scmurl"
	Finclude scm
else
	if [ -z "$up2date" ]; then
		up2date="Fcgit_lastarchive \"$_F_cgit_pkgurl\""
	fi
	if [ "${#source[@]}" -eq 0 ]; then
		source=("$_F_cgit_pkgurl/snapshot/${_F_cgit_name}${_F_cgit_sep}${_F_cgit_pkgver}${_F_cgit_ext}")
	fi
fi

Fcgit_lastarchive_filter="${Flasttar_filter}\\|${Flastzip_filter}"
Fcgit_lastarchive() {
	Flastarchive "$1" "${Fcgit_lastarchive_filter}"
}

Fcgit_build()
{
	if Fuse DEVEL; then
		Funpack_scm
	fi
	Fbuild
}

build()
{
	Fcgit_build
}
