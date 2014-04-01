#!/bin/sh

###
# = autotools.sh(3)
# Michel Hermier <hermier@frugalware.org>
#
# == NAME
# atutotools.sh - for Frugalware
#
# == SYNOPSIS
# Common autotools invocations and fixes.
#
# == EXAMPLE
# --------------------------------------------------
# --------------------------------------------------
#
# == OPTIONS
###
# General variables
###

###
# == PROVIDED FUNCTIONS
# * Fautotools_fixes: Fix common autotools problems.
###

Fautotools_fixes() {
	Fcd
	Fsed 'AM_CONFIG_HEADER' 'AC_CONFIG_HEADERS' ./configure.ac ./configure.in
}

