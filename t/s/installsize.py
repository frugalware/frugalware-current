#!/usr/bin/env python

try:
	import pacman
except ImportError:
	import alpm
	pacman = alpm
import os, tempfile, shutil, sys, re

archlist = None
limit = 630

if len(sys.argv) > 1:
	if sys.argv[1] == "--help":
		print "check if the default install fits on a single CD"
		sys.exit(0)
	else:
		archlist = ["frugalware-%s" % sys.argv[1]]
if not archlist:
	archlist = os.listdir("../..")

for i in archlist:
	if not re.match("^frugalware-", i):
		continue
	arch = i[11:]
	root = tempfile.mkdtemp()
	pacman.initialize(root)
	if os.getcwd().split('/')[-3] == "frugalware-current":
		treename = "frugalware-current"
	else:
		treename = "frugalware"
	db = pacman.db_register(treename)
	pacman.db_setserver(db, "file://" + os.getcwd() + "/../../frugalware-" + arch)
	pacman.db_update(1, db)
	size = 0
	num = 0
	j = pacman.db_getpkgcache(db)
	while j:
		pkg = pacman.void_to_PM_PKG(pacman.list_getdata(j))
		pkgname = pacman.void_to_char(pacman.pkg_getinfo(pkg, pacman.PKG_NAME))
		pkgsize = pacman.void_to_unsigned_long(pacman.pkg_getinfo(pkg, pacman.PKG_SIZE))
		group = pacman.void_to_char(pacman.list_getdata(pacman.void_to_PM_LIST(pacman.pkg_getinfo(pkg, pacman.PKG_GROUPS))))
		if group[-6:] == "-extra":
			j = pacman.list_next(j)
			continue
		size += pkgsize
		num += 1
		j = pacman.list_next(j)
	pacman.release()
	shutil.rmtree(root)
	mbsize = round(size / 1048576.0, 1)
	if mbsize > 650.0:
		print "Size for %s is too big: %d MB (should be < %d MB; %d packages)" % (arch, mbsize, limit, num)
