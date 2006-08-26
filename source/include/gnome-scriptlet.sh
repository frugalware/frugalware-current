#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# gnome-scriptlet. for Frugalware
# distributed under GPL License

# common scheme for kernel FrugalBuilds

# usage:
# _F_gnome_schemas() - if declared, gconf will be called to register them
# _F_gnome_entries() - same as above except for gconf .entries files
# _F_gnome_desktop - set to "y" if your package provides a .desktop file
# _F_gnome_scrollkeeper - set to "y" if you want to run scrollkeeper
# _F_gnome_mime - set to "y" if your package provides a mime type
# _F_gnome_iconcache - set to "y" if your package provides an icon in /usr/share/icons/hicolor
# _F_gnome_name - name of the generated install script
#                 (defaults to src/gnome-scriptlet.install)

if [ -z "$_F_gnome_name" ]; then
	_F_gnome_name="src/gnome-scriptlet.install"
fi
install="$_F_gnome_name"

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
	Fsed '$_F_gnome_schemas' "$str" ${Fsrcdir%/src}/$_F_gnome_name
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
	Fsed '$_F_gnome_entries' "$str" ${Fsrcdir%/src}/$_F_gnome_name
	Fsed '$_F_gnome_desktop' "$_F_gnome_desktop" ${Fsrcdir%/src}/$_F_gnome_name
	Fsed '$_F_gnome_scrollkeeper' "$_F_gnome_scrollkeeper" ${Fsrcdir%/src}/$_F_gnome_name
	Fsed '$_F_gnome_mime' "$_F_gnome_mime" ${Fsrcdir%/src}/$_F_gnome_name
	Fsed '$_F_gnome_iconcache' "$_F_gnome_iconcache" ${Fsrcdir%/src}/$_F_gnome_name
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
