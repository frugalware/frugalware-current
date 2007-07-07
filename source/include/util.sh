#!/bin/sh

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
# * _F_cd_path (defaults to $pkgname-$pkgver$pkgextraver)
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
Fsrcdir="$startdir/src"
Fdestdir="$startdir/pkg"
Fprefix="/usr"
Fsysconfdir="/etc"
Flocalstatedir="/var"
Fmenudir="/usr/share/applications"
Farchs=('i686' 'x86_64' 'ppc')
Fconfopts="--prefix=$Fprefix"
export LDFLAGS="-Wl,--hash-style=both"

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
# * Fcd(): Go to the source directory if it is $Fsrcdir currently. Parameter:
# optional source directory, default is $_F_cd_path.
###
Fcd() {
	if [ "$Fsrcdir" = `pwd` ]; then
		if [ "$#" -eq 1 ]; then
			Fmessage "Going to the source directory..."
			cd "$Fsrcdir/$1" || Fdie
		elif [ "$#" -eq 0 ]; then
			if [ -z "$_F_cd_path" ]; then
				_F_cd_path="$pkgname-$pkgver$pkgextraver"
			fi
			Fcd "$_F_cd_path"
		fi
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
# * Frm(): Deletes (rm -rf) a directory stucture under $Fdestdir. Parameter:
# name of the path to rm -rf (you can supply more than one).
###
Frm() {
	local i
	for i in "$@"; do
		Fmessage "Deleting file(s): $i"
		rm -rf "$Fdestdir"/$i || Fdie
	done
}

###
# * Fcp(): Copy file(s) under $Fdestdir. First parameter: name of the file,
# second parameter: path of the destination.
###
Fcp() {
	Fmessage "Copying file(s): $1"
	cp "$Fdestdir/"$1 "$Fdestdir"/$2 || Fdie
}

###
# * Fcpr(): Copy file(s) to $Fdestdir recursively from $Fsrcdir. First
# parameter: name of the file, second parameter: path of the destination.
###
Fcpr() {
	Fmessage "Copying file(s) recursive: $1"
	cp -a "$Fsrcdir/"$1 "$Fdestdir"/$2 || Fdie
}

###
# * Fcprrel(): Copy file(s) to $Fdestdir recursively from the current working
# directory. First parameter: name of the file, second parameter: path of the
# destination.
###
Fcprrel() {
	Fmessage "Copying file(s) recursive: $1"
	cp -a $1 "$Fdestdir"/$2 || Fdie
}

###
# * Fmv(): Move a file under $Fdestdir. First parameter: name of the file,
# second parameter: path of the destination.
###
Fmv() {
	Fmessage "Moving file(s): $1"
	mv "$Fdestdir/"$1 "$Fdestdir"/$2 || Fdie
}

###
# * Finstallrel(): Install file(s) to $Fdestdir. Parameters: 1) set permission
# mode (as in chmod) 2) file(s) to be installed (defaults to `basename
# $destination`) 3) destination
###
Finstallrel() {
	if [ "$#" -eq 3 ]; then
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
	find "$Fdestdir"/$1 -type d |xargs chmod $2 || Fdie
}

###
# Ffileschmod(): Changes the permissions of all file(s) inside $Fdestdir. First
# parameter: where to start "find", second parameter: octal mode or
# [+-][rwxstugo].
###
Ffileschmod() {
	Fmessage "Changing file permissions inside: $1"
        find "$Fdestdir"/$1 -type f |xargs chmod $2 || Fdie
}

###
# * Fdirschown(): Change the owner and/or group of dirs and subdirs inside
# $Fdestdir. Parameters: 1) where to start "find" 2) owner 3) group.
###
Fdirschown() {
	Fmessage "Changing the owner of directories inside: $1"
	find "$Fdestdir"/$1 -type d |xargs chown $2:$3 || Fdie
}

###
# * Ffileschown(): Change the owner and/or group of files inside $Fdestdir.
# Parameters: 1) where to start "find" 2) owner 3) group.
###
Ffileschown() {
	Fmessage "Changing the owner of files inside: $1"
	find "$Fdestdir"/$1 -type f |xargs chown $2:$3 || Fdie
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
		Ffile /usr/share/man/man${i##*.}/$i
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
		Ffilerel /usr/share/man/man${i##*.}/$i
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
		if [ -d "$i" ]; then
			Fcpr "$Fsrcdir/$i" "/usr/share/doc/$pkgname-$pkgver/"
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
			Fcprrel "$i" "/usr/share/doc/$pkgname-$pkgver/"
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
# * Fln(): Create a symlink in $Fdestdir. First parameter: source (i.e.
# mysql/libmysqlclient.so), second parameter: target (i.e. /usr/lib/)
# ($target's dir will be created if necessary).
###
Fln() {
	Fmessage "Creating symlink(s): $1"
	Fmkdir "`dirname $2`"
	ln -sf $1 "$Fdestdir"/$2 || Fdie
}

###
# * Fsed(): Use sed on file(s). Parameters: 1) regexp (see man sed!) 2)
# replacement 3) file(s) to edit in place.
###
Fsed() {
	Fcd
	for i in ${@:3:$#}; do
		Fmessage "Using sed with file: $i"
		sed -i -e "s|$1|$2|g" "$i" || Fdie
	done
}

###
# * Fdeststrip(): Strip $Fdestdir from files in $Fdestdir. Parameter: file(s)
# to strip.
###
Fdeststrip() {
	local i
	for i in "$@"; do
		Fsed "$Fdestdir" "" $Fdestdir/$i
	done
}

###
# * Fpatch(): Apply a patch with -p1 (or -p0 if -p1 fails). Parameter: Patch to
# apply. A ".gz" or ".bz2" suffix will be ingored.
###
Fpatch() {
	Fcd
	local i level="1"
	Fmessage "Using patch: $1"
	if [ -n "`echo "$1" | grep '\.\(patch[0-9]*\|diff\)\.gz$'`" ]; then
		i=`basename "$1" .gz`
	elif [ -n "`echo "$1" | grep '\.\(patch[0-9]*\|diff\)\.bz2$'`" ]; then
		i=`basename "$1" .bz2`
	else
		i=$1
	fi
	if patch -Np0 --dry-run -i "$Fsrcdir/$i" >/dev/null && \
		! patch -Np1 --dry-run -i "$Fsrcdir/$i" >/dev/null; then
		level="0"
	fi
	patch -Np$level --no-backup-if-mismatch -i "$Fsrcdir/$i" || Fdie
}

###
# * Fpatchall(): Apply patches from source(). Allowed suffixes are
# \.\(patch[0-9]*\|diff\)\(\.\(gz\|bz2\)\|\). URLs allowed, too. If the patch
# is in some foo-<valid arch>.suffix format, then the patch will be applied on
# the given arch only.
###
Fpatchall() {
	local patch="" patcharch=""
	for i in ${source[@]}; do
		if [ -n "`echo "$i" | grep \.patch[0-9]*$`" -o -n "`echo "$i" | grep \.diff$`" -o -n "`echo "$i" | grep '\.\(patch[0-9]*\|diff\)\.\(gz\|bz2\)$'`" ]; then
			patch=`strip_url "$i"`
			patcharch=`echo $patch|sed 's/.*-\([^-]\+\)\.\(diff\|patch0\?\)$/\1/'`
			if [ "$patcharch" != "$patch" ] && echo ${Farchs[@]}|grep -q $patcharch; then
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

###
# * Fconf(): A wrapper to ./configure. It will try to run ./configure,
# Makefile.PL, extconf.rb and configure.rb, respectively. It will automatically
# add the --prefix=$Fprefix (defaults to /usr), --sysconfdir=$Fsysconfdir
# (defaults to /etc) and the --localstatedir=$Flocalstatedir (defaults to /var)
# switches. The two later will be added only if the configure script support
# it. If you want to pre-set a switch (i.e. add a switch only on a ceratin arch
# or so) apped the $Fconfopts variable. Parameter: switch(es) to pass to the
# configure script.
###
Fconf() {
	Fcd
	Fmessage "Configuring..."
	if [ -z "$_F_conf_configure" ]; then
		_F_conf_configure="./configure"
	fi
	if [ -x $_F_conf_configure ]; then
		grep -q sysconfdir $_F_conf_configure && \
			Fconfopts="$Fconfopts --sysconfdir=$Fsysconfdir"
		grep -q localstatedir $_F_conf_configure && \
			Fconfopts="$Fconfopts --localstatedir=$Flocalstatedir"
		$_F_conf_configure $Fconfopts "$@" || Fdie
	elif [ -f Makefile.PL ]; then
		if [ -z "$_F_conf_perl_pipefrom" ]; then
			perl Makefile.PL DESTDIR=$Fdestdir "$@" || Fdie
		else
			$_F_conf_perl_pipefrom | perl Makefile.PL DESTDIR=$Fdestdir "$@" || Fdie
		fi
		unset _F_conf_perl_pipefrom
		Fsed `perl -e 'printf "%vd", $^V'` "current" Makefile
	elif [ -f extconf.rb ]; then
		ruby extconf.rb --prefix="$Fprefix" "$@" || Fdie
	elif [ -f configure.rb ]; then
		./configure.rb --prefix="$Fprefix" "$@" || Fdie
	fi
}

###
# * Fmake(): A wrapper to make and "python setup.py build" after calling
# Fconf(). Paramter: switch(es) to pass to Fconf().
###
Fmake() {
	Fconf "$@"
	Fmessage "Compiling..."
	if [ -f GNUmakefile -o -f makefile -o -f Makefile ]; then
		make || Fdie
	elif [ -f setup.py ]; then
		python setup.py build "$@" || Fdie
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

###
# * Fmakeinstall(): A wrapper to make install. Calls make DESTDIR=$Fdestir or
# prefix=$Fdestdir/usr install (which is necessary). Also handles python's
# setup.py. Removes /usr/info/dir and /usr/share/info/dir and moves the perl
# modules (if found) to the right location. If an rc.$_F_rcd_name file is
# found, then installs the init script, too. Parameter(s) are passed to
# make/python.
###
Fmakeinstall() {
	Fmessage "Installing to the package directory..."
	if [ -f GNUmakefile -o -f makefile -o -f Makefile ]; then
		if grep -q DESTDIR GNUmakefile makefile Makefile 2>/dev/null; then
			make DESTDIR="$Fdestdir" "$@" install || Fdie
		else
			make prefix="$Fdestdir"/"$Fprefix" "$@" install || Fdie
		fi
	elif [ -f setup.py ]; then
		python setup.py install --prefix "$Fprefix" --root "$Fdestdir" "$@" || Fdie
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
	if [ -d $Fdestdir/usr/lib/perl5/?.?.? ]; then
		Fmv '/usr/lib/perl5/?.?.?' /usr/lib/perl5/current
	fi
	if [ -d $Fdestdir/usr/lib/perl5 ]; then
		find $Fdestdir/usr/lib/perl5 -name perllocal.pod -exec rm {} \;
		find $Fdestdir/usr/lib/perl5 -name .packlist -exec rm {} \;
	fi
	if [ -e $Fdestdir/usr/lib/perl5/site_perl/?.?.? ]; then
		Fmv '/usr/lib/perl5/site_perl/?.?.?' /usr/lib/perl5/site_perl/current
	fi
	if [ -d $Fdestdir/usr/lib/perl5/site_perl ]; then
		find $Fdestdir/usr/lib/perl5/site_perl -name perllocal.pod -exec rm {} \;
		find $Fdestdir/usr/lib/perl5/site_perl -name .packlist -exec rm {} \;
	fi

	# rc script
	if [ -z "$_F_rcd_name" ]; then
		_F_rcd_name=$pkgname
	fi
	if [ -e $Fsrcdir/rc.$_F_rcd_name ] && \
		grep -q "source /lib/initscripts/functions" $Fsrcdir/rc.$_F_rcd_name; then
		Frcd2 $_F_rcd_name
	fi
}

###
# * Fbuild(): The default build(): Fpatchall, Fmake, Fmakeinstall. Parameter(s)
# are passed to Fmake.
###
Fbuild() {
	Fpatchall
	Fmake "$@"
	Fmakeinstall
	if echo ${source[@]}|grep -q README.Frugalware; then
		Fdoc README.Frugalware
	fi
}

###
# * Frcd(): Create an rc.d environment. Parameter: name of the rc script,
# defaults to $pkgname.
#
# NOTE: this function is obsolete, use Frcd2 instead.
###
Frcd() {
	if [ "$#" -eq 1 ]; then
		Fmessage "Creating rc.d environment: $1"
		Fexe /etc/rc.d/rc.$1
		Ffile ../messages/* /etc/rc.d/rc.messages/
	else
		Frcd "$_F_rcd_name"
	fi
}

###
# * Frcd2(): Create the new rc.d environment. Paramter: name of the rc script,
# defaults to $pkgname.
###
Frcd2() {
	local po rc slang

	rc="$pkgname" ; [ -n "$1" ] && rc="$1"

	Fmessage "Creating new rc.d environment: $rc"
	Fexe /etc/rc.d/rc.$rc
	for po in $Fsrcdir/rc.$rc-*.po ; do
		[ ! -f "$po" ] && continue
		slang="`basename "$po" .po | sed "s|rc.$rc-||"`"
		Fmsgfmt /lib/initscripts/messages $slang $rc `basename $po .po`
	done
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
# correctly. Uses vercmp from pacman. Reads the version list from stdin.
###
Fsort() {
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
# * Flasttar(): Extracts version from a page's last tar.gz link.
###
Flasttar()
{
	grep 'tar.gz\($\|#\)'|sed -n 's/.*-\(.*\)\.t.*/\1/;$ p'
}

###
# * Flasttgz(): Extracts version from a page's last tgz link.
###
Flasttgz()
{
	grep 'tgz\($\|#\)'|sed -n 's/.*-\(.*\)\.t.*/\1/;$ p'
}

###
# * Flasttarbz2(): Extracts version from a page's last tar.bz2 link.
###
Flasttarbz2()
{
	grep 'tar.bz2\($\|#\)'|sed -n 's/.*-\(.*\)\.t.*/\1/;$ p'
}

###
# * Fdesktop(): Creates a .desktop file for graphical applications. Parameters:
# 1) name of the executable binary 2) icon name from /usr/share/pixmaps 3)
# categori(es) (optional). You can choose one or more from the followings:
# System;Games;AudioVideo;GNOME;KDE;Network;Development;FileTransfer;GTK; 4)
# mimetype(s) (optional). Example: Fdesktop vmware vmware-workstation.png
# "System;" "application/x-vmware-vm;application/x-vmware-team;"
#
# NOTE: this function is obsolete, use Fdesktop2 instead.
###
Fdesktop()
{
	Fmkdir $Fmenudir
	Fmessage "Installing desktop file: $pkgname.desktop"
	cat > $Fdestdir$Fmenudir/$pkgname.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=$pkgname
Comment=$pkgdesc
Exec=$1
Terminal=false
Type=Application
StartupNotify=true
Icon=$2
Categories=Application;$3
MimeType=$4
EOF
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

	if [ ! -z $_F_desktop_exec ] ; then
		dexec=$_F_desktop_exec
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
	cat > $Fdestdir$Fmenudir/$deskfilename << EOF
[Desktop Entry]
Encoding=UTF-8
Name=$dname
Comment=$ddesc
Exec=$dexec
Terminal=false
Type=Application
StartupNotify=true
Icon=$dicon
Categories=$dcategories
MimeType=$dmime
EOF

	if [ ! -z $_F_desktop_show_in ] ; then
		echo "OnlyShowIn=$dshowin;" >> $Fdestdir$Fmenudir/$pkgname.desktop
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
# * Fsplit(): Moves a file pattern to a subpackage. Parameters: 1) name of the
# subpackage 2) pattern of the files to move. Example: Fsplit libmysql /usr/lib.
#
# NOTE: never use a leading slash when using wildcards!
###
Fsplit()
{
	local subpkg=$1
	shift 1
	local i
	local dir
	local path
	for i in $@
	do
		# split the / suffix if used
		path=`echo $i|sed 's|/$||'`

		Fmessage "Moving $path to subpackage $subpkg"
		dir=`echo $path|sed 's|/[^/]*$||'`
		mkdir -p $startdir/pkg.$subpkg/$dir/
		mv $Fdestdir/$path $startdir/pkg.$subpkg/$dir/ || Fdie
	done
}

###
# * check_option(): Check if a logical flag is defined in options() or not.
# Parameter: name of the logical flag. Example: if [ "`check_option DEVEL`" ];
# then
###
check_option() {
	local i
	for i in ${options[@]}; do
		local uc=`echo $i | tr [:lower:] [:upper:]`
		local lc=`echo $i | tr [:upper:] [:lower:]`
		if [ "$uc" = "$1" -o "$lc" = "$1" ]; then
			echo $1
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

	if echo $2|grep -q _ ; then
		llang="$2"
		slang=`echo $llang|cut -d _ -f 1`
	else
		llang=${2}_`echo $2|tr [:lower:] [:upper:]`
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
	local cmd file tmp
	file="${1}"
	tmp="$(echo "${file}" | tr 'A-Z' 'a-z')"
	case "${tmp}" in
		*.tar.gz|*.tar.z|*.tgz)
		cmd="tar --use-compress-program=gzip -xf $file" ;;
		*.tar.bz2|*.tbz2)
		cmd="tar --use-compress-program=bzip2 -xf $file" ;;
		*.tar)
		cmd="tar -xf $file" ;;
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
		*)
		cmd="" ;;
	esac
	if [ "$cmd" != "" ]; then
		msg "    $cmd"
		$cmd
		if [ $? -ne 0 ]; then
			# unzip will return a 1 as a warning, it is not an error
			if [ "$unziphack" != "1" -o $? -ne 1 ]; then
				error "Failed to extract ${file}"
				msg "Aborting..."
				Fdie
			fi
		fi
	fi
}
