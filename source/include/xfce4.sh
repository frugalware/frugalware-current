#!/bin/sh

# (c) 2006 Priyank <priyankmg@gmail.com>
# (c) 2006 Alex Smith <alex@alex-smith.me.uk>
# xfce4.sh for Frugalware
# distributed under GPL License

hpurl="http://www.xfce.org"

if [ -z $_F_xfce_name ] ; then
	_F_xfce_name=$pkgname
fi

if [ -z $_F_xfce_goodies_ext ] ; then
	_F_xfce_goodies_ext=".tar.bz2"
fi

if [ -z $_F_xfce_goodies_dir ] ; then
	_F_xfce_goodies_dir=$_F_xfce_name
fi

if echo ${groups[*]} | grep -q goodies ; then
	url="http://goodies.xfce.org/projects/panel-plugins/${_F_xfce_name}"
	dlurl="http://goodies.xfce.org/releases/$_F_xfce_goodies_dir/"
	up2date="lynx -dump $dlurl | grep "$_F_xfce_name-.*${_F_xfce_goodies_ext}$" | sed -n 's/.*-\(.*\)\.t.*/\1/;$ p'"
	source=($dlurl/${_F_xfce_name}-${pkgver}${_F_xfce_goodies_ext})
else
	#preup2date="lynx -dump http://www.xfce.org/archive | grep 'xfce-' | sed -n 's/.*-\(.*\)\.t.*/\1/;$ p' | sed 's/[0-9][0-9]\. http:\/\/www\.xfce\.org\/archive\/xfce-//g' | sed 's/ //g' | sed 's/\///g'"
	# The above preup2date sometimes gives no output due to unknown reasons. The below one works always.
	preup2date="lynx -dump http://www.xfce.org/archive/ | grep xfce- | tail -n1 | sed 's/.*-\(.*\)\/.*/\1/'"
	dlurl="$hpurl/archive/xfce-4.4.0/src"
	up2date="lynx -dump $hpurl/archive/xfce-\$($preup2date)/src/ | grep $_F_xfce_name | Flasttarbz2"
	source=($dlurl/$_F_xfce_name-$pkgver.tar.bz2)
fi

options=(${options[@]} 'scriptlet')
