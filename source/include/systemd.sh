#!/bin/sh

###
# = systemd.sh(3)
# James Buren <ryuo@frugalware.org>
#
# == NAME
# systemd.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for systemd service packages.
#
# == EXAMPLE
# --------------------------------------------------
# # Here comes a working example - without the 2-lines-length header and
# # without any #optimization ok and other footnodes.
# --------------------------------------------------
#
# == OPTIONS
# * _F_sysvinit_units: a string of all sysvinit units to disable
# * _F_systemd_units: a string of all systemd units to manage. append a
# '=' after the system service name with 'e' and/or 's' for it to be
# enabled and/or started at install time
# * _F_systemd_scriptlet: set this with the name of your custom scriptlet
###
if [ -z "$_F_systemd_units" ]; then
	error "No systemd units defined."
	Fdie
fi
for i in ${_F_systemd_units}; do
	if ! echo "$i" | grep -qo '='; then
		error "Each systemd unit must have a '=' appended."
		Fdie
	fi
done

if [ -z "$_F_systemd_scriptlet" ]; then
	_F_systemd_scriptlet="$Fincdir/systemd.install"
fi

###
# == OVERWRITTEN VARIABLES
# * _F_genscriptlet_install
###
_F_genscriptlet_install="$_F_systemd_scriptlet"

###
# == APPENDED VARIABLES
# * Fsystemd_genscriptlet_hook to _F_genscriptlet_hooks()
# * depends()
###
_F_genscriptlet_hooks=(${_F_genscriptlet_hooks[@]} 'Fsystemd_genscriptlet_hook')
depends=(${depends[@]} 'systemd')

Finclude genscriptlet

###
# == PROVIDED FUNCTIONS
# * Fsystemd_genscriptlet_hook()
###
Fsystemd_genscriptlet_hook()
{
	Freplace '_F_systemd_units' "$1"
}
