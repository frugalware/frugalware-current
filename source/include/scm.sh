#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# scm.sh for Frugalware
# distributed under GPL License

# common up2date and an Funpack_scm() function for various "live" FBs

# usage:
# _F_scm_type: can be darcs, cvs, subversion, git or mercurial - required
# _F_scm_url: url of the repo - required
# _F_scm_password: password of the repo - required for cvs
# _F_scm_module: name of the module to check out - required for cvs and subversion

# slice the / suffix if there is any
_F_scm_url=${_F_scm_url%/}

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
	makedepends=(${makedepends[@]} 'cogito')
elif [ "$_F_scm_type" == "mercurial" ]; then
	# it seems that _every_ repo url has the same web interface which has a nice rss
	up2date="date +%Y%m%d%H%M%S --date '`lynx -dump $_F_scm_url/?style=rss|grep pubDate|sed 's/.*>\(.*\)<.*/\1/;q'`'"
	makedepends=(${makedepends[@]} 'mercurial')
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
	elif [ "$_F_scm_type" == "cvs" ]; then
		touch ~/.cvspass || Fdie
		cvs -d ${_F_scm_url/@/:$_F_scm_password@} login || Fdie
		cvs -d $_F_scm_url co $_F_scm_module || Fdie
		Fcd $_F_scm_module
	elif [ "$_F_scm_type" == "subversion" ]; then
		svn co $_F_scm_url $_F_scm_module || Fdie
		Fcd $_F_scm_module
	elif [ "$_F_scm_type" == "git" ]; then
		cg-clone $_F_scm_url || Fdie
		Fcd `echo $_F_scm_url |sed 's|.*/\(.*\)\..*|\1|'`
	elif [ "$_F_scm_type" == "mercurial" ]; then
		hg clone $_F_scm_url || Fdie
		Fcd ${_F_scm_url##*/}
	fi
	unset _F_scm_type _F_scm_url
}

build()
{
	Funpack_scm
	Fbuild
}
