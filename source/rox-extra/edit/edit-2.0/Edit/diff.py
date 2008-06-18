import rox
import os
from rox import processes, g
from rox.options import Option

try:
	processes.PipeThroughCommand
except:
	rox.croak('Edit requires ROX-Lib 1.9.11 or later. Sorry!\n'
		  '\nhttp://rox.sourceforge.net/rox_lib.html')

header_fg = Option('headers_fg', '#000')
header_bg = Option('headers_bg', '#ddd')

static_fg = Option('static_fg', '#000')
static_bg = Option('static_bg', '#fff')

additions_fg = Option('additions_fg', '#000')
additions_bg = Option('additions_bg', '#8f8')

deletions_fg = Option('deletions_fg', '#000')
deletions_bg = Option('deletions_bg', '#f88')

tags = g.TextTagTable()

header = g.TextTag('header')
tags.add(header)

static = g.TextTag('static')
tags.add(static)

add = g.TextTag('add')
tags.add(add)
remove = g.TextTag('remove')
tags.add(remove)

def options_changed():
	header.set_property('foreground', header_fg.value)
	header.set_property('background', header_bg.value)
	static.set_property('foreground', static_fg.value)
	static.set_property('background', static_bg.value)
	add.set_property('foreground', additions_fg.value)
	add.set_property('background', additions_bg.value)
	remove.set_property('foreground', deletions_fg.value)
	remove.set_property('background', deletions_bg.value)

rox.app_options.add_notify(options_changed)

class Diff(processes.PipeThroughCommand):
	def __init__(self, uri, src, dst):
		processes.PipeThroughCommand.__init__(self, ('diff', '-u', '--', uri, '-'), src, dst)
		self.wait()
	
	def check_errors(self, errors, status):
		if errors:
			raise Exception(errors)

def Tmp(mode = 'w+b', suffix = '-tmp'):
	"Create a seekable, randomly named temp file (deleted automatically after use)."
	import tempfile
	try:
		return tempfile.NamedTemporaryFile(mode, suffix = suffix)
	except:
		# python2.2 doesn't have NamedTemporaryFile...
		pass

	import random
	name = tempfile.mktemp(`random.randint(1, 1000000)` + suffix)

	fd = os.open(name, os.O_RDWR|os.O_CREAT|os.O_EXCL, 0700)
	tmp = tempfile.TemporaryFileWrapper(os.fdopen(fd, mode), name)
	tmp.name = name
	return tmp

class DiffWindow(rox.Dialog):
	def __init__(self, uri, diff):
		rox.Dialog.__init__(self)
		self.set_title(_('Changes to %s') % uri)
		self.set_has_separator(False)
		
		buffer = g.TextBuffer(tags)
		text = g.TextView(buffer)
		text.set_editable(False)
		text.set_cursor_visible(False)
		text.modify_base(g.STATE_NORMAL, g.gdk.color_parse(static_bg.value))

		swin = g.ScrolledWindow()
		swin.set_shadow_type(g.SHADOW_IN)
		swin.set_policy(g.POLICY_AUTOMATIC, g.POLICY_ALWAYS)
		self.vbox.pack_start(swin)
		swin.add(text)
		self.vbox.show_all()

		self.add_button(g.STOCK_CLOSE, g.RESPONSE_OK)
		self.connect('response', lambda b, r: self.destroy())

		iter = buffer.get_start_iter()
		for line in diff.split('\n'):
			line += '\n'
			if line[:4] in ('--- ', '+++ ', '@@ -'):
				tag = header
			elif line.startswith('-'):
				tag = remove
				if len(line) < 3: line = '  \n'
			elif line.startswith('+'):
				tag = add
				if len(line) < 3: line = '  \n'
			else:
				tag = static
			buffer.insert_with_tags(iter, line, tag)

		width = g.gdk.screen_width() * 3 / 4
		height = g.gdk.screen_height() * 1 / 2
		self.set_default_size(width, height)


def show_diff(uri, writer):
	from cStringIO import StringIO
	src = Tmp(suffix = '-diff')
	dst = StringIO()
	writer(src)
	src.seek(0)
	Diff(uri, src, dst)
	del src
	diff = dst.getvalue()
	del dst
	if not diff:
		rox.info(_('There is no difference between this version and the saved one.'))
	else:
		DiffWindow(uri, diff).show()
