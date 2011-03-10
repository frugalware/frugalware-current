#!/bin/sh

if [ -z "$MANPATH" ]; then
	export MANPATH=/usr/share/man:/usr/man:/usr/local/man:/usr/local/share/man
else
	export MANPATH=$MANPATH:/usr/share/man:/usr/man:/usr/local/man:/usr/local/share/man
fi
