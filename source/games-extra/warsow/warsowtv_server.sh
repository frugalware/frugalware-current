#!/bin/bash

cd "/usr/share/warsow/"
./wswtv_server +set fs_usehomedir 1 $*
exit $?
