#!/usr/bin/env python

try:
	import pacman
except ImportError:
	import alpm
	pacman = alpm
import os, tempfile, shutil, sys

def pacman_pkg_getgroups(pkg):
	i = pacman.void_to_PM_LIST(pacman.pkg_getinfo(pkg, pacman.PKG_GROUPS))
	ret = []
	while i:
		ret.append(pacman.void_to_char(pacman.list_getdata(i)))
		i = pacman.list_next(i)
	return ret

def any_in(needle, haystack):
	"""return true if any of the needle list is found in haystack"""
	for i in needle:
		if i in haystack:
			return True
	return False

if len(sys.argv) > 1 and sys.argv[1] == "--help":
	print("COREPKGS (core, chroot-core, devel-core) packages which depend on packages outsite COREPKGS (->COREPKGS is needed)")
	sys.exit(0)

basecats = ['core', 'chroot-core', 'devel-core']

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
	groups = pacman_pkg_getgroups(pkg)

	if not any_in(basecats, groups):
		i = pacman.list_next(i)
		continue
	j = pacman.void_to_PM_LIST(pacman.pkg_getinfo(pkg, pacman.PKG_DEPENDS))
	while j:
		found = False
		dep = pacman.void_to_char(pacman.list_getdata(j)).split("<")[0].split(">")[0].split("=")[0]
		k = pacman.db_getpkgcache(db)
		while not found and k:
			p = pacman.void_to_PM_PKG(pacman.list_getdata(k))
			if pacman.void_to_char(pacman.pkg_getinfo(p, pacman.PKG_NAME)) == dep:
				if any_in(basecats, pacman_pkg_getgroups(p)):
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
				socket = open("../source/%s/%s/FrugalBuild" % (groups[0], pkgname))
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
			print("%s should be moved out from COREPKGS (%s is not in COREPKGS; %s)" % (pkgname, pacman.void_to_char(pacman.list_getdata(j)), maintainer))
		j = pacman.list_next(j)
	i = pacman.list_next(i)
shutil.rmtree(root)
