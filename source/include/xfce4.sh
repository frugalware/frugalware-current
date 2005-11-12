#!/bin/sh

# (c) 2005 Marcus Habermehl <bmh1980de@yahoo.de>
# xfce4.sh for Frugalware
# distributed under GPL License

hpurl="http://www.xfce.org/"
preup2date=`lynx -dump $hpurl|grep -m 1 -o '[0-9\.]\+ released'|sed 's| released||'`

if [ -z $realname ] ; then
	name=$pkgname
else
	name=$realname
fi

if echo ${groups[*]} | grep -q goodies ; then
	dlurl="http://download.berlios.de/xfce-goodies/"
	up2date="lynx -dump 'http://developer.berlios.de/project/showfiles.php?group_id=910'|grep -m 1 \"$name-[0-9\.]\+.tar.\(gz\|bz2\)\"|grep -o '[0-9]\.[0-9\.]\+[0-9]'"
else
	dlurl="$hpurl/archive/xfce-$preup2date/src/"
	up2date="lynx -dump $dlurl|grep -m 1 -o \"$name-[0-9\.]\+[0-9]\"|sed \"s|$name-||\""
fi
