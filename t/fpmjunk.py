#!/usr/bin/env python

try:
	import pacman
except ImportError:
	import alpm
	pacman = alpm
import os, tempfile, shutil, sys, re

remove = False
if len(sys.argv) > 1:
	if sys.argv[1] == "--help":
		print("no longer necessary %s fpms" % sys.argv[2])
		sys.exit(0)
	elif sys.argv[1] == "--remove":
		remove = True
		arch = sys.argv[2]
	else:
		arch = sys.argv[1]

for i in ['frugalware-%s' % arch]:
	arch = i[11:]
	root = tempfile.mkdtemp()
	pacman.initialize(root)
	if os.getcwd().split('/')[-2] == "frugalware-current":
		treename = "frugalware-current"
		archive = treename
	else:
		treename = "frugalware"
		archive = treename + "-stable"
	db = pacman.db_register(treename)
	pacman.db_setserver(db, "file://" + os.getcwd() + "/../frugalware-" + arch)
	pacman.db_update(1, db)
	fdb = []
	j = pacman.db_getpkgcache(db)
	while j:
		pkg = pacman.void_to_PM_PKG(pacman.list_getdata(j))
		pkgname = pacman.void_to_char(pacman.pkg_getinfo(pkg, pacman.PKG_NAME))
		pkgver = pacman.void_to_char(pacman.pkg_getinfo(pkg, pacman.PKG_VERSION))
		fdb.append("%s-%s-%s.fpm" % (pkgname, pkgver, arch))
		j = pacman.list_next(j)
	pacman.release()
	shutil.rmtree(root)
	for j in os.listdir(os.getcwd() + "/../frugalware-" + arch):
		if j not in fdb and j != treename + ".fdb" and j != ".gitignore":
			print("frugalware-" + arch + "/" + j)
			if remove:
				os.rename("../frugalware-" + arch + "/" + j, "/srv/ftp/pub/archive/fpmjunk/" + archive + "/frugalware-" + arch + "/" + j)
