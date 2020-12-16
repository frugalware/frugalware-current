#!/bin/bash

###
# = kf5-version.sh(3)
# Michel Hermier <hermier@frugalware.org>
#
# == NAME
# kf5-version.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages built against a given KDE version.
#
# == OVERWRITTEN VARIABLES
# * _F_kdever_ver: the KDE realease
# * _F_kdever_qt: the Qt release required for KDE
# * _F_kdever_sha1sums: a hash of all the sha1sums for the various KDE projects
###


_F_kdever_frameworks=5.77
_F_kdever_frameworks_revision=0
_F_kf5_full="${_F_kdever_frameworks}.${_F_kdever_frameworks_revision}"
_F_kdever_plasma=5.20.4
_F_kdever_qt5=5.15.1
_F_kdever_apps=20.08.3
