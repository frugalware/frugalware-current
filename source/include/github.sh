
###
# = github.sh(3)
# Luka Vandervelden <lukc@upyum.com>
#
# == NAME
# github.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages hosted at Github, using git or tarballs
# depending on $USE_DEVEL.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=luafilesystem
# pkgver=1.5.0
# pkgrel=1
# pkgdesc="A library which extends the file-system capabilities of LUA."
# url="http://www.keplerproject.org/luafilesystem/"
# depends=('lua')
# groups=('lib-extra')
# archs=('i686' 'x86_64')
# sha1sums=('1ee2ca3b5dbc3cf7c21c7168a0873b2983b7e241')
# _F_github_author=keplerproject
# Finclude github
# --------------------------------------------------
#
# == OPTIONS
# * _F_github_name: name of the project on Github.
# * _F_github_ver: name of the tag of the wanted version on Github.
# * _F_github_ext: file extension used for this Github archive.
# * _F_github_author: owner of the repository and of the project on which
#   to get the software.
# * _F_github_tag: default is empty, use if source has in $url/tags.
#
# == APPENDED VARIABLES
# * source()
# == OVERWRITTEN VARIABLES
# * up2date
###

if [ -z "$_F_github_name" ]; then
	_F_github_name=$pkgname
fi

if [ -z "$_F_github_dirname" ]; then
	_F_github_dirname=$_F_github_name
fi


if [ -z "$_F_github_ver" ]; then
	_F_github_ver=$pkgver
fi

if [ -z "$_F_github_author" ]; then
	_F_github_author=$_F_github_name
fi

if [ -z "$_F_github_ext" ] ; then
	_F_github_ext=.tar.gz
fi

if [ -z "$_F_github_sep" ]; then
	_F_github_sep="$Fpkgversep"
fi

if [ -z "$url" ]; then
	url=http://github.com/$_F_github_author/$_F_github_name
fi

if [ -z "$_F_github_tag" ] && [ -z "$_F_github_tag_v" ]; then
	_F_github_up2date="downloads"
	_F_github_source="http://github.com/downloads/$_F_github_author/$_F_github_dirname/$_F_github_name$_F_github_sep$_F_github_ver$_F_github_ext"
else
	_F_github_up2date="releases/latest"
	_F_archive_name="archive"
	Fpkgversep="/"
	if [ -z "$_F_github_tag_v" ]; then
		_F_github_source="https://github.com/$_F_github_author/$_F_github_dirname/archive/$_F_github_ver$_F_github_ext"
	else
		_F_github_source="https://github.com/$_F_github_author/$_F_github_dirname/archive/v$_F_github_ver$_F_github_ext"
	fi
	_F_cd_path="$_F_github_name-$_F_github_ver"
fi


if [ "$_F_github_devel" = "yes" ]; then
	# Not checked, but may work.
	_F_scm_type=git
	_F_scm_url=git://github.com/$_F_github_author/$_F_github_name
	Finclude scm
else
	if [ -z "$_F_github_tag_v" ]; then
		up2date="Flastarchive http://github.com/$_F_github_author/$_F_github_dirname/$_F_github_up2date $_F_github_ext"
	else
		up2date="Flastarchive http://github.com/$_F_github_author/$_F_github_dirname/$_F_github_up2date $_F_github_ext | sed 's/v//'"
	fi
	# On one line for Mr Portability, Hermier Portability.
	source=(${source[@]} ${_F_github_source})
fi
