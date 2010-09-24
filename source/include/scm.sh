#!/bin/sh

###
# = scm.sh(3)
# Miklos Vajna <vmiklos@frugalware.org>
#
# == NAME
# scm.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for "live" (pulling out the source directly using a version
# control system) packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=mktemp-cvs
# pkgver=20060614
# pkgrel=1
# pkgdesc="A small program to allow safe temporary file creation from shell scripts."
# url="http://www.mktemp.org/"
# depends=('glibc')
# replaces=('debianutils')
# groups=('base' 'chroot-core')
# archs=('i686' 'x86_64')
# options=('nobuild')
# _F_scm_type="cvs"
# _F_scm_url=":pserver:anoncvs@anoncvs.mktemp.org:/cvs"
# _F_scm_password="anoncvs"
# _F_scm_module="mktemp"
# Finclude scm

# build()
# {
#         Funpack_scm
#         chmod +x config.guess config.sub configure install-sh mkinstalldirs
#         Fbuild
# }
# --------------------------------------------------
# Example for hg:
# --------------------------------------------------
# _F_scm_type="mercurial"
# _F_scm_url="http://thunk.org/hg/e2fsprogs"
# --------------------------------------------------
# Example for git:
# --------------------------------------------------
# _F_scm_type="git"
# _F_scm_url="http://www.kernel.org/pub/scm/linux/pcmcia/pcmciautils.git"
# --------------------------------------------------
# Example for darcs:
# --------------------------------------------------
# _F_scm_type="darcs"
# _F_scm_url="http://darcs.frugalware.org/repos/pacman-tools/"
# --------------------------------------------------
# Example for bzr:
# --------------------------------------------------
# _F_scm_type="bzr"
# _F_scm_url="http://people.ubuntu.com/~pitti/bzr/pmount"
# --------------------------------------------------
# Example for svn:
# --------------------------------------------------
# _F_scm_type="subversion"
# _F_scm_url="svn://svn.mplayerhq.hu/mplayer/trunk"
# --------------------------------------------------
# == OPTIONS
# * _F_scm_type: can be darcs, cvs, subversion, git, mercurial or bzr - required
# * _F_scm_url: url of the repo - required
# * _F_scm_password: password of the repo - required for cvs
# * _F_scm_module: name of the module to check out - required for cvs
# * _F_scm_tag: name of the tag/branch to use - implemented for darcs/cvs/svn/git
###

# slice the / suffix if there is any
_F_scm_url=${_F_scm_url%/}

###
# == OVERWRITTEN VARIABLES
# * up2date
# * makedepends()
###
if [ "$_F_scm_type" == "darcs" ]; then
	up2date="lynx -source -dump $_F_scm_url/_darcs/inventory|grep ']'|sed -n 's/.*\*\(.*\)\]./\1/;$ p'"
	makedepends=(${makedepends[@]} 'darcs')
elif [ "$_F_scm_type" == "cvs" ]; then
	# if you know a better solution, patches are welcome! :)
	up2date="date +%Y%m%d"
	makedepends=(${makedepends[@]} 'cvs')
elif [ "$_F_scm_type" == "subversion" ]; then
	up2date="echo -n $pkgver|sed 's/[0-9]\+$//'; svn log $_F_scm_url --limit=1 |sed -n '/^r/s/r\([0-9]\+\) .*/\1/p'"
	makedepends=(${makedepends[@]} 'subversion')
elif [ "$_F_scm_type" == "git" ]; then
	up2date="echo -n ${pkgver%%.g*}.g;git ls-remote $_F_scm_url|sed 's/^\(.\{7\}\).*/\1/;q'"
	makedepends=(${makedepends[@]} 'git')
elif [ "$_F_scm_type" == "mercurial" ]; then
	# it seems that _every_ repo url has the same web interface which has a nice rss
	up2date="date +%Y%m%d%H%M%S --date '`lynx -dump $_F_scm_url/?style=rss|grep pubDate|sed 's/.*>\(.*\)<.*/\1/;q'`'"
	makedepends=(${makedepends[@]} 'mercurial')
