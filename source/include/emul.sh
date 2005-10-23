#!/bin/sh

# (c) 2005 Miklos Vajna <vmiklos@frugalware.org>
# emul.sh for Frugalware
# distributed under GPL License

# common source() and build() for emulation of i686 on x86_64

earch=i686

source=(http://ftp.frugalware.org/pub/frugalware/frugalware-current/frugalware-$earch/$pkgname-$pkgver-$pkgrel-$earch.fpm)

build()
{
        mkdir $Fsrcdir/tmp || return 1
	file $pkgname-$pkgver-$pkgrel-$earch.fpm |grep -q bzip2 && f=j || f=z
        tar x${f}f $pkgname-$pkgver-$pkgrel-$earch.fpm -C tmp || return 1
        Fmkdir /usr/lib/chroot32
        cp -av tmp/* $Fdestdir/usr/lib/chroot32 || return 1
}

# vim: ft=sh
