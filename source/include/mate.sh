#!/bin/sh

###
# = mate.sh(3)
# Anthony Jorion <pingax@frugalware.fr>
#
# == Name
# mate.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for MATE packages.
#
# == EXAMPLE
# --------------------------------------------------
# TODO 
# --------------------------------------------------
#
# == OPTIONS
# * _F_mate_ver specifies the branch of MATE to use.
# * _F_mate_ext (default to .tar.xz) extension of
# the source tarball
###

if [ -z $_F_mate_name ] ; then
	_F_mate_name=$pkgname
fi

if [ -z $_F_mate_ver ] ; then
    _F_mate_ver="1.8"
fi

if [ -z $_F_mate_ext ] ; then
    _F_mate_ext=".tar.xz"
fi

_F_mate_getver()
{
    local tmpver count

    tmpver=`echo $pkgver | tr -d '[0-9][a-z]'`
    count=`expr length "$tmpver"`

    case $count in
        1)
        tmpver="$pkgver"
        ;;
        2)
        tmpver="${pkgver%.*}"
        ;;
        3)
        tmpver="${pkgver%.*.*}"
        ;;
    esac
    echo $tmpver
}

###
# == OVERWRITTEN VARIABLES
# * url
# * up2date
# * source()
###

up2date="Flasttar http://pub.mate-desktop.org/releases/$_F_mate_ver/"

source="http://pub.mate-desktop.org/releases/$_F_mate_ver/${_F_mate_name}-$pkgver${_F_mate_ext}"

url="http://mate-desktop.org"
