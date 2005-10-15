export PATH=$PATH:/usr/lib/mingw/bin
export MANPATH=$MANPATH:/usr/lib/mingw/man
if [ -z "$INFOPATH" ]; then
	export INFOPATH=/usr/lib/mingw/info
else
	export INFOPATH=$INFOPATH:/usr/lib/mingw/info
fi
