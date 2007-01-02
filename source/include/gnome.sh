#!/bin/sh

# (c) 2003-2006 Miklos Vajna <vmiklos@frugalware.org>
# gnome.sh for Frugalware
# distributed under GPL License

# up2date and source() macro for gnome packages

if [ -z "$_F_gnome_name" ]; then
	_F_gnome_name=$pkgname
fi

_F_gnome_devel="n" # temp. hack for bumping to 2.15

_F_gnome_getver()
{
	local tmpver count

	tmpver=`echo $pkgver | tr -d '[0-9][a-z]'`
	count=`expr length "$tmpver"`

	case $count in
	    1)
	    tmpver="$pkgver"
	    ;;
	    2)
	    tmpver="${pkgver%.*}"
	    ;;
	    3)
	    tmpver="${pkgver%.*.*}"
	    ;;
	esac
	echo $tmpver
}

pkgurl="http://ftp.gnome.org/pub/GNOME/sources"

if [ -n "$_F_gnome_devel" ]; then
	up2date="lynx -dump $pkgurl/$_F_gnome_name/\$(lynx -dump $pkgurl/$_F_gnome_name/?C=N\;O=D|grep '/'|sed -ne 's|.*]\(.*\)/.*|\1|' -e '1 p')/|grep ]LA|sed 's/.*S-\([0-9\.]*\).*/\1/'"
else
	up2date="lynx -dump $pkgurl/$_F_gnome_name/\$(lynx -dump $pkgurl/$_F_gnome_name/?C=N\;O=D|grep '[0-9]\.[0-9]*[02468]/'|sed -ne 's|.*]\(.*\)/.*|\1|' -e '1 p')/|grep ]LA|sed 's/.*S-\([0-9\.]*\).*/\1/'"
fi

source=(http://ftp.gnome.org/pub/gnome/sources/$_F_gnome_name/`_F_gnome_getver`/$_F_gnome_name-$pkgver.tar.bz2)

options=(${options[@]} 'scriptlet')

_F_gnome_pygtkdefsdir="usr/share/pygtk/2.0/defs"
