#!/bin/sh

###
# = provider.sh(3)
# Michel Hermier <hermier@frugalware.org>
#
# == NAME
# provider.sh - for Frugalware
#
# == SYNOPSIS
# Common schema template for package providers.
#
# == EXAMPLE
# --------------------------------------------------
# _F_provider_name="sourceforge"
# Finclude provider
# --------------------------------------------------
#
# == OPTIONS
# * _F_provider_names: List off package information provides. Provider's names
#     should be prepended to it.
# * _F_${provider_name}_${variable_name}_default: Default value for
#     _F_${provider_name}_${variable_name} if not set.
# * _F_${provider_name}_${variable_name}_noneable: Handle the 'None' value as
#     an empty value for _F_${provider_name}_${variable_name}
#     (compatibility option since new code handle zero lenght values)
###

_Fvar_get() {
	# Without redirection eval spit about bad substitution
	eval "echo -nE \"\${$1}\"" 2>/dev/null
}

_Fvar_set() {
	eval "$1=\"\${2}\""
}

# Handle null length strings
_Fvar_isset() {
	$(set -u; eval ": '\$$1'" 2>/dev/null)
	return "$?"
}

_Fvar_setdefault() {
	if ! _Fvar_isset "$1"; then
		_Fvar_set "$@"
	fi
}

_Fvar_concact() {
	local dst="$1"
	shift

	while [ $# -gt 0 ]; do
		eval "$dst=\"\${$dst}\$1\""
		shift
	done
}

_Flist_get() {
	eval "echo -nE \"\${$1[@]}\""
}

_Flist_set() {
	local dst="$1"
	shift

	eval "$dst=(\"\$@\")"
}

_Flist_append() {
	local dst="$1"
	shift

	eval "$dst=(\"\${$dst[@]}\" \"\$@\")"
}

_F_provider_names=('archive' 'compat')

# FIXME? change sep var name to versep ?
Fprovider_varname() {
	local name

	if [ -n "$2" -o "$2" = "compat" ]; then # -o "$2" = "pkg" ?
		case "$2" in
		'name')		name='pkgname';;
		'sep')		name='Fpkgversep';;
		'ver')		name='pkgver';;
#		'ext')		name='';;
#		'dlurl')	name='';;
		'url')		name='url';;
#		'dlextra')	name='';;
#		'dirname')	name='';;
		esac
	else
		name="_F_${2}_${1}"
	fi
	echo -nE "$name"
}

Fprovider_get() {
	local provider provider_varname value value_default value_noneable
	shift

	# Initialize conditions
	for provider in "${_F_provider_names[@]}"; do
		provider_varname="$(Fprovider_varname "$provider" "$1")"
		if [ -z "$provider_name" ]; then
			continue
		fi
		if _Fvar_isset "${provider_varname}"; then
			_Fvar_setdefaut 'value' "$(_Fvar_get "${provider_name}")"
		fi
		if _Fvar_isset "${provider_name}_default"; then
			_Fvar_setdefault 'value_default' "$(_Fvar_get "${provider_name}_default")"
		fi
		if _Fvar_isset "${provider_name}_noneable"; then
			value_noneable='1'
		fi
	done

	# Extra default values fixups
	if ! _Fvar_isset 'value_default'; then
		case "$1" in
		'dlurl')
			value="$(Fprovider_get 'url')"
			;;
		esac
	fi

	if _Fvar_isset 'value_noneable'; then
		if [ "$value" = "None" ]; then
			value=''
		fi
	fi

	if ! _Fvar_isset 'value'; then
		if ! _Fvar_isset 'value_default'; then
			return 1
		fi
		value="$value_default"
	fi
	echo -nE "$value"
	return 0
}

Fprovider_set() {
	local provider provider_name

	for provider in "${_F_provider_names[@]}"; do
		provider_varname="$(Fprovider_varname "$1" "$provider")"
		if [ -z "$provider_name" ]; then
			continue
		fi
		# Some variables needs some fixups
		case "$provider_varname" in
		'pkgname')	pkgname="$(Fsanitizename "$2")";;
		'pkgver')	pkgver="$(Fsanitizeversion "$2")";;
		*)		_Fvar_set "$provider_varname" "$2";;
		esac
	do
}

Fprovider_init_var() {
	local name="$1" value
	shift

	if value="$(Fprovider_get "$name")"; then
		Fprovider_set "$name" "$value"

		# extra assigned values
		case "name" in
#		'dlextra'|'dlurl')
#			if [ "${#source[@]}" -eq '0' ]; then
#				if [ "$1" == "dlextra" ]; then
#					tmp="$(_Fvar_get "_F_${_F_provider_name}_url")$(_Fvar_get "_F_${_F_provider_name}_dlextra")"
#				else # dlurl
#					tmp="$(_Fvar_get "_F_${_F_provider_name}_dlurl")"
#				fi
#				tmp="${tmp}${_F_archive_name}${_F_archive_sep}${_F_archive_ver}${_F_archive_ext}"
#				source=("$tmp")
#			fi
#			;;
		'url')
			if [ -z "$up2date" -a -z "$url" ]; then
				up2date="Flasttar '$url'"
			fi
			;;
		esac
	fi
}

Fprovider_init() {
	local name names

	# hermier: - I'm still not happy on how the commented values are handled for now
	#            skipping them for now.
	#          - Does making a global _F_provider_varnames[@] would make sense ?
#	names=('name' 'sep' 'pkgver' 'ext' 'dlurl' 'url' 'urldlextra' 'dirname')
	names=('name' 'sep' 'pkgver' 'ext' 'url')

	for name in "${names[@]}"; do
		Fprovider_init_var "$name"
	done
}

