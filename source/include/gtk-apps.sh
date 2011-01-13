#!/bin/sh

###
# = gtk-apps.sh(3)
# Devil505 <devil505linux@gmail.com>
#
# == NAME
# gtk-apps.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages listed on gtk-apps.org.
#
# == EXAMPLE
# --------------------------------------------------
# soon !
# --------------------------------------------------
#
# == OPTIONS
# * _F_gtk_apps_id : to indicate the content ID of the project on gtk-apps.org
###

if [ -n "$_F_gtk_apps_id" ]; then
	url="http://www.gtk-apps.org/content/show.php?content=$_F_gtk_apps_id"
	up2date="lynx -dump "$url"|grep -v http|grep  -m1 '      [0-9.0-9.0-9]'|sed 's/      \(.*\).*/\1/'"
fi

###
# == OVERWRITTEN VARIABLES
# * up2date
# * url
###
