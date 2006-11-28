#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# sourceforge.sh for Frugalware
# distributed under GPL License

# sets url, up2date and source() for a typical sf project

if [ -z "$_F_sourceforge_name" ]; then
	_F_sourceforge_name=$pkgname
fi

if [ -z "$_F_sourceforge_mirror" ]; then
	# set our preferred mirror
	_F_sourceforge_mirror="heanet"
fi

if [ -z "$_F_sourceforge_dirname" ]; then
	_F_sourceforge_dirname="$_F_sourceforge_name"
fi

if [ -z "$_F_sourceforge_ext" ]; then
	_F_sourceforge_ext=".tar.gz"
fi

if [ -z "$_F_sourceforge_broken_up2date" ]; then
        _F_sourceforge_broken_up2date=0
fi

url="http://sourceforge.net/projects/$_F_sourceforge_dirname"
if [ $_F_sourceforge_broken_up2date -eq 0 ]; then
	up2date="lynx -dump http://sourceforge.net/project/showfiles.php?group_id=\$(lynx -dump $url|grep showfiles|sed 's/.*=\(.*\)/\1/;q')|grep -m1 'Latest \[.*\]'|sed 's/.*]$_F_sourceforge_prefix\(.*\) \[.*\].*/\1/;s/-/_/g'"
else
 	up2date="lynx -dump http://sourceforge.net/project/showfiles.php?group_id=\$(lynx -dump $url|grep showfiles|sed 's/.*=\(.*\)/\1/;q')|grep -m1 '$_F_sourceforge_name-\(.*\)$_F_sourceforge_ext'|sed 's/.*$_F_sourceforge_name-\(.*\)$_F_sourceforge_ext.*/\1/;s/-/_/g'"
fi
source=(http://${_F_sourceforge_mirror}.dl.sourceforge.net/sourceforge/$_F_sourceforge_dirname/$_F_sourceforge_name-${pkgver//_/-}$_F_sourceforge_ext)
