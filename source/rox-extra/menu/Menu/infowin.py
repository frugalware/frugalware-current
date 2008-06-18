# infowin.py

__all__ = ['infowin', 'InfoWin']

import os, re

import rox
from rox import g, AppInfo

_url_re = re.compile(r'(URL:)?(\w+?://\S+)')

def _collect_about(ai):
    """Extract about information from AppInfo object in the current language."""

    info = []
    for key in ai.about[''].keys():
        k, v = ai.getAbout(key)
        if v == '':
            v = ai.getAbout(key, [''])[1]
        info.append((k, v.strip()))
    return info

def infowin(pname, info=None):
    """Open info window for this program.

    info is a source of an AppInfo.xml file, if None then
    APP_DIR/AppInfo.xml is loaded instead.
    """

    if info is None:
        info = os.path.join(rox.app_dir, 'AppInfo.xml')
    try:
        ai = AppInfo.AppInfo(info)
    except:
        rox.report_exception()
        return

    info = _collect_about(ai)
    if os.path.isdir(os.path.join(rox.app_dir, 'Help')):
        help = True
    else:
        help = False
    try:
        iw = InfoWin(pname, fields=info, help=help)
        iw.set_title(_("About"))
        iw.show()
        return iw
    except:
        rox.report_exception()

class CommonMixIn:

    def key_event(self, window, kev):
        if kev.keyval == g.keysyms.Escape:
            self.close()
            return True
        elif kev.keyval in [g.keysyms.Return, g.keysyms.KP_Enter] \
          and hasattr(self, '_ok_cb'):
            self._ok_cb()
            return True
        return False

    def show(self):
        rox.Dialog.show(self)
        if self.standalone:
            rox.mainloop()

    def close(self, widget=None, *args):
        self.hide()
        if self.standalone:
            self.destroy()
        return True

class InfoWin(CommonMixIn, rox.Dialog):
    """A dialog showing information such as author, version, etc."""

    def __init__(self, pname, fields=None, icon=None, help=False, standalone=False):
        rox.Dialog.__init__(self)

        if not fields:
            raise ValueError, \
              "'fields' keyword must have at least one label, value pair."
        self.urls = {}
        self.icon_size = 64
        self.standalone = standalone

        self.set_position(g.WIN_POS_CENTER)
        self.set_default_size(350,-1)
        self.connect("delete_event", self.close)
        self.connect('key-press-event', self.key_event)
        self.set_title(_("Info"))
        tooltips = g.Tooltips()

        hbox = g.HBox()
        self.vbox.pack_start(hbox, False, False, 5)
        hbox.show()

        try:
            if not icon:
                icon = os.path.join(rox.app_dir, '.DirIcon')
            pixbuf = g.gdk.pixbuf_new_from_file(icon)
            scaled_pixbuf = pixbuf.scale_simple(self.icon_size,
              self.icon_size, g.gdk.INTERP_BILINEAR)
            ic = g.Image()
            ic.set_from_pixbuf(scaled_pixbuf)
            hbox.pack_start(ic)
            ic.show()
        except:
            pass

        # program name label
        name = g.Label()
        name.set_markup('<span size="xx-large" weight="bold">%s</span>' % pname)
        hbox.pack_end(name)

        # use table to pack labels and descriptions
        table = g.Table(len(fields), 2)
        self.vbox.pack_start(table, padding=3)

        for i, (fieldname, fieldtext) in enumerate(fields):
            label = g.Label("%s:" % fieldname)
            label.set_alignment(1,0)
            table.attach(label, 0, 1, i, i+1, xpadding=2)

            # search for URLs or email addresses
            if fieldtext.find('@') > 0:
                self.urls[fieldname] = []
                from parseaddrlist import parseaddrlist
                for name, address in parseaddrlist(fieldtext):
                    if not address: continue
                    if not name:
                        name = address
                    self.urls[fieldname].append((name, 'mailto:%s' % address))
            else:
                ul = _url_re.findall(fieldtext)
                if ul:
                    self.urls[fieldname] = [(fieldtext, x[1]) for x in ul]

            frame = g.Frame()
            frame.set_shadow_type(g.SHADOW_IN)
            table.attach(frame, 1, 2, i, i+1, xpadding=0)
            urls = self.urls.get(fieldname)
            if urls:
                hbox = g.VBox()
                frame.add(hbox)
                for j, (text, url) in enumerate(urls):
                    label = g.Label('')
                    label.set_markup(
                      '<span foreground="blue"><u>%s</u></span>' % text)
                    evb = g.EventBox()
                    evb.add(label)
                    evb.set_events(g.gdk.BUTTON_PRESS_MASK)
                    evb.connect("button_press_event", self.open_url,
                      fieldname, j)
                    hbox.pack_start(evb)
                    evb.realize()
                    evb.window.set_cursor(g.gdk.Cursor(g.gdk.HAND1))
                    tooltips.set_tip(evb,
                      _("Open URL <%s> with the default URL handler.") % url,
                      tip_private=None)
            else:
                label = g.Label('')
                label.set_text(fieldtext)
                label.set_selectable(True)
                frame.add(label)
                label.set_alignment(0.5,0)
                label.set_justify(g.JUSTIFY_CENTER)
                label.set_line_wrap(True)

        self.vbox.show_all()

        if help:
            self.add_button(g.STOCK_HELP, g.RESPONSE_HELP)
        self.add_button(g.STOCK_CLOSE, g.RESPONSE_CLOSE)
        self.connect('response', self.response_cb)
        self.set_default_response(g.RESPONSE_CLOSE)

    def open_url(self, widget, event, name, idx):
        """Open the url associated with a label with ROX url handler."""

        try:
            url = self.urls[name][idx][1]
        except:
            return
        from rox import basedir, filer
        app = basedir.load_first_config('rox.sourceforge.net',
          'MIME-types', 'text_x-uri')
        try:
            if os.path.islink(app):
                app = os.readlink(app)
            if os.path.isdir(app):
                app = os.path.join(app, 'AppRun')
            filer._spawn((app, url))
        except (OSError, IOError):
            import threading, webbrowser
            t = threading.Thread(target=webbrowser.open, args=(url, 1))
            t.setDaemon(1)
            t.start()
        except:
            rox.report_exception()

    def response_cb(self, widget, id, *args):
        """Callback for dialog buttons."""

        if id == g.RESPONSE_CLOSE:
            self.close()
        elif id == g.RESPONSE_HELP:
            self.open_help()

    def open_help(self, widget=None, *args):
        """Open the Help directory with the filer."""

        from rox import filer
        helpdir = os.path.join(rox.app_dir, 'Help')
        if os.path.isdir(helpdir):
            filer.open_dir(helpdir)
