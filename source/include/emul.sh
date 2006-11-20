#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# emul.sh for Frugalware
# distributed under GPL License

# common source() and build() for emulation of i686 on x86_64

_F_emul_name=${pkgname/-emul}
_F_emul_arch=i686

up2date="lynx -dump http://ftp.frugalware.org/pub/frugalware/frugalware-current/frugalware-$_F_emul_arch/ |grep '$_F_emul_name-[^-]*-[^-]*-$_F_emul_arch.fpm$'|grep -v 'mingw'|sed -n 's/.*$_F_emul_name-\(.*\)-\([^-]*\)-$_F_emul_arch.fpm/\1_\2/;$ p'"
# requested by krix
up2date="$pkgver"
#source=(http://ftp.frugalware.org/pub/frugalware/frugalware-current/frugalware-$_F_emul_arch/$_F_emul_name-$pkgver-$pkgrel-$_F_emul_arch.fpm)
source=(http://ftp.frugalware.org/pub/frugalware/frugalware-current/frugalware-$_F_emul_arch/$_F_emul_name-${pkgver/_/-}-$_F_emul_arch.fpm)

build()
{
        mkdir $Fsrcdir/tmp || return 1
        tar xf $_F_emul_name-$pkgver-$pkgrel-$_F_emul_arch.fpm -C tmp || return 1
        Fmkdir /usr/lib/chroot32
        cp -av tmp/* $Fdestdir/usr/lib/chroot32 || return 1
	Frm /usr/share/{doc,man}
}
