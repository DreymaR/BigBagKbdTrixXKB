MAKING THE CUT/COPY/PASTE KEYS WORK WITH GTK APPS:
**************************************************

by DreymaR, 2013 (thanks to Kuglee on the Colemak forum!)

- With my Extend mappings for instance, you can make the keyboard send multimedia keys
- These have virtual key names XF86### where ### is Cut/Copy/Paste for my X/C/V mappings
- Those keys are sent to the system but not all of them do anything useful automatically
- The snippets below tell GTK to map the edit keys to actions so they work (in GTK apps at least)
- Copy the gtkrc-2.0 part into ~/.gtkrc-2.0 (make a new file if you don't have it) for gtk-2
- Copy the gtk.css part into ~/.config/gtk-3.0/gtk.css for gtk-3
- (If you're new to this, note the initial periods in the file/folder names: That means hidden.)

# Old method: I used to enclose the below as separate files. Now, the install script contains all.
# Using those files, the following commands would install them (run from their dir):
# 	cat gtkrc-2.0 >> ~/.gtkrc-2.0
# 	cat gtk.css >> ~/.config/gtk-3.0/gtk.css


CONTENT OF THE NECESSARY FILES:
******************************

~/.gtkrc-2.0
#########################
binding "gtk-xf86cut-copy-paste"
{
        bind "XF86Cut"   { "cut-clipboard" () }
        bind "XF86Copy"  { "copy-clipboard" () }
        bind "XF86Paste" { "paste-clipboard" () }
}

class "*" binding "gtk-xf86cut-copy-paste"
#########################

~/.config/gtk-3.0/gtk.css
#########################
@binding-set gtk-xf86cut-copy-paste
{
        bind "XF86Cut"   { "cut-clipboard" () };
        bind "XF86Copy"  { "copy-clipboard" () };
        bind "XF86Paste" { "paste-clipboard" () };
}

* {
        gtk-key-bindings: gtk-xf86cut-copy-paste
}
#########################

