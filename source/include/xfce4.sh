#!/bin/sh

# (c) 2005 Marcus Habermehl <bmh1980de@yahoo.de>
# xfce4.sh for Frugalware
# distributed under GPL License

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
	preup2date=`lynx -dump $hpurl|grep released|sed 's/.*e \(.*\) r.*/\1/;q'`
	dlurl="$hpurl/archive/xfce-$preup2date/src/"
	up2date="lynx -dump $hpurl/archive/xfce-$preup2date/src/|grep \"$name-[0-9\.].*gz$\"|Flasttar"
fi
