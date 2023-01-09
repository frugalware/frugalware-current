#!/bin/bash

# No author, see below.

###
# = util.sh(3)
#
# == NAME
# util.sh - for Frugalware
#
# == SYNOPSIS
# General utility functions for Frugalware packages.
#
# == EXAMPLE
#
# Example for Fdesktop2:
# --------------------------------------------------
# _F_desktop_name="Adobe Reader"
# _F_desktop_icon="acroread.png"
# _F_desktop_categories="GTK;Utility;Viewer;"
# _F_desktop_mime="application/pdf;"
# --------------------------------------------------
# NOTE: You don't need to use Finclude util, it is automatically included.
#
# == OPTIONS
# * _F_archive_name (defaults to $pkgname)
# * _F_archive_ver (defaults to $pkgver$pkgextraver)
# * _F_archive_prefix (defaults to "")
# * _F_archive_nolinksonly (defaults to no, so that only links are proceeded by
# default)
# * _F_archive_nosort (defaults to no, so sorting is enabled by default)
# * _F_archive_grep (defaults to empty): grep for a regexp before
# searching for the version
# * _F_archive_grepv (defaults to empty): grep -v for a regexp before
# searching for the version
# * _F_cd_path (defaults to $_F_archive_name$Fpkgversep$_F_archive_ver)
# * _F_conf_configure (defaults to ./configure)
# * _F_conf_perl_pipefrom: if set, pipe the output of this command in Fconf()
# for perl packages
# * _F_rcd_name (defaults to $pkgname): the name of the initscript without the
# 'rc.' prefix
# * _F_desktop_filename (defaults to $pkgname.desktop): Name of the .desktop
# file
# * _F_desktop_name (defaults to $pkgname): Name of the desktop icon to be
# displayed
# * _F_desktop_desc (defaults to $pkgdesc): Description of the icon
# * _F_desktop_icon (no default, required): Icon to be used from
# /usr/share/pixmaps
# * _F_desktop_exec (defaults to $pkgname): Name of the executable file
# * _F_desktop_categories ('Application;' is always prepended): You can choose
# one or more from the followings:
# System;Game;AudioVideo;GNOME;KDE;Network;Development;FileTransfer;GTK;
# * _F_desktop_mime (no default, optional): Mimetypes
# * _F_desktop_show_in: Whether the icon should be showed in only a particular
# DE like "XFCE;" for Xfce, "GNOME;" for Gnome, etc.
# * _F_conf_notry: Fconf will try to use prefix, mandir and similar
# parameters by default. You can disable the try of a parameter here.
# * _F_make_opts (defaults V=1 , verbose ): extra make arguments used both with Fmake
# and Fmakeinstall.
###

# Copyright (C) 2005-2006 Bence Nagy <nagybence@tipogral.hu>
# Copyright (C) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# util.sh for Frugalware
# distributed under GPL License

# Parts of Fsort and Funpack_makeself are:
# Copyright (C) 1999-2005 Gentoo Foundation
# This file can be distributed under the terms of the
# GNU General Public License version 2.

###
# == OVERWRITTEN VARIABLES
# Since util.sh is included before the FrugalBuild you may modify these
# variables, they won't be overwritten by util.sh again.
#
# * Fpkgversep (defaults to -): the separator between the package name
# and the package version in the package archive filename.
# * Fsrcdir
# * Fdestdir
# * Fprefix
# * Fsysconfdir
# * Flocalstatedir
# * Fmenudir
# * Farchs
# * Fconfopts
# * LDFLAGS
###
Fpkgversep="-"
Fsrcdir="$startdir/src"
Fdestdir="$startdir/pkg"
Fprefix="/usr"
Fsysconfdir="/etc"
Flocalstatedir="/var"
Finfodir="/usr/share/info"
Fmandir="/usr/share/man"
Fmenudir="/usr/share/applications"
Farchs=('x86_64')
Fbuildchost="`arch`-frugalware-linux"
Fconfopts=""
_F_make_opts="V=1"

unset LANG LC_ALL

## ok gcc6++ makes way to much noise by default
## we don't care about deprecated stuff and such as long is a warning
## so add some C/CXX flags to disable these.
## NOTE: qt5.sh still need his own version of this since qmake gets the flags from qt5 build
## and we sed the C/XX FLAGS in the arch confs

CXXFLAGS+=" -Wno-deprecated -Wno-deprecated-declarations"
CFLAGS+=" -Wno-deprecated -Wno-deprecated-declarations"

###
# == PROVIDED FUNCTIONS
# * Fmessage(): Prints out a message. Parameter: message to display.
###
Fmessage() {
	if [ "$USE_COLOR" = "Y" -o "$USE_COLOR" = "y" ]; then
		echo -e "\033[1;36m==>\033[1;0m \033[1;1m$1\033[1;0m" >&2
	else
		echo "==> $1" >&2
	fi
}

###
# * Fdie():  Cause makepkg to exit.
###
Fdie() {
	exit 2
}

###
# * Fset_lto_toolchain(): Helper function to handle NM, AR, RANLIB for LTO
##

Fset_lto_toolchain() {

	if [ ! "`check_option NOLTO`" ]; then # LTO build
		if [ ! "`check_option CLANG`" ]; then # gcc build
			Fmessage "Setting NM AR RANLIB for gcc LTO build."
			export NM=gcc-nm
			export AR=gcc-ar
			export RANLIB=gcc-ranlib
		else # clang
			Fmessage "Setting NM AR RANLIB for clang LTO build."
			export NM=llvm-nm
			export AR=llvm-ar
			export RANLIB=llvm-ranlib
		fi
	else # NON LTO. Maybe again set clang to llvm-* ?
		Fmessage "Setting NM AR RANLIB for NON-LTO build."
		export NM=binutils-nm
		export AR=binutils-ar
		export RANLIB=binutils-ranlib
	fi
}

## internal
#__is_deprecated() {
#	warning "Function ${FUNCNAME[1]}() is deprecated , port your package away from it."
#}

###
# * Fcpvar(): Copy a variable to another by name. Parameters: 1) Destination
# variable name. 2) Source variable name. Example: Fcpvar use USE_$FOO
#
# NOTE: This is a shortcut to tmp=a$b; c=${!tmp}, Fcpvar can do this in one go
# (and even 'c' can be a variable).
###
Fcpvar() {
	eval "$1=(\"\${$2[@]}\")"
}

###
# * Fuse(): Checks a use variable. Parameter: a use variable value or the use
# variable name. Example: Fuse DEVEL and Fuse $USE_DEVEL are equivalent.
###
Fuse() {
	local use
	Fcpvar use "USE_$1"
	if [ "$use" = "n" ]; then
		return 1
	elif [ "$use" = "y" ]; then
		return 0
	elif [ "$1" = "n" ]; then
		return 1
	elif [ "$1" = "y" ]; then
		return 0
	else
		Fmessage "Unknown use variable $1!"
		Fdie
	fi
}

###
# * Flowerstr(): Lower a string. Parameters: The string to lower.
###
Flowerstr() {
	echo -nE "$@"|tr '[:upper:]' '[:lower:]'
}

###
# *Fupperstr(): Upper a string. Parameters: The string to upper.
###
Fupperstr() {
	echo -nE "$@"|tr '[:lower:]' '[:upper:]'
}

