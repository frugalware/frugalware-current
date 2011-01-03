#!/bin/sh

###
# = sourceforge.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# sourceforge.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages hosted at SourceForge.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=scim-uim
# pkgver=0.1.4
# pkgrel=1
# pkgdesc="UIM input method for SCIM."
# _F_sourceforge_dirname="scim"
# Finclude sourceforge
# url="http://www.scim-im.org/"
# purl="http://sourceforge.net/project/showfiles.php?group_id=108454"
# depends=('scim>=1.4.4' 'uim')
# options=('scriptlet')
# groups=('xapps-extra')
# archs=('i686' 'x86_64')
# sha1sums=('9023c205cb1623e749bd5ca7baf721c55f36f279')
# --------------------------------------------------
#
# == OPTIONS
# * _F_sourceforge_name (defaults to $pkgname): same as _F_sourceforge_realname
# but it can be used for both source() and up2date
# * _F_sourceforge_mirror (defaults to downloads): the sourceforge mirror to use
# * _F_sourceforge_dirname (default to $pkgname): if the source
# tarball uses a name different to the sourceforge project name, then use this
# option to declare the project name
# * _F_sourceforge_ext (defaults to .tar.gz): extension of the source tarball
# * _F_sourceforge_prefix (no defaults): used to correct the up2date output
# As example $pkgver should be 1.2.3 but you get V1.2.3 in such a case you can
# set _F_sourceforge_prefix="V"
# * _F_sourceforge_sep (defaults to "-"): used for source() and up2date. As example
# for an "baz_1.2.3.tar.gz" tarball you should use _F_sourceforge_sep="_", for empty
# values use _F_sourceforge_sep="None" that way you can dowload such foo1234.tgz
# * _F_sourceforge_pkgver (defaults to $pkgver): Some packages are called foo-1.2.3
# but the source is called different from $pkgver, e.g: foo-123 or foo-12.3, in such
# a case _F_sourceforge_pkgver may help to avoid custom $source
# * _F_sourceforge_subdir (defaults to ""): in case the source tarball
# is in some subdirectory under the files of the project. Example:
# "/fsarchiver-src/"
###

if [ -z "$_F_sourceforge_name" ]; then
	_F_sourceforge_name=$pkgname
fi

if [ -z "$_F_sourceforge_pkgver" ]; then
	_F_sourceforge_pkgver=${pkgver//_/-}
fi

if [ -z "$_F_sourceforge_mirror" ]; then
	# set our preferred mirror
	_F_sourceforge_mirror="downloads"
	#_F_sourceforge_mirror="dfn"
fi

if [ -z "$_F_sourceforge_dirname" ]; then
	_F_sourceforge_dirname=$pkgname
fi

if [ -z "$_F_sourceforge_ext" ]; then
	_F_sourceforge_ext=".tar.gz"
fi

if [ -z "$_F_sourceforge_sep" ]; then
	_F_sourceforge_sep="-"
fi

if [ -n "$_F_sourceforge_sep" ] && [ "$_F_sourceforge_sep" = "None" ]; then
	_F_sourceforge_sep=""
fi

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
###
_F_sourceforge_url="http://sourceforge.net/projects/$_F_sourceforge_dirname"
_F_sourceforge_id="\$(Fwcat $_F_sourceforge_url/ | grep --color project-id | sed -e 's|.*project-id/||;s|/.*||')"
_F_sourceforge_rss_url="http://sourceforge.net/api/file/index/project-id/$_F_sourceforge_id/mtime/desc/limit/20/rss"
if [ -z "$url" ]; then
	url="$_F_sourceforge_url"
fi
_F_archive_name=$_F_sourceforge_name
_F_archive_prefix=$_F_sourceforge_prefix
Fpkgversep=$_F_sourceforge_sep
up2date="lynx -dump $_F_sourceforge_rss_url | \
	egrep '/$_F_sourceforge_name$_F_sourceforge_sep.*$_F_sourceforge_ext' | \
	sed -e 's|.*$_F_sourceforge_name$_F_sourceforge_sep$_F_sourceforge_prefix||;s|$_F_sourceforge_ext.*||' | \
	Fsort | tac | \
	head -n 1"

source=("http://${_F_sourceforge_mirror}.sourceforge.net/${_F_sourceforge_dirname}/${_F_sourceforge_name}${_F_sourceforge_sep}${_F_sourceforge_pkgver}${_F_sourceforge_ext}")


