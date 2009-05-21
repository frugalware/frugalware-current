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
# up2date="lynx -dump '$purl'|grep -m1 '$pkgname-'|sed 's/.*-\(.*\).tar.gz .*/\1/'"
# sha1sums=('9023c205cb1623e749bd5ca7baf721c55f36f279')
# --------------------------------------------------
#
# == OPTIONS
# * _F_sourceforge_realname (defaults to $_F_sourceforge_auto_realname): if you want to use
# a custom package name (for example the upstream name contains uppercase letters)
# and _F_sourceforge_auto_realname isn't working then use this to declare the real
# name (used in up2date only)
# * _F_sourceforge_name (defaults to $pkgname): same as _F_sourceforge_realname
# but it can be used for both source() and up2date
# * _F_sourceforge_mirror (defaults to mesh): the sourceforge mirror to use
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
#
# == DEPRECATED OPTIONS
# * _F_sourceforge_broken_up2date: it does nothing at the moment and will be removed
# before 1.0 is out
###

if [ -z "$_F_sourceforge_name" ]; then
	_F_sourceforge_name=$pkgname
fi

if [ -z "$_F_sourceforge_pkgver" ]; then
	_F_sourceforge_pkgver=${pkgver//_/-}
fi

if [ -z "$_F_sourceforge_mirror" ]; then
	# set our preferred mirror
	_F_sourceforge_mirror="mesh"
	#_F_sourceforge_mirror="dfn"
fi

if [ -z "$_F_sourceforge_dirname" ]; then
	_F_sourceforge_dirname=$pkgname
fi

if [ -z "$_F_sourceforge_ext" ]; then
	_F_sourceforge_ext=".tar.gz"
fi

if [ -n "$_F_sourceforge_broken_up2date" ]; then
	warning "_F_sourceforge_broken_up2date is deprecated and does nothing at the moment!"
	warning "Please update your FrugalBuild."
	_F_sourceforge_broken_up2date=0
fi

if [ -z "$_F_sourceforge_sep" ]; then
	_F_sourceforge_sep="-"
fi

if [ -n "$_F_sourceforge_sep" ] && [ "$_F_sourceforge_sep" = "None" ]; then
	_F_sourceforge_sep=""
fi

_F_sourceforge_up2date()
{
	local gid="" auto_realname=""
	gid=$(lynx -dump $_F_sourceforge_url|grep showfiles|sed 's/.*=\(.*\)/\1/;s/#downloads$//;q')
	if [ -z "$_F_sourceforge_realname" ]; then
		## Since the realname may differ on each new release of an package
		## we try to set it automatically but only if _F_sourceforge_realname is
		## is not used.
		auto_realname=$(lynx -dump http://sourceforge.net/project/showfiles.php?group_id=$gid | \
			grep -v '       + ' | \
			grep -i -m1 "   \(\[[0-9]\{2,\}\]\)${_F_sourceforge_name} " | \
			sed 's/^[ \t]*//;s/ \[.*//;s/.*]//;s/ _.*//g;s/ \(.*\).*//g')
		_F_sourceforge_realname="$auto_realname"
	fi
	lynx -dump http://sourceforge.net/project/showfiles.php?group_id=$gid | \
		grep -v '       + ' | \
		grep -m1 "   \(\[[0-9]\{2,\}\]\)${_F_sourceforge_realname} " | \
		sed "s/\(\[[0-9]\{2,\}\]\)Release.*//g
			s/.*]//g;s/$_F_sourceforge_prefix\(.*\) \([a-zA-Z]\).*/\1/
			s/${_F_sourceforge_realname}${_F_sourceforge_sep}//g
			s/${_F_sourceforge_realname} //
			s/-/_/g
			s/ _.*//g
			s/ \(.*\).*//g"
}

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
###
_F_sourceforge_url="http://sourceforge.net/projects/$_F_sourceforge_dirname"
if [ -z "$url" ]; then
	url="$_F_sourceforge_url"
fi
# this is needed because without the param tools assume we are using the
# old-style up2dates
up2date="_F_sourceforge_up2date fake_param"
source=(http://${_F_sourceforge_mirror}.dl.sourceforge.net/sourceforge/${_F_sourceforge_dirname}/"${_F_sourceforge_name}"${_F_sourceforge_sep}${_F_sourceforge_pkgver}${_F_sourceforge_ext})