###
# * __Faddsubpkg(): Internal usage only. Registers one new subpkg per call.
# Takes any number of parameters. Each parameter must be in the form of
# "key:value". The key is what the variable would be called if it were a
# regular package.
###
__Faddsubpkg() {
	local key value n i

	n=${#subpkgs[@]}
	for i in "$@"; do
		key="$(echo "$i" | cut -d ':' -f 1)"
		value="$(echo "$i" | cut -d ':' -f 2)"
		[ -z "$key" ] && continue
		case "$key" in
			pkgname)           subpkgs[$n]="$value"            ;;
			pkgdesc)           subdescs[$n]="$value"           ;;
			pkgdesc_localized) subdescs_localized[$n]="$value" ;;
			license)           sublicense[$n]="$value"         ;;
			replaces)          subreplaces[$n]="$value"        ;;
			groups)            subgroups[$n]="$value"          ;;
			depends)           subdepends[$n]="$value"         ;;
			rodepends)         subrodepends[$n]="$value"       ;;
			removes)           subremoves[$n]="$value"         ;;
			conflicts)         subconflicts[$n]="$value"       ;;
			provides)          subprovides[$n]="$value"        ;;
			backup)            subbackup[$n]="$value"          ;;
			install)           subinstall[$n]="$value"         ;;
			options)           suboptions[$n]="$value"         ;;
			archs)             subarchs[$n]="$value"           ;;
		esac
	done
}

###
# * Faddsubpkg(): Adds one subpkg to the list. Appended parameters are the
# corresponding values. Up to 14 parameters are used to define each entry. You
# must pass all previous parameters if you are to access the later ones. If you
# do not need parameter, simply pass an empty string, or leave it out if you do
# not need the later parameters. The order is as follows:
#  1) pkgname   (required)
#  2) pkgdesc   (required)
#  3) depends   (required)
#  4) rodepends
#  5) replaces
#  6) removes
#  7) conflicts
#  8) provides
#  9) license
# 10) backup
# 11) install
# 12) options
# 13) groups
# 14) archs
###
Faddsubpkg() {

	#__is_deprecated
	local g a

	if [ "$#" -lt 3 ]; then
		Fmessage "Faddsubpkg requires at least 3 parameters."
		Fdie
	fi
	if [ -n "${13}" ]; then
		g="${13}"
	else
		g="${groups[@]}"
	fi
	if [ -n "${14}" ]; then
		a="${14}"
	else
		a="${archs[@]}"
	fi
	__Faddsubpkg "pkgname:${1}" "pkgdesc:${2}" "depends:${3}" "rodepends:${4}"   \
	             "replaces:${5}" "removes:${6}" "conflicts:${7}" "provides:${8}" \
	             "license:${9}" "backup:${10}" "install:${11}" "options:${12}"   \
	             "groups:${g}" "archs:${a}"
}

###
# * Fexec(): Display and execute the command line passed as parameter. Note that
# it cannot be used in a pipe context. Parameters: the command line to execute.
###
Fexec() {
	Fmessage "$*"
	"$@"
	return $?
}

###
# * Fcd(): Go to the source directory if it is $Fsrcdir currently. Parameter:
# optional source directory, default is $_F_cd_path.
###
Fcd() {
	if [ -z "$_F_archive_name" ]; then
		_F_archive_name="$pkgname"
	fi
	if [ -z "$_F_archive_ver" ]; then
		_F_archive_ver="$pkgver$pkgextraver"
	fi
	if [ -z "$_F_cd_path" ]; then
		_F_cd_path="$_F_archive_name$Fpkgversep$_F_archive_ver"
	fi

	if [ "$Fsrcdir" = `pwd` ]; then
		if [ "$#" -eq 1 ]; then
			Fmessage "Going to the source directory..."
			cd "$Fsrcdir/$1" || Fdie
		elif [ "$#" -eq 0 ]; then
			Fcd "$_F_cd_path"
		fi
	fi
}

###
# * Fsubdestdir(): Output the subpackage Fdestdir (or Fdestdir if empty).
# Parameter: optional subpkg name.
###
Fsubdestdir() {
	local subdestdir="$Fdestdir"
	if [ -n "$1" ]; then
		subdestdir="$subdestdir.$1"
	fi
	if [ ! -d "$subdestdir" ]; then
		Fmessage "$i is not an existing subpackage."
		Fdie
	fi
	echo "$subdestdir"
}

Fsubdestdirinfo() {
	if [ -n "$1" ]; then
		if [ ! -d "$Fdestdir.$1" ]; then
			Fmessage "$i is not an existing subpackage."
			Fdie
		fi
		echo " in subpkg $1"
	fi
}

###
# * Fmkdir(): Creates a directory under $Fdestdir. Parameter: name of the
# directory to create (you can supply more than one).
###
Fmkdir() {
	local i
	for i in "$@"; do
		if [ ! -d "$Fdestdir/$i" ]; then
			Fmessage "Creating directory: $i"
			mkdir -p "$Fdestdir/$i" || Fdie
		fi
	done
}

###
# * Frm(): Deletes (rm -rf) a directory structure under $Fdestdir. Parameter:
# name of the path to rm -rf (you can supply more than one).
###
Frm() {
	local i
	for i in "$@"; do
		Fmessage "Deleting file(s): $i"
		rm -rf "$Fdestdir/"$i || Fdie
	done
}

###
# * Fcp(): Copy file(s) to $Fdestdir recursively from $Fsrcdir. First
# parameter: name of the file, second parameter: path of the destination.
###
Fcp() {
	Fmessage "Copying file(s): $1"
	if [ -e "$Fdestdir/"$1 ]; then
		cp "$Fdestdir/"$1 "$Fdestdir/"$2 || Fdie
	else
		cp -a "$Fsrcdir/"$1 "$Fdestdir/"$2 || Fdie
	fi
}

###
# * Fcpr(): Copy file(s) to $Fdestdir recursively from $Fsrcdir. First
# parameter: name of the file, second parameter: path of the destination.
###
Fcpr() {
	Fmessage "Copying file(s) recursive: $1"
	warning "Fcpr is deprecated in favor of Fcp"
	cp -a "$Fsrcdir/"$1 "$Fdestdir/"$2 || Fdie
}

###
# * Fcprel(): Copy file(s) to $Fdestdir recursively from the current working
# directory. First parameter: name of the file, second parameter: path of the
# destination.
###
Fcprel() {
	Fmessage "Copying file(s): $1"
	cp -a $1 "$Fdestdir/"$2 || Fdie
}

###
# * Fcprrel(): Copy file(s) to $Fdestdir recursively from the current working
# directory. First parameter: name of the file, second parameter: path of the
# destination.
###
Fcprrel() {
	Fmessage "Copying file(s) recursive: $1"
	warning "Fcprrel is deprecated in favor of Fcprel"
	cp -a $1 "$Fdestdir/"$2 || Fdie
}

###
# * Fmv(): Move a file under $Fdestdir. Parameters: 1) name of the file
# 2) destination.
###
Fmv() {
	Fsubmv '' "$@"
}

###
# * Fsubmv(): Move a file under the subpkg Fdestdir. Parameters: 1) name of the
# subpackage 2) name of the file 3) destination
###
Fsubmv()
{
	local destdir="`Fsubdestdir "$1"`" i info="`Fsubdestdirinfo "$1"`"
	Fmessage "Moving file(s)$info:"
	msg2 "$2 -> $3"
	for i in "$destdir/"$2 # expand $2 if possible
	do
		if [ ! -e "$i" -a ! -h "$i" ]; then # expand failed ?
			Fmessage "No such file $2$info!! Typo? ($i)"
			Fdie
		fi
		mv "$i" "$destdir/$3" || Fdie
	done
}

###
# * Finstallrel(): Install file(s) to $Fdestdir. Parameters: 1) set permission
# mode (as in chmod) 2) file(s) to be installed (defaults to `basename
# $destination`) 3) destination
###
Finstallrel() {
	if [ "$#" -eq 3 ]; then
		if [ -d $2 ]; then
			Fmessage "$2 is a folder, use this only for files"
			Fdie
		fi
		Fmessage "Installing file(s): $2"
		if [ "`ls -l $2 | wc -l`" -gt 1 ]; then
			Fmkdir "$3"
		fi
		if [ -d "$Fdestdir/$3" -a ! "`ls -l $2 | wc -l`" -gt 1 ]; then
			install -D -m "$1" $2 "$Fdestdir/$3/`basename "$2"`" || Fdie
		else
			install -D -m "$1" $2 "$Fdestdir/$3" || Fdie
		fi
	elif [ "$#" -eq 2 ]; then
		Finstallrel "$1" "`basename "$2"`" "$2"
	else
		local i
		for i in "${@:2:$#-2}"; do
			Fmkdir "${@:$#}"
			Finstallrel $1 "$i" "${@:$#}/`basename "$i"`"
		done
	fi
}

