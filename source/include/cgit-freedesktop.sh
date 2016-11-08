#!/bin/sh

###
# = cgit-freedesktop.sh(3)
# Michel Hermier <ihermier@frugalware.org>
#
# == NAME
# cgit-freedesktop.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for cgit packages on freedesktop.org.
#
# == EXAMPLE
#
# --------------------------------------------------
# pkgname=libdrm
# pkgver=0.1.4
# pkgrel=1
# pkgdesc="UIM input method for SCIM."
# _F_cgit_dirname="scim"
# Finclude cgit
# url="http://www.scim-im.org/"
# purl="http://cgit.net/project/showfiles.php?group_id=108454"
# depends=('scim>=1.4.4' 'uim')
# options=('scriptlet')
# groups=('xapps-extra')
# archs=('x86_64')
# sha1sums=('9023c205cb1623e749bd5ca7baf721c55f36f279')
# --------------------------------------------------
###
if [ -z "${_F_cgit_freedesktop_dirname}" ]; then
	_F_cgit_freedesktop_dirname="${pkgname}"
fi

if [ -z "${_F_cgit_freedesktop_name}" ]; then
	_F_cgit_freedesktop_name="$(basename ${_F_cgit_freedesktop_dirname})"
fi

###
# == OVERWRITTEN VARIABLES
# * _F_cgit_url
# * _F_cgit_scmurl
# * _F_cgit_dirname
# * _F_cgit_name
###
_F_cgit_url="http://cgit.freedesktop.org"
_F_cgit_scmurl="git://anongit.freedesktop.org/${_F_cgit_freedesktop_dirname}"
_F_cgit_dirname="${_F_cgit_freedesktop_dirname}"
_F_cgit_name="${_F_cgit_freedesktop_name}"

Finclude cgit

