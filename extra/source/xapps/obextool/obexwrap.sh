#!/bin/sh
#
# Shell wrapper for obexftp 0.10.2+
#
# Christian has changed output (of --list) to stderr, so we must
# "redirect" it back to stdout 
#
# Wrapper commands for:

### Version obexftp 0.10.2 - which I'm still using now...
#/root/frugalpkg/obextool/src/contrib/obexftp/obexftp.static -t /dev/ttyS0 "$@"
#obexftp -d /dev/modem "$@"

### Version obexftp 0.10.3
#obexftp -d /dev/modem "$@" 2>&1

### Version obexftp 0.10.4 (should also work with bluetooth)
#obexftp -b <btaddr> -B <channel> "$@" 2>&1
#obexftp -t /dev/modem "$@" 2>&1
# $HOME/sw/cprog/obexftp-0.10.4/apps/obexftp -t /dev/modem "$@" 2>/dev/null
obexftp -t /dev/ttyS0 "$@"
