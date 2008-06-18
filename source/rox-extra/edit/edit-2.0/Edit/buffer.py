import rox
from rox import g

# GtkSourceBuffer is a subclass of GtkTextBuffer which provides extra
# features. We'll use it if it's available, or GtkTextBuffer if not.
try:
	import gtksourceview
	_parentClass = gtksourceview.SourceBuffer
	have_sourceview = True
except:
	_parentClass = g.TextBuffer
	have_sourceview = False
	

DELETE = 1
INSERT = 2

# As operations are performed, they are added to 'in_progress'.
# When complete, the whole group is added to undo_buffer.

class Buffer(_parentClass):
	"A buffer that deals with undo/redo."

	action_nest_level = 0

	def __init__(self):
		if have_sourceview:
			_parentClass.__init__(self)
			self.set_max_undo_levels(1000)
		else:
			_parentClass.__init__(self, None)
        
		self.in_progress = None
		self.undo_buffer = []
		self.redo_buffer = []	# Will be None during undo or redo

		if have_sourceview:
			self.lm = gtksourceview.SourceLanguagesManager()
			self.set_data('languages-manager', self.lm)
	
	def set_type(self, mime_type):
		"""Set up syntax highlighting, if available"""
		self.language = None
		if not have_sourceview: return
		if not mime_type: return

		language = self.lm.get_language_from_mime_type(mime_type.media + '/' + mime_type.subtype)
		if language:
			self.set_highlight(True)
			self.set_language(language)			
			self.language = language.get_name()
		else:
			#print 'No language found for mime type "%s"' % mime_type
			self.set_highlight(False)
	
	def start_undo_history(self):
		if have_sourceview: return
		def begin(buffer):
			self.action_nest_level += 1
			if self.action_nest_level == 1:
				assert self.in_progress is None
				self.in_progress = []
		
		self.connect('begin-user-action', begin)
		def end_action(buffer):
			self.action_nest_level -= 1
			assert self.action_nest_level >= 0
			if self.action_nest_level == 0:
				assert self.in_progress is not None
				if self.in_progress:
					self.undo_buffer.append(self.in_progress)
				self.in_progress = None
		self.connect('end-user-action', end_action)
		self.connect('delete-range', self.delete_range)
		self.connect('insert-text', self.insert_text)
	
	def delete_range(self, buffer, start, end):
		self.in_progress.append((INSERT,
				 start.get_offset(),
				 buffer.get_slice(start, end, True)))
		if self.redo_buffer:
			self.redo_buffer = []
	
	def insert_text(self, buffer, where, text, len):
		text = text[:len]	# PyGtk bug?
		start = where.get_offset()
		self.in_progress.append((DELETE,
					start, start + len, text))
		if self.redo_buffer:
			self.redo_buffer = []
	
	try:
		g.TextBuffer(None).insert_at_cursor('hello')
	except:
		# Old version of pygtk
		def insert(self, iter, text):
			g.TextBuffer.insert(self, iter, text, -1)
		def insert_at_cursor(self, text):
			g.TextBuffer.insert_at_cursor(self, text, -1)

	def do_action(self, op):
		if op[0] == DELETE:
			start = self.get_iter_at_offset(op[1])
			end = self.get_iter_at_offset(op[2])
			self.delete(start, end)
		elif op[0] == INSERT:
			start = self.get_iter_at_offset(op[1])
			self.insert(start, op[2])
		else:
			rox.alert('Unknown entry in undo buffer!\n' + `op`)

	def undo(self, hist = None):
		if have_sourceview:
			if self.can_undo():
				_parentClass.undo(self)
			return

		if hist is None: hist = self.undo_buffer

		if not hist:
			g.gdk.beep()
			return	# Nothing to undo/redo

		assert not self.in_progress

		# List of actions to perform
		group = hist.pop()
		
		old_redo, self.redo_buffer = self.redo_buffer, None

		try:
			self.begin_user_action()
			group.reverse()
			for action in group:
				self.do_action(action)
		finally:
			self.redo_buffer = old_redo
			if hist is self.undo_buffer:
				self.redo_buffer.append(self.in_progress)
			else:
				self.undo_buffer.append(self.in_progress)
			self.in_progress = []

			self.end_user_action()
	
	def redo(self):
		if have_sourceview:
			_parentClass.redo(self)
		else: 
			self.undo(hist = self.redo_buffer)


	def begin_not_undoable_action(self):
		if have_sourceview:
			_parentClass.begin_not_undoable_action(self)
	
	def end_not_undoable_action(self):
		if have_sourceview:
			_parentClass.end_not_undoable_action(self)

	
