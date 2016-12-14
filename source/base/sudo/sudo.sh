#!/bin/sh

# /etc/profile.d/sudo.sh

# Adds /sbin and /usr/sbin to PATH when sudoing, so you don't have
# to give full PATH for launching a program in those directories.

alias sudo="PATH=$PATH:/sbin:/usr/sbin sudo"
