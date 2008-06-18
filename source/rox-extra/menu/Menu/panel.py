import gtk

def find_panel_window():
    root = gtk.gdk.get_default_root_window()
    wids = root.property_get('_NET_CLIENT_LIST')[2]
    wl = [gtk.gdk.window_foreign_new(long(w)) for w in wids]
    for w in wl:
        if w is not None:
            wclass = w.property_get('WM_CLASS')[2].split('\0')[:2]
            if wclass[0] == 'ROX-Panel':
                return w
    else:
        return None

def get_panel_orientation():
    panel = find_panel_window()
    if panel:
        panelx, panely = panel.get_root_origin()
        rect = panel.get_frame_extents()
        panelw, panelh = rect.width, rect.height
        if panelx == 0:
            if panelw > panelh:
                if panely == 0:
                    return "Top"
                else:
                    return "Bottom"
            return "Left"
        if panelw < panelh:
            return "Right"
