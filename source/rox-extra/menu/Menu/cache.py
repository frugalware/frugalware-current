import sys
import time
import shelve
import cPickle
import gtk
from os.path import getmtime

# exceptions
class CacheMiss(Exception):
    pass

# helper functions
def pixbuf_serialize(pb):
    """Serialize a pixbuf instance to a pickle"""

    return cPickle.dumps((pb.get_pixels(), pb.get_colorspace(),
      pb.get_has_alpha(), pb.get_bits_per_sample(), pb.get_width(),
      pb.get_height(), pb.get_rowstride()), 2)

def pixbuf_restore(s):
    """Create a pixbuf instance from the serialized pixel data"""

    data = cPickle.loads(s)
    return gtk.gdk.pixbuf_new_from_data(*data)

# classes
class CacheManager:

    def __init__(self, cache_file, debug=False):
        self.cache_file = cache_file
        self.debug = debug
        self.open_cache()

    def _debug(self, *msg):
        if self.debug:
            print >>sys.stderr, " ".join(map(str, msg))

    def open_cache(self):
        self.cache = shelve.open(self.cache_file, protocol=2)
        self._debug('CACHE open:', self.cache_file)

    def store_menu(self, root, menu):
        """Save menu structure to disk cache."""

        try:
            self.cache[root] = (getmtime(root), menu)
            self._debug('CACHE store:', root)
        except cPickle.PicklingError:
            try: del self.cache[root]
            except: pass

    def load_menu(self, root):
        """Try to load the menu structure from disk cache."""

        try:
            timestamp, menu = self.cache[root]
            if timestamp <= getmtime(root):
                self._debug('CACHE hit:', root)
                return menu
            else:
                del self.cache[root]
                msg = "Cached menu for '%s' out-of-date" % root
                self._debug('CACHE miss:', msg)
                raise CacheMiss, msg
        except KeyError:
            msg = "Directory '%s' not in cache." % root
            self._debug('CACHE miss:', msg)
            raise CacheMiss, msg

    def store_pixbuf(self, name, pb, timestamp=None):
        if timestamp is None:
            timestamp = time.time()
        self.cache['icon:'+name] = (timestamp, pixbuf_serialize(pb))
        self._debug('CACHE store:', name, timestamp)

    def load_pixbuf(self, name, if_newer=0):
        try:
            timestamp, data = self.cache['icon:'+name]
            if timestamp < if_newer:
                del self.cache['icon:'+name]
                msg = "Cached icon '%s' out-of-date." % name
                self._debug('CACHE miss:', msg, timestamp)
                raise CacheMiss, msg
            self._debug('CACHE hit:', name)
            return pixbuf_restore(data)
        except KeyError:
            msg = "Icon '%s' not in cache." % name
            self._debug('CACHE miss:', msg)
            raise CacheMiss, msg

    def sync(self):
        try:
            self.cache.sync()
            self._debug('CACHE sync')
        except AttributeError:
            self._debug('CACHE sync not supported')

    def __del__(self):
        self._debug('CACHE close:', self.cache_file)
        self.cache.close()
