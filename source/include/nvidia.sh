#!/bin/sh

###
# = nvidia.sh(3)
# Michel Hermier <hermier@frugalware.org>
#
# == NAME
# nvidia.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for nVidia packages.
#
# == EXAMPLE
# --------------------------------------------------
# pkgname=nvidia
# pkgver=173.14.12
# pkgrel=3
# archs=('x86_64')
# Finclude nvidia
# case "$_F_nvidia_arch" in
# x86_64) sha1sums=('78d3034314df7f9c95526707d7fcf4543f5993ed');;
# esac
# --------------------------------------------------
#
# == OPTIONS
# * _F_nvidia_name (defaults to NVIDIA-Linux-$_F_nvidia_arch-$pkgver-pkg$F_nvidia_pkgnum): the nvidia package name
# * _F_nvidia_arch (defaults guessed using CARCH): the nvidia package arch
# * _F_nvidia_pkgnum (defaults guessed using _F_nvidia_arch): the nvidia package number
# * _F_nvidia_linkver (defaults to pkgver): the link number used by the nvidia shared libraries
# * _F_nvidia_install (defaults to nvidia.install): Install file
# * _F_nvidia_legacyver (optionnal): version string has found at http://www.nvidia.com/object/unix.html
# * _F_nvidia_up2date (defaults depends of _F_nvidia_legacyver): an up2date grep string that will be followed
###
# General variables
if [ -z "$_F_nvidia_arch" ]; then
	_F_nvidia_arch=x86_64
fi
if [ -z "$_F_nvidia_pkgnum" ]; then
	case "$_F_nvidia_arch" in
	x86_64)	_F_nvidia_pkgnum=2;;
	esac
fi
if [ -z "$_F_nvidia_name" ]; then
	_F_nvidia_name=NVIDIA-Linux-$_F_nvidia_arch-$pkgver-pkg$_F_nvidia_pkgnum
fi
if [ -z "$_F_nvidia_linkver" ]; then
	_F_nvidia_linkver=$pkgver
fi
if [ -z "$_F_nvidia_opencl_linkver" ]; then
	_F_nvidia_opencl_linkver=1.0.0
fi
if [ -z "$_F_nvidia_install" ]; then
	_F_nvidia_install="$Fincdir/nvidia.install"
fi
if [ -z "$_F_nvidia_up2date" ]; then
	if [ -z "$_F_nvidia_legacyver" ]; then
		_F_nvidia_up2date="Latest Version:"
	else
		_F_nvidia_up2date="Latest Legacy GPU Version ($_F_nvidia_legacyver series):"
	fi
fi

