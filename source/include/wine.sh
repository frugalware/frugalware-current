#!/bin/sh

###
# = wine.sh(3)
# James Buren <ryuo@frugalware.org>
#
# == NAME
# wine.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for wine stable & development packages.
#
# == EXAMPLE
# pkgname=wine
# pkgver=1.2.3
# pkgrel=3
# Finclude wine
###

url="http://www.winehq.org"
groups=('xapps-extra')
depends=('lcms2' 'openal' 'libglu' 'libldap>=2.5.4' 'libpcap' 'libpulse' 'libmpg123' 'libgphoto2' 'gettext' 'libxml2' 'ocl-icd' \
	'libxcursor' 'libxi' 'libxrandr' 'libxinerama' 'libxcomposite' 'sane-backends' 'v4l-utils' 'libxrender' 'wayland' \
	'libxslt' 'vkd3d' 'vulkan-icd-loader' 'faudio' 'libosmesa' 'pcsc-lite' 'gst1-plugins-base' 'libxkbcommon')
#32 bit
depends+=('lib32-lcms2' 'lib32-libxcursor' 'lib32-libxi' 'lib32-libxrandr' 'lib32-libxinerama' 'lib32-libxcomposite' \
	'lib32-libxrender' 'lib32-freetype2' 'lib32-libxml2' 'lib32-ncurses' 'lib32-vkd3d' 'lib32-ocl-icd' 'lib32-libxkbcommon' \
	'lib32-libldap>=2.5.4' 'lib32-vulkan-icd-loader' 'lib32-faudio' 'lib32-libosmesa' 'lib32-wayland')
makedepends=('x11-protos' 'cups' 'bison' 'opencl-headers' 'kernel-headers' 'wayland-protocols' 'mingw-w64-gcc')
_F_cd_path="wine-$pkgver"
options=('genscriptlet' 'static' 'nofortify' 'nolto' 'plt' 'ldbfd')
archs=('x86_64')
_F_conf_configure="../configure"
_F_archive_grepv="\-rc"
Fconfopts="	--libdir=/usr/lib \
		--without-oss \
		--with-x \
		--with-wayland \
		--with-gstreamer"
F32confopts+="	--libdir=/usr/lib \
		--without-oss \
		--with-x \
		--with-wayland \
		--with-gstreamer"

Finclude cross32

case "$pkgname" in

wine)
	pkgdesc="An Open Source implementation of the Windows API on top of X and Unix. (Stable)"
	up2date="lynx -dump https://gitlab.winehq.org/api/v4/projects/wine%2Fwine/repository/tags  | jq -r '.[].name' | grep '\.0' | grep -v 9| head -n 1 | sed 's/wine-//g'"
	conflicts=('wine-devel' 'lib32-wine-devel')
	provides=('lib32-wine')
	replaces=('lib32-wine')
	source=(https://dl.winehq.org/wine/source/${pkgver}/wine-$pkgver.tar.xz)
	;;

wine-devel)
	pkgdesc="An Open Source implementation of the Windows API on top of X and Unix. (Development)"
	_F_archive_name="wine"
        up2date="lynx -dump https://gitlab.winehq.org/api/v4/projects/wine%2Fwine/repository/tags  | jq -r '.[].name' | head -n 1 | sed 's/wine-//g'"
	conflicts=('wine' 'lib32-wine-devel')
	provides=('wine' 'lib32-wine-devel')
	replaces=('lib32-wine-devel')
	source=(https://dl.winehq.org/wine/source/10.x/wine-$pkgver.tar.xz)
	;;

default)
	error "Unsupported package: $pkgname"
	Fdie
	;;

esac
_F_cross32_use_default=false

build()
{
	Fcd
	Fpatchall
	Fsed 'lib64' 'lib' configure.ac
	Fautoreconf
	Fexec rm -rf 64Bit_build || Fdie
	Fexec mkdir 64Bit_build || Fdie
	Fexec cd 64Bit_build || Fdie
	Fmake --enable-win64

	Fexec cd .. || Fdie
	Fexec rm -rf 32Bit_build || Fdie
	Fexec mkdir 32Bit_build || Fdie
        Fexec cd 32Bit_build || Fdie
        __cross32_conf_make_opts_pre_save
        __cross32_save_orig_vars
        __cross32_unset_vars
        ## util.sh
        export CHOST="i686-frugalware-linux"
        export Fbuildchost="${CHOST}"

	## cmake.sh , meson.sh
        export CROSS_PREFIX="/usr"
        export CROSS_INC="${CROSS_PREFIX}/${CHOST}/include"
        export CROSS_LIB="lib"
        export CROSS_BIN="${CROSS_PREFIX}/${CHOST}/bin"
        export CROSS_SBIN="${CROSS_PREFIX}/${CHOST}/bin"

        ## common
        export CFLAGS=" -m32 ${CFLAGS_ORIG/x86-64-v2/i686}"
        export CXXFLAGS=" -m32 ${CXXFLAGS_ORIG/x86-64-v2/i686}"
        ## clang is broken for 32bit , force gcc
        export CC="gcc"
        export CXX="g++"
        LDFLAGS+=" -L${CROSS_PREFIX}/${CROSS_LIB} -m32"
        export CPPFLAGS=" -I${CROSS_INC}"
        if [ -n "$_F_cross32_combined" ]; then
                export PKG_CONFIG_PATH="${CROSS_PREFIX}/${CROSS_LIB}/pkgconfig"
        else
                export PKG_CONFIG_LIBDIR="${CROSS_PREFIX}/${CROSS_LIB}/pkgconfig"
        fi
        export ASFLAGS="--32"

        ## we share some tools like tools for building docs
        ## shell scripts and such .. for that matter we need
        ## orig system PATH + 32bit PATH but put 32bit first

        export PATH=/usr/${CHOST}/bin:usr/${CHOST}/bin:$PATH_ORIG

        ## auto tools - default
        if [ -n "$_F_cross32_use_default" ]; then
                if [ -z "$_F_conf_configure" ]; then
                        _F_conf_configure="./configure"
                fi

                F32bindir="/usr/${CHOST}/bin"
                F32sbindir="/usr/${CHOST}/bin"
                F32includedir="/usr/${CHOST}/include"
                F32libdir="/usr/lib"
                F32libexecdir="/usr/${CHOST}/${pkgname}"

                Fconfoptstryset "bindir" "$F32bindir"
                Fconfoptstryset "sbindir" "$F32sbindir"
                Fconfoptstryset "libdir" "$F32libdir"
                Fconfoptstryset "includedir" "$F32includedir"
                Fconfoptstryset "libexecdir" "$F32libexecdir"
        fi

        __cross32_bug_me_set

        Fmake --with-wine64="$Fsrcdir/${_F_cd_path}/64Bit_build" 
        Fmakeinstall  libdir="$Fpkgdir/usr/lib" dlldir="$Fpkgdir/usr/lib/wine"

        Fexec cd ../64Bit_build || Fdie
        Fmakeinstall  libdir="$Fpkgdir/usr/lib" dlldir="$Fpkgdir/usr/lib/wine"

	Fexec cp $Fincdir/wine.conf $Fsrcdir
	Ffile /etc/binfmt.d/wine.conf
	Fln /usr/i686-frugalware-linux/bin/wine-preloader /usr/bin/wine-preloader
	Fln /usr/i686-frugalware-linux/bin/wine /usr/bin/wine

	## we cannot use reset_and_fix here since we don't split anything
	__cross32_unset_vars
	__cross32_export_orig_vars


}
