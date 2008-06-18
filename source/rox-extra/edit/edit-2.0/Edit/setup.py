import findrox; findrox.version(1, 19, 14)

import sys, os
import rox
from rox import g

try:
	import setup
	import __main__

	__main__.__builtins__._ = rox.i18n.translation(os.path.join(rox.app_dir, 'Messages'))

	g.rc_parse_string('style "edit-text-area" { GtkWidget::cursor-color = "#e00"\n'
			      'GtkWidget::cursor-aspect-ratio = 0.1}\n'
			      'style "edit-scrolled" { GtkScrolledWindow::scrollbar-spacing = 0}\n'
			      'class "GtkScrolledWindow" style : gtk "edit-scrolled"\n'
			      'class "GtkTextView" style : gtk "edit-text-area"\n')

	# Load icons
	factory = g.IconFactory()
	for name in ['rox-diff']:
		path = os.path.join(rox.app_dir, "images", name + ".png")
		pixbuf = g.gdk.pixbuf_new_from_file(path)
		if not pixbuf:
			print >>sys.stderr, "Can't load stock icon '%s'" % name
		g.stock_add([(name, name, 0, 0, "")])
		factory.add(name, g.IconSet(pixbuf = pixbuf))
	factory.add_default()

	from rox import choices
	choices.migrate('Edit', 'rox.sourceforge.net')
	rox.setup_app_options('Edit', site='rox.sourceforge.net')

	# Register options...
	import EditWindow
	import diff

	# All options must be registered by the time we get here
	rox.app_options.notify()
except:
	rox.report_exception()
