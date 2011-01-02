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
###
_F_kernelver_ver=2.6.36
_F_kernelver_rel=4
_F_kernelver_stable=2

###
# == APPENDED VALUES
# _F_genscriptlet_hooks: appends Fkernelver_genscriptlet_hook.
###
_F_genscriptlet_hooks=("${_F_genscriptlet_hooks[@]}" 'Fkernelver_genscriptlet_hook')

###
# == PROVIDED FUNCTIONS
# * Fkernelver_genscriptlet_hook: Hook to replace kernel versions variables in .install scripts.
###
Fkernelver_genscriptlet_hook()
{
	Freplace '_F_kernelver_ver' "$1"
	Freplace '_F_kernelver_rel' "$1"
	Freplace '_F_kernelver_stable' "$1"
}