###
# == OVERWRITTEN VARIABLES
# * groups
# * pkgdesc
# * source
# * up2date
# * url
# * _F_cd_path
# * _F_kernelmod_scriptlet
###
groups=('x11-extra')
pkgdesc="3D accelerated display driver for Nvidia cards"
url="http://www.nvidia.com/object/unix.html"
if [ -n "$_F_nvidia_arch" ]; then
	source=(ftp://download.nvidia.com/XFree86/Linux-$_F_nvidia_arch/$pkgver/$_F_nvidia_name.run)
fi
up2date="lynx -dump http://www.nvidia.com/object/unix.html|grep -m1 '"$_F_nvidia_up2date"'|sed 's/.*]//;s/-/_/'"

_F_cd_path=$_F_nvidia_name
_F_kernelmod_scriptlet=$_F_nvidia_install

###
# == APPENDED VARIABLES
# * depends: add xorg-server and pkgconfig to depends
# * conflicts: add libgl, libgl-headers and libglx to conflicts
# * provides: add libgl, libgl-headers and libglx to provides
# * options: add nostrip to options
###
rodepends=("${rodepends[@]}" 'libvdpau' 'nvidia-settings' 'nvidia-xconfig' 'pkgconfig' 'xorg-server>=1.9.0')
conflicts=("${conflicts[@]}" 'libgl' 'libgl-headers-mesa' 'libglx')
provides=("${provides[@]}" 'libgl' 'libgl-headers-mesa' 'libglx')
options=("${options[@]}" 'nostrip')

if [ "$pkgname" != "nvidia" ]; then
	conflicts=("${conflicts[@]}" 'nvidia')
	provides=("${provides[@]}" 'nvidia')
fi

###
# == INCLUDES DEPENDANCES
# * kernel-module
###

Finclude kernel-module

###
# == PROVIDED FUNCTIONS
# * Fbuild_nvidia_scriptlet: Build the nvidia scriplet
# * Fbuild_nvidia: Builds the software
# * build(): just calls Fbuild_nvidia
###

Fbuild_nvidia_scriptlet()
{
	Fbuild_kernelmod_scriptlet

	# Compatibility code remove after 1.3
	Fsed '$pkgname' "$pkgname" "${Fsrcdir}/$(basename "$_F_kernelmod_scriptlet")"
	Fsed '$pkgver' "$pkgver" "${Fsrcdir}/$(basename "$_F_kernelmod_scriptlet")"
}

Fbuild_nvidia() {
	cd $Fsrcdir
	sh $_F_nvidia_name.run --extract-only
	Fcd
	Fpatchall

	# Build the kernel module
	cd usr/src/nv || Fdie
	ln -s Makefile.kbuild Makefile || Fdie
	make SYSSRC=$_F_kernelmod_dir/build module || Fdie
	cd ../../.. || Fdie

	# Install the kernel module
	Ffilerel usr/src/nv/nvidia.ko $_F_kernelmod_dir/kernel/drivers/video/nvidia.ko
	Fbuild_nvidia_scriptlet

	# Install the binaries
	Fexerel usr/bin/nvidia-* /usr/bin/

	# Install the xorg modules
	Fmkdir usr/lib/xorg/modules/drivers
	Fexerel usr/X11R6/lib/modules/drivers/*.so* /usr/lib/xorg/modules/drivers/
	Fmkdir usr/lib/xorg/modules/extensions
	Fexerel usr/X11R6/lib/modules/extensions/*.so* /usr/lib/xorg/modules/extensions/
	Fln "libglx.so.$_F_nvidia_linkver" "/usr/lib/xorg/modules/extensions/libglx.so"
	# libnvidia-wfb.so is a libwfb replacement if xorg-server don't provides it
#	if [ -e "usr/X11R6/lib/modules/libnvidia-wfb.so.$_F_nvidia_linkver" ]; then
#		Fexerel usr/X11R6/lib/modules/libnvidia-wfb.so* /usr/lib/xorg/modules/
#		Fln "libnvidia-wfb.so.$_F_nvidia_linkver" "/usr/lib/xorg/modules/libnvidia-wfb.so"
#		Fln "libnvidia-wfb.so.$_F_nvidia_linkver" "/usr/lib/xorg/modules/libwfb.so"
#	fi

	# Install the libraries
	Fmkdir /usr/include/GL/
	Ffilerel usr/include/GL/* /usr/include/GL/
	Fexerel usr/lib/libGL.la /usr/lib/libGL.la
	Fsed "__LIBGL_PATH__" "/usr/lib" $Fdestdir/usr/lib/libGL.la
	Fexerel "usr/lib/libGL.so.$_F_nvidia_linkver" /usr/lib/
	Fln "libGL.so.$_F_nvidia_linkver" "/usr/lib/libGL.so"
	Fln "libGL.so.$_F_nvidia_linkver" "/usr/lib/libGL.so.1"
	Fln "libGL.so.$_F_nvidia_linkver" "/usr/lib/libGL.so.1.2"

	Fexerel "usr/lib/libGLcore.so.$_F_nvidia_linkver" /usr/lib/
	Fln "libGLcore.so.$_F_nvidia_linkver" "/usr/lib/libGLcore.so"
	Fln "libGLcore.so.$_F_nvidia_linkver" "/usr/lib/libGLcore.so.1"

	Fexerel "usr/lib/libnvidia-tls.so.$_F_nvidia_linkver" /usr/lib/
	Fln "libnvidia-tls.so.$_F_nvidia_linkver" "/usr/lib/libnvidia-tls.so"
	Fln "libnvidia-tls.so.$_F_nvidia_linkver" "/usr/lib/libnvidia-tls.so.1"

	Ffilerel "usr/X11R6/lib/libXvMCNVIDIA.a" /usr/lib/
	Fexerel "usr/X11R6/lib/libXvMCNVIDIA.so.$_F_nvidia_linkver" /usr/lib/
	Fln "libXvMCNVIDIA.so.$_F_nvidia_linkver" "/usr/lib/libXvMCNVIDIA.so"
	Fln "libXvMCNVIDIA.so.$_F_nvidia_linkver" "/usr/lib/libXvMCNVIDIA.so.1"
	Fln "libXvMCNVIDIA.so.$_F_nvidia_linkver" "/usr/lib/libXvMCNVIDIA_dynamic.so"
	Fln "libXvMCNVIDIA.so.$_F_nvidia_linkver" "/usr/lib/libXvMCNVIDIA_dynamic.so.1"

	if [ -e "usr/lib/libOpenCL.so.$_F_nvidia_opencl_linkver" ]; then
		Fmkdir /etc/OpenCL/vendors/
		Ffilerel etc/OpenCL/vendors/nvidia.icd /etc/OpenCL/vendors/
		Fmkdir /usr/include/CL/
		Ffilerel usr/include/CL/* /usr/include/CL/
		Fexerel "usr/lib/libOpenCL.so.$_F_nvidia_opencl_linkver" /usr/lib/
		Fln "libOpenCL.so.$_F_nvidia_opencl_linkver" "/usr/lib/libOpenCL.so"
		Fln "libOpenCL.so.$_F_nvidia_opencl_linkver" "/usr/lib/libOpenCL.so.1"
	fi

	if [ -e "usr/lib/libnvidia-cfg.so.$_F_nvidia_linkver" ]; then
		Fexerel "usr/lib/libnvidia-cfg.so.$_F_nvidia_linkver" /usr/lib/
		Fln "libnvidia-cfg.so.$_F_nvidia_linkver" "/usr/lib/libnvidia-cfg.so"
		Fln "libnvidia-cfg.so.$_F_nvidia_linkver" "/usr/lib/libnvidia-cfg.so.1"
	fi

	if [ -e "usr/lib/libnvidia-compiler.so.$_F_nvidia_linkver" ]; then
		Fexerel "usr/lib/libnvidia-compiler.so.$_F_nvidia_linkver" /usr/lib/
		Fln "libnvidia-compiler.so.$_F_nvidia_linkver" "/usr/lib/libnvidia-compiler.so"
		Fln "libnvidia-compiler.so.$_F_nvidia_linkver" "/usr/lib/libnvidia-compiler.so.1"
	fi

	if [ -e "usr/lib/libcuda.so.$_F_nvidia_linkver" ]; then
		Fmkdir /usr/include/cuda
		Ffilerel usr/include/cuda/* /usr/include/cuda/
		Fexerel "usr/lib/libcuda.so.$_F_nvidia_linkver" /usr/lib/
		Fln "libcuda.so.$_F_nvidia_linkver" "/usr/lib/libcuda.so"
		Fln "libcuda.so.$_F_nvidia_linkver" "/usr/lib/libcuda.so.1"
	fi

	if [ -e "usr/lib/libvdpau_nvidia.so.$_F_nvidia_linkver" ]; then
		Fexerel "usr/lib/libvdpau_nvidia.so.$_F_nvidia_linkver" /usr/lib/
		Fln "libvdpau_nvidia.so.$_F_nvidia_linkver" "/usr/lib/libvdpau_nvidia.so"
		Fln "libvdpau_nvidia.so.$_F_nvidia_linkver" "/usr/lib/libvdpau_nvidia.so.1"
	fi

	# Weird TLS stuff
	Fmkdir usr/lib/tls
	Fexerel "usr/lib/tls/libnvidia-tls.so.$_F_nvidia_linkver" /usr/lib/tls/
	Fln "libnvidia-tls.so.$_F_nvidia_linkver" "/usr/lib/tls/libnvidia-tls.so"
	Fln "libnvidia-tls.so.$_F_nvidia_linkver" "/usr/lib/tls/libnvidia-tls.so.1"

	# Data
	Fmkdir usr/share/applications
	Ffilerel usr/share/applications/* /usr/share/applications/
	Fmkdir usr/share/pixmaps
	Ffilerel usr/share/pixmaps/* /usr/share/pixmaps/
	Fmkdir usr/man/man1
	Ffilerel usr/share/man/man1/* /usr/man/man1/
	Frm usr/man/man1/nvidia-installer.1.gz

	# Documentation
	Fdocrel LICENSE usr/share/doc/*
	Fln "$pkgname-$pkgver" "/usr/share/doc/$pkgname"

	# Remove nvidia-setings
	Frm /usr/bin/nvidia-settings
	Frm /usr/man/man1/nvidia-settings.1.gz
	Frm /usr/share/applications/nvidia-settings.\*
	Frm /usr/share/pixmaps/nvidia-settings.\*

	# Remove nvidia-xconfig
	Frm /usr/bin/nvidia-xconfig
	Frm /usr/man/man1/nvidia-xconfig.1.gz

	Fkernelver_compress_modules
}

build() {
	Fbuild_nvidia
}
