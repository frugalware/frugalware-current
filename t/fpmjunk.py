#!/usr/bin/env python

import alpm, os, tempfile, shutil, sys, re

remove = False
if len(sys.argv) > 1:
	if sys.argv[1] == "--help":
		print "no longer necessary %s fpms" % sys.argv[2]
		sys.exit(0)
	elif sys.argv[1] == "--remove":
		remove = True
		arch = sys.argv[2]
	else:
		arch = sys.argv[1]

for i in ['frugalware-%s' % arch]:
	arch = i[11:]
	root = tempfile.mkdtemp()
	alpm.initialize(root)
	if os.getcwd().split('/')[-2] == "frugalware-current":
		treename = "frugalware-current"
	else:
		treename = "frugalware"
	db = alpm.db_register(treename)
	alpm.db_setserver(db, "file://" + os.getcwd() + "/../frugalware-" + arch)
	alpm.db_update(1, db)
	fdb = []
	j = alpm.db_getpkgcache(db)
	while j:
		pkg = alpm.void_to_PM_PKG(alpm.list_getdata(j))
		pkgname = alpm.void_to_char(alpm.pkg_getinfo(pkg, alpm.PKG_NAME))
		pkgver = alpm.void_to_char(alpm.pkg_getinfo(pkg, alpm.PKG_VERSION))
		fdb.append("%s-%s-%s.fpm" % (pkgname, pkgver, arch))
		j = alpm.list_next(j)
	alpm.release()
	shutil.rmtree(root)
	for j in os.listdir(os.getcwd() + "/../frugalware-" + arch):
		if j not in fdb and j != treename + ".fdb":
			print "frugalware-" + arch + "/" + j
			if remove:
				os.unlink("../frugalware-" + arch + "/" + j)
