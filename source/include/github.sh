
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
# archs=('x86_64')
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
# * _F_github_sep: defaults to Fpkgversep
# * _F_github_full_archive_name: no default. used for mad tarball names eg:
#   _F_github_full_archive_name="THis_Is-some-MAD1_1_3-nam_e"
# * _F_github_grepv: no default , use like _F_archive_grepv
#
# == APPENDED VARIABLES
# * source()
# == OVERWRITTEN VARIABLES
# * up2date
###

if [ -z "$_F_github_name" ]; then
	_F_github_name="$pkgname"
fi

if [ -z "$_F_github_dirname" ]; then
	_F_github_dirname="$_F_github_name"
fi


if [ -z "$_F_github_ver" ]; then
	_F_github_ver="$pkgver"
fi

if [ -z "$_F_github_author" ]; then
	_F_github_author="$_F_github_name"
fi

if [ -z "$_F_github_ext" ] ; then
	_F_github_ext=".tar.gz"
fi

if [ -z "$_F_github_sep" ]; then
	_F_github_sep="$Fpkgversep"
fi

if [ -z "$url" ]; then
	url=https://github.com/$_F_github_author/$_F_github_name
fi

if [[ -n "$_F_github_tag_v" ]] && [[ -n "$_F_github_tag" ]]; then
	echo "ERROR: Using TAG_V && TAG is not allowed!"
	echo "ERROR: Bailing out, please fix your package.."
	#exit 1
fi

## set source to archive .. seems to be fine.
## releases , tags and tags_v are all under archive

## same for up2date

## bleh
## ok allow to set this as custom name too
if [[ -z "$_F_github_full_archive_name" ]]; then
	if [[ -n "$_F_github_tag_v" ]]; then
		## tag_v should be v1.2.3.tar.gz
		_F_github_full_archive_name="v${_F_github_ver}"
	elif [[ -n "$_F_github_tag" ]]; then
		## tag should be 1.2.3.tar.gz
		_F_github_full_archive_name="${_F_github_ver}"
	else
		## normal stuff should be $pkgname-$pkgver.tar.gz ( but what is normal on github!)
		## everything else _F_github_full_archive_name="someThIng_Like3-1_foo"
		_F_github_full_archive_name="${_F_github_name}${_F_github_sep}${_F_github_ver}"
	fi
fi

## __F* internal
__F_github_full_archive_name="${_F_github_full_archive_name}${_F_github_ext}"
_F_github_source="https://github.com/$_F_github_author/$_F_github_dirname/archive/${__F_github_full_archive_name}"

## heh ok
if [ -n "$_F_archive_grepv" ]; then
	_F_github_grepv="$_F_archive_grepv"
fi

if [ -n "$_F_github_grepv" ]; then
	off='| grep -v -- $_F_github_grepv'
fi

if [ -z "$_F_github_grep" ]; then
        _F_github_grep='archive'
fi

if [ -z "$_F_github_up2date_path" ]; then
       _F_github_up2date="releases"
else
       _F_github_up2date="$_F_github_up2date_path"
fi


## fixme ?
if [ -n "$_F_github_devel" ]; then
	# Not checked, but may work.
	_F_scm_type=git
	_F_scm_url=git://github.com/$_F_github_author/$_F_github_name
	Finclude scm
	unset _F_github_source _F_github_tag _F_github_tag_v source
else
	up2date="lynx -read_timeout=280 -dump  https://github.com/${_F_github_author}/${_F_github_dirname}/${_F_github_up2date} | grep -v 'Source code' | grep  '\https\(.*\)$_F_github_ext'  $off | grep -m1 $_F_github_grep | sed 's/.*\/\(.*\)$_F_github_ext/\1/' | sed 's/^v//' | sed 's/${_F_github_name}${_F_github_sep}//'"
	# On one line for Mr Portability, Hermier Portability.
	source+=("${_F_github_source}")
fi

