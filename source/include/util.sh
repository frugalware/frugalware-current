#!/bin/sh

# Copyright (C) 2005-2006 Bence Nagy <nagybence@tipogral.hu>
# Copyright (C) 2005-2006 Miklos Vajna <vmiklos@frugalware.org>
# util.sh for Frugalware
# distributed under GPL License

# Parts of Fsort and Funpack_makeself are:
# Copyright (C) 1999-2005 Gentoo Foundation
# This file can be distributed under the terms of the
# GNU General Public License version 2.

# general utility functions for FrugalBuilds

Fsrcdir="$startdir/src"
Fdestdir="$startdir/pkg"
Fprefix="/usr"
Fsysconfdir="/etc"
Flocalstatedir="/var"
Fmenudir="/usr/share/applications"
Fconfopts="--prefix=$Fprefix"
export LDFLAGS="-Wl,--hash-style=both"

### @defgroup fwmakepkg Common functions
 # @{
 # @brief Common functions used by makepkg
 ##

### Prints out a message
 # @param message message to display
 ##
Fmessage() {
	if [ "$USE_COLOR" = "Y" -o "$USE_COLOR" = "y" ]; then
		echo -e "\033[1;36m==>\033[1;0m \033[1;1m$1\033[1;0m" >&2
	else
		echo "==> $1" >&2
	fi
}

### Cause makepkg to exit
 ##
Fdie() {
	exit 2
}

### Go to the source directory if it is $Fsrcdir currently
 # @param dir optional source directory, default is $pkgname-$pkgver$pkgextraver
 ##
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

### Creates a directory under $Fdestdir
 # @param dir name of the directory to create (you can supply more than one)
 ##
Fmkdir() {
	local i
	for i in "$@"; do
		if [ ! -d "$Fdestdir/$i" ]; then
			Fmessage "Creating directory: $i"
			mkdir -p "$Fdestdir/$i" || Fdie
		fi
	done
}

### Deletes (rm -rf) a directory stucture under $Fdestdir
 # @param path name of the path to rm -rf (you can supply more than one)
 ##
Frm() {
	local i
	for i in "$@"; do
		Fmessage "Deleting file(s): $i"
		rm -rf "$Fdestdir"/$i || Fdie
	done
}

### Copy file(s) under $Fdestdir
 # @param source name of the file(s)
 # @param dest path of the destination
 ##
Fcp() {
	Fmessage "Copying file(s): $1"
	cp "$Fdestdir/"$1 "$Fdestdir"/$2 || Fdie
}

### Copy file(s) to $Fdestdir recursively from $Fsrcdir
 # @param source name of the file(s)
 # @param dest path of the destination
 ##
Fcpr() {
	Fmessage "Copying file(s) recursive: $1"
	cp -dpR "$Fsrcdir/"$1 "$Fdestdir"/$2 || Fdie
}

### Copy file(s) to $Fdestdir recursively from the current working dir
 # @param source name of the file(s)
 # @param dest path of the destination
 ##
Fcprrel() {
	Fmessage "Copying file(s) recursive: $1"
	cp -dpR $1 "$Fdestdir"/$2 || Fdie
}

### Move file(s) under $Fdestdir
 # @param source name of the file(s)
 # @param dest path of the destination
 ##
Fmv() {
	Fmessage "Moving file(s): $1"
	mv "$Fdestdir/"$1 "$Fdestdir"/$2 || Fdie
}

### Install file(s) to $Fdestdir
 # @param mode set permission mode (as in chmod)
 # @param file(s) to be installed (defaults to `basename $destination`)
 # @param destination
 ##
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

### Install file(s) to $Fdestdir from $Fsrcdir
 # @param mode set permission mode (as in chmod)
 # @param file(s) to be installed from $Fsrcdir \
 #        (defaults to $Fsrcdir/`basename $destination`)
 # @param destination
 ##
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

### Changes the permissions of dirs & subdirs inside $Fdestdir
 # @param dir where to start "find"
 # @param permission octal mode or [+-][rwxstugo]
 ##
Fdirschmod() {
	Fmessage "Configure chmod dirs & subdirs inside: $1"
	find "$Fdestdir"/$1 -type d |xargs chmod $2 || Fdie
}

