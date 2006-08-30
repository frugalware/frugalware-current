#!/bin/sh

# (c) 2006 Alex Smith <alex@alex-smith.me.uk>
# mono.sh for Frugalware
# distributed under GPL License

# build function for packages with this weird mono foo

build() {
	export MONO_SHARED_DIR=$Fdestdir/weird
	mkdir -p $MONO_SHARED_DIR
	
	Fbuild
	
	rm -rf $MONO_SHARED_DIR
}
