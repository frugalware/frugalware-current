#!/bin/sh

# (c) 2005 Miklos Vajna <vmiklos@frugalware.org>
# sourceforge.sh for Frugalware
# distributed under GPL License

# sets url, up2date and source() for a typical sf project

url="http://sourceforge.net/projects/$pkgname"
up2date="lynx -dump http://sourceforge.net/project/showfiles.php?group_id=\$(lynx -dump $url|grep showfiles|sed 's/.*=\(.*\)/\1/;q')|grep 'Release Notes'|sed 's/[^]]*][^]]*]\([^ ]*\) .*/\1/;q'"
source=(http://dl.sourceforge.net/sourceforge/$pkgname/$pkgname-$pkgver.tar.gz)
