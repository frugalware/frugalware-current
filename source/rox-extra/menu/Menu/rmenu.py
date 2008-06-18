"""
    rmenu.py (a application menu applet for the ROX Panel)

    Copyright 2004-2005 Kenneth Hayber <ken@hayber.us>,
                        Christopher Arndt <chris@chrisarndt.de>
            All rights reserved.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License.

    This program is distributed in the hope that it will be useful
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
"""

# standard library modules
import sys, os, time, shelve
from os.path import dirname, exists, expanduser, join, isdir, isfile, realpath
try:
    set()
except NameError:
    from sets import Set as set

# third-party modules
import rox
from rox import g, app_options, applet, choices, filer, Menu, mime
from rox.options import Option
from rox.OptionsBox import REVERT

from cache import CacheManager, CacheMiss

# globals
APP_NAME = 'Menu'
APP_DIR = rox.app_dir
APP_SIZE = [28, 150]

# Options.xml processing
choices.migrate(APP_NAME, 'hayber.us')
rox.setup_app_options(APP_NAME, site='hayber.us')
Menu.set_save_name(APP_NAME, site='hayber.us')
options = dict(
  apps=Option('applications', join(expanduser('~'), 'Apps')),
  sort=Option('sort', True),
  icons=Option('icons', True)
)

rox.app_options.notify()

# helper functions
def isapp(name):
    """Check if file is an app dir."""

    apprun = join(name, 'AppRun')
    return isfile(apprun) and os.access(apprun, os.X_OK)

def walk(top):
    """Walk dir yielding a tuple (dir, dirnames, filenames) for every subdir.

    Simplified version of os.walk() that follows symlinked directories and
    puts ROX application dirs into filenames.
    """

    try:
        names = os.listdir(top)
    except error, err:
        return

    dirs, nondirs = [], []
    for name in names:
        path = join(top, name)
        # don't do hidden files
        if not name.startswith('.'):
            if isdir(path):
                if isapp(path):
                    nondirs.append((name, True))
                else:
                    dirs.append(name)
            else:
                nondirs.append((name, False))

    yield top, dirs, nondirs
    for name in dirs:
        for x in walk(join(top, name)):
            yield x

