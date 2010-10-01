#!/bin/sh

###
# = gnome-scriptlet.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# gnome-scriptlet.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for GNOME packages using scriplets.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=notification-daemon
# pkgver=0.3.6
# pkgrel=1
# pkgdesc="Galago Desktop Presence Framework - Desktop Notification Daemon"
# url="http://www.galago-project.org"
# depends=('libnotify>=0.4.3' 'libwnck' 'libsexy' 'gconf' 'dbus-glib>=0.71')
# makedepends=('gnome-doc-utils' 'intltool')
# groups=('gnome')
# archs=('i686' 'x86_64')
# source=($url/files/releases/source/$pkgname/$pkgname-$pkgver.tar.bz2)
# up2date="lynx -dump http://www.galago-project.org/files/releases/source/$pkgname | Flasttar"
# options=('scriptlet')
# _F_gnome_schemas=('/etc/gconf/schemas/notification-daemon.schemas')
# _F_gnome_desktop="y"
# _F_gnome_scrollkeeper="y"
# Finclude gnome-scriptlet
# sha1sums=('e43940d202e6af08ac69ec8129fa52be2a99300d')
# --------------------------------------------------
# NOTE: Please don't forget to include the necessary packgages (rarian,
# desktop-file-utils etc.) in the depends(). At the moment gnome-scriptlet.sh
# won't do this for you.
#
# == OPTIONS
# * _F_gnome_schemas() - if declared, gconf will be called to register them
# * _F_gnome_glib() - set to "y" for register schemas glib into /usr/share/glib-2.0/schemas
# * _F_gnome_entries() - same as above except for gconf .entries files
# * _F_gnome_desktop - set to "y" if your package provides a .desktop file
# * _F_gnome_scrollkeeper - set to "y" if you want to run rarian
# * _F_gnome_mime - set to "y" if your package provides a mime type
# * _F_gnome_iconcache - set to "y" if your package provides an icon in
# /usr/share/icons/hicolor
# * _F_gnome_scriptlet - name of the generated install script (defaults to
# src/gnome-scriptlet.install)
###
if [ -z "$_F_gnome_scriptlet" ]; then
	_F_gnome_scriptlet="src/gnome-scriptlet.install"
fi

if [ -n "$_F_gnome_schemas" ]; then
	Fconfopts="$Fconfopts --disable-schemas-install"
fi
if [ -n "$_F_gnome_scrollkeeper" ]; then
	Fconfopts="$Fconfopts --disable-scrollkeeper"
fi
if [ -n "$_F_gnome_desktop" ]; then
	Fconfopts="$Fconfopts --enable-desktop-update=no"
fi
if [ -n "$_F_gnome_mime" ]; then
	Fconfopts="$Fconfopts --disable-update-mimedb --enable-mime-update=no"
fi

###
# == OVERWRITTEN VARIABLES
# * install
###
install="$_F_gnome_scriptlet"

###
# == APPENDED VARIABLES
# * genscriptlet to options()
###
options=(${options[@]} 'genscriptlet')

###
# == PROVIDED FUNCTIONS
# * Fbuild_slice_scrollkeeper() removes scrollkeeper-update from Makefile.in
# and omf.make
###
Fbuild_slice_scrollkeeper()
{
	find . -name Makefile.in -exec sed -i -e 's/-scrollkeeper-update.*//' {} \;
	if [ -f omf.make ]; then
		sed -i -e 's/-scrollkeeper-update.*//' omf.make
	fi
}

###
# * Fbuild_gnome_scriptlet() generates a scriptlet for the given package from
# the template according to the declared options
###
Fbuild_gnome_scriptlet()
{
	local i str

	cp $Fincdir/gnome-scriptlet.install $Fsrcdir
	if [ -n "$_F_gnome_schemas" ]; then
		for i in "${_F_gnome_schemas[@]}"
		do
			if [ -z "$str" ]; then
				str="'$i'\n"
			else
				str="$str\t'$i'\n"
			fi
		done
	fi
	Fsed '$_F_gnome_schemas' "$str" ${Fsrcdir%/src}/$_F_gnome_scriptlet
	str=''
	if [ -n "$_F_gnome_entries" ]; then
		for i in "${_F_gnome_entries[@]}"
		do
			if [ -z "$str" ]; then
				str="'$i'\n"
			else
				str="$str\t'$i'\n"
			fi
		done
	fi
	Fsed '$_F_gnome_entries' "$str" ${Fsrcdir%/src}/$_F_gnome_scriptlet
	Fsed '$_F_gnome_glib' "$_F_gnome_glib" ${Fsrcdir%/src}/$_F_gnome_scriptlet
	Fsed '$_F_gnome_desktop' "$_F_gnome_desktop" ${Fsrcdir%/src}/$_F_gnome_scriptlet
	Fsed '$_F_gnome_scrollkeeper' "$_F_gnome_scrollkeeper" ${Fsrcdir%/src}/$_F_gnome_scriptlet
	Fsed '$_F_gnome_mime' "$_F_gnome_mime" ${Fsrcdir%/src}/$_F_gnome_scriptlet
	Fsed '$_F_gnome_iconcache' "$_F_gnome_iconcache" ${Fsrcdir%/src}/$_F_gnome_scriptlet
}

###
# * build() just includes Fbuild_slice_scrollkeeper and Fbuild_gnome_scriptlet
# in the default build() (and disables the schema installation on make install)
###
build()
{
	Fbuild_slice_scrollkeeper
	Fpatchall
	Fmake
	if [ -n "$_F_gnome_schemas" ]; then
		Fmakeinstall GCONF_DISABLE_SCHEMA_INSTALL=1
	else
		Fmakeinstall
	fi
	Fbuild_gnome_scriptlet
}
