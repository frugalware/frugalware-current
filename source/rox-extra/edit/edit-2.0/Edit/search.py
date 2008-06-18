import rox
from rox import g
from EditWindow import Minibuffer

regex_help = (
	('.', _('Matches any character')),
	('[a-z]', _('Any lowercase letter')),
	('[-+*/]', _('Any character listed (- must be first)')),
	('^A', _('A only at the start of a line')),
	('A$', _('A only at the end of a line')),
	('A*', _('Zero or more A')),
	('A+', _('One or more A')),
	('A?', _('Zero or one A')),
	('A{m,n}', _('Between m and n matches of A')),
	('A*?, A+?, A??, A{}?', _('Non-greedy versions of *, +, ? and {}')),
	('\*, \+, etc', _('Literal "*", "+"')),
	('A|B', _('Can match A or B')),
	('(AB)', _('Group A and B together (for *, \\1, etc)')),
	('\\1, \\2, etc', _('The first/second bracketed match (goes in the With: box)')),
	('\\b', _('Word boundary (eg, \\bWord\\b)')),
	('\\B', _('Non-word boundary')),
	('\\d, \\D', _('Digit, non-digit')),
	('\\s, \\S', _('Whitespace, non-whitespace')),
	(_('Others'), _('See the Python regular expression documentation for more')),
	('', ''),
	(_('Examples:'), ''),
	('Fred', _('Matches "Fred" anywhere')),
	('^Fred$', _('A line containing only "Fred"')),
	('Go+gle', _('"Gogle, Google, Gooogle, etc"')),
	('Colou?r', _('Colour or Color')),
	('[tT]he', _('"The" or "the"')),
	('M.*d', '"Md", "Mad", "Mud", "Mind", etc'),
	('([ab][cd])+', '"ac", "ad", "acbdad", etc'),
	('', ''),
	(_('Python expressions:'), ''),
	('old', _('The text that was matched')),
	('x', _("The numerical value of 'old'")),
	('old.upper()', _("Convert match to uppercase")),
	('x * 2', _("Double all matched numbers")),
)

class Search(Minibuffer):
	"A minibuffer used to search for text."
	dir = 1

	def setup(self, window):
		self.window = window
		buffer = window.buffer
		s, e = window.get_selection_range()
		self.window.mini_entry.set_text(buffer.get_text(s, e, False))
		cursor = buffer.get_iter_at_mark(window.insert_mark)
		buffer.move_mark_by_name('search_base', cursor)
		self.dir = 1
		self.set_label()

		fwd = rox.ButtonMixed(g.STOCK_GO_DOWN, _('Find Next'))
		fwd.set_relief(g.RELIEF_NONE)
		fwd.unset_flags(g.CAN_FOCUS)
		fwd.connect('clicked', lambda e: self.set_dir(1))

		rev = rox.ButtonMixed(g.STOCK_GO_UP, _('Find Previous'))
		rev.set_relief(g.RELIEF_NONE)
		rev.unset_flags(g.CAN_FOCUS)
		rev.connect('clicked', lambda e: self.set_dir(-1))
		
		case = g.CheckButton(label=_('Match case'))
		case.set_relief(g.RELIEF_NONE)
		case.unset_flags(g.CAN_FOCUS)
		
		self.window.mini_hbox.pack_start(fwd, False, True, 0)
		self.window.mini_hbox.pack_start(rev, False, True, 0)
#		self.window.mini_hbox.pack_start(case, False, True, 10)
		
		self.items = [fwd, rev] #, case]
		
	def close(self):
		for x in self.items:
			self.window.mini_hbox.remove(x)
	
	info = _('Type a string to search for. The display will scroll to show the ' \
		'next match as you type. Use the Up and Down cursor keys to move ' \
		'to the next or previous match. Press Escape or Return to finish.')
	
	def set_label(self):
		self.window.set_mini_label(_(' Find: '))
	
	def set_dir(self, dir):
		assert dir == 1 or dir == -1

		buffer = self.window.buffer
		cursor = buffer.get_iter_at_mark(self.window.insert_mark)
		buffer.move_mark_by_name('search_base', cursor)

		if dir == self.dir:
			if dir == 1:
				cursor.forward_char()
			else:
				cursor.backward_char()
			if self.search(cursor):
				buffer.move_mark_by_name('search_base', cursor)
			else:
				g.gdk.beep()
		else:
			self.dir = dir
			self.set_label()
		self.changed()
	
	def activate(self):
		self.set_dir(self.dir)

	def key_press(self, kev):
		k = kev.keyval
		if k == g.keysyms.Up:
			self.set_dir(-1)
		elif k == g.keysyms.Down:
			self.set_dir(1)
		else:
			return 0
		return 1
	
	def search(self, start):
		"Search forwards or backwards for the pattern. Matches at 'start'"
		"are allowed in both directions. Returns (match_start, match_end) if"
		"found."
		iter = start.copy()
		pattern = self.window.mini_entry.get_text()
		if not pattern:
			return (iter, iter)
		if self.dir == 1:
			found = iter.forward_search(pattern, 0, None)
		else:
			iter.forward_chars(len(pattern))
			found = iter.backward_search(pattern, 0, None)
		return found
	
	def changed(self):
		buffer = self.window.buffer
		pos = buffer.get_iter_at_mark(self.window.search_base)

		found = self.search(pos)
		if found:
			buffer.move_mark_by_name('insert', found[0])
			buffer.move_mark_by_name('selection_bound', found[1])
			self.window.text.scroll_to_iter(found[0], 0.05, False)
		else:
			g.gdk.beep()

