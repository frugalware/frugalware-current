# -*- coding: utf-8 -*-

# Provides full-text search using tracker.
# Returns files in the local filesystem.

import gnome
import gobject
from gettext import gettext as _

import re
import os.path

import deskbar
from deskbar.Handler import SignallingHandler
from deskbar.Match import Match

def _check_requirements ():
	try:
		import dbus
		try :
			if getattr(dbus, 'version', (0,0,0)) >= (0,41,0):
				import dbus.glib
		except:
			return (deskbar.Handler.HANDLER_IS_NOT_APPLICABLE, "Python dbus.glib bindings not found.", None)
		return (deskbar.Handler.HANDLER_IS_HAPPY, None, None)
	except:
		return (deskbar.Handler.HANDLER_IS_NOT_APPLICABLE, "Python dbus bindings not found.", None)
	
HANDLERS = {
	"TrackerFileSearchHandler" : {
		"name": "Search for files using Tracker",
		"description": _("Search all of your documents (using Tracker), as you type"),
		"requirements" : _check_requirements,
	}
}

#It would be nice to import the matchers of the files.py handler.
#For this, they would need to be moved to deskbar core.
#Advantages: easy i18n, a different matcher for directories.
class TrackerFileMatch (Match):
	def __init__(self, handler, fullpath=None, **args):
		Match.__init__ (self, handler, **args)
		self._icon = deskbar.Utils.load_icon_for_file(fullpath)
		self.fullpath = fullpath
		self.init_names()
				
	def get_name(self, text=None):
		return {"base": self.base,
			"dir": self.dir}

	def get_verb(self):
		return _("Open file %s\nin %s") \
				% ("<b>%(base)s</b>", "<i>%(dir)s</i>")
	
	def get_hash(self, text=None):
		return self.fullpath
		
	def action(self, text=None):
		print "Opening Tracker hit:", self.fullpath
		gnome.url_show ('file://' + self.fullpath)
		
	def get_category (self):
		return "files"

	def init_names (self):
		#print "Parsing «%r»" % self.fullpath
		dirname, filename = os.path.split(self.fullpath)
		if filename == '': #We had a trailing slash
			dirname, filename = os.path.split(dirname)
		
		#Reverse-tilde-expansion
		home = os.path.normpath(os.path.expanduser('~'))
		regexp = re.compile(r'^%s(/|$)' % re.escape(home))
		dirname = re.sub(regexp, r'~\1', dirname)
		
		self.dir = dirname
		self.base = filename


class TrackerFileSearchHandler(SignallingHandler):
	def __init__(self):
		SignallingHandler.__init__(self, "stock_file")
		
		import dbus
		# We have to do this or it won't work
		if getattr(dbus, 'version', (0,0,0)) >= (0,41,0):
			import dbus.glib

		# Set up dbus conenction to trackerd
		self.bus = dbus.SessionBus()
		self.proxy_obj = self.bus.get_object('org.freedesktop.Tracker', '/org/freedesktop/tracker')
		self.search_iface = dbus.Interface(self.proxy_obj, 'org.freedesktop.Tracker.Search')
		
		self.set_delay (500)
		
	def query (self, qstring, max):	
		#The first parameter could be used for up-to-date results
		self.search_iface.Text (-1, "Files", qstring, 0, max, reply_handler=lambda hits : self.__recieve_hits(qstring, hits, max), error_handler=self.__recieve_error)
		print "Tracker query:", qstring

	def __recieve_hits (self, qstring, hits, max):
		matches = []
		for filename in hits:
			matches.append( TrackerFileMatch(self, fullpath=filename) )
		self.emit_query_ready(qstring, matches)
		print "Tracker response for %s, - %s hits returned, %s shown" % (qstring, len(hits), len(matches))
		
	def __recieve_error (self, error):
		print "*** Tracker dbus error:", error
