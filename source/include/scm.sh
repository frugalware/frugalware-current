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
# _F_scm_module="mplayer"
# --------------------------------------------------
# == OPTIONS
# * _F_scm_type: can be darcs, cvs, subversion, git, mercurial or bzr - required
# * _F_scm_url: url of the repo - required
# * _F_scm_password: password of the repo - required for cvs
# * _F_scm_module: name of the module to check out - required for cvs and subversion
# * _F_scm_tag: name of the tag/branch to use - implemented for darcs/cvs
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
	up2date="svn log $_F_scm_url --limit=1 |sed -n '/^r/s/r\([0-9]\+\) .*/\1/p'"
	makedepends=(${makedepends[@]} 'subversion')
elif [ "$_F_scm_type" == "git" ]; then
	up2date="date +%Y%m%d%H%M%S --date '`curl -I $_F_scm_url/HEAD 2>&1|sed -n '/^Last-Modified/s/^[^:]*: //p'`'"
	makedepends=(${makedepends[@]} 'git')
elif [ "$_F_scm_type" == "mercurial" ]; then
	# it seems that _every_ repo url has the same web interface which has a nice rss
	up2date="date +%Y%m%d%H%M%S --date '`lynx -dump $_F_scm_url/?style=rss|grep pubDate|sed 's/.*>\(.*\)<.*/\1/;q'`'"
	makedepends=(${makedepends[@]} 'mercurial')
elif [ "$_F_scm_type" == "bzr" ]; then
	up2date="bzr log -r revno:-1 $_F_scm_url|grep ^revno|sed 's/revno: //'"
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
			darcs get --partial $_F_scm_url $extra || Fdie
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
		svn co $_F_scm_url $_F_scm_module || Fdie
		Fcd $_F_scm_module
	elif [ "$_F_scm_type" == "git" ]; then
		git clone $_F_scm_url || Fdie
		Fcd `echo $_F_scm_url |sed 's|.*/\(.*\)\..*|\1|'`
	elif [ "$_F_scm_type" == "mercurial" ]; then
		hg clone $_F_scm_url || Fdie
		Fcd ${_F_scm_url##*/}
	elif [ "$_F_scm_type" == "bzr" ]; then
		bzr branch $_F_scm_url || Fdie
		Fcd ${_F_scm_url##*/}
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
