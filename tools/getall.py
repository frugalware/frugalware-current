#!/usr/bin/env python

"""Updates existing and clones new Frugalware repos.

Usage: getall.py [options]

Options:
  -l ..., --login=...     developer login, defaults to $LOGNAME
  -r ..., --root=...      root directory for the git repos, defaults to ~/git

All parameters are optional.
"""

__author__ = "Miklos Vajna <vmiklos@frugalware.org>"
__version__ = "0.1.0"
__date__ = "Thu, 19 Jul 2007 00:47:10 +0200"
__copyright__ = "Copyright (c) 2007 Miklos Vajna"
__license__ = "GPL"

import os, pwd, getopt, sys

server = "git.frugalware.org"
repodir = "/home/ftp/pub/other/homepage-ng/git/repos"

class Options:
	def __init__(self):
		self.login = pwd.getpwuid(os.getuid())[0]
		self.root = os.path.join(os.environ['HOME'], "git")

def update(options):
	try:
		os.chdir(options.root)
	except OSError:
		os.makedirs(options.root)
	sock = os.popen("ssh %s@%s ls -l %s" % (options.login, server, repodir))
	buf = sock.readlines()
	sock.close()
	buf.pop(0)
	for i in buf:
		path = os.path.abspath(os.path.join(repodir, i.strip().split(" ")[-1]))
		repo = os.path.split(path)[-1]
		if repo.startswith("frugalware-"):
			local = repo[len("frugalware-"):]
		else:
			local = repo
		url = "%s@%s:%s" % (options.login, server, path)
		print "Updating '%s':" % repo
		try:
			old = os.getcwd()
			os.chdir(local)
			os.system("git pull")
			os.chdir(old)
		except OSError:
			os.system("git clone %s %s" % (url, repo))

def usage(ret):
	print __doc__
	sys.exit(ret)

def main():
	options = Options()
	try:
		opts, args = getopt.getopt(sys.argv[1:], "hl:r:v", ["help", "login=", "root=", "version"])
	except getopt.GetoptError:
		usage(1)
	for opt, arg in opts:
		if opt in ("-h", "--help"):
			usage(0)
		if opt in ("-l", "--login"):
			options.login = arg
		if opt in ("-r", "--root"):
			options.root = arg
		if opt in ("-v", "--version"):
			print "getall %s" % __version__
			sys.exit(0)
	update(options)

if __name__ == "__main__":
	main()
