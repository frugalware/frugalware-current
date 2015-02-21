#!/bin/sh

###
# = lxde.sh(3)
# PacMiam <PacMiam@gmx.fr>
#
# == NAME
# lxde.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for LXDE packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=menu-cache
# pkgver=0.3.2
# pkgdesc="library creating and utilizing caches to speed up the manipulation for freedesktop.org defined application menus"
# groups=('xlib-extra')
# depends=('glib2')
# makedepends=('intltool')
# options+=('scriptlet')
# Finclude lxde
# sha1sums=('1c92ae19326a18ca9ce588704a5d8e746a8ec244')
# --------------------------------------------------
#
# == OPTIONS
# * _F_lxde_gtk3 (default to n): build package with gtk3 support
# * _F_lxde_ext (default to .tar.xz): extension of the source tarball
# * _F_lxde_dirname (default to lxde): project name on sourceforge
# * _F_lxde_subdirs (default to none): subdirs project on sourceforge
# * _F_lxde_github (default to n): use github instead of sourceforge
# * _F_lxde_group (default to lxde-desktop): change default group
# * _F_lxde_rss_limit (default to 100): rss limit on sourceforge
###

if [ ! -z "$_F_lxde_gtk3" ] ; then
    Fconfopts="${Fconfopts[@]} --enable-gtk3"
fi

###
# == OVERWRITTEN VARIABLES
# * up2date
# * source()
###

if [ -z "$url" ] ; then
    url="http://lxde.org/"
fi

if [ -z "$archs" ] ; then
    archs=('i686' 'x86_64')
fi

if [ -z "$pkgrel" ] ; then
    pkgrel=1
fi

# Sourceforge
if [ -z "$_F_lxde_github" ] ; then

    # Tarball extension
    if [ -z "$_F_lxde_ext" ] ; then
        _F_lxde_ext=".tar.xz"
    fi

    # Project name
    if [ -z "$_F_lxde_dirname" ] ; then
        _F_lxde_dirname="lxde"
    fi

    # Sub-directories
    if [ ! -z "$_F_lxde_subdirs" ] ; then
        _F_sourceforge_subdir="$_F_lxde_subdirs"
    fi

    # rss limit
    if [ -z "$_F_lxde_rss_limit" ] ; then
	    _F_lxde_rss_limit=100
    fi

    _F_sourceforge_ext="$_F_lxde_ext"
    _F_sourceforge_dirname="$_F_lxde_dirname"
    _F_sourceforge_rss_limit="$_F_lxde_rss_limit"
    Finclude sourceforge

# Github
else

    # Project name
    if [ -z "$_F_lxde_githubname" ] ; then
        _F_lxde_githubname="$pkgname"
    fi

    _F_github_name="$_F_lxde_githubname"
    _F_github_author="lxde"
    _F_github_tag="y"
    Finclude github
fi

###
# == APPENDED VARIABLES
# * lxde-desktop to groups()
###
if [ -z "$_F_lxde_group" ] ; then
    _F_lxde_group="lxde-desktop"
fi

groups=(${groups[@]} $_F_lxde_group)
