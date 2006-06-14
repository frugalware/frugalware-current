#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# scm.sh for Frugalware
# distributed under GPL License

# common up2date and an Funpack_scm() function for various "live" FBs

# usage:
# _F_scm_type: can be darcs
# _F_scm_url: url of the repo

# slice the / suffix if there is any
_F_scm_url=${_F_scm_url%/}

if [ "$_F_scm_type" == "darcs" ]; then
	up2date="lynx -source -dump $_F_scm_url/_darcs/inventory|grep ']'|sed -n 's/.*\*\(.*\)\]./\1/;$ p'"
	makedepends=(${makedepends[@]} 'darcs')
fi

Funpack_scm()
{
	if [ "$_F_scm_type" == "darcs" ]; then
		if [ -d "${_F_scm_url##*/}" ]; then
			darcs pull || Fdie
		else
			darcs get --partial $_F_scm_url || Fdie
		fi
		Fcd ${_F_scm_url##*/}
	fi
}


build()
{
	Funpack_scm
	Fbuild
	unset _F_scm_type _F_scm_url
}
