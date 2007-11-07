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
# * _F_sourceforge_name (defaults to $pkgname): if you want to use a custom
# package name (for example the upstream name contains uppercase letters) then
# use this to declare the real name
# * _F_sourceforge_mirror (defaults to mesh): the sourceforge mirror to use
# * _F_sourceforge_dirname (default to $_F_sourceforge_name): if the source
# tarball uses a name different to the sourceforge project name, then use this
# option to declare the project name
# * _F_sourceforge_ext (defaults to .tar.gz): extension of the source tarball
# * _F_sourceforge_broken_up2date: if set, try an other method for up2date, try
# this if the normal up2date does not work, maybe this will
# *_F_sourceforge_prefix (no defaults):  used to correct the up2date output
# As example $pkgver should be 1.2.3 but you get V1.2.3 in such a case you can
# set _F_sourceforge_prefix="V"
# *_F_sourceforge_sep ( defaults to - ): used for source() only right now. As example
# for an "baz_1.2.3.tar.gz" tarball you should use _F_sourceforge_sep="_"
###
if [ -z "$_F_sourceforge_name" ]; then
	_F_sourceforge_name=$pkgname
fi

if [ -z "$_F_sourceforge_mirror" ]; then
	# set our preferred mirror
	_F_sourceforge_mirror="mesh"
fi

if [ -z "$_F_sourceforge_dirname" ]; then
	_F_sourceforge_dirname="$_F_sourceforge_name"
fi

if [ -z "$_F_sourceforge_ext" ]; then
	_F_sourceforge_ext=".tar.gz"
fi

if [ -z "$_F_sourceforge_broken_up2date" ]; then
        _F_sourceforge_broken_up2date=0
fi

if [ -z "$_F_sourceforge_sep" ]; then
	_F_sourceforge_sep="-"
fi

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
###
url="http://sourceforge.net/projects/$_F_sourceforge_dirname"
if [ $_F_sourceforge_broken_up2date -eq 0 ]; then
	up2date="lynx -dump http://sourceforge.net/project/showfiles.php?group_id=\$(lynx -dump $url|grep showfiles|sed 's/.*=\(.*\)/\1/;q')|grep -m1 'Latest \[.*\]'|sed 's/.*]$_F_sourceforge_prefix\(.*\) \[.*\].*/\1/;s/-/_/g'"
else
 	up2date="lynx -dump http://sourceforge.net/project/showfiles.php?group_id=\$(lynx -dump $url|grep showfiles|sed 's/.*=\(.*\)/\1/;q')|grep -m1 '$_F_sourceforge_name\(.*\)$_F_sourceforge_ext'|sed 's/.*$_F_sourceforge_name$_F_sourceforge_prefix\(.*\)$_F_sourceforge_ext.*/\1/;s/-/_/g;s/_//1'"
fi
source=(http://${_F_sourceforge_mirror}.dl.sourceforge.net/sourceforge/$_F_sourceforge_dirname/$_F_sourceforge_name$_F_sourceforge_sep${pkgver//_/-}$_F_sourceforge_ext)
