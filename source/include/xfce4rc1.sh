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

if [ -z $_F_xfce_goodies_ext ] ; then
	_F_xfce_goodies_ext=".tar.gz"
fi

if [ -z $_F_xfce_goodies_dir ] ; then
	_F_xfce_goodies_dir=$name
fi

if echo ${groups[*]} | grep -q goodies ; then
	url="http://goodies.xfce.org/projects/panel-plugins/${name}"
	dlurl="http://goodies.xfce.org/releases/$_F_xfce_goodies_dir/"
	up2date="lynx -dump $dlurl | grep "$name-.*${_F_xfce_goodies_ext}$" | sed -n 's/.*-\(.*\)\.t.*/\1/;$ p'"
	source=($dlurl/${pkgname}-${pkgver}${_F_xfce_goodies_ext})
else
	preup2date=`lynx -dump http://www.xfce.org/archive | grep 'xfce-' | sed -n 's/.*-\(.*\)\.t.*/\1/;$ p' | sed 's/[0-9][0-9]\. http:\/\/www\.xfce\.org\/archive\/xfce-//g' | sed 's/ //g' | sed 's/\///g'`
	dlurl="$hpurl/archive/xfce-$preup2date/src/"
	up2date="lynx -dump $hpurl/archive/xfce-$preup2date/src/ | grep $name | Flasttarbz2"
	source=($dlurl/$name-$pkgver.tar.bz2)
fi

