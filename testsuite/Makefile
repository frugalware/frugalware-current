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

compile:
	@echo "All done. Start 'make test' now."

test:
	@echo "no longer necessary fpms (please repoman del them):"
	sh fpmjunkall.sh .
	@echo "no longer necessary sources (please repoman del them):"
	sh srcjunk.sh ..
	@echo "missing sources (please repoman up them):"
	sh srcmissing.sh ..
	@echo "packages in the frugalware repo in wrong group (lib->xlib is needed or so):"
	./xbugs frugalware-current
	@echo "packages in the frugalware with a dependency from extra (move them to extra):"
	python deps-extra-i686.py
	@echo "packages with old-style up2dates (slows down repoman cl):"
	sh up2date.sh ..
	@echo "duplicated packages (please remove them):"
	sh pkgdup.sh ..
	@echo "missing xorg packages (please package them):"
	sh xorg.sh ..
