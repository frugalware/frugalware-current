#!/bin/sh

###
# = skel.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# skel.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for skeleton packages.
#
# == EXAMPLE
# --------------------------------------------------
# # Here comes a working example - without the 2-lines-length header and
# # without any #optimization ok and other footnodes.
# --------------------------------------------------
#
# == OPTIONS
# * _F_skel_name (defaults to $pkgname): if you want to use a custom package
# name (for example the upstream name contains uppercase letters) then use this
# to declare the real name
###
if [ -z "$_F_berlios_name" ]; then
	_F_berlios_name=$pkgname
fi

###
# == OVERWRITTEN VARIABLES
# * up2date
# * source()
###
up2date="foo"
source=(bar)

###
# == APPENDED VARIABLES
# * force to options()
###
options=(${options[@]} 'force')

###
# == PROVIDED FUNCTIONS
# * Fbuildskel()
###
Fbuildskel()
{
	true
}

###
# * build() just calls Fbuildskel()
###
build()
{
	Fbuildskel
}
