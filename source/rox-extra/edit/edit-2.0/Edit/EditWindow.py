
import rox
from rox import g, filer, app_options, mime
import sys
from rox.loading import XDSLoader
from rox.options import Option
from rox import OptionsBox
from rox.saving import Saveable
import os
import diff
import codecs

# WARNING: This is a temporary hack, until we write a way choose between
# the two ways of doing toolbars or we abandon the old method entirely
import warnings
warnings.filterwarnings('ignore', category=DeprecationWarning,
			module='EditWindow')
# End temporary hack

def optional_section(available):
	"""If requires is None, the section is enabled. Otherwise,
	the section is shaded and the requires message is shown at
	the top."""
	if available:
		def build_enabled_section(box, node, label):
			return box.do_box(node, None, g.VBox(False, 0))
		return build_enabled_section
	else:
		def build_disabled_section(box, node, label):
			assert label is not None
			box, = box.do_box(node, None, g.VBox(False, 0))
			box.set_sensitive(False)
			frame = g.Frame(label)
			box.set_border_width(4)
			frame.add(box)
			return [frame]
		return build_disabled_section

try:
	import gtkspell
	have_spell = True
except:
	have_spell = False

to_utf8 = codecs.getencoder('utf-8')

from buffer import Buffer, have_sourceview
from rox.Menu import Menu, set_save_name, SubMenu, Separator, Action, ToggleItem

OptionsBox.widget_registry['source-view-only'] = optional_section(have_sourceview)

default_font = Option('default_font', 'serif')

background_colour = Option('background', '#fff')
foreground_colour = Option('foreground', '#000')

auto_indent = Option('autoindent', '1')
word_wrap = Option('wordwrap', '1')

layout_left_margin = Option('layout_left_margin', 2)
layout_right_margin = Option('layout_right_margin', 4)

layout_before_para = Option('layout_before_para', 0)
layout_after_para = Option('layout_after_para', 0)
layout_inside_para = Option('layout_inside_para', 0)
layout_indent_para = Option('layout_indent_para', 2)

right_margin = Option('right_margin', 80)
show_margin = Option('show_margin', True)
smart_home_end = Option('smart_home_end', True)
show_line_numbers = Option('show_line_numbers', True)
show_line_markers = Option('show_line_markers', True)
tab_width = Option('tab_width', 4)
use_spaces_for_tabs = Option('use_spaces_for_tabs', False)

show_toolbar = Option('show_toolbar', 1)

set_save_name('Edit', site='rox.sourceforge.net')

edit_menu = [
  Action(_('Cut'),		'cut',		'<Ctrl>X', g.STOCK_CUT),
  Action(_('Copy'),	'copy',		'<Ctrl>C', g.STOCK_COPY),
  Action(_('Paste'),	'paste',	'<Ctrl>V', g.STOCK_PASTE),
  Separator(),
  Action(_('Undo'),	'undo',		'<Ctrl>Z', g.STOCK_UNDO),
  Action(_('Redo'),	'redo',		'<Ctrl>Y', g.STOCK_REDO),
  Separator(),
  Action(_('Search...'),	'search',	'F4', g.STOCK_FIND),
  Action(_('Search and Replace....'), 'search_replace',
					'<Ctrl>F4', g.STOCK_FIND_AND_REPLACE),
  Action(_('Goto line...'),	'goto',		'F5', g.STOCK_JUMP_TO),
  ]

bookmark_menu = [
  Separator(),
  Action(_('Toggle Bookmark'),	'toggle_bookmark',	'<Ctrl>F2'),
  Action(_('Next Bookmark'),	'next_bookmark',	'F2'),
  Action(_('Previous Bookmark'),	'prev_bookmark',	'<Shift>F2'),
  ]
  
if have_sourceview:
	edit_menu += bookmark_menu

