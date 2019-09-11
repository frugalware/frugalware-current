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
# * _F_systemd_units: a string of all systemd service to manage.
# Append a '=' after the systemd service name with 'e', 'd' and/or
# 's' for it to be enabled, disabled  and/or started at install time
# * _F_systemd_sockets: a string of all systemd sockets to manage.
# Append a '=' after the systemd socket name with 'e' and/or 's'
# for it to be enabled and/or started at install time.
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

## sockets are optional so we won't error out like for units
## it they missing .. but still need check here.
if [ -n "$_F_systemd_sockets" ]; then
	for j in ${_F_systemd_sockets}; do
		if ! echo "$j" | grep -qo '='; then
			error "Each systemd socket must have a '=' appended."
			Fdie
		fi
	done
fi

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
###
_F_genscriptlet_hooks=(${_F_genscriptlet_hooks[@]} 'Fsystemd_genscriptlet_hook')

Finclude genscriptlet

###
# == PROVIDED FUNCTIONS
# * Fsystemd_genscriptlet_hook()
###
Fsystemd_genscriptlet_hook()
{
	Freplace '_F_systemd_units' "$1"
}
