#!/bin/sh

# (c) 2005 Miklos Vajna <vmiklos@frugalware.org>
# emul.sh for Frugalware
# distributed under GPL License

# common source() and build() for emulation of i686 on x86_64

ename=`echo $pkgname|sed 's/-emul//'`
earch=i686

up2date="lynx -dump http://ftp.frugalware.org/pub/frugalware/frugalware-current/$repo/frugalware-i686/ |grep \"$ename-[^-]*-[^-]*-$earch.fpm$\"|sed \"s/.*$ename-\(.*\)-[^-]*-$earch.fpm/\1/\""
source=(http://ftp.frugalware.org/pub/frugalware/frugalware-current/$repo/frugalware-$earch/$ename-$pkgver-$pkgrel-$earch.fpm)

build()
{
        mkdir $Fsrcdir/tmp || return 1
	file $ename-$pkgver-$pkgrel-$earch.fpm |grep -q bzip2 && f=j || f=z
        tar x${f}f $ename-$pkgver-$pkgrel-$earch.fpm -C tmp || return 1
        Fmkdir /usr/lib/chroot32
        cp -av tmp/* $Fdestdir/usr/lib/chroot32 || return 1
}

# vim: ft=sh