###
# * Finstall(): Install file(s) to $Fdestdir from $Fsrcdir. Parameters: 1) set
# permission mode (as in chmod) 2) file(s) to be installed from $Fsrcdir
# (defaults to $Fsrcdir`basename $destination`) 3) destination
###
Finstall() {
	if [ "$#" -eq 3 ]; then
		Finstallrel "$1" "$Fsrcdir/$2" "$3"
	elif [ "$#" -eq 2 ]; then
		Finstallrel "$1" "$Fsrcdir/`basename "$2"`" "$2"
	else
		local i
		for i in "${@:2:$#-2}"; do
			Fmkdir "${@:$#}"
			Finstallrel "$1" "$Fsrcdir/$i" "${@:$#}/`basename "$i"`"
		done
	fi
}

###
# * Fdirschmod(): Changes the permissions of dirs & subdirs inside $Fdestdir.
# First parameter: where to start "find", second parameter: octal mode or
# [+-][rwxstugo].
###
Fdirschmod() {
	Fmessage "Changing directory permissions inside: $1"
	find "$Fdestdir"/$1 -type d -print0 |xargs -0 chmod $2 || Fdie
}

###
# * Fdirchmod(): Changes the permissions of dir $Fdestdir.
# First parameter: octal mode or [+-][rwxstugo] , second parameter: the dir_name
###
Fdirchmod() {

	if [ -e "$Fdestdir/$2" ]; then
		Fmessage "Changing permissions on directory: $2 to $1"
		chmod $1 $Fdestdir/$2 || Fdie
	else
		Fmessage "Directory $2 doesn't exist.."
		Fdie
	fi
}

###
# * Ffileschmod(): Changes the permissions of all file(s) inside $Fdestdir. First
# parameter: where to start "find", second parameter: octal mode or
# [+-][rwxstugo].
###
Ffileschmod() {
	Fmessage "Changing file permissions inside: $1"
        find "$Fdestdir"/$1 -type f -print0 |xargs -0 chmod $2 || Fdie
}

###
# * Fdirschown(): Change the owner and/or group of dirs and subdirs inside
# $Fdestdir. Parameters: 1) where to start "find" 2) owner 3) group.
###
Fdirschown() {
	Fmessage "Changing the owner of directories inside: $1"
	find "$Fdestdir"/$1 -type d -print0 |xargs -0 chown $2:$3 || Fdie
}

###
# * Ffileschown(): Change the owner and/or group of files inside $Fdestdir.
# Parameters: 1) where to start "find" 2) owner 3) group.
###
Ffileschown() {
	Fmessage "Changing the owner of files inside: $1"
	find "$Fdestdir"/$1 -type f -print0 |xargs -0 chown $2:$3 || Fdie
}

###
# * Fexe(): Install executable file(s) to $Fdestdir from $Fsrcdir. First
# parameter: file(s) to be installed from $Fsrcdir (defaults to
# $Fsrcdir/`basename $destination`), second parameter: destination.
###
Fexe() {
	Finstall 0755 "$@"
}

###
# * Fexerel(): Install executable file(s) to $Fdestdir. First parameter:
# file(s) to be installed (defaults to `basename $destination`), second
# parameter: destination.
###
Fexerel() {
	Finstallrel 0755 "$@"
}

###
# * Ffile(): Install regular file(s) to $Fdestdir from $Fsrcdir. First
# parameter: file(s) to be installed from $Fsrcdir (defaults to
# $Fsrcdir/`basename $destination`), second parameter: destination.
###
Ffile() {
	Finstall 0644 "$@"
}

###
# * Ffilerel(): Install regular file(s) to $Fdestdir. First parameter: file(s)
# to be installed (defaults to `basename $destination`), second parameter:
# destination.
###
Ffilerel() {
	Finstallrel 0644 "$@"
}

