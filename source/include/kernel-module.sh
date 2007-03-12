#!/bin/sh

###
# = kernel-module.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# kernel-module.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for kernel module packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=cdemu
# pkgver=0.8
# pkgrel=13
# pkgdesc="A kernel module designed to simulate a CD drive with just simple cue/bin files."
# Finclude kernel-module
# depends=(${depends[@]} 'python')
# groups=('apps-extra')
# archs=('i686' 'x86_64')
# install=$pkgname.install
# _F_sourceforge_ext=".tar.bz2"
# Finclude sourceforge
# sha1sums=('3a4e170232b74b1d62c73da78cf2abd58bf2daca')
#
# build()
# {
#         # no Fcheckkernel, crosscompilation verified
#         Fsed '$(shell uname -r)' "$_F_kernelmod_uname" Makefile
#         Fbuild
# }
# --------------------------------------------------
# NOTE: You need to use Fcheckkernel to prevent crosscompilation or that
# comment to be sure about there will be no wrong module will be built by
# accident! See the 'Kernel modules' section of 'makepkg' document for more
# info.
#
# == OVERWRITTEN VARIABLES
# * _F_kernelmod_ver: the kernel version
# * _F_kernelmod_rel: the kernel release
# * _F_kernelmod_uname: the output of the uname -r command of the official kernel
# * _F_kernelmod_pkgver: the package version (pkgname-pkgrel) of the kernel
# * _F_kernelmod_dir: the directory where the modules are (ie: /lib/modules/`uname -r`)
# * depends()
# * makedepends()
# * install
###
_F_kernelmod_ver=2.6.20
_F_kernelmod_rel=3
_F_kernelmod_uname=$_F_kernelmod_ver-fw$_F_kernelmod_rel
_F_kernelmod_pkgver=${_F_kernelmod_uname/fw}
_F_kernelmod_dir=/lib/modules/$_F_kernelmod_uname
depends=("kernel$_F_kernel_name=$_F_kernelmod_pkgver")
makedepends=("kernel$_F_kernel_name-source=$_F_kernelmod_pkgver")
install=$Fincdir/kernel-module.install

###
# == APPENDED VARIABLES
# * scriptlet to options()
###
options=(${options[@]} 'scriptlet')

###
# == PROVIDED FUNCTIONS
# * Fcheckkernel: Checks if the version of the running kernel equals to the
# installed one, this is required if the crosscompilation is not verified.
# Never use this function outside build().
###
Fcheckkernel()
{
	if [ "`uname -r`" != "$_F_kernelmod_uname" ]; then
		error "You might installed the required kernel package, but"
		plain "you're not running that kernel. Please reboot your system."
		Fdie
	fi
}
