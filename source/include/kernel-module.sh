#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# kernel-module.sh for Frugalware
# distributed under GPL License

# a common function and a scriptlet for externel kernel module packages

_F_kernelmod_ver=2.6.19
_F_kernelmod_rel=2
_F_kernelmod_uname=$_F_kernelmod_ver-fw$_F_kernelmod_rel
_F_kernelmod_pkgver=${_F_kernelmod_uname/fw}
_F_kernelmod_dir=/lib/modules/$_F_kernelmod_uname
depends=("kernel=$_F_kernelmod_pkgver")
makedepends=("kernel-source=$_F_kernelmod_pkgver")
install=$Fincdir/kernel-module.install
options=(${options[@]} 'scriptlet')

Fcheckkernel()
{
	if [ "`uname -r`" != "$_F_kernelmod_uname" ]; then
		error "You might installed the required kernel package, but"
		plain "you're not running that kernel. Please reboot your system."
		Fdie
	fi
}
