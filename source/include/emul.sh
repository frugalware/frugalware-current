#!/bin/sh

###
# = emul.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# emul.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for i686 emulation packages on x86_64.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=expat-emul
# pkgver=2.0.0_5
# pkgrel=1
# pkgdesc="An XML Parser library written in C for emulation of i686 on x86_64"
# url="http://expat.sf.net"
# depends=('glibc-emul')
# Finclude emul
# sha1sums=('194a653f29520845d7659cbb4127139875a997ba')
# --------------------------------------------------
#
# == OPTIONS
# * _F_emul_arch (defaults to i686): the arch we want to emulate
###
# don't document this option, we really should not use custom package names for
# emul pkgs. it is here for backward compatibility (for example the nvidia
# package still uses it - without any good reason)
_F_emul_name=${pkgname/-emul}
# same, don't touch this
_F_emul_ver=`echo $pkgver|sed 's/\(.*\)_\([^_]\+\)/\1-\2/'`
_F_emul_arch=i686

###
# == OVERWRITTEN VARIABLES
# * groups()
# * archs()
# * up2date
# * source()
###
groups=('emul-extra')
archs=('!i686' 'x86_64')
up2date="lynx -dump http://ftp.frugalware.org/pub/frugalware/frugalware-current/frugalware-$_F_emul_arch/ |grep '/$_F_emul_name-[^-]*-[^-]*-$_F_emul_arch.fpm$'|sed 's/.*$_F_emul_name-\(.*\)-\([^-]*\)-$_F_emul_arch.fpm/\1_\2/;q'"
source=(http://ftp.frugalware.org/pub/frugalware/frugalware-current/frugalware-$_F_emul_arch/$_F_emul_name-$_F_emul_ver-$_F_emul_arch.fpm)
###
# == APPENDED VARIABLES
# * nostrip to options()
###
options=(${options[@]} 'nostrip')

###
# == PROVIDED FUNCTIONS
# * build()
###
build()
{
        mkdir -p $Fsrcdir/tmp || return 1
       	bsdtar xf $_F_emul_name-$_F_emul_ver-$_F_emul_arch.fpm -C tmp || return 1
        Fmkdir /usr/lib/chroot32
        cp -av tmp/* $Fdestdir/usr/lib/chroot32 || return 1
	Frm /usr/share/{doc,man}
}
