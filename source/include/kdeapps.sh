#!/bin/sh

# (c) 2006 Gabriel Craciunescu <crazy@frugalware.org>
# kdeapps.sh for Frugalware
# distributed under GPL License

if [ ! -z "$_F_kdeapps_id" ]; then
	url="http://www.kde-apps.org/content/show.php?content=$_F_kdeapps_id"
	up2date="lynx -dump -nolist $url|grep -m1 'Version:'|sed 's/.*: *\(.*\)$/\1/'"
fi

if [ ! -z "$_F_kdeapps_id2" ]; then
        url="http://www.kde-look.org/content/show.php?content=$_F_kdeapps_id2"
        up2date="lynx -dump -nolist $url|grep -m1 'Version:'|sed 's/.*: *\(.*\)$/\1/'"
fi

options=(${options[@]} 'scriptlet')

build()
{
	Fcd
	for i in `find . -iname configure`
	do
		Fsed '-O2' '' $i
	done
	Fbuild  --disable-dependency-tracking \
		--disable-debug --without-debug \
		--with-gnu-ld
}

unset _F_kdeapps_id _F_kdeapps_id2