menu = Menu('main', [
SubMenu(_('File'), [
  Action(_('Save'),	'save',		'<Ctrl>S', g.STOCK_SAVE),
  Action(_('Save As...'),	'save_as',	'', g.STOCK_SAVE_AS),
  Action(_('Open Parent'),	'up',		'', g.STOCK_GO_UP),
  Action(_('Show Changes'),	'diff', 	'', 'rox-diff'),
  ToggleItem(_('Word Wrap'), 'word_wrap'),
  Action(_('Close'),	'close',	'', g.STOCK_CLOSE),
  Separator(),
  Action(_('New'),	'new',		'', g.STOCK_NEW)]),

SubMenu(_('Edit'), edit_menu),

Action(_('Options'),		'show_options', '', g.STOCK_PROPERTIES),
Action(_('Help'),		'help',		'F1', g.STOCK_HELP),
])

known_codecs = (
	"iso8859_1", "iso8859_2", "iso8859_3", "iso8859_4", "iso8859_5",
	"iso8859_6", "iso8859_7", "iso8859_8", "iso8859_9", "iso8859_10",
	"iso8859_13", "iso8859_14", "iso8859_15",
	"ascii", "base64_codec", "charmap",
	"cp037", "cp1006", "cp1026", "cp1140", "cp1250", "cp1251", "cp1252",
	"cp1253", "cp1254", "cp1255", "cp1256", "cp1257", "cp1258", "cp424",
	"cp437", "cp500", "cp737", "cp775", "cp850", "cp852", "cp855", "cp856",
	"cp857", "cp860", "cp861", "cp862", "cp863", "cp864", "cp865", "cp866",
	"cp869", "cp874", "cp875", "hex_codec",
	"koi8_r",
	"latin_1",
	"mac_cyrillic", "mac_greek", "mac_iceland", "mac_latin2", "mac_roman", "mac_turkish",
	"mbcs", "quopri_codec", "raw_unicode_escape",
	"rot_13",
	"utf_16_be", "utf_16_le", "utf_16", "utf_7", "utf_8", "uu_codec",
	"zlib_codec"
)

class Abort(Exception):
	pass

class Minibuffer:
	def setup(self):
		"""Called when the minibuffer is opened."""
	
	def key_press(self, kev):
		"""A keypress event in the minibuffer text entry."""
	
	def changed(self):
		"""The minibuffer text has changed."""
	
	def activate(self):
		"""Return or Enter pressed."""
	
	info = 'Press Escape to close the minibuffer.'

class DiffLoader(XDSLoader):
	def __init__(self, window):
		XDSLoader.__init__(self, ['text/plain'])
		self.window = window
	
	def xds_load_from_file(self, path):
		self.window.diff(path = path)
	
	def xds_load_from_stream(self, name, type, stream):
		tmp = diff.Tmp(suffix = '-' + (name or 'tmp'))
		import shutil
		shutil.copyfileobj(stream, tmp)
		tmp.seek(0)
		self.window.diff(path = tmp.name)

