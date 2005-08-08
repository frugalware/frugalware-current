#!/bin/sh
# 
# Preprocessor for 'less'. Used when this environment variable is set:
# LESSOPEN="|lesspipe.sh %s"

trap 'exit 0' PIPE

guesscompress() {
	case "$1" in
		*.gz)  echo "gunzip -c" ;;
		*.bz2) echo "bunzip2 -c" ;;
		*)     echo "cat" ;;
	esac
}

lesspipe() {
	local DECOMPRESSOR=""

	case "$match" in

	### Man pages ###
	*.[0-9n]|*.man|\
	*.[0-9n].bz2|*.man.bz2|\
	*.[0-9n].gz|*.man.gz)
		DECOMPRESSOR=$(guesscompress "$match")
		if [[ $($DECOMPRESSOR -- "$1" | file -) == *troff* ]] ; then
			if [[ $1 == /* ]] ; then
				man -- "$1"
			else
				man -- "./$1"
			fi
		else
			$DECOMPRESSOR -- "$1"
		fi
		;;

	### Tar files ###
	*.tar)                   tar tvvf "$1" ;;
	*.tar.bz2|*.tbz2|*.tbz) tar tjvvf "$1" ;;
	*.tar.gz|*.tgz|*.tar.z) tar tzvvf "$1" ;;

	### Misc archives ###
	*.bz2)        bzip2 -dc -- "$1" ;;
	*.gz|*.z)     gzip -dc -- "$1"  ;;
	*.zip)        unzip -l "$1" ;;
	*.rpm)        rpm -qpivl --changelog -- "$1" ;;
	*.cpi|*.cpio) cpio -itv < "$1" ;;
	*.rar)        unrar l -- "$1" ;;
	*.ace)        unace l -- "$1" ;;
	*.arj)        unarj l -- "$1" ;;
	*.cab)        cabextract -l -- "$1" ;;
	*.7z)         7z l -- "$1" ;;
	*.a)          ar tv "$1" ;;
	*.fpm)        tar tzvvf "$1" ;;
	*.deb)        ar tv "$1"
	              ar p "$1" data.tar.gz | tar tzvvf - ;;

	### Media ###
	*.gif|*.jpeg|*.jpg|*.pcd|*.png|*.tga|*.tiff|*.tif|*.bmp)
		if type -p identify > /dev/null ; then
			identify "$1"
		else
			echo "Please install imagemagick in order"
			echo "to view info about images"
		fi
		;;
	*.avi|*.mpeg|*.mpg|*.mov|*.qt|*.wmv|*.asf|*.rm)
		# XXX: anyone have a better command ?
		file -L -- "$1"
		;;

	### Everything else ###
	*)
		# Maybe we didn't match due to case issues ...
		if [[ ${recur} == 0 ]] ; then
			recur=1
			match=$(echo $1 | tr '[:upper:]' '[:lower:]')
			lesspipe "$1"
		fi

		local out=$(file -L -- "$1")
		if [[ ${out} == *ELF* || ${out} == *a.out* ]] ; then
			strings -- "$1"
		fi
		;;
	esac
}

if [[ -d $1 ]] ; then
	ls -alF -- "$1"
else
	recur=0
	match=$1
	lesspipe "$1" 2> /dev/null
fi