###
# * Fman(): Install regular file(s) to the man directory from $Fsrcdir.
# Parameter: file(s) to be installed from $Fsrcdir
###
Fman() {
	local i
	for i in $@
	do
		Ffile $i /usr/share/man/man${i##*.}/`basename $i`
	done
}

###
# * Fmanrel(): Install regular file(s) to the man directory.  Parameter:
# file(s) to be installed
###
Fmanrel() {
	local i
	for i in $@
	do
		Ffilerel $i /usr/share/man/man${i##*.}/`basename $i`
	done
}

###
# * Fdoc(): Install documentation file(s) to
# $Fdestdir/usr/share/doc/$pkgname-$pkgver from $Fsrcdir. Also if $file.xx or
# $file.xx_YY present then it will be automatically installed, too. Parameter:
# file(s) to be installed from $Fsrcdir (defaults to $Fsrcdir/`basename
# $destination`).
###
Fdoc() {
	Fmkdir "/usr/share/doc/$pkgname-$pkgver"
	local i
	for i in $@
	do
		if [ -d "$Fsrcdir/$i" ]; then
			Fcp "$i" "/usr/share/doc/$pkgname-$pkgver/"
		else
		Ffile "$i" "/usr/share/doc/$pkgname-$pkgver/"
		local j
		for j in `ls $Fsrcdir|grep "$i\.[a-z_A-Z]\+$"`
		do
			Ffile "$j" "/usr/share/doc/$pkgname-$pkgver/"
		done
		fi
	done
}

###
# * Fdocrel(): Install documentation file(s) to
# $Fdestdir/usr/share/doc/$pkgname-$pkgver. Also if $file.xx or $file.xx_YY
# present then it will be automatically installed, too. Parameter: file(s) to
# be installed (defaults to $Fsrcdir/`basename $destination`).
###
Fdocrel() {
	Fmkdir "/usr/share/doc/$pkgname-$pkgver"
	local i
	for i in $@
	do
		if [ -d "$i" ]; then
			Fcprel "$i" "/usr/share/doc/$pkgname-$pkgver/"
		else
		Ffilerel "$i" "/usr/share/doc/$pkgname-$pkgver/"
		local j
		for j in `ls |grep "$i\.[a-z_A-Z]\+$"`
		do
			Ffilerel "$j" "/usr/share/doc/$pkgname-$pkgver/"
		done
		fi
	done
}

###
# * Ficon(): Install icon file(s) to $Fdestdir/usr/share/pixmaps from $Fsrcdir.
# Parameter: file(s) to be installed from $Fsrcdir.
###
Ficon() {
        Fmkdir "/usr/share/pixmaps"
        Ffile "$@" "/usr/share/pixmaps/"
}

###
# * Ficonrel(): Install icon file(s) to $Fdestdir/usr/share/pixmaps from the
# current working directory.  Parameter: file(s) to be installed.
###
Ficonrel() {
        Fmkdir "/usr/share/pixmaps"
        Ffilerel "$@" /usr/share/pixmaps
}

###
# * Fdesktoprel(): Install desktop file(s) to $Fdestdir/usr/share/applications
# from the current working directory.  Parameter: file(s) to be installed.
###

Fdesktoprel() {
	Fmkdir "/usr/share/applications"
	Ffilerel "$@" /usr/share/applications
}

###
# * Fln(): Create a symlink in $Fdestdir. First parameter: source (i.e.
# mysql/libmysqlclient.so), second parameter: target (i.e. /usr/lib/)
# ($target's dir will be created if necessary).
###
Fln() {
	Fmessage "Creating symlink(s): $1 -> $2"
	Fmkdir "`dirname $2`"
	ln -sf $1 "$Fdestdir"/$2 || Fdie
}

###
# * __Fsed(): Private implementation of Fsed and Freplace. Parameters:
# 1) regexp (see man sed!) 2) replacement 3) file to edit in place.
###
__Fsed() {
	if [ ! -e "$3" ]; then
		error "File $3 not found."
		return 1
	fi
	if [ ! -f "$3" ]; then
		error "File $3 is not a regular file."
		return 1
	fi
	sed -i -e "s|$1|$2|g" "$3" || Fdie
}

###
# * Fsed(): Use sed on file(s). Parameters: 1) regexp (see man sed!) 2)
# replacement 3) file(s) to edit in place.
###
Fsed() {
	local i path
	Fcd
	for i in "${@:3:$#}"; do
		for path in $i; do # expand $i if possible
			Fmessage "Using sed with file: $path"
			__Fsed "$1" "$2" "$path"
		done
	done
}

###
# * Freplace(): Do some parameter substitution on file(s). The parameters
# should be escaped using the "@parameter@" syntax. Parameters:
# 1) Variable to substituate 2) file(s) where the substitution happens.
###
Freplace() {
	local i path
	Fcd
	for i in "${@:2:$#}"; do
		for path in $i; do # expand $i if possible
			Fmessage "Subtituing $1 in file: $path"
			__Fsed "@$1@" "$(eval echo \${$1[@]})" "$path"
		done
	done
}

###
# * Fdeststrip(): Strip $Fdestdir from files in $Fdestdir. Parameter: file(s)
# to strip.
###
Fdeststrip() {
	local i
	for i in "$@"; do
		Fsed "$Fdestdir" "" "$Fdestdir/$i"
	done
}

###
# * __Fpatch(): Internal. Apply a patch with -p1 (or -p0 if -p1 fails).
# Parameter: Patch to apply.
###
__Fpatch() {
	local level="1"
	if ! patch -Np1 --dry-run -i "$Fsrcdir/$1"; then
		if ! patch -Np0 --dry-run -i "$Fsrcdir/$1"; then
			return 1
		fi
		level="0"
	fi
	# if we are here, the patch applied with -p0, so it's no good
	# showing the output again
	if [ "$level" = 0 ]; then
		patch -Np$level --no-backup-if-mismatch -i "$Fsrcdir/$1" || Fdie
	else
		patch -Np$level --no-backup-if-mismatch -i "$Fsrcdir/$1" || Fdie
	fi
	return 0
}

###
# * Fpatch(): Apply a patch. Parameter: Patch to
# apply. A ".gz" or ".bz2" suffix will be ingored.
###
Fpatch() {
	Fcd
	local i
	Fmessage "Using patch: $1"
	if [ -n "`echo "$1" | grep '\.gz$'`" ]; then
		i=`basename "$1" .gz`
	elif [ -n "`echo "$1" | grep '\.bz2$'`" ]; then
		i=`basename "$1" .bz2`
	else
		i=$1
	fi
	if ! __Fpatch "$i"; then
		warning "Patch $i did not apply, trying a dos2unix line ending convertion."
		sed -i 's/\r$//' "$Fsrcdir/$i"
		if ! __Fpatch "$i"; then
			error "Patch $i did not apply at all, check your patch"
			Fdie
		fi
	fi
}

###
# * Fpatchall(): Apply patches from source(). Allowed suffixes are
# \.\(patch[0-9]*\|diff\)\(\.\(gz\|bz2\)\|\). URLs allowed, too. If the patch
# is in some foo-<valid arch>.suffix format, then the patch will be applied on
# the given arch only.
###
Fpatchall() {
	local patch="" patcharch="" i
	for i in "${source[@]}"; do
		if [ -n "`echo "$i" | grep '\.patch[0-9]*$'`" -o -n "`echo "$i" | grep '\.diff$'`" -o -n "`echo "$i" | grep '\.\(patch[0-9]*\|diff\)\.\(gz\|bz2\)$'`" ]; then
			patch=`strip_url "$i"`
			patcharch=`echo $patch|sed 's/.*-\([^-]\+\)\.\(diff\|patch0\?\)$/\1/'`
			if [ "$patcharch" != "$patch" ] && echo " ${Farchs[@]} "|grep -q " $patcharch "; then
				# filter the patch if it's not for the current arch
				if [ "$patcharch" == "$CARCH" ]; then
					Fpatch $patch
				fi
			else
				Fpatch $patch
			fi
		fi
	done
}

Fbuildsystem_make() {
	local command="$1"
	shift

	case "$command" in
	'probe')
		if [ -n "$_F_conf_python_style" ]; then
			test -f GNUmakefile -o -f makefile -o -f Makefile -a ! -f setup.py
		else
			test -f GNUmakefile -o -f makefile -o -f Makefile
		fi
		return $?
		;;
	'make')
		Fexec make $_F_make_opts "$@"
		return $?
		;;
	'install')
		if make -p -q DESTDIR="@FDESTDIR@" "$@" install 2>/dev/null | grep -v 'DESTDIR\s*=' | \
			grep -q "@FDESTDIR@\\|\$DESTDIR\\|\$(DESTDIR)\\|\${DESTDIR}" 2>/dev/null; then
			_F_make_opts="$_F_make_opts DESTDIR=$Fdestdir"
		else
			_F_make_opts="$_F_make_opts prefix=$Fdestdir/$Fprefix"
		fi
		Fexec make $_F_make_opts "$@" install
		return $?
		;;
	*)
		return -1
		;;
	esac
}

###
# * Fconfoptstryset(): A utility function that try to append an option to
# $Fconfopts if $_F_conf_configure supports it and is not already used in
# $confopts. Parameters: 1) Name of the option 2) Value of the option.
###
Fconfoptstryset() {

	if [ -z "$2" ]; then
		return 0
	fi

	# check if $_F_conf_configure supports it
	if ! grep -q -- "--$1" $_F_conf_configure; then
		return 1
	fi

	# check if it was not already set in $Fconfopts
	if echo "$Fconfopts" | grep -q -- "--$1=" - ; then
		return 2
	fi

	if [ -z "$_F_conf_notry" ] || ! echo $1 |grep -q $_F_conf_notry; then
		Fconfopts+=" --$1=$2"
	fi
	return 0

}


__configure_disable_static() {

	if [ ! "`check_option STATIC`" ]; then
		Fconfoptstryset "enable-static" "no"
	fi
}

Fbuildsystem_configure() {
	# This build system USUALLY produce a Fbuildsystem_make compatible environment
	local command="$1"
	shift

	if [ -z "$_F_conf_configure" ]; then
		_F_conf_configure="./configure"
		if [ ! -x "$_F_conf_configure" -a -n "$_F_conf_outsource" ]; then
			_F_conf_configure="$Fsrcdir/$_F_cd_path/configure"
		fi
	fi

	case "$command" in
	'probe')
		test -x "$_F_conf_configure" -o -f "$_F_conf_configure.ac" -o -f "$_F_conf_configure.in"
		return $?
		;;
	'prepare')
		if [ ! -e "$_F_conf_configure" ]; then
			Fautogen
			return $?
		fi
		return 0
		;;
	'configure')
		Fconfoptstryset "prefix" "$Fprefix"
		Fconfoptstryset "sysconfdir" "$Fsysconfdir"
		Fconfoptstryset "localstatedir" "$Flocalstatedir"
		Fconfoptstryset "docdir" "/usr/share/doc/$pkgname-$pkgver"
		Fconfoptstryset "infodir" "$Finfodir"
		Fconfoptstryset "mandir" "$Fmandir"
		Fconfoptstryset "build" "$Fbuildchost"
		#Fconfoptstryset "host" "$Fbuildchost"
		Fconfoptstryset "libexecdir" "/usr/lib/$pkgname"
		#Fconfoptstryset "target" "$Fbuildchost"
		## try to disable silent rules
		## we already set V=1 by default but this isn't going to work
		## when apps using enabled silence rules on ./configure..
		## we really want to know what is going on.
		## don't ask me how to do that for perl/ruby or other stuff -- crazy --
		Fconfoptstryset "enable-silent-rules" "no"
		## disable static by default when !static option
		__configure_disable_static
		Fexec $_F_conf_configure $Fconfopts "$@"
		return $?
		;;
	*)
		return -1
		;;
	esac
}

