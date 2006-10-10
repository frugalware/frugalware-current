#!/bin/sh

# if you language is missing from here, please file a bugreport
if [ ! -z "$DISPLAY" -a "$LANG" = "zh_CN.utf8" ]; then
	export XMODIFIERS=@im=SCIM
	export G_FILENAME_ENCODING=@utf8
	export GTK_IM_MODULE=scim
	export QT_IM_MODULE=scim
	scim -d
fi
