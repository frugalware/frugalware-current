#!/bin/sh

USE_DEVEL=${USE_DEVEL:-"n"}

Finclude kernel-version

###
# = kernel.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# kernel.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for kernel packages.
#
# == EXAMPLE
# * To build a vanilla upstream kernel with a custom version and config:
# --------------------------------------------------
# pkgver=2.6.20
# pkgrel=1
# _F_kernel_name="-custom"
# Finclude kernel
# --------------------------------------------------
# * To use a given patchset (for example -ck):
# --------------------------------------------------
# pkgver=2.6.20
# pkgrel=1
# _F_kernel_name="-ck"
# _F_kernel_patches=(http://www.kernel.org/pub/linux/kernel/people/ck/patches/\
# 2.6/2.6.20/2.6.20-ck1/patch-2.6.20-ck1.bz2)
# Finclude kernel
# --------------------------------------------------
# == OPTIONS
# You are strongly recommended to use the pkgver and pkgrel variables, however
# all the variables are optional. Here is a list of them:
#
# * _F_kernel_vmlinuz (defaults to arch/$arch/boot/bzImage): path to the kernel
# binary
# * _F_kernel_name (defaults to ""): include a string in the kernel version
# string (example: "-mygrsec")
# * _F_kernel_ver (defaults to $pkgver): the version of the kernel
# * _F_kernel_rel (defaults to $pkgrel): the release of the kernel (used in the
# kernel version string)
# * _F_kernel_dontfakeversion if set, don't replace the kernel version string
# with a generated one (from _F_kernel_ver, _F_kernel_name and _F_kernel_rel)
# * _F_kernel_uname: specify the kernel version manually (defaults to
# $_F_kernel_name-fw$_F_kernel_rel)
# * _F_kernel_path: vmlinuz on x86
#
# == OVERWRITTEN VARIABLES
# * pkgver (if not set)
# * pkgrel (if not set)
###

if Fuse $USE_DEVEL; then
	_F_kernel_dontfakeversion=1
fi

if [ -z "$_F_kernel_ver" ]; then
	_F_kernel_ver=$_F_kernelver_ver
fi

if [ -z "$_F_kernel_rel" ]; then
	_F_kernel_rel=$_F_kernelver_rel
fi

if [ -z "$_F_kernel_dontfakeversion" ]; then
	_F_kernel_dontfakeversion=0
fi
if [ -z "$_F_kernel_uname" ]; then
	_F_kernel_uname="$_F_kernel_name-fw$_F_kernel_rel"
fi

if [ -z "$_F_kernel_path" ]; then
	case "$CARCH" in
	*)	_F_kernel_path=vmlinuz;;
	esac
fi

if [ -z "$pkgver" ]; then
	pkgver=$_F_kernel_ver
fi

if [ -z "$pkgrel" ]; then
	pkgrel=$_F_kernel_rel
fi

if [ -z "$_F_archive_name" ]; then
	_F_archive_name=linux
fi


###
# * pkgname
# * pkgdesc
###
if [ -z "$pkgname" ]; then
	if [ -z "$_F_kernel_name" ]; then
		pkgname=kernel
	else
		pkgname=kernel$_F_kernel_name
	fi
fi
if [ -z "$_F_kernel_name" ]; then
	pkgdesc="The Linux Kernel and modules"
else
	pkgdesc="The Linux Kernel and modules (${_F_kernel_name/-} version)"
fi

###
# * Fkernel_genscriptlet_hook()
###
Fkernel_genscriptlet_hook()
{
	Freplace '_F_kernel_path' "$1"
	Freplace '_F_kernel_name' "$1"
	Freplace '_F_kernel_rel' "$1"
	Freplace '_F_kernel_uname' "$1"
	Freplace '_F_kernel_ver' "$1"
}

