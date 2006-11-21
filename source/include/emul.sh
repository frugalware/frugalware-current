#!/bin/sh

# (c) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# emul.sh for Frugalware
# distributed under GPL License

# common source() and build() for emulation of i686 on x86_64

_F_emul_name=${pkgname/-emul}
_F_emul_arch=i686

groups=('emul-extra')
archs=('!i686' 'x86_64')
up2date="lynx -dump http://ftp.frugalware.org/pub/frugalware/frugalware-current/frugalware-$_F_emul_arch/ |grep '/$_F_emul_name-[^-]*-[^-]*-$_F_emul_arch.fpm$'|sed 's/.*$_F_emul_name-\(.*\)-\([^-]*\)-$_F_emul_arch.fpm/\1_\2/;q'"
source=(http://ftp.frugalware.org/pub/frugalware/frugalware-current/frugalware-$_F_emul_arch/$_F_emul_name-${pkgver/_/-}-$_F_emul_arch.fpm)

build()
{
        mkdir $Fsrcdir/tmp || return 1
        tar xf $_F_emul_name-${pkgver/_/-}-$_F_emul_arch.fpm -C tmp || return 1
        Fmkdir /usr/lib/chroot32
        cp -av tmp/* $Fdestdir/usr/lib/chroot32 || return 1
	Frm /usr/share/{doc,man}
}
