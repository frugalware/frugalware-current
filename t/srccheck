#!/bin/bash

#declare vars
pkgname=""
nobuild=""
archs=""
source=""
prevfile=""

# fake variable for fwmakepkg
export CHROOT=1

. ./functions.sh || echo "could not parse functions"
. /etc/makepkg.conf || echo "could not parse makepkg.conf"
. /usr/lib/frugalware/fwmakepkg || echo "could not parse fwmakepkg"


if [ "$1" == "--download" ]; then
	download="y"
	shift
fi

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
    exit
fi

directory=$(dirname $1)
cd "$directory" || exit
startdir="$(pwd)"
export startdir

. ./FrugalBuild || echo "could not parse $1"
maintainer=$(grep Maintainer FrugalBuild |sed 's/.*: //')

if [[ -z "$pkgname" ]]; then
  echo "$directory: $pkgname is missing ($maintainer)"
  exit
fi

#Package is nobuild or nomirror
if [[ -n "$nobuild" ]] || ( [[ -n "$(check_option NOBUILD)" ]]  ||  [[ -n "$(check_option NOMIRROR)" ]] ); then
  exit
fi

for j in "${archs[@]}"
do
  [[ "${j:0:1}" = '!' ]] && continue
  export CARCH=$j
  startdir="$(pwd)"
  export startdir
  . ./FrugalBuild || echo "could not parse $1, arch $j"
  for k in "${source[@]}"
  do
    [[ "${k:0:25}" = "http://ftp.frugalware.org" ]] && continue
    file="`strip_url $k`"
    if [ ! -e "$file" ] && [ "$prevfile" != "$file" ]; then
      prevfile="$file"
      echo "$directory: $file is missing ($maintainer)"
      if [ ! -z "$download" ]; then
        echo "downloading $file..."
        $FTPAGENT $k
      fi
    fi
  done
done
