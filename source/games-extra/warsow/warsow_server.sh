#!/bin/bash

cd "/usr/share/warsow/"
./wsw_server +set fs_usehomedir 1 $*
exit $?