Fbuildsystem_perl() {
	# This build system produce a Fbuildsystem_make compatible environment
	local command="$1"
	shift

	case "$command" in
	'probe')
		test -f Makefile.PL
		return $?
		;;
	'configure')
		if [ -z "$_F_conf_perl_pipefrom" ]; then
			Fexec perl Makefile.PL "$@" || Fdie
		else
			$_F_conf_perl_pipefrom | perl Makefile.PL "$@" || Fdie
		fi
		return $?
		;;
	'make')
                Fexec make DESTDIR=$Fdestdir MANPATH=/usr/share/man "$@" || Fdie
		unset _F_conf_perl_pipefrom
		Fsed `perl -e 'printf "%vd", $^V'` "current" Makefile
		return $?
		;;
	*)
		return -1
		;;
	esac
}

Fbuildsystem_ruby_configure() {
	# This build system produce a Fbuildsystem_make compatible environment
	local command="$1"
	shift

	case "$command" in
	'probe')
		test -f configure.rb
		return $?
		;;
	'configure')
		Fexec ruby configure.rb --prefix="$Fprefix" "$@"
		return $?
		;;
	*)
		return -1
		;;
	esac
}

Fbuildsystem_ruby_extconf() {
	# This build system produce a Fbuildsystem_make compatible environment
	local command="$1"
	shift

	case "$command" in
	'probe')
		test -f extconf.rb
		return $?
		;;
	'configure')
		Fexec ruby extconf.rb --prefix="$Fprefix" "$@"
		return $?
		;;
	*)
		return -1
		;;
	esac
}

Fbuildsystem_ruby_setup() {
	local command="$1"
	shift

	case "$command" in
	'probe')
		test -f setup.rb
		return $?
		;;
	'configure')
		Fexec ruby setup.rb config "$@"
		return $?
		;;
	'make')
		# Original code used 'setup' directive but setup.rb manual say 'make' have to be checked
		Fexec ruby setup.rb make "$@"
		return $?
		;;
	'install')
		Fexec ruby setup.rb install --prefix=$Fdestdir "$@"
		return $?
		;;
	*)
		return -1
		;;
	esac
}

Fbuildsystem_python_setup() {
	echo "$@"
	local command="$1" _pyver
	shift

	if [ -z "$_F_python_version" ]; then
		_python="python"
		_F_python_libdir=`python -c 'from distutils import sysconfig; print sysconfig.get_python_lib()[1:]'`
		_F_python_ver=`python -c 'from distutils import sysconfig; print sysconfig.get_python_version()'`
	else
		_python="$_F_python_version"

		_pyver="${_F_python_version/python/}"
		case "$_pyver" in
		3)
			## only python3 possible fo now
			_F_python3_libdir=`python3 -c 'from distutils import sysconfig; print(sysconfig.get_python_lib()[1:])'`
			_F_python3_ver=`python3 -c 'from distutils import sysconfig; print(sysconfig.get_python_version())'`
			;;
		*)
			## do not allow _F_python_version="python" .. is default
			Fmessage "Do not use _F_python_version=python , is default"
			Fdie
			;;
		esac
	fi

	if [ -z "$_F_python_install_data_dir" ]; then
		_F_python_install_data_dir="usr/share/"
	fi


	case "$command" in
	'probe')
		test -f setup.py
		return $?
		;;
	'make')
		# does configure and build
		Fexec "$_python" setup.py build "$@" || Fdie
		return $?
		;;
	'install')
		Fexec "$_python" setup.py install --prefix "$Fprefix" --root "$Fdestdir" --install-data $_F_python_install_data_dir "$@" || Fdie
		return $?
		;;
	*)
		return -1
		;;
	esac
}

Fbuildsystem_java_ant() {
	local command="$1"
	shift

	case "$command" in
	'probe')
		test -f build.xml
		return $?
		;;
	'make')
		if declare -f Fant >/dev/null; then
			Fjavacleanup
			Fant "$@" || Fdie
		else
			Fmessage "build.xml found, but missing Finclude java!"
			Fdie
		fi
		;;
	'install')
		if declare -f Fjar >/dev/null; then
			local i
			for i in ${_F_java_jars[@]}
			do
				Fjar $i || Fdie
			done
		else
			Fmessage "build.xml found, but missing Finclude java!"
			Fdie
		fi
		;;
	*)
		return -1
		;;
	esac
}
__as_needed_libtool_hack() {

	if [ ! "`check_option NOASNEEDED`" ]; then
		local lt=$(find . -type f -name libtool)
		if [[ ${lt[@]} ]]; then
			Fmessage "Patching libtool for as-needed:"
			local i
			for i in ${lt[@]}
			do
				Fmessage "--> $i..."
				sed -i -e 's/ -shared / -Wl,--as-needed\0/g' ${i}
				## eg: -shared -> -Wl,--as-needed -shared
			done
		fi
	fi
}

###
# * Fconf(): A wrapper to ./configure. It will try to run ./configure,
# Makefile.PL, extconf.rb and configure.rb, respectively. It will automatically
# add the --prefix=$Fprefix (defaults to /usr), --sysconfdir=$Fsysconfdir
# (defaults to /etc) and the --localstatedir=$Flocalstatedir (defaults to /var)
# switches. The two later will be added only if the configure script support
# it. If you want to pre-set a switch (i.e. add a switch only on a certain arch
# or so) append the $Fconfopts variable. Parameter: switch(es) to pass to the
# configure script.
###
Fconf() {
	Fcd
	Fset_lto_toolchain
	Fmessage "Configuring..."

	if Fbuildsystem_configure 'probe'; then
		Fbuildsystem_configure 'prepare' || Fdie
		Fbuildsystem_configure 'configure' "$@" || Fdie
	elif Fbuildsystem_perl 'probe'; then
		Fbuildsystem_perl 'configure' "$@" || Fdie
	elif Fbuildsystem_ruby_extconf 'probe' ; then
		Fbuildsystem_ruby_extconf 'configure' "$@" || Fdie
	elif Fbuildsystem_ruby_configure 'probe' ; then
		Fbuildsystem_ruby_configure 'configure' "$@" || Fdie
	elif Fbuildsystem_ruby_setup 'probe'; then
		 Fbuildsystem_ruby_setup 'configure' "$@" || Fdie
	fi

	__as_needed_libtool_hack

}

###
# * Fmake(): A wrapper to make and "python setup.py build" after calling
# Fconf(). Parameter: switch(es) to pass to Fconf().
###
Fmake() {
	Fconf "$@"
	Fmessage "Compiling..."
	if Fbuildsystem_make 'probe'; then
		Fbuildsystem_make 'make' || Fdie
	elif Fbuildsystem_python_setup 'probe'; then
		Fbuildsystem_python_setup 'make' "$@" || Fdie
	elif Fbuildsystem_ruby_setup 'probe'; then
		Fbuildsystem_ruby_setup 'make' "$@" || Fdie
	elif Fbuildsystem_java_ant 'probe'; then
		Fbuildsystem_java_ant 'make' "$@" || Fdie
	else
		Fmessage "No Makefile or setup.py found!"
		Fdie
	fi
}

###
# * Fnant(): A wrapper to nant. Parameters: 1) build file to use 2) switch(es)
# to pass to nant.
###
Fnant() {
	Fmessage "Compiling with NAnt..."
	if [ ! -f "$1" ]; then
		nant $@ -D:debug=false -D:install.prefix=/usr -D:install.destdir=$Fdestdir || Fdie
	else
		buildfile=$1
		shift
		nant -buildfile:${buildfile} $@ -D:debug=false -D:install.prefix=/usr || Fdie
	fi
}