elif [ "$_F_scm_type" == "bzr" ]; then
	up2date="echo -n ${pkgver%%.bzr*}.bzr;bzr revno $_F_scm_url"
	makedepends=(${makedepends[@]} 'bzr')
fi

###
# == PROVIDED FUNCTIONS
# * Funpack_scm()
###
Funpack_scm()
{
	local extra

	if [ "$_F_scm_type" == "darcs" ]; then
		if [ -n "$_F_scm_tag" ]; then
			extra="--tag=$_F_scm_tag"
		fi
		if [ -d "${_F_scm_url##*/}" ]; then
			darcs pull $extra || Fdie
		else
			darcs get --lazy $_F_scm_url $extra || Fdie
		fi
		Fcd ${_F_scm_url##*/}
	elif [ "$_F_scm_type" == "cvs" ]; then
		touch ~/.cvspass || Fdie
		cvs -d ${_F_scm_url/@/:$_F_scm_password@} login || Fdie
		if [ -n "$_F_scm_tag" ]; then
			cvs -d $_F_scm_url -r $_F_scm_tag co $_F_scm_module || Fdie
		else
			cvs -d $_F_scm_url co $_F_scm_module || Fdie
		fi
		Fcd $_F_scm_module
	elif [ "$_F_scm_type" == "subversion" ]; then
		if [ -z "$_F_scm_tag" ]; then
			svn co $_F_scm_url $pkgname || Fdie
		else
			svn co -r $_F_scm_tag $_F_scm_url $pkgname || Fdie
		fi
		Fcd $pkgname
	elif [ "$_F_scm_type" == "git" ]; then
		if [ -d $pkgname ]; then
			cd $pkgname
			if [ -n "$_F_scm_tag" ]; then
				git fetch
			else
				git pull
			fi
			git checkout -f
		else
			if [ -d $HOME/git/${_F_scm_url##*/} ]; then
				_F_scm_git_cloneopts="$_F_scm_git_cloneopts --reference $HOME/git/${_F_scm_url##*/}"
			fi
			git clone $_F_scm_git_cloneopts $_F_scm_url $pkgname || Fdie
			cd $pkgname
		fi
		if [ -n "$_F_scm_tag" ]; then
			# 1.6.6.rc1.52.gff86bdd -> 1.6.6.rc1.52-gff86bdd
			# 1.6.6.rc1 -> 1.6.6-rc1
			# 1.6.6 -> 1.6.6
			if echo $_F_scm_tag |grep -q -- '\(\.g\|\.rc\)'; then
				_F_scm_tag2=$(echo $_F_scm_tag|sed 's/\(.*\)\.\([^.]\)/\1-\2/')
			else
				_F_scm_tag2=$_F_scm_tag
			fi
			if [ -f .git/refs/remotes/origin/$_F_scm_tag2 ]; then
				# this is a branch
				git checkout origin/$_F_scm_tag2 || Fdie
			else
				# this is a tag or commit
				git checkout $_F_scm_tag2 || Fdie
			fi
		fi
	elif [ "$_F_scm_type" == "mercurial" ]; then
		hg clone $_F_scm_url || Fdie
		Fcd ${_F_scm_url##*/}
	elif [ "$_F_scm_type" == "bzr" ]; then
		if [ ! -d "${_F_scm_url##*/}" ]; then
			bzr branch --stacked $_F_scm_url || Fdie
			Fcd ${_F_scm_url##*/}
		else
			Fcd ${_F_scm_url##*/}
			bzr revert || Fdie
			bzr pull || Fdie
		fi
	fi
}

###
# * build() just calls Funpack_scm and Fbuild
###
build()
{
	Funpack_scm
	Fbuild
}