# classes
class RoxMenu(applet.Applet):
    """A Menu Applet"""

    def __init__(self, filename, root=None):
        """Initialize applet.

        filename is passed to Applet.__init__()
        root is the top of the directory hierarchy that is
        scanned for applications to build the menu.
        """

        applet.Applet.__init__(self, filename)

        # load the applet icon
        self.image = g.Image()
        self.pixbuf = g.gdk.pixbuf_new_from_file(join(APP_DIR, 'images',
          'menu.svg'))
        self.image.set_from_pixbuf(self.pixbuf)
        self.resize_image(8)
        self.add(self.image)

        self.vertical = self.get_panel_orientation() in ('Right', 'Left')
        if self.vertical:
            self.set_size_request(8, -1)
        else:
            self.set_size_request(-1, 8)

        # use IconFactory for the icons of the menu items
        self.factory = g.IconFactory()
        self.factory.add_default()
        # cache
        self.cache_file = join(rox.basedir.save_config_path('hayber.us',
          APP_NAME), 'cache' )
        self.cache = CacheManager(self.cache_file)

        # set the tooltip
        tooltips = g.Tooltips()
        tooltips.set_tip(self, _("Application starter - "
          "click left to open menu, click right for more options."),
          tip_private=None)

        # menus
        if root:
            self.root = root
        else:
            self.root = options['apps'].value
        self.refresh_menu()
        self.mainmenu.attach(self, self)
        self.build_appmenu()

        # event handling
        self.add_events(g.gdk.BUTTON_PRESS_MASK)
        self.connect('button-press-event', self.button_press)
        self.connect('size-allocate', self.resize)
        self.connect('delete_event', self.quit)
        rox.app_options.add_notify(self.get_options)

    def run_it(self, args=None):
        """Open the given file with ROX."""

        #print >>sys.stderr, args
        try:
            filer.spawn_rox((realpath(args),))
        except:
            rox.info(args)

    def load_icon(self, name, path, isapp=False, force_reload=False):
        """Try to load an icon for an application."""

        size = mime.ICON_SIZE_SMALL
        try:
            if force_reload: raise CacheMiss
            pb = self.cache.load_pixbuf(name)
        except CacheMiss:
            try:
                if isapp:
                    for icon in ('.DirIcon', 'AppIcon.xpm'):
                        iconpath = join(path, icon)
                        if exists(iconpath):
                            pb = g.gdk.pixbuf_new_from_file(iconpath)
                            h=int(pb.get_width()*float(size)/pb.get_height())
                            pb = pb.scale_simple(size, h, g.gdk.INTERP_BILINEAR)
                            self.cache.store_pixbuf(name, pb)
                            break
                    else:
                        return
                else:
                    mtype = mime.get_type(path)
                    pb = mtype.get_icon(size)
            except:
                rox.report_exception()
                print >>sys.stderr, "Can't load icon '%s'" % iconpath
                return
        g.stock_add([(name, name, 0, 0, "")])
        self.factory.add(name, g.IconSet(pixbuf=pb))

    def process_dir(self, directory):
        """Walk a directory and build main menu.

        Directories will be submenus. Empty directories are ignored.
        Normal files and app dirs are added as normal menu items.
        """

        menu = []; menu_append = menu.append
        for curdir, dirs, files in walk(directory):
            if options['sort'].int_value:
                sdirs = [(x.lower(), x) for x in dirs]
                sdirs.sort()
                dirs[:] = [x[1] for x in sdirs]
                dirs.reverse()
                files = [(x[0].lower(), x) for x in files]
                files.sort()
                files = [x[1] for x in files]
                files.reverse()
            for file in files:
                path = join(curdir, file[0])
                leaf = path[len(directory):]
                if options['icons'].int_value:
                    self.load_icon(leaf, path, file[1], force_reload=True)
                    menu_append(Menu.Action(leaf,
                        'run_it', '', leaf, values=(path,)))
                else:
                    menu_append(Menu.Action(leaf,
                        'run_it', '', None, values=(path,)))
        menu.reverse()
        return menu

    def resize(self, widget, rectangle):
        """Called when the panel sends a size."""

        if self.vertical:
            size = rectangle[2]
        else:
            size = rectangle[3]
        if size != self.size:
            self.resize_image(size)

    def resize_image(self, size):
        """Resize the application image."""

        # I like the look better with the -4, there is no technical
        # reason for it.
        scaled_pixbuf = self.pixbuf.scale_simple(size-4, size-4,
          g.gdk.INTERP_BILINEAR)
        self.image.set_from_pixbuf(scaled_pixbuf)
        self.size = size

    def button_press(self, window, event):
        """Handle mouse clicks by popping up the matching menu."""

        if event.button == 1:
            if self.mainmenu_items:
                self.mainmenu.popup(self, event, self.position_menu)
            else:
                rox.alert(_("Could not read your application directory.\n\nPlease set the path to your Apps folder in the options!"))
        elif event.button == 2:
            self.open_app_folder()
        elif event.button == 3:
            self.appmenu.popup(self, event, self.position_menu)

    def get_panel_orientation(self):
        """Return panel orientation and margin for displaying a popup menu.

        Position in ('Top', 'Bottom', 'Left', 'Right').
        """

        pos = self.socket.property_get('_ROX_PANEL_MENU_POS', 'STRING', g.FALSE)
        if pos: pos = pos[2]
        if pos:
            side, margin = pos.split(',')
            margin = int(margin)
        else:
            side, margin = None, 2
        return side

    def get_options(self, widget=None, rebuild=False, response=False):
        """Used as the notify callback when options change."""

        if response:
            # option box closed by button
            if rebuild == REVERT:
                return
        elif not rebuild:
            # option box still open
            return
        self.root = options['apps'].value
        for o in ('apps', 'sort', 'icons'):
            if options[o].has_changed:
                rebuild = True
                break
        if rebuild:
            self.refresh_menu(True)

    def show_options(self, button=None):
        """Open the options edit dialog."""
        rox.edit_options()
        rox._options_box.connect_after('destroy', self.get_options, True)
        rox._options_box.connect_after('response', self.get_options, True)

    def get_info(self):
        """Display an InfoWin box."""

        iw = getattr(self, 'iw', None)
        if not iw:
            from infowin import infowin
            self.iw = iw = infowin(APP_NAME)
        iw.show()

    def refresh_menu(self, force_reload=False):
        """Rebuild the menu from disk."""

        #stime = time.time()
        if self.root and isdir(self.root):
            try:
                if force_reload: raise CacheMiss
                self.mainmenu_items = self.cache.load_menu(self.root)
                for e in self.mainmenu_items:
                    if e.stock:
                        self.load_icon(e.stock, join(self.root, e.stock))
            except CacheMiss:
                self.mainmenu_items = self.process_dir(self.root)
                self.cache.store_menu(self.root, self.mainmenu_items)
                self.cache.sync()
        else:
            self.mainmenu_items = []
        self.mainmenu = Menu.Menu('main', self.mainmenu_items)
        #etime = time.time()
        #print >>sys.stderr, "Refresh time(ms): %.2f, Menu leaves: %i" % \
        #  ((etime-stime)*1000, len(self.mainmenu_items))

    def build_appmenu(self):
        """Build the right-click app menu."""

        self.appmenu_items = []
        i_append = self.appmenu_items.append
        i_append(Menu.Action(
          _('Open apps folder'), 'open_app_folder', '', g.STOCK_JUMP_TO))
        i_append(Menu.Action(
          _('Refresh menu'), 'refresh_menu', '', g.STOCK_REFRESH, (True,)))
        i_append(Menu.Separator())
        i_append(Menu.Action(
          _('Info...'), 'get_info', '', g.STOCK_DIALOG_INFO))
        i_append(Menu.Action(
          _('Options...'), 'show_options', '', g.STOCK_PREFERENCES))
        i_append(Menu.Separator())
        i_append(Menu.Action(
          _('Close'), 'quit', '', g.STOCK_CLOSE))
        self.appmenu = Menu.Menu('other', self.appmenu_items)
        self.appmenu.attach(self, self)

    def open_app_folder(self):
        """Open the folder comtaining the appliocations with ROX-Filer."""

        if self.root and isdir(self.root):
            filer.open_dir(self.root)
        else:
            rox.alert(_("Could not open your application directory.\n\nPlease set the path to your Apps folder in the options!"))

    def quit(self, *args):
        """Quit applet and close everything."""

        del self.cache
        try:
            self.iw.destroy()
        except AttributeError:
            pass
        except:
            rox.report_exception()
        self.destroy()