class RegexHelp(g.ScrolledWindow):
	def __init__(self):
		g.ScrolledWindow.__init__(self)
		self.set_shadow_type(g.SHADOW_IN)
		self.set_policy(g.POLICY_NEVER, g.POLICY_AUTOMATIC)
		
		model = g.ListStore(str, str)
		view = g.TreeView(model)
		self.add(view)
		view.show()

		cell = g.CellRendererText()
		column = g.TreeViewColumn(_('Code'), cell, text = 0)
		view.append_column(column)
		column = g.TreeViewColumn(_('Meaning'), cell, text = 1)
		view.append_column(column)

		for c, m in regex_help:
			new = model.append()
			model.set(new, 0, c, 1, m)

		self.set_size_request(-1, 150)

		view.get_selection().set_mode(g.SELECTION_NONE)

history = {}	# Field name -> last value

class Replace(rox.Dialog):
	def __init__(self, window):
		self.edit_window = window
		rox.Dialog.__init__(self, parent = window,
					flags = g.DIALOG_DESTROY_WITH_PARENT |
						g.DIALOG_NO_SEPARATOR)
		self.add_button(g.STOCK_CANCEL, g.RESPONSE_CANCEL)
		self.add_button(g.STOCK_FIND_AND_REPLACE, g.RESPONSE_OK)
		self.set_default_response(g.RESPONSE_OK)

		def response(dialog, resp):
			if resp == g.RESPONSE_OK:
				self.do_replace()
			else:
				self.destroy()
		self.connect('response', response)

		vbox = g.VBox(False, 5)
		self.vbox.pack_start(vbox, True, True, 0)
		vbox.set_border_width(5)
		self.sizegroup = g.SizeGroup(g.SIZE_GROUP_HORIZONTAL)

		def field(name):
			hbox = g.HBox(False, 2)
			vbox.pack_start(hbox, False, True, 0)
			entry = g.Entry()
			label = g.Label(name)
			self.sizegroup.add_widget(label)
			hbox.pack_start(label, False, True, 0)
			hbox.pack_start(entry, True, True, 0)
			entry.set_text(history.get(name, ''))
			def changed(entry):
				history[name] = entry.get_text()
			entry.connect('changed', changed)
			entry.set_activates_default(True)
			
			return entry

		self.replace_entry = field(_('Replace:'))
		self.with_entry = field(_('With:'))
		
		
		hbox = g.HBox(False) 
		label = g.Label()
		self.sizegroup.add_widget(label)
		hbox.pack_start(label, False, False, 3)
		self.regex = g.CheckButton(_('Advanced search and replace'))
		hbox.pack_start(self.regex, False, False, 0)
		vbox.pack_start(hbox, False, True, 0)
		self.vbox.show_all()

		regex_help = RegexHelp()
		vbox.pack_start(regex_help, True, True, 0)

		self.python_with = g.CheckButton(_("Evaluate 'With' as Python expression"))
		def changed(toggle): history['Python'] = toggle.get_active()
		vbox.pack_start(self.python_with, False, True, 0)
		self.python_with.set_active(history.get('Python', False))
		self.python_with.connect('toggled', changed)

		def changed(toggle):
			history['Advanced'] = toggle.get_active()
			if toggle.get_active():
				regex_help.show()
				self.python_with.show()
			else:
				regex_help.hide()
				self.python_with.hide()
				self.resize(1, 1)
		self.regex.connect('toggled', changed)
		self.regex.set_active(history.get('Advanced', False))
	
	def do_replace(self, show_info = True):
		regex = self.regex.get_active()

		replace = self.replace_entry.get_text()
		if not replace:
			rox.alert(_('You need to specify something to search for...'))
			return
		with = self.with_entry.get_text()
		
		changes = [0]
		if regex:
			import re
			try:
				prog = re.compile(replace)
			except:
				rox.report_exception()
				return
			python = self.python_with.get_active()
			if python:
				try:
					code = compile(with, 'With', 'eval')
					def with(match):
						locals = {'old': match.group(0)}
						try:
							locals['x'] = float(locals['old'])
						except:
							locals['x'] = None
						return str(eval(code, locals))
				except:
					rox.report_exception()
					return
			def do_line(line):
				new, n = prog.subn(with, line)
				if n:
					changes[0] += 1
					return new
		else:
			def do_line(line):
				new = line.replace(replace, with)
				if new == line:
					return None
				changes[0] += 1
				return new

		try:
			self.edit_window.process_selected(do_line)
		except:
			rox.report_exception()
			return
		if not changes[0]:
			rox.alert(_('Search string not found'))
			return
		if show_info:
			if changes[0] == 1:
				rox.info(_('One line changed'))
			else:
				rox.info(_('%d lines changed') % changes[0])
		self.destroy()