__remove_static_libs() {

	if [ ! "`check_option STATIC`" ]; then
		local stl=$(find $Fdestdir -type f -name "*.a")
		if [[ ${stl[@]} ]]; then
			Fmessage "Removing the following static libs:"
			local i
			for i in ${stl[@]}
			do
				Fmessage "--> $i"
				rm -f ${i} || Fdie
			done
		fi
	fi
}

Fremove_static_libs() {

	__remove_static_libs
}

__kill_libtool_dependency_libs() {

	if [ ! "`check_option LIBTOOL`" ]; then

		local la=$(find $Fdestdir -type f -name "*.la")
		if [[ ${la[@]} ]]; then
			#Fmessage "Setting Libtool's dependency_libs=.* to ZERO in:"
			Fmessage "Removing Libtool's .la files:"
			local i
			for i in ${la[@]}
			do
				Fmessage "--> $i"
				#sed -i "s/^dependency_libs=.*/dependency_libs=''/" ${i}
				rm -rf ${i}
			done
		fi
	fi
}

Ffix_la_files() {

	__kill_libtool_dependency_libs
}

###
# * Fmakeinstall(): A wrapper to make install. Calls make DESTDIR=$Fdestir or
# prefix=$Fdestdir/usr install (which is necessary). Also handles python's
# setup.py. Removes /usr/info/dir and /usr/share/info/dir and moves the perl
# modules (if found) to the right location. If an rc.$_F_rcd_name file is
# found, then installs the init script, too. Parameter(s) are passed to
# make/python.
###
Ffix_perl() {
 	if [ -d $Fdestdir/usr/lib/perl5/*.*.* ]; then
        Fmv '/usr/lib/perl5/*.*.*' /usr/lib/perl5/current
    fi
    if [ -d $Fdestdir/usr/lib/perl5 ]; then
        find $Fdestdir/usr/lib/perl5 -name perllocal.pod -exec rm {} \;
        find $Fdestdir/usr/lib/perl5 -name .packlist -exec rm {} \;
    fi
    if [ -e $Fdestdir/usr/lib/perl5/site_perl/*.*.* ]; then
        Fmv '/usr/lib/perl5/site_perl/*.*.*' /usr/lib/perl5/site_perl/current
    fi
    if [ -d $Fdestdir/usr/lib/perl5/site_perl ]; then
        find $Fdestdir/usr/lib/perl5/site_perl -name perllocal.pod -exec rm {} \;
        find $Fdestdir/usr/lib/perl5/site_perl -name .packlist -exec rm {} \;
        rmdir -p --ignore-fail-on-non-empty \
            $Fdestdir/usr/lib/perl5/site_perl/current/*/auto/{*,*/*} \
            &>/dev/null
    fi
}

Fmakeinstall() {
	Fmessage "Installing to the package directory..."
	if Fbuildsystem_make 'probe'; then
		Fbuildsystem_make 'install' "$@" || Fdie
	elif Fbuildsystem_python_setup 'probe'; then
		Fbuildsystem_python_setup 'install' "$@" || Fdie
	elif Fbuildsystem_ruby_setup 'probe'; then
		Fbuildsystem_ruby_setup 'install' "$@" || Fdie
	elif Fbuildsystem_java_ant 'probe'; then
		Fbuildsystem_java_ant 'install' "$@" || Fdie
	else
		Fmessage "No Makefile or setup.py found!"
		Fdie
	fi
	if [ -e $Fdestdir/usr/info/dir ]; then
		Frm /usr/info/dir
	fi
	if [ -e $Fdestdir/usr/share/info/dir ]; then
		Frm /usr/share/info/dir
	fi

	Ffix_perl

	Ffix_la_files
	Fremove_static_libs
}

###
# * Fbuild(): The default build(): Fpatchall, Fmake, Fmakeinstall. Parameter(s)
# are passed to Fmake.
###
Fbuild() {

	if [ -z "$_Fbuild_no_patch" ]; then
		Fpatchall
	fi

	if [ -n "$_Fbuild_autoreconf" ]; then
		Fmessage "Running autoreconf..."
		Fcd
		Fautoreconf
        fi

	Fmake "$@"
	Fmakeinstall
	if echo ${source[@]}|grep -q README.Frugalware; then
		Fdoc README.Frugalware
	fi
}

###
# * build(): just calls Fbuild()
###
build() {
	Fbuild
}

###
# * Facu(): Updates config.sub and config.guess from our automake.
###
Facu() {
	cat /usr/share/automake/config.sub >config.sub
	cat /usr/share/automake/config.guess >config.guess
}

###
# * Fsort(): Similar to sort, but handles versions (i.e. 1.9 vs 1.10 vs 2.0)
# correctly. Uses versort from pacman. Reads the version list from stdin.
# Uses vercmp from pacman-g2 when versort is not found.
###
Fsort() {
	if [ -x /usr/bin/versort ]; then
		/usr/bin/versort
	else

	# Deprecated method of sorting, it's too much slow
	local i= items= left=0
	items=( `cat|tr '\n' ' '` )
	while [[ ${left} -lt ${#items[@]} ]] ; do
		local lowest_idx=${left}
		local idx=$(( ${lowest_idx} + 1 ))
		while [[ ${idx} -lt ${#items[@]} ]] ; do
			i=`vercmp "${items[${lowest_idx}]}" "${items[${idx}]}"`
			[[ $i -gt 0 ]] && lowest_idx=${idx}
			idx=$(( ${idx} + 1 ))
		done
		local tmp=${items[${lowest_idx}]}
		items[${lowest_idx}]=${items[${left}]}
		items[${left}]=${tmp}
		left=$(( ${left} + 1 ))
	done
	echo ${items[@]}|sed 's/ /\n/g'

	fi
}

###
# * Funpack_makeself(): Unpack those pesky makeself generated files... They're
# shell scripts with the binary package tagged onto the end of the archive.
# Loki utilized the format as does many other game companies. Parameters: 1)
# file to unpack 2) offset (optional) 3) tail|dd (optional)
###
Funpack_makeself() {
	local src="$1"
	local skip="$2"
	local exe="$3"

	local shrtsrc="$(basename "${src}")"
	Fmessage "Unpacking ${shrtsrc}"
	local dir=${shrtsrc%.*}
	mkdir $dir
	if [ -z "${skip}" ]
	then
		local ver="`grep -a '#.*Makeself' ${src} | awk '{print $NF}'`"
		local skip=0
		exe=tail
		case ${ver} in
			1.5.*)	# Tested 1.5.{3,4,5} ... guessing 1.5.x series is same.
				skip=$(grep -a ^skip= "${src}" | cut -d= -f2)
				;;
			2.0|2.0.1)
				skip=$(grep -a ^$'\t'tail "${src}" | awk '{print $2}' | cut -b2-)
				;;
			2.1.1)
				skip=$(grep -a ^offset= "${src}" | awk '{print $2}' | cut -b2-)
				let skip="skip + 1"
				;;
			2.1.2)
				skip=$(grep -a ^offset= "${src}" | awk '{print $3}' | head -n 1)
				let skip="skip + 1"
				;;
			2.1.3)
				skip=`grep -a ^offset= "${src}" | awk '{print $3}'`
				let skip="skip + 1"
				;;
			2.1.4|2.1.5)
				skip=$(grep -a offset=.*head.*wc "${src}" | awk '{print $3}' | head -n 1)
				skip=$(head -n ${skip} "${src}" | wc -c)
				exe="dd"
				;;
			*)
				plain "I'm sorry, but I was unable to support the Makeself file."
				plain "Version '${ver}' is not supported."
				Fdie
				;;
		esac
	fi
	case ${exe} in
		tail)	exe="tail -n +${skip} '${src}'";;
		dd)		exe="dd ibs=${skip} skip=1 obs=1024 conv=sync if='${src}'";;
		*)		error "makeself can't handle exe '${exe}'"
				Fdie
	esac

	# Let's grab the first few bytes of the file to figure out what kind of archive it is.
	local tmpfile="$(mktemp)"
	eval ${exe} 2>/dev/null | head -c 512 > "${tmpfile}"
	local filetype="$(file -b "${tmpfile}")"
	case ${filetype} in
		*tar\ archive)
			eval ${exe} | tar --no-same-owner -xf - -C $dir
			;;
		bzip2*)
			eval ${exe} | bzip2 -dc | tar --no-same-owner -xf - -C $dir
			;;
		gzip*)
			eval ${exe} | tar --no-same-owner -xzf - -C $dir
			;;
		compress*)
			eval ${exe} | gunzip | tar --no-same-owner -xf - -C $dir
			;;
		*)
			error "Unknown file type \"${filetype}\"?"
			Fdie
			;;
	esac
}

###
# * Fautoconfize(): Our autogen.sh. Runs aclocal, autoheader, autoconf and
# finally automake.
###
Fautoconfize() {
	Fmessage "Running aclocal autoheader autoconf automake  ..."
	aclocal || Fdie
	autoheader || Fdie
	autoconf || Fdie
	automake -a -c -f || Fdie
}

###
# * Fautoreconf(): runs autoreconf -vif.
###
Fautoreconf() {
	Fmessage "Running autoreconf -vif ..."
	autoreconf -vif || Fdie
}

###
# * Fautogen(): Try to run autogen scripts else run Fautoconfize if not found.
###
Fautogen() {
	local autogen old_pwd="$(pwd)"

	cd "$(dirname "$_F_conf_configure")" || return
	if [ -f "./configure.ac" -o -f "./configure.in" ]; then
		for autogen in './autogen.sh'; do
			if [ -f "$autogen" ]; then
				Fexec "$autogen"
				cd "$old_pwd"
				return
			fi
		done
		Fautoconfize
	fi
	cd "$old_pwd"
}

###
# * Fsanitizename: Clear/fix some common package name string common problems on
# an automated package name retrival/usage (remove duplicate name assignation in
# scripts). Parameters: 1) name (optional) to clean, else stdin if not present.
###
Fsanitizename() {
	if [ $# -gt 0 ]; then
		echo "$1" | Fsanitizename
	else
		sed "s/\(.*\)/\L\1/g;s/ /_/g"
	fi
}

###
# * Fsanitizeversion: Clear/fix some common version string common problems on
# an automated version output (also remove pkgextraver ending). Parameters:
# 1) version (optional) to clean, else stdin if not present.
###
Fsanitizeversion() {
	if [ $# -gt 0 ]; then
		echo "$1" | Fsanitizeversion
	else
		sed "s/%2B/+/g;s/$pkgextraver$//;s/$_F_archive_prefix//;s/-/_/g"
	fi
}

###
# * Fwcat: Extracts a page to stdout. Parameters: 1) url of the page.
###
Fwcat() {
	# NOTE: wget is first because it handle https, while lynx don't support
	# it without user interaction.
	# Note "-e robots=off" disable robots.txt grabbing
	wget -O - -q --no-check-certificate "$1" && return

	# Use lynx in case wget failed since it support "broken" directory url.
	# eg. when http://foo.com/bar instead of http://foo.com/bar/
	lynx -read_timeout=280 -source "$1" 2>/dev/null && return
}

Flasttar_filter='\.tar\(\.gz\|\.bz2\)\?\|\.tgz'
Flastzip_filter='\.zip'

###
# * Flastarchive: Extracts last archive version from a page. Parameters: 1)
# url (optional) of the page, else stdin if not present 2) extension_filter
# for the archive type
###
Flastarchive() {
	if [ -z "$_F_archive_name" ]; then
		_F_archive_name="$pkgname"
	fi

	if [ -z "$1" ]; then
		# If first parameter is empty, ignore it since it is optional
		# Required by Flasttar/Flasttgz/Flasttarbz2
		shift
	fi

	if [ $# -gt 1 ]; then
		local filter lynx="lynx -read_timeout=280 -dump"

		if [ -z "$_F_archive_nolinksonly" ]; then
			lynx+=" -listonly"
		fi

		if [ -n "$_F_archive_grep" ]; then
			filter="$filter | grep -- \"$_F_archive_grep\""
		fi
		if [ -n "$_F_archive_grepv" ]; then
			filter="$filter | grep -v -- \"$_F_archive_grepv\""
		fi
#		eval "$lynx \"$1\" $filter" | Flastarchive "$2" # possible optimisation
		eval "$lynx $1 $filter" | Flastarchive "$2"
	else
		local _Flastarchive_regex="s:.*/$_F_archive_name$Fpkgversep\([^/]*\)\($1\)[^/]*$:\1:p"

		if [ -z "$_F_archive_nosort" ]; then
			sed -n "$_Flastarchive_regex" \
				| Fsort | tail -n1 | Fsanitizeversion
		else
			sed -n "$_Flastarchive_regex" \
				| tail -n1 | Fsanitizeversion
		fi
	fi
}

###
# * Flastdir(): A convenience function to Flastarchive for directories.
# Parameters: 1) url (optional) see Flastarchive
###
Flastdir() {
	local _Flastdir_regex='/'

	if [ -z "$1" ]; then
		Flastarchive "$_Flastdir_regex"
	else
		Flastarchive "$1" "$_Flastdir_regex"
	fi
}

###
# * Flastverdir(): A convenience function to Flastdir for version only
# directories. Parameters: 1) url (optional) see Flastdir
###
Flastverdir() {
	pkgname='' Fpkgversep='' _F_archive_name='' Flastdir "$1"
}

###
# * Flasttar(): A convenience function to Flastarchive for all the known tar
# ball extension. Parameters: 1) url (optional) see Flastarchive
###
Flasttar() {
	Flastarchive "$1" "$Flasttar_filter"
}

###
# * Flasttgz(): A convenience function to Flastarchive for the tgz extension.
# Parameters: 1) url (optional) see Flastarchive
#
# NOTE: this function is obsolete, use Flasttar instead.
###
Flasttgz() {
	Flastarchive "$1" '\.tgz'
}

###
# * Flasttarbz2(): A convenience function to Flastarchive for the tar.bz2
# extension. Parameters: 1) url (optional) see Flastarchive
#
# NOTE: this function is obsolete, use Flasttar instead.
###
Flasttarbz2() {
	Flastarchive "$1" '\.tar\.bz2'
}

###
# * Fup2gnugz(): Up2date line for programs hosted at ftp.gnu.org ( tar.gz ).
##
Fup2gnugz()
{
	up2date="Flasttar 'http://ftp.gnu.org/gnu/$pkgname/?C=M;O=A'"
}

###
# * Fup2gnubz2(): Up2date line for programs hosted at ftp.gnu.org ( tar.bz2 ).
##
Fup2gnubz2()
{
        up2date="Flasttar 'http://ftp.gnu.org/gnu/$pkgname/?C=M;O=A'"
}

###
# * Fdesktop2(): Creates a .desktop for graphical applications. See the OPTIONS
# section for options.
###
Fdesktop2()
{
	dcategories="Application;"
	if [ -z $_F_desktop_filename ] ; then
		deskfilename=$pkgname.desktop
	else
		deskfilename=$_F_desktop_filename.desktop
	fi

	if [ ! -n "$_F_desktop_name" ] ; then
		dname=$pkgname
	else
		dname="$_F_desktop_name"
	fi

	if [ -z "$_F_desktop_desc" ] ; then
		ddesc=$pkgdesc
	else
		ddesc=$_F_desktop_desc
	fi

	if [ ! -z $_F_desktop_icon ] ; then
		dicon=$_F_desktop_icon
	fi

	if [ ! -z "$_F_desktop_exec" ] ; then
		dexec="$_F_desktop_exec"
	else
		dexec=$pkgname
	fi

	if [ ! -z $_F_desktop_categories ] ; then
		dcategories="${dcategories[@]}$_F_desktop_categories"
	fi

	if [ ! -z $_F_desktop_mimetypes ] ; then
		dmime=$_F_desktop_mimetypes
	fi

	if [ ! -z $_F_desktop_show_in ] ; then
		dshowin=$_F_desktop_show_in
	fi

	Fmkdir $Fmenudir
	Fmessage "Installing desktop file: $deskfilename"
	DNAME=$dname DDESC=$ddesc DEXEC=$dexec DICON=$dicon DCATEGORIES=$dcategories DMIME=$dmime envsubst <$Fincdir/fdesktop2.tmpl > $Fdestdir$Fmenudir/$deskfilename

	if [ ! -z $_F_desktop_show_in ] ; then
		echo "OnlyShowIn=$dshowin;" >> $Fdestdir$Fmenudir/$deskfilename
	fi
}

###
# * Fwrapper(): Creates a wrapper for applications. Parameters: 1) wrapper
# string or command 2) name of the wrapper file to be installed under /usr/bin.
# Example: Fwrapper "python /usr/lib/python/foo.py" foo.
###
Fwrapper()
{
	local exe=$2
	mkdir -p $startdir/pkg/usr/bin
	Fmessage "Creating a wrapper: /usr/bin/$exe"
	echo "#!/bin/sh" > $startdir/pkg/usr/bin/$exe
	echo "$1" >> $startdir/pkg/usr/bin/$exe
	chmod 755 $startdir/pkg/usr/bin/$exe
}

###
# * Ftreecmp(): Compare 2 tree and do an action on a compare result. Parameters:
# 1) Fist tree 2) Second tree 3) Action to perform on compared item. The item
# is an inode item (relative to both tree) prefixed with '-', '=' or '+'
# depending if it deleted, still present or added in the comparison from the
# first tree to the second tree.
###
Ftreecmp() {
	local line old=$(mktemp) new=$(mktemp)
	if [ ! -d "$1" -o ! -d "$2" ]; then
		Fmessage "$1 or $2 is not a directory"
		Fdie
	fi
	if [ -z "$3" ]; then
		Fmessage "Comparison function is empty"
		Fdie
	fi
	(cd "$1" && find $_F_treecmp_findopts | sort) > $old
	(cd "$2" && find $_F_treecmp_findopts | sort) > $new
	diff --new-line-format='+%L' --old-line-format='-%L' \
		--unchanged-line-format='=%L' $old $new \
	| while read line
	do
		"$3" "$line" "$1" "$2"
	done
	rm $old $new
}

###
# * __Ftreecmp_cleandestdir: Internal
###
__Ftreecmp_cleandestdir() {
	case "$1" in
	=*)	Frm "${1//=/}" ;;
	esac
}

###
# * Fcleandestdir(): Clean the $Fdestdir from subpackages files, to make
# them conflict less. Parameters: The subpackages to use.
###
Fcleandestdir() {
	local i subdestdir
	for i in "$@"
	do
		Fmessage "Removing conflicting files with $i subpackage."
		subdestdir="`Fsubdestdir "$i"`"
		_F_treecmp_findopts='! -type d' \
		Ftreecmp "$Fdestdir" "$subdestdir" __Ftreecmp_cleandestdir
	done
}

###
# * Fsplit(): Moves a file pattern to a subpackage. Parameters: 1) name of the
# subpackage 2) pattern of the files to move. Example: Fsplit libmysql /usr/lib.
#
# NOTE: You have to quote wildcards to split the proper files! (/foo/* => /foo/\*)
###
Fsplit()
{
	Fsubsplit '' "$@"
}

###
# * Fsubsplit(): Moves a file pattern from a subpackage to another subpackage.
# Parameters: 1) name of the source subpackage 2) name of the dest subpackage
# 3) pattern of the files to move.
#
# NOTE: You have to quote wildcards to split the proper files! (/foo/* => /foo/\*)
###
Fsubsplit()
{
	local srcpkg="$1" srcdir="`Fsubdestdir "$1"`" srcinfo="`Fsubdestdirinfo "$1"`"
	local destpkg="$2" destdir="`Fsubdestdir "$2"`" destinfo="`Fsubdestdirinfo "$2"`"
	local i dir path
	shift 2

	for i in "$@"
	do
		Fmessage "Moving $i$srcinfo to subpackage $destpkg"
		for path in "$srcdir"/$i
		do
			path="`echo ${path%/}`" # Remove / suffix if found
			dir="`dirname ${path#$srcdir}`" # Remove $Fdestdir prefix, and last dir element
			mkdir -p "$destdir/$dir/"
			mv "$path" "$destdir/$dir/" || Fdie
		done
	done
}

###
# * check_option(): Check if a logical flag is defined in options() or not.
# Parameter: name of the logical flag. Example: if [ "`check_option DEVEL`" ];
# then
###
check_option() {
	local i
	for i in "${options[@]}"; do
		if [ "`Flowerstr "$i"`" = "$1" -o "`Fupperstr "$i"`" = "$1" ]; then
			echo -nE "$1"
			return
		fi
	done
}

###
# * Fmsgfmt(): Install gettext po files to binary mo files. Parameters: 1) path
# to locale directory (eg /usr/share/locale) 2) language 3) name of the mo file
# (without the .mo suffix), defaults to $pkgname 4) name of the po file,
# defaults $pkgname-$lang (without the .po suffix). Example: Fmsgfmt
# /usr/share/locale hu file file-hu.
###
Fmsgfmt() {
	local llang mofile pofile slang

	if echo -nE "$2"|grep -q _ ; then
		llang="$2"
		slang=`echo $llang|cut -d _ -f 1`
	else
		llang="${2}_`Fupperstr \"$2\"`"
		slang="$2"
	fi

	[ -n "$3" ] && mofile="$3.mo" || mofile="$pkgname.mo"
	[ -n "$4" ] && pofile="$4.po" || pofile="$pkgname-$slang.po"

	[ -f $Fsrcdir/$pofile ] || Fdie

	Fmkdir $1/$llang/LC_MESSAGES
	msgfmt -o $Fdestdir/$1/$llang/LC_MESSAGES/$mofile $Fsrcdir/$pofile || Fdie
}

###
# * Fextract(): Extract archives. Parameter: file name to extract. Example:
# Fextract pacman.tar.gz.
###
Fextract() {
	local cmd file
	file="${1}"
	case `Flowerstr "$file"` in
		*.tar.bz2|*.tbz2|*.tbz)
		cmd="tar $_F_extract_taropts --use-compress-program=bzip2 -xf $file" ;;
		*.tar.gz|*.tar.z|*.tgz)
		cmd="tar $_F_extract_taropts --use-compress-program=gzip -xf $file" ;;
		*.tar.lz)
                cmd="tar $_F_extract_taropts --use-compress-program=lzip -xf $file" ;;
		*.tar.lzma)
		cmd="tar $_F_extract_taropts --use-compress-program=lzma -xf $file" ;;
		*.tar.xz|*.txz)
		cmd="tar $_F_extract_taropts --use-compress-program=xz -xf $file" ;;
		*.tar)
		cmd="tar $_F_extract_taropts -xf $file" ;;
		*.zip)
		unziphack=1
		cmd="unzip -qqo $file" ;;
		*.cpio.gz)
		cmd="bsdtar -x -f $file" ;;
		*.cpio.bz2)
		cmd="bsdtar -x -f $file" ;;
		*.gz)
		cmd="gunzip -f $file" ;;
		*.bz2)
		cmd="bunzip2 -f $file" ;;
		*.lzma)
		cmd="unlzma -f $file" ;;
		*.xz)
		cmd="unxz -f $file" ;;
		*.7z)
		cmd="7z x $file" ;;
		*)
		cmd="" ;;
	esac
	if [ "$cmd" != "" ]; then
		msg "    $cmd"
		$cmd
		ret=$?
		if [ $ret -ne 0 ]; then
			# unzip will return a 1 as a warning, it is not an error
			if [ "$unziphack" != "1" -o $ret -ne 1 ]; then
				error "Failed to extract ${file}"
				msg "Aborting..."
				Fdie
			fi
		fi
	fi
}


