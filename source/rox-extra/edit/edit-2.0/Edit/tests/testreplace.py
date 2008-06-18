#!/usr/bin/env python2.2
import unittest
import sys
import os, time
from os.path import dirname, abspath, join

sys.path.insert(0, '..')
sys.argv[0] = dirname(sys.argv[0])

import setup
from EditWindow import EditWindow
import search

class TestReplace(unittest.TestCase):
	def setUp(self):
		self.win = EditWindow(show = False)
		self.win.buffer.begin_user_action()
		self.win.buffer.insert_at_cursor("Hello\n")
		self.win.buffer.end_user_action()
		self.win.buffer.start_undo_history()
	
	def tearDown(self):
		self.win.destroy()
	
	def get_text(self):
		s = self.win.buffer.get_start_iter()
		e = self.win.buffer.get_end_iter()
                return self.win.buffer.get_text(s, e, True)
	
	def assertNow(self, expected):
		actual = self.get_text()
		if actual != expected:
			raise AssertionError("Incorrect final text.\n"
				"Expected:\n%s\nActual:\n%s" % (expected[:100], actual[:100]))

	def testSimple(self):
		self.win.process_selected(lambda x: "World")
		self.assertNow("World\n")
		self.win.undo()
		self.assertNow("Hello\n")
	
	def testReplace(self):
		self.win.undo()
		self.win.buffer.begin_user_action()
		self.win.buffer.insert_at_cursor("deàça")
		self.win.buffer.end_user_action()
		replace = search.Replace(self.win)
		replace.replace_entry.set_text("a")
		replace.with_entry.set_text("b")
		replace.do_replace(show_info = False)
		
		self.assertNow("deàçb")

		self.win.undo()
		self.assertNow("deàça")
	

sys.argv.append('-v')
unittest.main()
