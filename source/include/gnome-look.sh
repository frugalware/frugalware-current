#!/bin/sh

###
# = gnome-look.sh(3)
# Devil505 <devil505linux@gmail.com>
#
# == NAME
# gnome-look..sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages listed on gnome-look.org.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=somatic-icon-theme
# pkgver=0.2
# pkgrel=1
# pkgdesc="The Somatic icons have been used with permission from David Lanham"
# depends=('icon-naming-utils' 'libpng')
# groups=('xlib-extra')
# archs=('i686' 'x86_64')
# _F_archive_name="ICON-Somatic"
# _F_gnome_look_id="64638"
# Finclude gnome-look
# source=(http://www.mibhouse.org/pokemon_jojo/public/files/$_F_archive_name-$pkgver.tar.gz)
# sha1sums=('9ac4a3b3e920c3d6ef81c29b2f1dcfec7db11ac7')
# --------------------------------------------------
#
# == OPTIONS
# * _F_gnome_look_id : to indicate the content ID of the project on gnome-look.org
###

if [ -n "$_F_gnome_look_id" ]; then
	url="http://www.gnome-look.org/content/show.php?content=$_F_gnome_look_id"
	up2date="lynx -dump "$url"|grep -v http|grep  -m1 '      [0-9.0-9.0-9]'|sed 's/      \(.*\).*/\1/'"
fi

###
# == OVERWRITTEN VARIABLES
# * up2date
# * url
###
