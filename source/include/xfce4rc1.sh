#!/bin/sh

# (c) 2006 Priyank <priyankmg@gmail.com>
# (c) 2006 Alex Smith <alex@alex-smith.me.uk>
# xfce4rc1.sh for Frugalware
# distributed under GPL License

# DO NOT USE in -current!

hpurl="http://www.xfce.org/"

if [ -z $realname ] ; then
	name=$pkgname
else
	name=$realname
fi

if echo ${groups[*]} | grep -q goodies ; then
	dlurl="http://download.berlios.de/xfce-goodies/"
	up2date="lynx -dump http://developer.berlios.de/project/showfiles.php?group_id=910|grep \"$name-.*tar.\(gz\|bz2\)$\"|sed 's/.*-\(.*\)\.t.*/\1/;q'"
else
	preup2date=`lynx -dump http://www.xfce.org/archive | grep 'xfce-' | sed -n 's/.*-\(.*\)\.t.*/\1/;$ p' | sed 's/[0-9][0-9]\. http:\/\/www\.xfce\.org\/archive\/xfce-//g' | sed 's/ //g' | sed 's/\///g'`
	dlurl="$hpurl/archive/xfce-$preup2date/src/"
	up2date="lynx -dump $hpurl/archive/xfce-$preup2date/src/ | grep $name | Flasttarbz2"
fi

source=($dlurl/$name-$pkgver.tar.bz2)

