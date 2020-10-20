#!/bin/sh

###
# = kernel-version.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# kernel-version.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages built against a given kernel version.
#
# == OVERWRITTEN VARIABLES
# * _F_kernelver_ver: the kernel version
# * _F_kernelver_rel: the kernel release
# * _F_kernelver_stable: the number of the -stable patch to use (if any)
# * _F_kernelver_nextver: the next kernel version
###
_F_kernelver_ver=5.9.1
_F_kernel_mod_compress=zstd
_F_kernelver_rel=1

###
# == APPENDED VALUES
# _F_genscriptlet_hooks: appends Fkernelver_genscriptlet_hook.
###
_F_genscriptlet_hooks=("${_F_genscriptlet_hooks[@]}" 'Fkernelver_genscriptlet_hook')

###
# == PROVIDED FUNCTIONS
# * Fkernelver_genscriptlet_hook: Hook to replace kernel versions variables in .install scripts.
# * Fkernelver_compress_modules: Search for kernel modules and compress any found.
###
Fkernelver_genscriptlet_hook()
{
	Freplace '_F_kernelver_ver' "$1"
	Freplace '_F_kernelver_rel' "$1"
}

Fkernelver_compress_modules()
{
	if [ -n "$_F_kernel_mod_compress" ]; then
		case "$_F_kernel_mod_compress" in
			zstd) _Fkernelver_compress_modules_zstd ;;
			xz)   _Fkernelver_compress_modules_xz ;;
		esac
	fi
}

_Fkernelver_compress_modules_zstd()
{
    local _directory
    _directory="$Fdestdir/lib/modules/${_F_kernelver_ver}${_F_kernel_name}-fw$_F_kernelver_rel"
    Fexec find $_directory -name "*.ko" -exec zstd -T0 -19 -q --rm -f '{}' \; || Fdie
}

_Fkernelver_compress_modules_xz()
{
    local _directory
    _directory="$Fdestdir/lib/modules/${_F_kernelver_ver}${_F_kernel_name}-fw$_F_kernelver_rel"
    Fexec find $_directory -name "*.ko" -exec xz -T0 '{}' \; || Fdie
}

makedepends=("${makedepends[@]}" 'ca-certificates')
