#!/bin/sh

Finclude kernel-version

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
#         Fbuild_kernelmod_scriptlet
# }
# --------------------------------------------------
#
# If you want to build a module for a custom kernel, then you need to set three
# options. Here is an example:
#
# --------------------------------------------------
# _F_kernelmod_name="-xen0"
# _F_kernelmod_ver=2.6.19
# _F_kernelmod_rel=2
# --------------------------------------------------
#
# NOTE: You need to use Fcheckkernel to prevent crosscompilation or that
# comment to be sure about there will be no wrong module will be built by
# accident! See the 'Kernel modules' section of 'makepkg' document for more
# info.
#
# == OPTIONS
# * _F_kernelmod_scriptlet: the kernel module install script
# * _F_kernelmod_name: build module for a custom kernel - built using
# _F_kernel_name (optional, defaults to "")
# * _F_kernelmod_ver: kernel version (required if _F_kernelmod_name is set)
# * _F_kernelmod_rel: kernel release (required if _F_kernelmod_name is set)
#
# == OVERWRITTEN VARIABLES
# * _F_kernelmod_uname: the output of the uname -r command of the official kernel
# * _F_kernelmod_pkgver: the package version (pkgname-pkgrel) of the kernel
# * _F_kernelmod_dir: the directory where the modules are (ie: /lib/modules/`uname -r`)
# * _F_genscriptlet_install: the _F_kernelmod_scriptlet value.
###
if [ -z "$_F_kernelmod_scriptlet" ]; then
	_F_kernelmod_scriptlet="$Fincdir/kernel-module.install"
fi
if [ -z "$_F_kernelmod_name" ]; then
	_F_kernelmod_ver="$_F_kernelver_ver"
	_F_kernelmod_rel="$_F_kernelver_rel"
fi
_F_kernelmod_uname=$_F_kernelmod_ver$_F_kernelmod_name-fw$_F_kernelmod_rel
_F_kernelmod_pkgver=$_F_kernelmod_ver-$_F_kernelmod_rel
_F_kernelmod_dir=/lib/modules/$_F_kernelmod_uname
_F_genscriptlet_install="$_F_kernelmod_scriptlet"

###
# == APPENDED VARIABLES
# * kernel package name to depends()
# * kernel package source to makedepends()
# * scriptlet to options()
# * Fkernelmod_genscriptlet_hook to _F_genscriptlet_hooks()
###
depends=("${depends[@]}" "kernel$_F_kernelmod_name=$_F_kernelmod_pkgver")
makedepends=("${makedepends[@]}" "kernel$_F_kernelmod_name-source=$_F_kernelmod_pkgver")
options=("${options[@]}" 'scriptlet') # Required by kernel
_F_genscriptlet_hooks=("${_F_genscriptlet_hooks[@]}" Fkernelmod_genscriptlet_hook)

Finclude genscriptlet

###
# == PROVIDED FUNCTIONS
# * Fbuild_kernelmod_scriptlet() generates a scriptlet for the given package from
# the template according to the declared options
###
Fbuild_kernelmod_scriptlet()
{
	Fgenscriptlet

	# Compatibility code remove after 1.3
	Fsed '$_F_kernelmod_uname' "$_F_kernelmod_uname" "${Fsrcdir}/$(basename "$_F_kernelmod_scriptlet")"
}

###
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

###
# * Fkernelmod_genscriptlet_hook() is the genscriplet hook that substitute kernelmod
# variables inside scriptlets.
###
Fkernelmod_genscriptlet_hook()
{
	Freplace '_F_kernelmod_dir' "$1"
	Freplace '_F_kernelmod_pkgver' "$1"
	Freplace '_F_kernelmod_rel' "$1"
	Freplace '_F_kernelmod_uname' "$1"
	Freplace '_F_kernelmod_ver' "$1"
}

