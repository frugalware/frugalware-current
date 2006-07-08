#!/bin/sh

if [ -z "$1" ]; then
	echo "searches for missing xorg packages"
	echo "usage: $0 <startdir>"
	echo "example: $0 .."
	exit 1
fi
if [ ! -d $1/_darcs -o ! -d $1/source -o ! -d $1/extra ]; then
	echo "hey, where are you?"
	exit 1
fi

cd $1

upstream=`mktemp`
fw=`mktemp`

for i in app data doc driver font lib proto testdir util xserver
do
	lynx -dump http://xorg.freedesktop.org/releases/individual/$i/|grep bz2$|sed 's|.*/\(.*\)-.*|\1|'
done |sort -u |tr [A-Z] [a-z]>$upstream
ls source/x11|sed 's|/$||' >$fw
# xf86-video-impact is mips-only :)
diff -u $upstream $fw|grep ^-[^-] |grep -v 'xf86-video-impact'
rm -f $upstream $fw
