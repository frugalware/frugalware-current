export KDEDIR=/usr
export MANPATH=$MANPATH:$KDEDIR/man
if [ -z "$PKG_CONFIG_PATH" ]; then
	export PKG_CONFIG_PATH=$KDEDIR/lib/pkgconfig
else
	export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$KDEDIR/lib/pkgconfig
fi
