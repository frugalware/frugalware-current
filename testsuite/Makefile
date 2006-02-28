# Makefile for the Frugalware testsuite
#
# Copyright (C) 2006 Miklos Vajna <vmiklos@frugalware.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#

LDFLAGS += -lalpm

compile: depbugs
	@echo "All done. Start 'make test' now."

test:
	sh fpmjunkall.sh .
	sh srcjunk.sh .
	sh srcmissing.sh .
	./depbugs frugalware-current

clean:
	rm -f depbugs
