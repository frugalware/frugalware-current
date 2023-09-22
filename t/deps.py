#!/usr/bin/env python

try:
	import pacman
except ImportError:
	import alpm
	pacman = alpm
import os, tempfile, shutil, sys

if len(sys.argv) > 1:
	if sys.argv[1] == "--help":
		print("check if all the packages can be downloaded via pacman-g2 -Sw")
		sys.exit(0)

root = tempfile.mkdtemp()
if pacman.initialize(root) == -1:
	print("initialize() failed")
if os.getcwd().split('/')[-2] in ["frugalware-current", "current"]:
	treename = "frugalware-current"
else:
	treename = "frugalware"
local = pacman.db_register("local")
db = pacman.db_register(treename)
if not db:
	print("db_register() failed")
if pacman.db_setserver(db, "file://" + os.getcwd() + "/../frugalware-%s" % sys.argv[1]) == -1:
	print("db_setserver() failed")
if pacman.db_update(1, db) == -1:
	print("db_update() failed")
if pacman.trans_init(pacman.TRANS_TYPE_SYNC, pacman.TRANS_FLAG_NOCONFLICTS, None, None, None) == -1:
	print("trans_init() failed")
i = pacman.db_getpkgcache(db)
while i:
	pkg = pacman.void_to_PM_PKG(pacman.list_getdata(i))
	pkgname = pacman.void_to_char(pacman.pkg_getinfo(pkg, pacman.PKG_NAME))
	if pacman.trans_addtarget(pkgname):
		print("failed to add target '%s' (%s)" % (pkgname, pacman.strerror(pacman.cvar.pm_errno)))
		break
	i = pacman.list_next(i)
junk = pacman.LISTp_new()
if pacman.trans_prepare(junk) == -1:
	print("%s:" % pacman.strerror(pacman.cvar.pm_errno))
	i = pacman.list_first(pacman.LISTp_to_LIST(junk))
	while i:
		miss = pacman.void_to_PM_DEPMISS(pacman.list_getdata(i))
		if pacman.void_to_long(pacman.dep_getinfo(miss, pacman.DEP_TYPE)) == pacman.DEP_TYPE_DEPEND:
			reason = "requires"
		else:
			reason = "is required by"
		sys.stdout.write(":: %s: %s %s" % (pacman.void_to_char(pacman.dep_getinfo(miss, pacman.DEP_TARGET)),
			reason, pacman.void_to_char(pacman.dep_getinfo(miss, pacman.DEP_NAME))))
		mod = pacman.void_to_long(pacman.dep_getinfo(miss, pacman.DEP_MOD))
		ver = pacman.void_to_char(pacman.dep_getinfo(miss, pacman.DEP_VERSION))
		if mod == pacman.DEP_MOD_EQ:
			sys.stdout.write("=%s\n" % ver)
		elif mod == pacman.DEP_MOD_GE:
			sys.stdout.write(">=%s\n" % ver)
		elif mod == pacman.DEP_MOD_LE:
			sys.stdout.write("<=%s\n" % ver)
		else:
			print()
		i = pacman.list_next(i)
pacman.release()
shutil.rmtree(root)
