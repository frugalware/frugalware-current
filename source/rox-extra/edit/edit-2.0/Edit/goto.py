from rox import g
import rox
from EditWindow import Minibuffer

class Goto(Minibuffer):
	"A minibuffer used to find a line by number."

	def setup(self, window):
		self.window = window
		self.window.set_mini_label(_('Goto line:'))
	
	info = _('Enter the line number to go to. Line numbers start from 1. '
		 'Press Escape to cancel, or Return to jump to the line.')
	
	def activate(self):
		line = self.window.mini_entry.get_text()
		if line:
			try:
				line = int(line)
				assert line >= 1
			except:
				rox.alert(_('Invalid line number: %s') % line)
			else:
				buffer = self.window.buffer
				iter = buffer.get_iter_at_line(line - 1)
				buffer.place_cursor(iter)
				self.window.text.scroll_to_iter(iter, 0.05, False)
		self.window.set_minibuffer(None)
