#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# gnome-scriptlet. for Frugalware
# distributed under GPL License

# common scheme for kernel FrugalBuilds

# usage:
# _F_gnome_schemas() - if declared, gconf will be called to register them
# _F_gnome_desktop - set to "y" if your package provides a .desktop file
# _F_gnome_scrollkeeper - set to "y" if you want to run scrollkeeper
# _F_gnome_mime - set to "y" if your package provides a mime type

install="src/gnome-scriptlet.install"

if [ -n "$_F_gnome_schemas" ]; then
	Fconfopts="$Fconfopts --disable-schemas-install"
fi
if [ -n "$_F_gnome_scrollkeeper" ]; then
	Fconfopts="$Fconfopts --disable-scrollkeeper"
fi
if [ -n "$_F_gnome_mime" ]; then
	Fconfopts="$Fconfopts --disable-update-mimedb"
fi

Fbuild_slice_scrollkeeper()
{
	find . -name Makefile.in -exec sed -i -e 's/-scrollkeeper-update.*//' {} \;
	if [ -f omf.make ]; then
		sed -i -e 's/-scrollkeeper-update.*//' omf.make
	fi
}

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
	Fsed '$_F_gnome_schemas' "$str" $Fsrcdir/gnome-scriptlet.install
	Fsed '$_F_gnome_desktop' "$_F_gnome_desktop" $Fsrcdir/gnome-scriptlet.install
	Fsed '$_F_gnome_scrollkeeper' "$_F_gnome_scrollkeeper" $Fsrcdir/gnome-scriptlet.install
	Fsed '$_F_gnome_mime' "$_F_gnome_mime" $Fsrcdir/gnome-scriptlet.install
}

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
