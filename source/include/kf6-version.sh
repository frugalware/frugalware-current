#!/bin/bash

###
# = kf6-version.sh(3)
# Michel Hermier <hermier@frugalware.org>
#
# == NAME
# kf6-version.sh - for Frugalware
#
# == SYNOPSIS
# Common schema for packages built against a given KDE version.
#
# == OVERWRITTEN VARIABLES
# * _F_kdever_ver: the KDE realease
# * _F_kdever_qt: the Qt release required for KDE
# * _F_kdever_sha1sums: a hash of all the sha1sums for the various KDE projects
###


_F_kdever_frameworks=6.7
_F_kdever_frameworks_revision=0
_F_kf6_full="${_F_kdever_frameworks}.${_F_kdever_frameworks_revision}"
_F_kdever_plasma=6.1.5
_F_kdever_qt6=6.8.0
_F_kdever_apps=24.08.1



