#!/bin/sh

###
# = gnome-shell-extension.sh(3)
# bouleetbil <bouleetbil@frogdev.info>
#
# == NAME
# gnome-shell-extension.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for gnome-shell-extensions packages.
###

###
# == PROVIDED FUNCTIONS
# * FGnomeShellVersion(): Change shell-version into metadata.json.
###
FGnomeShellVersion()
{
for i in `find $Fdestdir/usr/share/gnome-shell/extensions/ -name metadata.json`
do
	Fsed "shell-version\": \[" \
		"shell-version\": \[ \"3.2\"," \
		$i
done
}
