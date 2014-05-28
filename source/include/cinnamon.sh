#!/bin/sh

###
# = cinnamon.sh(3)
# James Buren <ryuo@frugalware.org>
#
# == NAME
# cinnamon.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for cinnamon packages.
#
# == EXAMPLE
# --------------------------------------------------
# options+=('asneeded')
#
# pkgname=cinnamon-session
# pkgver=2.0.6
# pkgrel=1
# pkgdesc="The Cinnamon Session Handler"
# depends=('gtk+3' 'upower' 'json-glib')
# makedepends=('intltool' 'gnome-doc-utils' 'gobject-introspection>=1.36.0' 'gnome-common')
# groups=('gnome-extra' 'cinnamon')
# archs=('i686' 'x86_64')
# _F_gnome_glib=y
# Finclude cinnamon gnome-scriptlet
# source=(${source[@]} remove-sessionmigration.patch timeout.patch)
# Fconfopts+="-disable-schemas-compile --enable-systemd --disable-gconf"
# sha1sums=('91f1b36af4e7df454fdd3bdb250df3d61b0ee29e' \
#           '65b07f44c9c0b0a3283a92794ac4c9bb18605d86' \
#           '645433c4f078e628ebaf091c233b18262a541d91')
#
# build()
# {
# 	Fbuild
# 	Fbuild_gnome_scriptlet
# }
# --------------------------------------------------
#
# == OPTIONS
# * _F_cinnamon_name (defaults to $pkgname): use if upstream name does not match
# $pkgname
# * _F_cinnamon_ver (defaults to $pkgver): use if upstream version does not match
# $pkgver
# * _F_cinnamon_ext (defaults to .tar.gz): use if you need to change the file
# extension used for downloading the source archive
###
if test -z "$_F_cinnamon_name"; then
  _F_cinnamon_name="$pkgname"
fi
if test -z "$_F_cinnamon_ver"; then
  _F_cinnamon_ver="$pkgver"
fi
if test -z "$_F_cinnamon_ext"; then
  _F_cinnamon_ext=".tar.gz"
fi

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
###
url="http://cinnamon.linuxmint.com"
_baseurl="http://github.com/linuxmint/${_F_cinnamon_name}"
up2date="Fwcat ${_baseurl}/releases | sed -r -n 's|.*>(([0-9]\.)+[0-9]?)<.*|\1|p' | Fsort | tail -n 1"
source=(${_baseurl}/archive/${_F_cinnamon_ver}${_F_cinnamon_ext})
unset _baseurl

###
# == APPENDED VARIABLES
# * scriptlet to options()
###
options=(${options[@]} 'scriptlet')
