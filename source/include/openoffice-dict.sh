#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# openoffice-dict.sh for Frugalware
# distributed under GPL License

# common url up2date, source(), build() and .install for openoffice.org dictionaries

url="ftp://ftp.services.openoffice.org/pub/OpenOffice.org/contrib/dictionaries/"
# no way to determine pkgver automatically :-/
up2date="$pkgver"
source=(ftp://ftp.services.openoffice.org/pub/OpenOffice.org/contrib/dictionaries/$_F_openoffice_name-pack.zip)

install=$Fincdir/openoffice-dict.install

_F_openoffice_option() {
	local i
	for i in ${dictoptions[@]}; do
		local uc=`echo $i | tr [:lower:] [:upper:]`
		local lc=`echo $i | tr [:upper:] [:lower:]`
		if [ "$uc" = "$1" -o "$lc" = "$1" ]; then
			echo $1
			return
		fi
	done
}

build()
{
	for i in *.zip
	do
		unzip -qqo $i
	done

	if [ ! "`_F_openoffice_option NODICT`" ]; then
		if [ -e $_F_openoffice_name.aff ]; then
			Ffile /usr/lib/openoffice.org/share/dict/ooo/$_F_openoffice_name.aff
		fi
		if [ -e $_F_openoffice_name.dic ]; then
			Ffile /usr/lib/openoffice.org/share/dict/ooo/$_F_openoffice_name.dic
		fi
	fi
	if [ ! "`_F_openoffice_option NOHYPH`" ]; then
		if [ -e hyph_$_F_openoffice_name.dic ]; then
			Ffile /usr/lib/openoffice.org/share/dict/ooo/hyph_$_F_openoffice_name.dic
		fi
	fi
	if [ ! "`_F_openoffice_option NOTH`" ]; then
		if [ -e th_$_F_openoffice_name.dat ]; then
			Ffile /usr/lib/openoffice.org/share/dict/ooo/th_$_F_openoffice_name.dat
		fi
		if [ -e th_$_F_openoffice_name.idx ]; then
			Ffile /usr/lib/openoffice.org/share/dict/ooo/th_$_F_openoffice_name.idx
		fi
	fi
}

