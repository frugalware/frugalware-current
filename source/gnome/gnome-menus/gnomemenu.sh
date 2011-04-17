#!/bin/bash

export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS}:/etc/xdg:/etc/xdg
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_DATA_DIRS=/usr/share
export XDG_CACHE_HOME=${HOME}/.cache
export GDK_USE_XFT=1

if [ -f /etc/xdg/menus/gnome-applications.menu ] ; then
	export XDG_MENU_PREFIX=gnome-
fi
