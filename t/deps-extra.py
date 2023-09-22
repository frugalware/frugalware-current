#!/usr/bin/env python

try:
	import pacman
except ImportError:
	import alpm
	pacman = alpm
import os, tempfile, shutil, sys

if len(sys.argv) > 1 and sys.argv[1] == "--help":
	print("installed-by-default packages which depend on extra packages")
	sys.exit(0)

root = tempfile.mkdtemp()
pacman.initialize(root)
if os.getcwd().split('/')[-2] == "frugalware-current":
	treename = "frugalware-current"
else:
	treename = "frugalware"
db = pacman.db_register(treename)
pacman.db_setserver(db, "file://" + os.getcwd() + "/../frugalware-%s" % sys.argv[1])
pacman.db_update(1, db)

i = pacman.db_getpkgcache(db)
while i:
	pkg = pacman.void_to_PM_PKG(pacman.list_getdata(i))
	pkgname = pacman.void_to_char(pacman.pkg_getinfo(pkg, pacman.PKG_NAME))
	group = pacman.void_to_char(pacman.list_getdata(pacman.void_to_PM_LIST(pacman.pkg_getinfo(pkg, pacman.PKG_GROUPS))))
	try:
		if group[-6:] == "-extra":
			i = pacman.list_next(i)
			continue
	except TypeError:
		print("%s has no groups()" % pkgname)
		i = pacman.list_next(i)
		continue
	j = pacman.void_to_PM_LIST(pacman.pkg_getinfo(pkg, pacman.PKG_DEPENDS))
	while j:
		found = False
		dep = pacman.void_to_char(pacman.list_getdata(j)).split("<")[0].split(">")[0].split("=")[0]
		k = pacman.db_getpkgcache(db)
		while not found and k:
			p = pacman.void_to_PM_PKG(pacman.list_getdata(k))
			pname = pacman.void_to_char(pacman.pkg_getinfo(p, pacman.PKG_NAME))
			if pname == dep:
				buggy = False
				l = pacman.void_to_PM_LIST(pacman.pkg_getinfo(p, pacman.PKG_GROUPS))
				while not found and l:
					g = pacman.void_to_char(pacman.list_getdata(l))
					if  g[-6:] == "-extra":
						buggy = True
					l = pacman.list_next(l)
				if not buggy and not (len(sys.argv) > 1 and pname == sys.argv[1]):
					found = True
			else:
				l = pacman.void_to_PM_LIST(pacman.pkg_getinfo(p, pacman.PKG_PROVIDES))
				while not found and l:
					pr = pacman.void_to_PM_PKG(pacman.list_getdata(l))
					if pacman.void_to_char(pacman.pkg_getinfo(pr, pacman.PKG_NAME)) == dep:
						found = True
					l = pacman.list_next(l)
			k = pacman.list_next(k)
		if not found:
			try:
				socket = open("../source/%s/%s/FrugalBuild" % (group, pkgname))
				while True:
					line = socket.readline()
					if not line:
						break
					if line[:14] != "# Maintainer: ":
						continue
					# FIXME: we here hardcore the encoding of the FBs
					maintainer = line[14:].strip().decode('latin1')
					break
				socket.close()
			except IOError:
				maintainer = "Unknown"
			print("%s should be moved to extra (%s is in extra; %s)" % (pkgname, pacman.void_to_char(pacman.list_getdata(j)), maintainer))
		j = pacman.list_next(j)
	i = pacman.list_next(i)
pacman.release()
shutil.rmtree(root)
