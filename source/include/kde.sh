#!/bin/sh

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

url="http://www.kde.org"
_F_kde_ver=3.5.5
pkgurl="ftp://ftp.solnet.ch/mirror/KDE/stable/$_F_kde_ver/src"
up2date="lynx -dump http://www.kde.org/download/|grep '$_F_kde_name'|sed -n '1 p'|sed 's/.*-\([^ ]*\) .*/\1/'"
source=($pkgurl/$_F_kde_name-$pkgver.tar.bz2)
# qt's post_install is essential for kde pkgs
options=(${options[@]} 'scriptlet')
## If someone want to work on this /etc move here is a way to do it. Just add ${kde_config} to Fconfopts
## !!!BIG FAT WARNING!!!: THE WHOLE KDE AND _EVERY DAMN KDE_APP NEED BE REBUILD WITH THIS_ 
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



