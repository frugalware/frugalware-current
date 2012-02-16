#!/bin/sh

###
# = kernel-initrd.sh(3)
# James Buren <ryuo@frugalware.org>
#
# == NAME
# kernel-initrd.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for kernel initrd packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=kernel-initrd-modules
# pkgrel=1
# pkgdesc="Initrd for kernel modules."
# _F_kernel_initrd_options="--kernel-only"
# _F_kernel_initrd_name="initrd-modules"
# _F_kernel_initrd_modules_check=y
#
# Finclude kernel-initrd
#
# rodepends=("kernel=$_F_kernelver_ver-$_F_kernelver_rel")
# --------------------------------------------------
#
# == OPTIONS
# * _F_kernel_initrd_modules_check: specify if you want the generated initrd
# to be checked for kernel modules
# * _F_kernel_initrd_options: options to pass to dracut
# * _F_kernel_initrd_name: name of initrd to place under /boot
###
_F_cd_path="."
_F_genscriptlet_install="$Fincdir/kernel-initrd.install"
_F_genscriptlet_hooks=('_kernel_initrd_genscriptlet_hook')
Finclude kernel-version genscriptlet

if [ -z "$_F_kernel_initrd_name" ]; then
	error "_F_kernel_initrd_name is not defined."
	Fdie
fi

if [ -z "$_F_kernel_initrd_options" ]; then
	error "_F_kernel_initrd_options is not defined."
	Fdie
fi

###
# == OVERWRITTEN VARIABLES
# * pkgver
# * url
# * makedepends()
# * archs()
# * up2date
# * groups()
# * source()
# * options()
###
pkgver=$_F_kernelver_ver
url="http://www.frugalware.org"
makedepends=(
'udev>=175-2'
'systemd>=38-2'
'kmod>=4-2'
'xz'
'linux-firmware>=20120203-1'
'eject'
'sysvinit-tools'
'less'
'xfsprogs'
'jfsutils'
'reiserfsprogs'
'mdadm'
'lvm2'
'dracut-plymouth'
'dracut-raid'
"kernel=$_F_kernelver_ver-$_F_kernelver_rel"
)
archs=('i686' 'x86_64')
up2date="$pkgver"
groups=('base')
source=()
options=('scriptlet' 'genscriptlet')

###
# == PROVIDED FUNCTIONS
# * _kernel_initrd_genscriptlet_hook()
# * Fbuild_kernel_initrd()
###
_kernel_initrd_genscriptlet_hook()
{
	Freplace '_F_kernel_initrd_name' "$1"
}

Fbuild_kernel_initrd()
{
	local _UNAME _INITRD
	_UNAME="$_F_kernelver_ver-fw$_F_kernelver_rel"
	_INITRD="$_F_kernel_initrd_name-$_UNAME"
	Fmkdir /boot
	Fexec /usr/sbin/dracut --no-compress --force -a dmsquash-live \
		$_F_kernel_initrd_options $_INITRD $_UNAME || Fdie
	if [ -n "$_F_kernel_initrd_modules_check" ]; then
		Fmessage "Checking initrd for kernel modules."
		if ! cpio -t < $_INITRD | grep -q '\.ko\.xz$'; then
			error "No kernel modules in initrd."
			Fdie
		fi
	fi
	xz < $_INITRD > $Fdestdir/boot/$_INITRD || Fdie
	Fln $_INITRD /boot/${_INITRD/-$_UNAME/}
	Fgenscriptlet
}

###
# * build() just calls Fbuild_kernel_initrd()
###
build()
{
	Fbuild_kernel_initrd
}
