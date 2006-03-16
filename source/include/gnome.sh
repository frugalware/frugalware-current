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

preup2date=`echo $pkgver|sed 's/\([0-9]\+\.[0-9]\+\).*$/\1/'`

pkgurl="http://ftp.gnome.org/pub/GNOME/sources"

if [ "$nondevel" == "1" ]; then
	up2date="lynx -dump $pkgurl/$name/\$(lynx -dump $pkgurl/$name/?C=N\;O=D|grep '/'|sed -ne 's|.*]\(.*\)/.*|\1|' -e '1 p')/|grep ]LA|sed 's/.*S-\([0-9\.]*\).*/\1/'"
else
	up2date="lynx -dump $pkgurl/$name/\$(lynx -dump $pkgurl/$name/?C=N\;O=D|grep '[0-9]\.[0-9]*[02468]/'|sed -ne 's|.*]\(.*\)/.*|\1|' -e '1 p')/|grep ]LA|sed 's/.*S-\([0-9\.]*\).*/\1/'"
fi

source=(http://ftp.gnome.org/pub/gnome/sources/$pkgname/$preup2date/$name-$pkgver.tar.bz2)

unset realname
unset nondevel
