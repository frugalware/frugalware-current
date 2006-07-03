#!/bin/sh

# (c) 2003-2006 Miklos Vajna <vmiklos@frugalware.org>
# gnome.sh for Frugalware
# distributed under GPL License

# up2date and source() macro for gnome packages

if ! [ -z "$realname" ]; then
	name=$realname
else
	name=$pkgname
fi

pkgurl="http://ftp.gnome.org/pub/GNOME/sources"

if [ "$nondevel" == "1" ]; then
	up2date="lynx -dump $pkgurl/$name/\$(lynx -dump $pkgurl/$name/?C=N\;O=D|grep '/'|sed -ne 's|.*]\(.*\)/.*|\1|' -e '1 p')/|grep ]LA|sed 's/.*S-\([0-9\.]*\).*/\1/'"
else
	up2date="lynx -dump $pkgurl/$name/\$(lynx -dump $pkgurl/$name/?C=N\;O=D|grep '[0-9]\.[0-9]*[02468]/'|sed -ne 's|.*]\(.*\)/.*|\1|' -e '1 p')/|grep ]LA|sed 's/.*S-\([0-9\.]*\).*/\1/'"
fi

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

source=(http://ftp.gnome.org/pub/gnome/sources/$pkgname/$tmpver/$name-$pkgver.tar.bz2)

options=(${options[@]} 'scriptlet')

unset realname
unset nondevel
unset tmpver
unset count
