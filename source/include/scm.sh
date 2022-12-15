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
# archs=('x86_64')
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
# Example for svn:
# --------------------------------------------------
# _F_scm_type="subversion"
# _F_scm_url="svn://svn.mplayerhq.hu/mplayer/trunk"
# --------------------------------------------------
# == OPTIONS
# * _F_scm_type: can be cvs, subversion, git or mercurial - required
# * _F_scm_url: url of the repo - required
# * _F_scm_password: password of the repo - required for cvs
# * _F_scm_module: name of the module to check out - required for cvs
# * _F_scm_tag: name of the tag/branch to use - implemented for cvs/svn/git/mercurial
# * _F_scm_want_up2date: disabled by default , enable if you want to see up2date's for this package
# * _F_scm_git_cloneopts: clone options for git , defaults to --depth=1
###

# slice the / suffix if there is any
_F_scm_url=${_F_scm_url%/}

if [ -z "$_F_scm_git_cloneopts" ]; then
        if [ -z "$_F_scm_tag" ]; then
                _F_scm_git_cloneopts=" --depth=1"
        fi
fi

###
# == OVERWRITTEN VARIABLES
# * up2date
# * makedepends()
###
if [ "$_F_scm_type" == "cvs" ]; then
	if [ -n "$_F_scm_want_up2date" ]; then
		# if you know a better solution, patches are welcome! :)
		up2date="date +%Y%m%d"
	else
		up2date="$pkgver"
	fi
	makedepends=(${makedepends[@]} 'cvs')
elif [ "$_F_scm_type" == "subversion" ]; then
	if [ -n "$_F_scm_want_up2date" ]; then
		up2date="echo -n $pkgver|sed 's/[0-9]\+$//'; svn log $_F_scm_url --limit=1 |sed -n '/^r/s/r\([0-9]\+\) .*/\1/p'"
	else
		up2date="$pkgver"
	fi
	makedepends=(${makedepends[@]} 'subversion')
elif [ "$_F_scm_type" == "git" ]; then
	if [ -n "$_F_scm_want_up2date" ]; then
		up2date="echo -n ${pkgver%%.g*}.g;git ls-remote $_F_scm_url|sed 's/^\(.\{7\}\).*/\1/;q'"
	else
		up2date="$pkgver"
	fi
	makedepends=(${makedepends[@]} 'git')
elif [ "$_F_scm_type" == "mercurial" ]; then
	if [ -n "$_F_scm_want_up2date" ]; then
		# it seems that _every_ repo url has the same web interface which has a nice rss
		up2date="date +%Y%m%d%H%M%S --date '\$(lynx -dump $_F_scm_url/?style=rss|grep pubDate|sed 's/.*>\(.*\)<.*/\1/;q')'"
	else
		up2date="$pkgver"
	fi
	makedepends=(${makedepends[@]} 'mercurial')
fi

###
# == PROVIDED FUNCTIONS
# * Funpack_scm()
###
Funpack_scm()
{
	local extra

	if [ "$_F_scm_type" == "cvs" ]; then
                Fmessage "Checking out with CVS.."
		touch ~/.cvspass || Fdie
		Fexec cvs -d ${_F_scm_url/@/:$_F_scm_password@} login || Fdie
		if [ -n "$_F_scm_tag" ]; then
			Fexec cvs -d $_F_scm_url -r $_F_scm_tag co $_F_scm_module || Fdie
		else
			Fexec cvs -d $_F_scm_url co $_F_scm_module || Fdie
		fi
		Fcd $_F_scm_module
	elif [ "$_F_scm_type" == "subversion" ]; then
                Fmessage "Checking out with SVN.."
		if [ -z "$_F_scm_tag" ]; then
			Fexec svn co $_F_scm_url $pkgname || Fdie
		else
			Fexec svn co -r $_F_scm_tag $_F_scm_url $pkgname || Fdie
		fi
		Fcd $pkgname
	elif [ "$_F_scm_type" == "git" ]; then
                Fmessage "Checking out with GIT.."
		if [ -d $pkgname ]; then
			cd $pkgname
			if [ -n "$_F_scm_tag" ]; then
				Fexec git fetch
			else
				Fexec git pull
			fi
			Fexec git checkout -f
		else
			if [ -d $HOME/git/${_F_scm_url##*/} ]; then
				_F_scm_git_cloneopts+=" --reference $HOME/git/${_F_scm_url##*/}"
			fi
			Fexec git clone $_F_scm_git_cloneopts $_F_scm_url $pkgname || Fdie
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
				Fexec git checkout origin/$_F_scm_tag2 || Fdie
			else
				# this is a tag or commit
				Fexec git checkout $_F_scm_tag2 || Fdie
			fi
		fi
	elif [ "$_F_scm_type" == "mercurial" ]; then
                Fmessage "Checking out with HG.."
		if [ -z "$_F_scm_tag" ]; then
			Fexec hg clone $_F_scm_url || Fdie
		else
			Fexec hg clone -r $_F_scm_tag $_F_scm_url || Fdie
		fi
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
