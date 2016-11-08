#!/bin/sh

###
# = sawfish-script.sh(3)
# James Buren <ryuo@frugalware.org>
#
# == NAME
# sawfish-script.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for sawfish scripts.
#
# == EXAMPLE
# --------------------------------------------------
# # Compiling Time: 0.01 SBU
# # Maintainer: James Buren <ryuo@frugalware.org>
#
# _F_sawfish_name="runapplication"
# _F_sawfish_file="Run-application.jl"
# pkgver=0.2
# pkgrel=1
# pkgdesc="A sawfish script which provides a run-command dialog."
# url="http://sawfish.wikia.com/wiki/Run-application"
# up2date="lynx -dump '$url' | grep -o 'Version: \(.*\)' | sed 's|Version: \(.*\)|\1|'"
# source=(http://images.wikia.com/sawfish/images//2/25/$_F_sawfish_file)
# Finclude sawfish-script
# sha1sums=('7d65e7924ae73a3863a0e535939b4a8983bf49af')
# --------------------------------------------------
#
# == OPTIONS
# * _F_sawfish_name: set to name of script, must be entered
# * _F_sawfish_file: set to full name of the .jl file, defaults to
# $_F_sawfish_name.jl
###
[ -z "$_F_sawfish_name" ] && Fdie
[ -z "$_F_sawfish_file" ] && _F_sawfish_file="$_F_sawfish_name.jl"

###
# == OVERWRITTEN VARIABLES
# * groups
# * archs
# * pkgname
###
groups=('xlib-extra' 'sawfish-scripts')
archs=('x86_64')
pkgname="sawfish-$_F_sawfish_name"

###
# == APPENDED VARIABLES
# * sawfish to rodepends
###
rodepends=(${rodepends[@]} 'sawfish')

###
# == PROVIDED FUNCTIONS
# * Fbuildsawfish()
###
Fbuildsawfish()
{
	Ffile $_F_sawfish_file /usr/share/sawfish/site-lisp/`echo "$_F_sawfish_file" | tr 'A-Z' 'a-z'`
}

###
# * build() just calls Fbuildsawfish()
###
build()
{
	Fbuildsawfish
}
