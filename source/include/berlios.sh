#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# (c) 2005-2006 Priyank Gosalia <priyank@frugalware.org>
# berlios.sh for Frugalware
# distributed under GPL License

# sets url, up2date and source() for a typical berlios project

if ! [ -z "$realname" ]; then
	name=$realname
else
	name=$pkgname
fi

url="http://developer.berlios.de/projects/$name"

if [ -z "$_F_berlios_prefix" ]; then
	up2date="lynx -dump http://developer.berlios.de/project/showfiles.php?group_id=\$(lynx -dump $url| grep -m1 showfiles | sed -e 's/.*id=\(.*\)\&.*/\1/;q') | sed -e '1,/$name/d;//{s/ *[^ ]* *\([^ ]*\).*/\1/;q;};d'"
else
	up2date="lynx -dump http://developer.berlios.de/project/showfiles.php?group_id=\$(lynx -dump $url| grep -m1 showfiles | sed -e 's/.*id=\(.*\)\&.*/\1/;q') | sed -e '1,/$name/d;//{s/ *[^ ]$_F_berlios_prefix\([^ ]*\).*/\1/;q;};d'"
fi

if [ -z "$_F_berlios_ext" ]; then
	source=(http://download.berlios.de/$name/$name-$pkgver.tar.gz)
else
	source=(http://download.berlios.de/$name/$name-$pkgver$_F_berlios_ext)
fi

unset realname _F_berlios_prefix _F_berlios_ext
