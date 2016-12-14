#!/bin/sh

###
# = berlios.sh(3)
# Priyank Gosalia <priyank@frugalware.org>
#
# == NAME
# berlios.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages hosted at berios.
#
# == EXAMPLE
# --------------------------------------------------
# # Compiling Time: 0.01 SBU
# # Maintainer: Christian Hamar alias krix <krics@linuxforum.hu>
#
# pkgname=sonata
# pkgver=1.0.1
# pkgrel=1
# pkgdesc="Sonata is a lightweight GTK+ music client for the Music Player Daemon (MPD)."
# _F_berlios_ext=".tar.bz2"
# Finclude berlios
# depends=('mpd' 'pygtk')
# options=('scriptlet')
# groups=('xapps-extra')
# archs=('x86_64')
# sha1sums=('e771538c1fc4f6299efc4699acffd8af7d529417')
# --------------------------------------------------
#
# == OPTIONS
# * _F_berlios_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
# * _F_berlios_ext (defaults to .tar.gz): extension of the source tarball
# * _F_berlios_dirname (default to $_F_berlios_name): if the source tarball
# uses a name different to the berlios project name, then use this option to
# declare the project name
###
if [ -z "$_F_berlios_name" ]; then
	_F_berlios_name=$pkgname
fi

if [ -z "$_F_berlios_ext" ]; then
        _F_berlios_ext=".tar.gz"
fi

if [ -z "$_F_berlios_dirname" ]; then
        _F_berlios_dirname="$_F_berlios_name"
fi

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
###
url="http://developer.berlios.de/projects/$_F_berlios_dirname"
up2date="lynx -dump http://developer.berlios.de/project/showfiles.php?group_id=\$(lynx -dump $url| grep -m1 showfiles | sed -e 's/.*id=\(.*\)\&.*/\1/;q') | grep -m1 '$_F_berlios_name-\(.*\)$_F_berlios_ext'| sed 's/.*$_F_berlios_name-\(.*\)$_F_berlios_ext.*/\1/;s/-/_/g;s/$pkgextraver//'"
source=(http://download.berlios.de/$_F_berlios_dirname/$_F_berlios_name-${pkgver//_/-}${pkgextraver//_/-}$_F_berlios_ext)
