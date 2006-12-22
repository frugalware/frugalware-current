#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# (c) 2005-2006 Priyank Gosalia <priyank@frugalware.org>
# berlios.sh for Frugalware
# distributed under GPL License

# sets url, up2date and source() for a typical berlios project

if [ -z "$_F_berlios_name" ]; then
	_F_berlios_name=$pkgname
fi

if [ -z "$_F_berlios_ext" ]; then
        _F_berlios_ext=".tar.gz"
fi

url="http://developer.berlios.de/projects/$_F_berlios_name"
up2date="lynx -dump http://developer.berlios.de/project/showfiles.php?group_id=\$(lynx -dump $url| grep -m1 showfiles | sed -e 's/.*id=\(.*\)\&.*/\1/;q') | grep -m1 '$_F_berlios_name-\(.*\)$_F_berlios_ext'| sed 's/.*$_F_berlios_name-\(.*\)$_F_berlios_ext.*/\1/;s/-/_/g'"
source=(http://download.berlios.de/$_F_berlios_name/$_F_berlios_name-${pkgver//_/-}$_F_berlios_ext)
