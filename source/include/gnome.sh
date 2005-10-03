#!/bin/sh

# (c) 2003-2005 Miklos Vajna <vmiklos@frugalware.org>
# gnome.sh for Frugalware
# distributed under GPL License

# up2date macro for gnome packages

if ! [ -z "$realname" ]; then
	name=$realname
else
	name=$pkgname
fi

if [ "$nondevel" == "1" ]; then
	preup2date=`lynx -dump http://ftp.gnome.org/pub/GNOME/sources/$name/?C=N\;O=D|grep '/'|sed -ne 's|.*]\(.*\)/.*|\1|' -e '1 p'`
else
	preup2date=`lynx -dump http://ftp.gnome.org/pub/GNOME/sources/$name/?C=N\;O=D|grep '[0-9]\.[0-9]*[02468]/'|sed -ne 's|.*]\(.*\)/.*|\1|' -e '1 p'`
fi
up2date="lynx -dump http://ftp.gnome.org/pub/GNOME/sources/$name/$preup2date/|grep ]LA|sed 's/.*S-\([0-9\.]*\).*/\1/'"
unset realname
unset nondevel
