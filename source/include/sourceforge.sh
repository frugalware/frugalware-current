#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# sourceforge.sh for Frugalware
# distributed under GPL License

# sets url, up2date and source() for a typical sf project

if ! [ -z "$realname" ]; then
	name=$realname
else
	name=$pkgname
fi
url="http://sourceforge.net/projects/$name"
if [ -z "$_F_sourceforge_prefix" ]; then
	up2date="lynx -dump http://sourceforge.net/project/showfiles.php?group_id=\$(lynx -dump $url|grep showfiles|sed 's/.*=\(.*\)/\1/;q')|grep 'Release Notes'|sed 's/[^]]*][^]]*]\([^ ]*\) .*/\1/;q'"
else
	up2date="lynx -dump http://sourceforge.net/project/showfiles.php?group_id=\$(lynx -dump $url|grep showfiles|sed 's/.*=\(.*\)/\1/;q')|grep 'Release Notes'|sed 's/[^]]*][^]]*]$_F_sourceforge_prefix\([^ ]*\) .*/\1/;q'"
fi
if [ -z "$_F_sourceforge_ext" ]; then
	source=(http://dl.sourceforge.net/sourceforge/$name/$name-$pkgver.tar.gz)
else
	source=(http://dl.sourceforge.net/sourceforge/$name/$name-$pkgver.$_F_sourceforge_ext)
fi
unset realname _F_sourceforge_prefix _F_sourceforge_ext