### Changes the permissions of all file(s) inside $Fdestdir
 # @param dir to where start "find"
 # @param permission octal mode or [+-][rwxstugo]
 ##
Ffileschmod() {
	Fmessage "Configure chmod all files inside: $1"
        find "$Fdestdir"/$1 -type f |xargs chmod $2 || Fdie
}

### Change the owner and/or group of dirs and subdirs inside $Fdestdir
 # @param dir where to start "find"
 # @param owner (needed)
 # @param group (needed)
 ##
Fdirschown() {
	Fmessage "Configure chown dirs & subdirs inside: $1"
	find "$Fdestdir"/$1 -type d |xargs chown $2:$3 || Fdie
}

### Change the owner and/or group of all file(s) inside $Fdestdir
 # @param dir where to start "find"
 # @param owner (needed)
 # @param group (needed)
 ##
Ffileschown() {
	Fmessage "Configure chown all files inside: $1"
	find "$Fdestdir"/$1 -type f |xargs chown $2:$3 || Fdie
}

### Install executable file(s) to $Fdestdir from $Fsrcdir
 # @param file(s) to be installed from $Fsrcdir \
 #        (defaults to $Fsrcdir/`basename $destination`)
 # @param destination
 ##
Fexe() {
	Finstall 0755 "$@"
}

### Install executable file(s) to $Fdestdir
 # @param file(s) to be installed \
 #        (defaults to `basename $destination`)
 # @param destination
 ##
Fexerel() {
	Finstallrel 0755 "$@"
}

### Install regular file(s) to $Fdestdir from $Fsrcdir
 # @param file(s) to be installed from $Fsrcdir \
 #        (defaults to $Fsrcdir/`basename $destination`)
 # @param destination
 ##
Ffile() {
	Finstall 0644 "$@"
}

### Install regular file(s) to $Fdestdir
 # @param file(s) to be installed \
 #        (defaults to `basename $destination`)
 # @param destination
 ##
Ffilerel() {
	Finstallrel 0644 "$@"
}

### Install documentation file(s) to $Fdestdir/usr/share/doc/$pkgname-$pkgver \
 #  from $Fsrcdir. Also is $file.xx or $file.xx_YY present then it will be \
 #  automatically installed, too.
 # @param file(s) to be installed from $Fsrcdir \
 #        (defaults to $Fsrcdir/`basename $destination`)
 ##
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

### Install documentation file(s) to $Fdestdir/usr/share/doc/$pkgname-$pkgver.
 #  Also is $file.xx or $file.xx_YY present then it will be \
 #  automatically installed, too.
 # @param file(s) to be installed \
 #        (defaults to $Fsrcdir/`basename $destination`)
 ##
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

### Install icon file(s) to $Fdestdir/usr/share/pixmaps \
 #  from $Fsrcdir
 # @param file(s) to be installed from $Fsrcdir \
 #        (defaults to $Fsrcdir/`basename $destination`)
 ##
Ficon() {
        Fmkdir "/usr/share/pixmaps"
        Ffile "$@" "/usr/share/pixmaps/"
}

### Install icon file(s) to $Fdestdir/usr/share/pixmaps \
 #  from $Fsrcdir
 # @param file(s) to be installed from $Fsrcdir \
 #        (defaults to $Fsrcdir/`basename $destination`)
 ##
Ficonrel() {
        Fmkdir "/usr/share/pixmaps"
        Ffilerel "$@" /usr/share/pixmaps
}

### Create symlink in $Fdestdir
 # @param source (i.e. mysql/libmysqlclient.so)
 # @param target (i.e. /usr/lib/) ($target's dir will be created if necessary)
 ##
Fln() {
	Fmessage "Creating symlink(s): $1"
	Fmkdir "`dirname $2`"
	ln -sf $1 "$Fdestdir"/$2 || Fdie
}

### Use sed with file(s)
 # @param regexp
 # @param replacement (see man sed!)
 # @param file(s) to edit in place
 ##
