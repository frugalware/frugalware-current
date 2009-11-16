#!/bin/sh

###
# = genscriptlet.sh(3)
# Michel Hermier <hermier@frugalware.org>
#
# == NAME
# genscriptlet.sh - for Frugalware
#
# == SYNOPSIS
# Scriptlet utilities for common schema.
#
# == EXAMPLE
# * To generate an install file for a foo package like:
# --------------------------------------------------
# pkgname=foo
# pkgver=1.0.0
# pkgrel=1
# _F_genscriptlet_install=foo.install
# Finclude genscriptlet
# --------------------------------------------------
# where foo.install look like:
# --------------------------------------------------
# ...
# echo "This is $pkgname version $pkgversion."
# ...
# --------------------------------------------------
# will generate an install file like:
# --------------------------------------------------
# ...
# echo "This is foo version 1.0.0."
# ...
# --------------------------------------------------
#
# * To create a custom substitution hook do:
# --------------------------------------------------
# _F_gensciptlet_hooks=("${_F_gensciptlet_hooks[@]}" 'my_genscriptlet_hook')
# my_genscriptlet_hook() {
#     Fsed '$foo' "$foo" "$1"
# }
# Finclude genscriptlet
# --------------------------------------------------
# Notice that the hook has the filename where substitution must append passed as
# argument $1.
#
# == OPTIONS
# All the variables are optional. However if you don't set _F_genscriptlet_install
# or _F_genscriptlet_subinstall most of the tools provided here won't have any effects.
#
# * _F_genscriptlet_install: the original install source file that requires variable
#  substitutions (see FrugalBuild install manual).
# * _F_genscriptlet_subinstall(): the original subinstall source files that requires
#  variable substitutions (see FrugalBuild subinstall manual)
# * _F_gensciptlet_hooks(): a list of hooks that Fgenscriptlet will use.
#
# == OVERWRITTEN VARIABLES
# * install
# * subinstall
###
if [ -z "$_F_genscriptlet_install" ]; then
	if [ -z "$install" ]; then
		error "_F_genscriptlet_install is used but install is allready defined."
		plain "Check your FrugalBuild."
		Fdie
	else
		install="src/$(basename \"$_F_genscriptlet_install\")"
	fi
fi

if [ "${#_F_genscriptlet_subinstall[@]}" -gt 0 ]; then
	if [ "${#subinstall[@]}" -gt 0 ]; then
		error "_F_genscriptlet_subinstall is used but install is allready defined."
		plain "Check your FrugalBuild."
		Fdie
	else
		local file
		subinstall=() # Really necessary ?
		for file in "${_F_genscriptlet_subinstall[@]}"
		do
			subinstall=("${subintall[@]}" "src/$(basename \"$file\")")
		done
	fi
fi

###
# == APPENDED VARIABLES
# * options()
###
options=("${options[@]}" 'scriptlet' 'genscriptlet')

###
# == PROVIDED FUNCTIONS
# * Fgenscriptlet(): function that ease the creation of dynamic install files.
###
__Fgenscriptlet()
{
	local install_src="$1"
	local install_dest="${Fsrcdir}/$(basename $install_src)"

	cp -f "$install_src" "$install_dest" || Fdie
	for hook in "${_F_genscriptlet_hooks[@]}"
	do
		$hook "$install_dest"
	done
}

Fgenscriptlet()
{
	__Fgenscriptlet "$_F_genscriptlet_install"

	local file
	for file in "${_F_genscriptlet_subinstall[@]}"
	do
		__Fgenscriptlet "$file"
	done
}
