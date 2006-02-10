#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# openoffice-dict.sh for Frugalware
# distributed under GPL License

# common url up2date, source(), build() and .install for openoffice.org dictionaries

url="ftp://ftp.services.openoffice.org/pub/OpenOffice.org/contrib/dictionaries/"
# no way to determine pkgver automatically :-/
up2date="$pkgver"
source=(ftp://ftp.services.openoffice.org/pub/OpenOffice.org/contrib/dictionaries/$dictname-pack.zip)

install=$Fincdir/openoffice-dict.install

check_dictoption() {
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

	if [ ! "`check_dictoption NODICT`" ]; then
		if [ -e $dictname.aff ]; then
			Ffile /usr/lib/ooo-2.0/share/dict/ooo/$dictname.aff
		fi
		if [ -e $dictname.dic ]; then
			Ffile /usr/lib/ooo-2.0/share/dict/ooo/$dictname.dic
		fi
	fi
	if [ ! "`check_dictoption NOHYPH`" ]; then
		if [ -e hyph_$dictname.dic ]; then
			Ffile /usr/lib/ooo-2.0/share/dict/ooo/hyph_$dictname.dic
		fi
	fi
	if [ ! "`check_dictoption NOTH`" ]; then
		if [ -e th_$dictname.dat ]; then
			Ffile /usr/lib/ooo-2.0/share/dict/ooo/th_$dictname.dat
		fi
		if [ -e th_$dictname.idx ]; then
			Ffile /usr/lib/ooo-2.0/share/dict/ooo/th_$dictname.idx
		fi
	fi
}