class EditWindow(rox.Window, XDSLoader, Saveable):
	_word_wrap = False
	wrap_button = None
	
	def __init__(self, filename = None, show = True, line_number = None):
		rox.Window.__init__(self)
		XDSLoader.__init__(self, ['text/plain', 'UTF8_STRING'])
		self.set_default_size(g.gdk.screen_width() * 2 / 3,
				      g.gdk.screen_height() / 2)

		self.savebox = None
		self.info_box = None
		self.language = None

		app_options.add_notify(self.update_styles)
		
		if filename:
			import os.path
			if not os.path.exists(filename):
				try:
					filename2, line_number = filename.split(':')
					line_number = long(line_number)
				except ValueError:
					# Either there was no ':', or it wasn't followed by a number
					pass
				else:
					filename = filename2
			self.uri = os.path.abspath(filename)
			self.mime_type = mime.get_type(self.uri, 1)
		else:
			self.uri = None			
			self.mime_type = mime.lookup('text', 'plain')

		self.buffer = Buffer()

		try:
			import gtksourceview
			self.text = gtksourceview.SourceView(self.buffer)
			pixbuf = g.gdk.pixbuf_new_from_file(rox.app_dir+"/images/marker.png")
			self.text.set_marker_pixbuf("bookmark", pixbuf)			
			if self.mime_type:
				self.buffer.set_type(self.mime_type)
		except:
			self.text = g.TextView()
			self.text.set_buffer(self.buffer)
			
		self.text.set_size_request(10, 10)
		self.xds_proxy_for(self.text)
		
		self.insert_mark = self.buffer.get_mark('insert')
		self.selection_bound_mark = self.buffer.get_mark('selection_bound')
		start = self.buffer.get_start_iter()
		self.mark_start = self.buffer.create_mark('mark_start', start, True)
		self.mark_end = self.buffer.create_mark('mark_end', start, False)
		self.mark_tmp = self.buffer.create_mark('mark_tmp', start, False)
		tag = self.buffer.create_tag('marked')
		tag.set_property('background', 'green')
		self.marked = 0

		# When searching, this is where the cursor was when the minibuffer
		# was opened.
		start = self.buffer.get_start_iter()
		self.search_base = self.buffer.create_mark('search_base', start, True)

		vbox = g.VBox(False)
		self.add(vbox)

		tools = g.Toolbar()
		tools.set_style(g.TOOLBAR_ICONS)
		vbox.pack_start(tools, False, True, 0)

		self.status_label = g.Label('')
		tools.append_widget(self.status_label, None, None)
		tools.insert_stock(g.STOCK_HELP, _('Help'), None, self.help, None, 0)
		diff = tools.insert_stock('rox-diff', _('Show changes from saved copy.\n'
				'Or, drop a backup file onto this button to see changes from that.'),
				None, self.diff, None, 0)
		DiffLoader(self).xds_proxy_for(diff)
		
		if have_spell:
			self.spell = None
			image_spell = g.Image()
			image_spell.set_from_stock(g.STOCK_SPELL_CHECK, tools.get_icon_size()) 
			self.spell_button  = tools.insert_element(g.TOOLBAR_CHILD_TOGGLEBUTTON,
					None, _("Check Spelling"), _("Check Spelling"), None,
					image_spell, self.toggle_spell, None, 0)			
			
		image_wrap = g.Image()
		image_wrap.set_from_file(rox.app_dir + '/images/rox-word-wrap.png')
		self.wrap_button = tools.insert_element(g.TOOLBAR_CHILD_TOGGLEBUTTON,
					None, _("Word Wrap"), _("Word Wrap"), None, image_wrap,
					lambda button: self.set_word_wrap(button.get_active()),
					None, 0)
		tools.insert_stock(g.STOCK_REDO, _('Redo'), None, self.redo, None, 0)
		tools.insert_stock(g.STOCK_UNDO, _('Undo'), None, self.undo, None, 0)
		tools.insert_stock(g.STOCK_FIND_AND_REPLACE, _('Replace'), None, self.search_replace, None, 0)
		tools.insert_stock(g.STOCK_FIND, _('Search'), None, self.search, None, 0)
		tools.insert_stock(g.STOCK_SAVE_AS, _('Save As'), None, self.save_as, None, 0)
		self.save_button = tools.insert_stock(g.STOCK_SAVE, _('Save'), None, self.save, None, 0)
		tools.insert_stock(g.STOCK_GO_UP, _('Up'), None, self.up, None, 0)
		tools.insert_stock(g.STOCK_CLOSE, _('Close'), None, self.close, None, 0)
		# Set minimum size to ignore the label
		tools.set_size_request(tools.size_request()[0], -1)

		self.tools = tools
		
		swin = g.ScrolledWindow()
		swin.set_policy(g.POLICY_AUTOMATIC, g.POLICY_AUTOMATIC)
		vbox.pack_start(swin, True, True)

		swin.add(self.text)
		
		if show:
			self.show_all()
		self.update_styles()

		self.update_title()

		# Create the minibuffer
		self.mini_hbox = g.HBox(False)

		info = rox.ButtonMixed(g.STOCK_DIALOG_INFO, '')
		info.set_relief(g.RELIEF_NONE)
		info.unset_flags(g.CAN_FOCUS)
		info.connect('clicked', self.mini_show_info)
		
		close = rox.ButtonMixed(g.STOCK_STOP, '')
		close.set_relief(g.RELIEF_NONE)
		close.unset_flags(g.CAN_FOCUS)
		close.connect('clicked', lambda e: self.set_minibuffer(None))

		self.mini_hbox.pack_end(info, False, True, 0)
		self.mini_hbox.pack_start(close, False, True, 0)
		self.mini_label = g.Label('')
		self.mini_hbox.pack_start(self.mini_label, False, True, 0)
		self.mini_entry = g.Entry()
		self.mini_hbox.pack_start(self.mini_entry, True, True, 0)
		vbox.pack_start(self.mini_hbox, False, True)
		self.mini_entry.connect('key-press-event', self.mini_key_press)
		self.mini_entry.connect('changed', self.mini_changed)

		self.connect('destroy', self.destroyed)

		self.connect('delete-event', self.delete_event)
		self.text.grab_focus()
		self.text.connect('key-press-event', self.key_press)
			
		# FIXME: why does this freeze Edit?
		#if have_spell:
			#if self.mime_type.media == 'text' and self.mime_type.subtype == 'plain':
				#self.toggle_spell()
				##self.spell.set_language ("en_US")		
		
		def update_current_line(*unused):
			cursor = self.buffer.get_iter_at_mark(self.insert_mark)
			bound = self.buffer.get_iter_at_mark(self.selection_bound_mark)
			if cursor.compare(bound) == 0:
				n_lines = self.buffer.get_line_count()
				self.status_label.set_text(_('Line %s of %d') % (cursor.get_line() + 1, n_lines))
			else:
				n_lines = abs(cursor.get_line() - bound.get_line()) + 1
				if n_lines == 1:
					n_chars = abs(cursor.get_line_offset() - bound.get_line_offset())
					if n_chars == 1:
						bytes = to_utf8(self.buffer.get_text(cursor, bound, False))[0]
						self.status_label.set_text(_('One character selected (%s)') %
							' '.join(map(lambda x: '0x%2x' % ord(x), bytes)))
					else:
						self.status_label.set_text(_('%d characters selected') % n_chars)
				else:
					self.status_label.set_text(_('%d lines selected') % n_lines)
		self.buffer.connect('mark-set', update_current_line)
		self.buffer.connect('changed', update_current_line)

	
		# Loading might take a while, so get something on the screen
		# now...
		g.gdk.flush()

		if filename:
			try:
				self.load_file(filename)
				if filename != '-':
					self.save_last_stat = os.stat(filename)
			except Abort:
				self.destroy()
				raise

		self.buffer.connect('modified-changed', self.update_title)
		self.buffer.set_modified(False)

		def button_press(text, event):
			if event.button != 3:
				return False
			#self.text.emit('populate-popup', menu.menu)
			menu.popup(self, event)
			return True
		self.text.connect('button-press-event', button_press)
		self.text.connect('popup-menu', lambda text: menu.popup(self, None))

		menu.attach(self, self)
		self.buffer.place_cursor(self.buffer.get_start_iter())
		self.buffer.start_undo_history()

		if line_number:
			iter = self.buffer.get_iter_at_line(int(line_number) - 1)
			self.buffer.place_cursor(iter)
			self.text.scroll_to_mark(self.insert_mark, 0.05, False)
	
	def key_press(self, text, kev):
		if kev.keyval == g.keysyms.Return or kev.keyval == g.keysyms.KP_Enter:
			return self.auto_indent()
		elif kev.keyval == g.keysyms.Tab or kev.keyval == g.keysyms.KP_Tab:
			return self.indent_block()
		elif kev.keyval == g.keysyms.ISO_Left_Tab:
			return self.unindent_block()
			
	def auto_indent(self):
		if not auto_indent.int_value:
			return False
			
		start = self.buffer.get_iter_at_mark(self.insert_mark)
		end = start.copy()
		start.set_line_offset(0)
		end.forward_to_line_end()
		line = self.buffer.get_text(start, end, False)
		indent = ''
		
		if self.mime_type.subtype == 'x-python':
			try:
				l = line.split('\n')[0]
			except:
				l = line
			if l.endswith(':') and not l.startswith('#'):
				if use_spaces_for_tabs.int_value:
					indent += ' ' * tab_width.int_value
				else:
					indent += '\t'
		elif have_sourceview:
			return False
			
		for x in line:
			if x in ' \t':
				indent += x
			else:
				break
		
		self.buffer.begin_user_action()
		self.buffer.insert_at_cursor('\n' + indent)
		self.buffer.end_user_action()
		return True

	def indent_block(self):
		try:
			(start, end) = self.buffer.get_selection_bounds()
			start_line = start.get_line()
			end_line = end.get_line()
			self.buffer.begin_user_action()
			for i in range(start_line, end_line+1):
				iter = self.buffer.get_iter_at_line(i)
				self.buffer.insert(iter, '\t')
			self.buffer.end_user_action()
			return True
		except:
			return False
		
	def unindent_block(self):
		try:
			(start, end) = self.buffer.get_selection_bounds()
			start_line = start.get_line()
			end_line = end.get_line()
			self.buffer.begin_user_action()
			for i in range(start_line, end_line+1):
				iter = self.buffer.get_iter_at_line(i)
				if iter.get_char() == '\t':
					next_char = iter.copy()
					next_char.forward_char()
					self.buffer.delete(iter, next_char)
			self.buffer.end_user_action()
			return True
		except:
			return False

	def destroyed(self, widget):
		app_options.remove_notify(self.update_styles)
		
	def update_styles(self):
		try:
			import pango
			font = pango.FontDescription(default_font.value)
			bg = g.gdk.color_parse(background_colour.value)
			fg = g.gdk.color_parse(foreground_colour.value)

			self.text.set_left_margin(layout_left_margin.int_value)
			self.text.set_right_margin(layout_right_margin.int_value)
			
			self.text.set_pixels_above_lines(layout_before_para.int_value)
			self.text.set_pixels_below_lines(layout_after_para.int_value)
			self.text.set_pixels_inside_wrap(layout_inside_para.int_value)
			self.text.set_indent(layout_indent_para.int_value)

			self.word_wrap = bool(word_wrap.int_value)

			if show_toolbar.int_value:
				self.tools.show()
			else:
				self.tools.hide()
		except:
			rox.report_exception()
		else:
			self.text.modify_font(font)
			self.text.modify_base(g.STATE_NORMAL, bg)
			self.text.modify_text(g.STATE_NORMAL, fg)

		if have_sourceview:
			self.text.set_show_line_numbers(show_line_numbers.int_value)
			self.text.set_show_line_markers(show_line_markers.int_value)
			self.text.set_auto_indent(auto_indent.int_value)
			self.text.set_tabs_width(tab_width.int_value)
			self.text.set_insert_spaces_instead_of_tabs(use_spaces_for_tabs.int_value)
			self.text.set_margin(right_margin.int_value)
			self.text.set_show_margin(show_margin.int_value)
			self.text.set_smart_home_end(smart_home_end.int_value)
			if self.buffer.language == 'Python':
				self.text.set_auto_indent(False)

	def cut(self): self.text.emit('cut_clipboard')
	def copy(self): self.text.emit('copy_clipboard')
	def paste(self): self.text.emit('paste_clipboard')
	
	def delete_event(self, window, event):
                if self.buffer.get_modified():
                        self.save_as(discard = 1)
                        return 1
                return 0

	def update_title(self, *unused):
		title = self.uri or '<'+_('Untitled')+'>'
                if self.buffer.get_modified():
                        title = title + " *"
			self.save_button.set_sensitive(True)
		else:
			self.save_button.set_sensitive(False)
                self.set_title(title)

        def xds_load_from_stream(self, name, t, stream):
		if t == 'UTF8_STRING':
			return	# Gtk will handle it
		try:
			self.insert_data(stream.read())
		except Abort:
			pass
	
	def get_encoding(self, message):
		"Returns (encoding, errors), or raises Abort to cancel."
		box = g.MessageDialog(self, 0, g.MESSAGE_QUESTION, g.BUTTONS_CANCEL, message)
		box.set_has_separator(False)

		frame = g.Frame()
		box.vbox.pack_start(frame, True, True)
		frame.set_border_width(6)

		hbox = g.HBox(False, 4)
		hbox.set_border_width(6)

		hbox.pack_start(g.Label(_('Encoding:')), False, True, 0)
		combo = g.Combo()
		combo.disable_activate()
		combo.entry.connect('activate', lambda w: box.activate_default())
		combo.set_popdown_strings(known_codecs)
		hbox.pack_start(combo, True, True, 0)
		ignore_errors = g.CheckButton(_('Ignore errors'))
		hbox.pack_start(ignore_errors, False, True)

		frame.add(hbox)
		
		box.vbox.show_all()
		box.add_button(g.STOCK_CONVERT, g.RESPONSE_YES)
		box.set_default_response(g.RESPONSE_YES)

		while 1:
			combo.entry.grab_focus()
			
			resp = box.run()
			if resp != g.RESPONSE_YES:
				box.destroy()
				raise Abort

			if ignore_errors.get_active():
				errors = 'replace'
			else:
				errors = 'strict'
			encoding = combo.entry.get_text()
			try:
				codecs.getdecoder(encoding)
				break
			except:
				rox.alert(_("Unknown encoding '%s'") % encoding)
			
		box.destroy()

		return encoding, errors
	
	def insert_data(self, data):
		import codecs
		errors = 'strict'
		encoding = 'utf-8'
		while 1:
			decoder = codecs.getdecoder(encoding)
			try:
				data = decoder(data, errors)[0]
				if errors == 'strict':
					assert '\0' not in data
				else:
					if '\0' in data:
						data = data.replace('\0', '\\0')
				break
			except:
				pass

			encoding, errors = self.get_encoding(
				_("Data is not valid %s. Please select the file's encoding. "
				  "Turn on 'ignore errors' to try and load it anyway.")
				  % encoding)

		self.buffer.begin_user_action()
		self.buffer.insert_at_cursor(data)
		self.buffer.end_user_action()
		return 1
	
	def load_file(self, path):
		try:
			if path == '-':
				file = sys.stdin
			else:
				file = open(path, 'r')
			contents = file.read()
			if path != '-':
				file.close()
				
			self.buffer.begin_not_undoable_action()
			self.insert_data(contents)
			self.buffer.end_not_undoable_action()	
		except Abort:
			raise
		except:
			rox.report_exception()
			raise Abort
	
	def close(self, button = None):
                if self.buffer.get_modified():
                        self.save_as(discard = 1)
                else:
                        self.destroy()

	def discard(self):
                self.destroy()

        def up(self, button = None):
                if self.uri:
                        filer.show_file(self.uri)
                else:
                        rox.alert(_('File is not saved to disk yet'))
                        
                     
	def toggle_spell(self, button = None):
		if self.spell:
			self.spell.detach()
			self.spell = None
			self.spell_button.set_active(False)
		else:
			try:
				self.spell = gtkspell.Spell(self.text)
				self.spell_button.set_active(True)
			except:
				self.spell = None
				self.spell_button.set_active(False)
		    
		#self.spell_button.set_active(self.spell != None)
	
	def diff(self, button = None, path = None):
		path = path or self.uri
		if not path:
			rox.alert(_('This file has never been saved; nothing to compare it to!\n'
				    'Note: you can drop a file onto the toolbar button to see '
				    'the changes from that file.'))
			return
		diff.show_diff(path, self.save_to_stream)

	def has_selection(self):
		s, e = self.get_selection_range()
		return not e.equal(s)
	
	def get_marked_range(self):
		s = self.buffer.get_iter_at_mark(self.mark_start)
		e = self.buffer.get_iter_at_mark(self.mark_end)
		if s.compare(e) > 0:
			return e, s
		return s, e

	def get_selection_range(self):
		s = self.buffer.get_iter_at_mark(self.insert_mark)
		e = self.buffer.get_iter_at_mark(self.selection_bound_mark)
		if s.compare(e) > 0:
			return e, s
		return s, e

	def save(self, widget = None):
		if self.uri:
			self.save_to_file(self.uri)
			self.buffer.set_modified(False)
		else:
			self.save_as(discard=0)

	def save_as(self, widget = None, discard = 0):
		from rox.saving import SaveBox

		if self.savebox:
			self.savebox.destroy()

		try:
			self.mime_type = mime.get_type(self.uri, 1)
		except:
			self.mime_type = mime.lookup('text', 'plain')
			
		mime_text = self.mime_type.media + '/' + self.mime_type.subtype
		
		if self.has_selection() and not discard:
			saver = SelectionSaver(self)
			self.savebox = SaveBox(saver, 'Selection', mime_text)
			self.savebox.connect('destroy', lambda w: saver.destroy())
		else:
			uri = self.uri or _('TextFile')
			self.savebox = SaveBox(self, uri, mime_text, discard)
		self.savebox.show()

        def help(self, button = None):
                filer.open_dir(os.path.join(rox.app_dir, 'Help'))
	
	def save_to_stream(self, stream):
		s = self.buffer.get_start_iter()
		e = self.buffer.get_end_iter()
                stream.write(self.buffer.get_text(s, e, True))
	
	def set_uri(self, uri):
                self.uri = uri
		self.buffer.set_modified(False)
                self.update_title()
	
	def new(self):
		EditWindow()
	
	def change_font(self):
		style = self.text.get_style().copy()
		style.font = load_font(options.get('edit_font'))
		self.text.set_style(style)
	
	def show_options(self):
		rox.edit_options()
	
	def set_marked(self, start = None, end = None):
		"Set the marked region (from the selection if no region is given)."
		self.clear_marked()
		assert not self.marked

		buffer = self.buffer
		if start:
			assert end
		else:
			assert not end
			start, end = self.get_selection_range()
		buffer.move_mark(self.mark_start, start)
		buffer.move_mark(self.mark_end, end)
		buffer.apply_tag_by_name('marked',
			buffer.get_iter_at_mark(self.mark_start),
			buffer.get_iter_at_mark(self.mark_end))
		self.marked = 1
	
	def clear_marked(self):
		if not self.marked:
			return
		self.marked = 0
		buffer = self.buffer
		buffer.remove_tag_by_name('marked',
			buffer.get_iter_at_mark(self.mark_start),
			buffer.get_iter_at_mark(self.mark_end))
	
	def undo(self, widget = None):
		self.buffer.undo()
		cursor = self.buffer.get_iter_at_mark(self.insert_mark)
		self.text.scroll_to_iter(cursor, 0.05, False)
	
	def redo(self, widget = None):
		self.buffer.redo()
		cursor = self.buffer.get_iter_at_mark(self.insert_mark)
		self.text.scroll_to_iter(cursor, 0.05, False)

	def goto(self, widget = None):
		from goto import Goto
		self.set_minibuffer(Goto())
	
	def search(self, widget = None):
		from search import Search
		self.set_minibuffer(Search())
	
	def search_replace(self, widget = None):
		from search import Replace
		Replace(self).show()
	
	def toggle_bookmark(self):
		cursor = self.buffer.get_iter_at_mark(self.insert_mark)
		name = str(cursor.get_line())
		marker = self.buffer.get_marker(name)
		if marker:
			self.buffer.delete_marker(marker);		
		else:
			marker = self.buffer.create_marker(name, "bookmark", cursor);		
		
	def next_bookmark(self):
		cursor = self.buffer.get_iter_at_mark(self.insert_mark)
		cursor.forward_char()
		marker = self.buffer.get_next_marker(cursor)
		if marker:
			self.buffer.get_iter_at_marker (cursor, marker)
			self.buffer.place_cursor(cursor)
			self.text.scroll_to_iter(cursor, 0.05, False)

	def prev_bookmark(self):
		cursor = self.buffer.get_iter_at_mark(self.insert_mark)
		cursor.backward_char()
		marker = self.buffer.get_prev_marker(cursor)
		if marker:
			self.buffer.get_iter_at_marker (cursor, marker)
			self.buffer.place_cursor(cursor)
			self.text.scroll_to_iter(cursor, 0.05, False)

	def set_mini_label(self, label):
		self.mini_label.set_text(label)

	def set_minibuffer(self, minibuffer):
		assert minibuffer is None or isinstance(minibuffer, Minibuffer)

		try:
			self.minibuffer.close()
		except:
			pass
			
		self.minibuffer = None

		if minibuffer:
			self.mini_entry.set_text('')
			self.minibuffer = minibuffer
			minibuffer.setup(self)
			self.mini_entry.grab_focus()
			self.mini_hbox.show_all()
		else:
			self.mini_hbox.hide()
			self.text.grab_focus()
	
	def mini_key_press(self, entry, kev):
		if kev.keyval == g.keysyms.Escape:
			self.set_minibuffer(None)
			return 1
		if kev.keyval == g.keysyms.Return or kev.keyval == g.keysyms.KP_Enter:
			self.minibuffer.activate()
			return 1

		return self.minibuffer.key_press(kev)
	
	def mini_changed(self, entry):
		if not self.minibuffer:
			return
		self.minibuffer.changed()

	def mini_show_info(self, *unused):
		assert self.minibuffer
		if self.info_box:
			self.info_box.destroy()
		self.info_box = g.MessageDialog(self, 0, g.MESSAGE_INFO, g.BUTTONS_OK,
						self.minibuffer.info)
		self.info_box.set_title(_('Minibuffer help'))
		def destroy(box):
			self.info_box = None
		self.info_box.connect('destroy', destroy)
		self.info_box.show()
		self.info_box.connect('response', lambda w, r: w.destroy())
	
	def process_selected(self, process):
		"""Calls process(line) on each line in the selection, or each line in the file
		if there is no selection. If the result is not None, the text is replaced."""
		self.buffer.begin_user_action()
		try:
			self._process_selected(process)
		finally:
			self.buffer.end_user_action()
	
	def _process_selected(self, process):
		if self.has_selection():
			def get_end():
				start, end = self.get_selection_range()
				if start.compare(end) > 0:
					return start
				return end
			start, end = self.get_selection_range()
			if start.compare(end) > 0:
				start = end
		else:
			def get_end():
				return self.buffer.get_end_iter()
			start = self.buffer.get_start_iter()
		end = get_end()

		while start.compare(end) <= 0:
			line_end = start.copy()
			line_end.forward_to_line_end()
			if line_end.compare(end) >= 0:
				line_end = end
			line = self.buffer.get_text(start, line_end, False)
			new = process(line)
			if new is not None:
				self.buffer.move_mark(self.mark_tmp, start)
				self.buffer.insert(line_end, new)
				start = self.buffer.get_iter_at_mark(self.mark_tmp)
				line_end = start.copy()
				line_end.forward_chars(len(line.decode('utf-8')))
				self.buffer.delete(start, line_end)
				
				start = self.buffer.get_iter_at_mark(self.mark_tmp)
				end = get_end()
			if not start.forward_line(): break

	def set_word_wrap(self, value):
		self._word_wrap = value
		self.wrap_button.set_active(value)
		if value:
			self.text.set_wrap_mode(g.WRAP_WORD)
		else:
			self.text.set_wrap_mode(g.WRAP_NONE)
	
	word_wrap = property(lambda self: self._word_wrap, set_word_wrap)

class SelectionSaver(Saveable):
	def __init__(self, window):
		self.window = window
		window.set_marked()
	
	def save_to_stream(self, stream):
		s, e = self.window.get_marked_range()
		stream.write(self.window.buffer.get_text(s, e, True))
	
	def destroy(self):
		# Called when savebox is remove. Get rid of the selection marker
		self.window.clear_marked()
