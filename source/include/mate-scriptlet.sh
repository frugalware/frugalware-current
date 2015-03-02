#!/bin/sh

###
# = mate-scriptlet.sh(3)
# Anthony Jorion <pingax@frugalware.org>
#
# == NAME
# mate-scriptlet.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for MATE packages using scriplets.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=notification-daemon
# pkgver=0.3.6
# pkgrel=1
# pkgdesc="Galago Desktop Presence Framework - Desktop Notification Daemon"
# url="http://www.galago-project.org"
# depends=('libnotify>=0.4.3' 'libwnck' 'libsexy' 'gconf' 'dbus-glib>=0.71')
# makedepends=('mate-doc-utils' 'intltool')
# groups=('mate')
# archs=('i686' 'x86_64')
# source=($url/files/releases/source/$pkgname/$pkgname-$pkgver.tar.bz2)
# up2date="lynx -dump http://www.galago-project.org/files/releases/source/$pkgname | Flasttar"
# options=('scriptlet')
# _F_mate_schemas=('/etc/gconf/schemas/notification-daemon.schemas')
# _F_mate_desktop="y"
# _F_mate_scrollkeeper="y"
# Finclude mate-scriptlet
# sha1sums=('e43940d202e6af08ac69ec8129fa52be2a99300d')
# --------------------------------------------------
# NOTE: Please don't forget to include the necessary packgages (rarian,
# desktop-file-utils etc.) in the depends(). At the moment mate-scriptlet.sh
# won't do this for you.
#
# == OPTIONS
# * _F_mate_schemas() - if declared, gconf will be called to register them
# * _F_mate_glib() - set to "y" for register schemas glib into /usr/share/glib-2.0/schemas
# * _F_mate_entries() - same as above except for gconf .entries files
# * _F_mate_desktop - set to "y" if your package provides a .desktop file
# * _F_mate_scrollkeeper - set to "y" if you want to run rarian
# * _F_mate_mime - set to "y" if your package provides a mime type
# * _F_mate_iconcache - set to "y" if your package provides an icon in
# /usr/share/icons/hicolor
# * _F_mate_gio - set to "y" for update gio modules into /usr/lib/gio/modules
# * _F_mate_immodules -set to "y" for update gtk.immodules
# * _F_mate_scriptlet - name of the generated install script (defaults to
# src/mate-scriptlet.install)
###
if [ -z "$_F_mate_scriptlet" ]; then
	_F_mate_scriptlet="src/mate-scriptlet.install"
fi

if [ -n "$_F_mate_schemas" ]; then
	Fconfopts+=" --disable-schemas-install"
fi
if [ -n "$_F_mate_scrollkeeper" ]; then
	Fconfopts+=" --disable-scrollkeeper"
fi
if [ -n "$_F_mate_desktop" ]; then
	Fconfopts+=" --enable-desktop-update=no"
fi
if [ -n "$_F_mate_mime" ]; then
	Fconfopts+=" --disable-update-mimedb --enable-mime-update=no"
fi
if [ "$_F_mate_doc" = "y" ]; then
	makedepends=(${makedepends[@]} 'gtk-doc')
	subpkgs=("${subpkgs[@]}" "$pkgname-doc")
	subdescs=("${subdescs[@]}" "$pkgname documention")
	subrodepends=("${subrodepends[@]}" "$pkgname=$pkgver")
	subdepends=("${subdepends[@]}" "gtk+3")
	subgroups=("${subgroups[@]}" 'mate-docs')
	subarchs=("${subarchs[@]}" 'i686 x86_64')
	subreplaces=("${subreplaces[@]}" '')
	subprovides=("${subprovides[@]}" '')

fi

#Split documentation
_F_mate_split_doc()
{
	if [ -d "$Fdestdir/usr/share/mate/help" ]; then
		Fsplit $pkgname-doc usr/share/mate/help
	fi
	if [ -d "$Fdestdir/usr/share/gtk-doc" ]; then
		Fsplit $pkgname-doc usr/share/gtk-doc
	fi
	if [ -d "$Fdestdir/usr/share/doc" ]; then
		Fsplit $pkgname-doc usr/share/doc
	fi
	if [ -d "$Fdestdir/usr/share/man" ]; then
                Fsplit $pkgname-doc usr/share/man
        fi

}
###
# == OVERWRITTEN VARIABLES
# * install
###
install="$_F_mate_scriptlet"

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
# * Fbuild_mate_scriptlet() generates a scriptlet for the given package from
# the template according to the declared options
###
Fbuild_mate_scriptlet()
{
	local i str

	cp $Fincdir/mate-scriptlet.install $Fsrcdir
	if [ -n "$_F_mate_schemas" ]; then
		for i in "${_F_mate_schemas[@]}"
		do
			if [ -z "$str" ]; then
				str="'$i'\n"
			else
				str="$str\t'$i'\n"
			fi
		done
	fi
	Fsed '$_F_mate_schemas' "$str" ${Fsrcdir%/src}/$_F_mate_scriptlet
	str=''
	if [ -n "$_F_mate_entries" ]; then
		for i in "${_F_mate_entries[@]}"
		do
			if [ -z "$str" ]; then
				str="'$i'\n"
			else
				str="$str\t'$i'\n"
			fi
		done
	fi
	Fsed '$_F_mate_entries' "$str" ${Fsrcdir%/src}/$_F_mate_scriptlet
	Fsed '$_F_mate_glib' "$_F_mate_glib" ${Fsrcdir%/src}/$_F_mate_scriptlet
	Fsed '$_F_mate_desktop' "$_F_mate_desktop" ${Fsrcdir%/src}/$_F_mate_scriptlet
	Fsed '$_F_mate_scrollkeeper' "$_F_mate_scrollkeeper" ${Fsrcdir%/src}/$_F_mate_scriptlet
	Fsed '$_F_mate_mime' "$_F_mate_mime" ${Fsrcdir%/src}/$_F_mate_scriptlet
	Fsed '$_F_mate_iconcache' "$_F_mate_iconcache" ${Fsrcdir%/src}/$_F_mate_scriptlet
	Fsed '$_F_mate_gio' "$_F_mate_gio" ${Fsrcdir%/src}/$_F_mate_scriptlet
	Fsed '$_F_mate_immodules' "$_F_mate_immodules" ${Fsrcdir%/src}/$_F_mate_scriptlet
}

###
# * build() just includes Fbuild_slice_scrollkeeper and Fbuild_mate_scriptlet
# in the default build() (and disables the schema installation on make install)
###
build()
{
	Fbuild_slice_scrollkeeper
	Fpatchall
	Fmake
	if [ -n "$_F_mate_schemas" ]; then
		Fmakeinstall GCONF_DISABLE_SCHEMA_INSTALL=1
	else
		Fmakeinstall
	fi
	if [ "$_F_mate_doc" = "y" ]; then
		_F_mate_split_doc
	fi
	Fbuild_mate_scriptlet
}
