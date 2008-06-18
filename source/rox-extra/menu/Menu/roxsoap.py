#!/usr/bin/env python

"""A quick-and-dirty helper module to do SOAP RPCs to ROX-Filer.

Usage:
>>> proxy = RoxSOAPProxy()
>>> proxy.Version()

To see, which SOAP RPC calls are supported:
>>> print proxy._methods

For the method arguments, please see the ROX manual (appendix C).

If a method takes arguments, you have to specify them as keyword arguments
(case-sensitive!):
>>> proxy.FileType(Filename='movie.avi')
(u'video/x-msvideo',)

Only the following types are supported as arguments values:
- (Unicode) strings
- Lists of (unicode) strings
- All other types will be converted to unicode strings, which may not be
  what you want. Boolean types will work, though.

All methods return a tuple of unicode strings or None.
"""

import sys
import os
from xml.dom import minidom

__all__ = ['RoxSOAPProxy', 'SOAPRPCError']

__author__ = "Christopher Arndt"
__version__ = "0.2"
__date__ = "2005-09-19"
__copyright__ = "Python license"

class SOAPRPCError(Exception):
    pass

class curry:
    """Curry a callable with default arguments and return it as a new callable.
    """

    def __init__(self, callable, *args, **kwargs):
        self.callable = callable
        self.pending = args[:]
        self.kwargs = kwargs.copy()

    def __call__(self, *args, **kwargs):
        if kwargs and self.kwargs:
            kw = self.kwargs.copy()
            kw.update(kwargs)
        else:
            kw = kwargs or self.kwargs
        return apply(self.callable, self.pending + args, kw)

class RoxSOAPProxy:
    """A wrapper for SOAP RPC calls to ROX-Filer."""

    _SOAP_REQUEST_TEMPLATE=u"""\
<?xml version="1.0"?>
<env:Envelope xmlns:env="http://www.w3.org/2001/12/soap-envelope">
 <env:Body xmlns="http://rox.sourceforge.net/SOAP/ROX-Filer">
  <%(method)s>
%(args)s
  </%(method)s>
 </env:Body>
</env:Envelope>
"""
    _methods = ['CloseDir', 'Copy', 'Examine', 'FileType', 'Link', 'Mount',
      'Move', 'OpenDir', 'Panel', 'PanelAdd', 'PanelRemove', 'Pinboard',
      'PinboardAdd', 'PinboardRemove', 'Run', 'SetBackdrop', 'SetBackdropApp',
      'Show', 'Unmount', 'Version'
    ]

    def __init__(self, debug=False):
        self.debug = debug

    def __getattr__(self, name):
        if name in self._methods:
            return curry(self._do_rpc, name)
        else:
            try:
                return self.__dict__[name]
            except KeyError:
                raise AttributeError, \
                  "SOAP RPC method '%s' not supported" % name

    def _parse_response(self, response):
        """Extract the RPC results from a SOAP response"""

        xml = minidom.parseString(response)
        l = []
        for el in xml.getElementsByTagName('soap:result'):
            l.append("".join([n.nodeValue for n in el.childNodes]))
        if l:
            return tuple(l)

    def _build_request(self, method, **kwargs):
        """Enter method docstring here."""

        args = []
        for k,v in kwargs.items():
            if type(v) == type([]):
                args.append(u'   <%s>' % k)
                for i in v:
                    args.append(u'     <string>%s</string>' % unicode(i))
                args.append(u'   </%s>' % k)
            else:
                args.append(u"   <%s>%s</%s>" % (k, unicode(v), k))
        args = "\n".join(args)
        return self._SOAP_REQUEST_TEMPLATE % {'args': args, 'method': method}

    def _send_request(self, msg):
        cin, cout, cerr = os.popen3('rox --RPC', 'rb+')
        cin.write(msg)
        cin.flush()
        cin.close()
        response = cout.read()
        err = cerr.read()
        cout.close(); cerr.close()
        return response, err

    def _do_rpc(self, method, **kwargs):
        msg = self._build_request(method, **kwargs)
        self._debug("Send SOAP request:\n", msg)
        response, err = self._send_request(msg)
        if err:
            self._debug("Error while doing SOAP call:\n", err)
            raise SOAPRPCError, err
        if response:
            self._debug("Received SOAP response:\n", response)
            return self._parse_response(response)

    def _debug(self, *msg):
        if self.debug:
            print >>sys.stderr, " ".join(map(str, msg))

def _test():
    proxy = RoxSOAPProxy()
    print "ROX version:", proxy.Version()[0]

if __name__ == '__main__':
    __usage__ = """Usage: roxsoap.py Method [argument=value ...]

Method is one of: %s

See http://rox.sourceforge.net/Manual/Manual/Manual.html#soap for more
information about method signatures.""" % ", ".join(RoxSOAPProxy._methods)

    if len(sys.argv) > 1:
        method = sys.argv[1]
        args = {}
        try:
            for arg in sys.argv[2:]:
                k, v = arg.split('=', 1)
                args[k] = v
        except ValueError:
            print >>sys.stderr, __usage__
            sys.exit(1)
        proxy = RoxSOAPProxy(True)
        soapcall = getattr(proxy, method)
        try:
            print soapcall(**args)
        except SOAPRPCError, msg:
            print >>sys.stderr, msg
    else:
        _test()
