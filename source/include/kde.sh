#!/bin/sh

# (c) 2007 Gabriel Craciunescu <crazy@frugalware.org>
# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# kde.sh for Frugalware
# distributed under GPL License

# common url, up2date, and source(), and build() for kde packages

if [ -z "$_F_kde_name" ]; then
        _F_kde_name=$pkgname
fi

if [ -z "$_F_kde_build_debug" ]; then
        _F_kde_build_debug=0
fi

if [ -z "$_F_cd_path" ]; then
        _F_cd_path=$_F_kde_name-$pkgver
fi

if [ -z "$_F_kde_reconf" ]; then
        _F_kde_reconf=0
fi

if [ -z "$_F_kde_split_docs" ]; then
        _F_kde_split_docs=0
fi

if [ -z "$_F_kde_defaults" ]; then
	_F_kde_defaults=1
fi

## This only works on 'kde core' and conflicts with some _F_sourceforge
## options so allow to disable when isset to 0 , default is enabled
## TODO: add mirror option 
if [ "$_F_kde_defaults" -eq 1 ]; then
	url="http://www.kde.org"
	_F_kde_ver=3.5.6
	pkgurl="ftp://ftp.solnet.ch/mirror/KDE/stable/$_F_kde_ver/src"
	up2date="lynx -dump http://www.kde.org/download/|grep '$_F_kde_name'|sed -n '1 p'|sed 's/.*-\([^ ]*\) .*/\1/'"
	source=($pkgurl/$_F_kde_name-$pkgver.tar.bz2)
fi
# qt's post_install is essential for kde pkgs
options=(${options[@]} 'scriptlet')
## If someone want to work on this /etc move here is a way to do it. Just add ${kde_config} to Fconfopts
## !!!BIG FAT WARNING!!!: THE WHOLE KDE AND _EVERY DAMN KDE_APP NEED BE REBUILD WITH THIS_.
##			  KDE{APPS} NEED BE FORCED TO USE THIS BY DEFAULT
## 			  !!! DO NOT EVER REMOVE THIS FROM DEFAULTS ONCE IS ADDED OR KDE BREAKS !!!

#kde_config="kde_confdir=/etc/kde3/config \
#            kde_kcfgdir=/etc/kde3/config.kcfg"

Fconfopts="$Fconfopts \
                --disable-dependency-tracking \
                --with-gnu-ld \
                --enable-gcc-hidden-visibility \
                --enable-new-ldflags \
		--disable-finale"

if [ "$_F_kde_build_debug" -eq 1 ]; then
        Fconfopts="$Fconfopts --enable-debug --with-debug"
else
        Fconfopts="$Fconfopts --disable-debug --without-debug"
fi


## Things for kde apps

if [ ! -z "$_F_kde_id" ]; then
        url="http://www.kde-apps.org/content/show.php?content=$_F_kde_id"
        up2date="lynx -dump -nolist $url|grep -m1 'Version:'|sed 's/.*: *\(.*\)$/\1/'"
fi

if [ ! -z "$_F_kde_id2" ]; then
        url="http://www.kde-look.org/content/show.php?content=$_F_kde_id2"
        up2date="lynx -dump -nolist $url|grep -m1 'Version:'|sed 's/.*: *\(.*\)$/\1/'"
fi


Fbuild_kde_reconf()
{
        if [ "$_F_kde_reconf" -eq 1 ]; then
                Fcd
                Fpatchall
                make -f admin/Makefile.common cvs || Fdie
        fi
}

Fbuild_kde_split_docs()
{
        if [ "$_F_kde_split_docs" -eq 1 ]; then
                Fsplit $_F_kde_name-docs usr/share/doc
        fi
}


Fbuild_kde()
{

if [  "$_F_kde_reconf" -eq 1 ]; then
        Fbuild_kde_reconf
        Fconf \
		DO_NOT_COMPILE="$_F_kde_do_not_compile"
        make || Fdie
        Fmakeinstall
else
	Fbuild \
		DO_NOT_COMPILE="$_F_kde_do_not_compile"
fi
        Fbuild_kde_split_docs
}


build()
{
        Fbuild_kde
}

