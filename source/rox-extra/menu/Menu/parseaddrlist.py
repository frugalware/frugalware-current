import email.Utils

def tokensplit(s, splitchars=None, quotes='"\''):
    """Split a string into tokens at every occcurence of splitchars.

    splitchars within quotes are disregarded.
    """

    if splitchars is None:
        import string
        splitchars = string.whitespace
    inquote = None
    l = []; token = []
    for c in s:
        if c in quotes:
            if c == inquote:
                inquote = None
            elif inquote is None:
                inquote = c
        if c in splitchars and inquote is None:
            l.append("".join(token))
            token = []
            inquote = None
        else:
            token.append(c)
    else:
        l.append("".join(token))
    return l

def parseaddrlist(alist):
    """Parse a comma-separated list of email address into (name, mail) tuples.
    """

    l = []
    for addr in tokensplit(alist, ',', quotes='"'):
        addr = addr.strip()
        if addr:
            l.append(email.Utils.parseaddr(addr))
    return l


if __name__ == '__main__':
    al = '"Hacker, J. Random" <random@hacker.net>, Joe O\'Donnel <joe@foo.com>, luser@dau.org, alice (Alice Bobton), <zaphod@frogstar.net>, '
    print parseaddrlist(al)
