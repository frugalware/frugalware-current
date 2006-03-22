#!/bin/sh

# (c) 2006 Marcus Habermehl <bmh1980@frugalware.org>
# rox.sh for Frugalware
# distributed under GPL License

[ -z "$_F_app_dir" ] && Fdie

Froxbuild()
{
	Fcd $_F_app_dir
	if [ -d src ] ; then ./AppRun --compile || Fdie ; fi
	if [ -f libdir ] ; then Fsed '/usr/apps' '/usr/share/Apps' libdir ; fi
	Fmkdir /usr/{bin,share/{Apps,doc}}
	Fcpr $_F_app_dir /usr/share/Apps/
	Fln /usr/share/Apps/$F_appdir/Help /usr/share/doc/$pkgname-$pkgver
	if [ -f $Fsrcdir/$pkgname ] ; then
		Fexe /usr/bin/$pkgname
	else
		Fln /usr/share/Apps/$_F_app_dir/AppRun /usr/bin/$pkgname
	fi
}

build()
{
	Froxbuild
}
