#!/bin/sh

# (c) 2006 Miklos Vajna <vmiklos@frugalware.org>
# python.sh for Frugalware
# distributed under GPL License

# common variables for python packages

_F_python_libdir=`python -c 'from distutils import sysconfig; print sysconfig.get_python_lib()'`
_F_python_ver=`python -c 'from distutils import sysconfig; print sysconfig.get_python_version()'`
