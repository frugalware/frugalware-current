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
_F_kernelver_ver=2.6.21
_F_kernelver_rel=2
_F_kernelver_stable=3