Fsed() {
	Fcd
	for i in ${@:3:$#}; do
		Fmessage "Using sed with file: $i"
		sed -i -e "s|$1|$2|g" "$i" || Fdie
	done
}

### Strip $Fdestdir from files in $Fdestdir
 # @param file(s) to strip
 ##
Fdeststrip() {
	local i
	for i in "$@"; do
		Fsed "$Fdestdir" "" $Fdestdir/$i
	done
}

### Apply a patch with -p1 (use the .patch0 suffix for -p0)
 # @param Patch to apply. A ".gz" or ".bz2" suffix will be ingored.
 ##
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

### Apply patches from source(). \
 #  Allowed suffixes are \.\(patch[0-9]*\|diff\)\(\.\(gz\|bz2\)\|\). \
 #  URLs allowed, too.
 ##
Fpatchall() {
	local archs=('i686' 'x86_64' 'ppc') patch="" patcharch=""
	for i in ${source[@]}; do
		if [ -n "`echo "$i" | grep \.patch[0-9]*$`" -o -n "`echo "$i" | grep \.diff$`" -o -n "`echo "$i" | grep '\.\(patch[0-9]*\|diff\)\.\(gz\|bz2\)$'`" ]; then
			patch=`strip_url "$i"`
			patcharch=`echo $patch|sed 's/.*-\([^-]\+\)\.\(diff\|patch0\?\)$/\1/'`
			if [ "$patcharch" != "$patch" ] && echo ${archs[@]}|grep -q $patcharch; then
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

### A wrapper to ./configure. It will try to run ./configure, Makefile.PL, \
 #  extconf.rb and configure.rb, respectively. It will automatically add the \
 #  --prefix=$Fprefix (defaults to /usr), \
 #  --sysconfdir=$Fsysconfdir (defaults to /etc) and the \
 #  --localstatedir=$Flocalstatedir (defaults to /var) switches. The two later \
 #  will be added only if the configure script support it.
 #  If you want to pre-set a switch (i.e. add a switch only on a ceratin \
 #  arch or so) apped the $Fconfopts variable.
 # @param switch(es) to pass to the configure script
 ##
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

### A wrapper to make and "python setup.py build" after calling Fconf()
 # @param switch(es) to pass to Fconf()
 ##
Fmake() {
	Fconf "$@"
	Fmessage "Compiling..."
	if [ -f GNUmakefile -o -f makefile -o -f Makefile ]; then
		make || Fdie
	elif [ -f setup.py ]; then
		python setup.py build "$@" || Fdie
	fi
}

### A wrapper to nant
 # @param build file to use
 # @param switch(es) to pass to nant
 ##
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

### A wrapper to make install: calls make DESTDIR=$Fdestir or \
 #  prefix=$Fdestdir/usr install (which is necessary). \
 #  Also handles python's setup.py. \
 #  Removes /usr/info/dir and /usr/share/info/dir.
 # @param param(s) passed to make/python
 ##
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

### A default build(): Fpatchall, Fmake, Fmakeinstall
 # @param param(s) passed to Fmake
 ##
Fbuild() {
	Fpatchall
	Fmake "$@"
	Fmakeinstall
}

### Create an rc.d environment
 # @param name of the rc script, defaults to $pkgname
 ##
Frcd() {
	if [ "$#" -eq 1 ]; then
		Fmessage "Creating rc.d environment: $1"
		Fexe /etc/rc.d/rc.$1
		Ffile ../messages/* /etc/rc.d/rc.messages/
	else
		Frcd "$pkgname"
	fi
}

### Create the new rc.d environment
 # @param name of the rc script, defaults to $pkgname
 ##
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

build() {
	Fbuild
}

### Updates config.sub and config.guess from our automake.
 ##
Facu() {
	cat /usr/share/automake/config.sub >config.sub
	cat /usr/share/automake/config.guess >config.guess
}

### Similar to sort, but handles versions (i.e. 1.9 vs 1.10 vs 2.0) correctly. \
 # Uses vercmp from pacman.
 # @param versions to be sorted
 ##
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

### Unpack those pesky makeself generated files... \
 # They're shell scripts with the binary package tagged onto \
 # the end of the archive. Loki utilized the format as does \
 # many other game companies.
 # @param file to unpack
 # @param offset (optional)
 # @param tail|dd (optional)
 ##
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

### Our autogen.sh. Runs aclocal, autoheader, autoconf and finally automake.
 ##
Fautoconfize() {
	Fmessage "Running aclocal autoheader autoconf automake  ..."
	aclocal || Fdie
	autoheader || Fdie
	autoconf || Fdie
	automake -a -c -f || Fdie
}

Fautoreconf() {
	Fmessage "Running autoreconf -vif ..."
	autoreconf -vif || Fdie
}

### Include a scheme. They are in $fst_root/source/include/, and they have a \
 # .sh suffix. After including them, you can of course overwrite the \
 # initialized values, using only a part of the scheme.
 # @param scheme(s) to include (_without_ the .sh suffix)
 ##
Finclude ()
{
	if [ "$startdir" = `pwd` ]; then
		local i
		i=`pwd`
		while true
		do
			if [ -e "$i/_darcs" ]; then
				break
			elif [ "$i" == "" ]; then
				break
			fi
			i=`echo $i|sed 's|\(.*\)/.*|\1|'`
		done
		if [ "$i" -a -d "$i"/source/include ]; then
			local Fincdir=$i/source/include
		elif [ -d /var/tmp/fst/include ]; then
			local Fincdir=/var/tmp/fst/include
		elif [ -d $fst_root/$reponame/source/include ]; then
			local Fincdir=$fst_root/$reponame/source/include
		fi
		if [ ! -z "$Fincdir" ]; then
			for i in "$@"
			do
				source $Fincdir/$i.sh || Fdie
			done
		else
			echo "Could not find the scheme dir! (\$fst/source/include)"
			echo "Please edit your /etc/repoman.conf or ~/.repoman.conf."
			Fdie
		fi
	fi
}

### Extracts version from a page's last tar.gz link
 ##
Flasttar()
{
	grep tar.gz$|sed -n 's/.*-\(.*\)\.t.*/\1/;$ p'
}

Flasttgz()
{
	grep tgz$|sed -n 's/.*-\(.*\)\.t.*/\1/;$ p'
}

Flasttarbz2()
{
	grep tar.bz2$|sed -n 's/.*-\(.*\)\.t.*/\1/;$ p'
}

### Creates a .desktop file for graphical applications
 # example: Fdesktop vmware vmware-workstation.png "System;" \
 # 	"application/x-vmware-vm;application/x-vmware-team;"
 # @param name of the executable binary
 # @param icon name from /usr/share/pixmaps
 # @param categori(es) (optional)
 # You can choose one or more from the followings:
 # System;Games;AudioVideo;GNOME;KDE;Network;Development;FileTransfer;GTK;
 # @param mimetype(s) (optional)
 ##
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


### Creates a .desktop for graphical applications 
 # A more flexible Fdesktop()
 # Options:
 # _F_desktop_filename : Name of the .desktop file
 # _F_desktop_name : Name of the desktop icon to be displayed
 # _F_desktop_desc : Description of the icon
 # _F_desktop_icon : Icon to be used from /usr/share/pixmaps
 # _F_desktop_exec : Name of the executable file
 # _F_desktop_categories : Categories (same as Fdesktop)
 # _F_desktop_mime : Mimetypes
 # _F_desktop_show_in : Whether the icon should be showed in only a particular DE
 #			like "XFCE;" for Xfce, "GNOME;" for Gnome, etc. 
###
Fdesktop2()
{
	dcategories="Application;"
	if [ -z $_F_desktop_filename ] ; then
		deskfilename=$pkgname.desktop
	else
		deskfilename=$_F_desktop_filename.desktop
	fi

	if [ -z $_F_desktop_name ] ; then
		dname=$pkgname
	else
		dname=$_F_desktop_name
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
	cat > $Fdestdir$Fmenudir/$pkgname.desktop << EOF
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

### Moves a file pattern to a subpackage
 # example: Fsplit libmysql /usr/lib
 # @param name of the subpackage
 # @param pattern of the files to move
 ##
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

### Check if a logical flag is defined in options() or not
 # example: if [ "`check_option DEVEL`" ]; then
 # @param: name of the logical flag
 ##
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

### Install gettext po files to binary mo files
 # example: Fmsgfmt /usr/share/locale hu file file-hu
 # @param path to locale directory (eg /usr/share/locale)
 # @param language
 # @param name of the mo file, default $pkgname
 # @param name of the po file, default $pkgname-$lang
 ##
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

### @}
