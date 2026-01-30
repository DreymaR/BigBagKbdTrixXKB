DreymaR's Big Bag of Keyboard Tricks
====================================
<br>

### For Linux using XKB
This is my Linux/XKB implementation of my [Big Bag][BigBag] layout tools, including:
* Improved "Colemak[eD]" AltGr mappings (lv3-4), placing dead keys on AltGr+symbol keys
* Powerful Extend layers using Caps Lock as a lv5 modifier for navigation/editing from the home position and more!
* Comfy Angle/Wide ergo modifications to improve wrist angles(!), hand spacing and right pinky movement+load
* The Curl-DH ergo mod to allow a more natural finger curvature and avoid lateral stretches
    - The Colemak-DH layout on normal row-staggered keyboards, is a combination of the Curl-DH and Angle mods
* The Sym ergo mod to improve access to often-used symbol keys
* For several locales, a 'Unified Symbols' layout with only a few necessary changes from the standard Colemak[eD]
    - Also, a layout to 'Keep Local Symbols' like their default (QWERTY-type) counterparts for that locale
* Intuitive phonetic layouts for Cyrillic, Greek and Hebrew scripts
* Mirrored Colemak that allows one-handed typing with practically no re-learning (if I ever break an arm...)
* The 4 Tarmak transitional Colemak layouts for learning Colemak(-DH) in smaller steps if so desired
<br>

The main Big Bag pages are found at [https://dreymar.colemak.org/][BigBag]. 

To see XKB info boxes there, select the Tux platform icon.
<br><br>

Setup
-----
First, run the install script. This copies my modified files into the system X11 directory. Original files are backed up by default.
<br>

* You can now probably use the system's layout settings to choose a setup. 
* However, some layout settings won't let you set the model component that I use for some ergo mods.
* I've made a `setkb.sh` BASH script to activate my setups and to bring me back to defaults.
* Run the install and setkb scripts with -h (and/or look inside them) first, for more help and info.
* For more info on your choices, consult the [Big Bag][BigBag] pages. Select the Tux platform icon.
<br>

* The setkb script activates a (Big Bag) layout setup with model, layout and option components, using a `setxkbmap` command.
    - If your distro doesn't have an X server (e.g., Wayland), you can't use the setkb script directly. See below.
* The setkb script can write its command to a file that gets sourced at startup, like `~/.bashrc`; check your distro for which file(s) to use.
* Learn about `setkb.sh "model locale variant"` shortstring syntax in the [BigBag][BigBag4X].
    - The default is `"5caw us us"`: PC105(ISO) board with Curl(DH)AngleWide mods, US locale, Cmk-eD UniversalSymbols variant.
    - To switch to, say, an ANSI board without ergo mods, that's `4n` instead of `5caw`. Look in the scripts.
* NOTE: It may be necessary to select "Use system defaults" in the OS GUI layout settings if you have changed anything there.
<br>

Before trying out the BigBag, you may want to find out what your current XKB settings are. One way of seeing what you use is `setxkbmap -v 9`.
- To get the standard US default layout back, you can use `setkb 4n` for ANSI keyboards; `5n` for ISO. What you want depends on your locale.
- Generally, use `setkb 4n/5n [loc [var]]` to get back your locale layout/model. The `[var]` is for variant; omit it for the default/basic one.
<br>

Tips
----
* Due to complaints from new users that Extend on F# keys interferes with `Ctrl+Alt+F#` TTY shortcuts, FKey Extend is now disabled by default.
    - You can enable FKey Extend by activating the [include "extend(lv5_fk)"][BB-ExtFK] bit (delete the leading slashes) in the `symbols/extend` file.
    - If you had already installed the BigBag you must either edit the file in its target X11 directory, or edit and then reinstall the files.
    - In theory, we could make such shortcuts part of Extend so you can have both them and the Multimedia key shortcuts. I'll think about it.
* To just get Extend with the currently active layout, use `setxkbmap -v 9 -option "" -option "misc:extend,lv5:caps_switch_lock,compose:menu"`.
    - The first `-option ""` clears any existing option settings, while the one with non-empty arguments add to existing options.
* The 'Keep Symbols' layouts are intended for those who aren't ready to give up their symbol mappings. Not the best option, but "training wheels".
    - The Unified 'us' variants are usually much better. The 'ks' ones will miss out on some symbols and many dead keys.
* The `xkb-data` package is very consistent between distros. I've used [Debian xkb-data][XKB-DebS], sometimes with some Ubuntu updates.
* Any .deb package may be opened using `dpkg -x` or `ar -xv` (from `binutils`) on Linux
    - On Windows, you can use any decent zip manager such as PeaZip.
* To change your logon keyboard layout, use the `dpkg-reconfigure` command:
    - `sudo dpkg-reconfigure keyboard-configuration`
    - NOTE: Be sure you know how to type your password afterwards!
<br><br>

Wayland & Friends
-----------------
Wayland has a somewhat different tack: It uses xkb-data files, but not an X server. So the setkb script won't work there, but the BigBag as such will.

It depends on which Wayland Compositor you're using. Sorry, but I don't know them all. See its docs for more info?

For the popular Sway compositor, add a piece like this example to your `~/.config/sway/config` file:
```
input * {
  xkb_model     pc105awide
  xkb_layout    us
  xkb_variant   cmk_ed_us
  xkb_options   lv5:caps_switch_lock,misc:extend,compose:menu
}
```

And here's one for Hyprland's `~/.config/hypr/hyprland` file:
```
input {
    kb_rules=evdev
    kb_model=pc105awide
    kb_layout=us
    kb_variant=cmk_ed_dh
    kb_options=misc:extend,lv5:caps_switch_lock,compose:menu
    repeat_rate=40
    repeat_delay=200
}
``` 
The repeat settings are of course optional. Some like a higher repeat rate and a lower delay, and this is how to get that.

For GNOME, most of the settings should be available in GUI form in cases where the setxkbmap function is overridden or unavailable.
It's usually `Settings→Region & Language→Input Sources` or `System→Preferences→Keyboard→Layouts` you want, I think. 
However, the model component needed for "hard" ergo mods may not be available there, and you may need to set that dconf entry separately. 
The GNOME Tweak Tool can be useful. For a more manual approach, there's `dconf` and `gsettings` for editing the dconf settings database. 
E.g., `gsettings set org.gnome.desktop.input-sources xkb-model "'pc104awide'"` (for the AngleWide-ANSI model). 
This is considered an "old way" nowadays, if I'm correct, and with Wayland & Friends there are usually other, newer ways.

Here's a KDE Settings `~/.config/kxkbrc` file. It can be set via the Settings GUI, or edited directly:
```
[$Version]
update_info=kxkb_variants.upd:split-variants,kxkb.upd:remove-empty-lists,kxkb.upd:add-back-resetoptions

[Layout]
DisplayNames=,
LayoutList=us,us
LayoutLoopCount=-1
Model=pc104awide
Options=grp:alt_shift_toggle,grp:win_space_toggle,caps:backspace,lv3:ralt_switch_multikey,compose:menu
ResetOldOptions=true
ShowFlag=false
ShowLabel=true
ShowLayoutIndicator=true
ShowSingle=true
Use=true
VariantList=cmk_ed_dh,
``` 
This one uses Caps as a Backspace. See the example above to upgrade it to an Extend key.

In NixOS without Wayland/Sway, [services.xserver](https://nixos.wiki/wiki/Keyboard_Layout_Customization) should work:
```
services.xserver = {
  layout = "us";
  xkbVariant = "cmk_ed_dh";
  xkbModel   = "pc105awide";
  xkbOptions = "misc:extend,lv5:caps_switch_lock,compose:menu";
};
```
To get the xserver layout in your console as well, use `console.useXkbConfig` in your `configuration.nix` file.

I guess the solution will be quite similar for other compositors, but I don't know more at the moment.
<br><br>

localectl
---------
* You can use the `localectl set-x11-keymap` command to make changes persistent; you may have to run it with `sudo` privileges
* Syntax: `[sudo] localectl [--no-convert] set-x11-keymap layout [model [variant [options]]]`
* Example: `sudo localectl set-x11-keymap us pc105awide cmk_ed_us "lv5:caps_switch_lock,misc:extend"`
* For `layout` and `[variant]`, you can use for instance `"us,us"` and `"cmk_ed_us,"` to switch between Cmk-eD and the default us layout
* Unfortunately, you can't switch between multiple models nor options this way – so your QWERTY may have the Angle (and Curl!) mods...
* Add `--no-convert` to not convert between closest matching console and X11 keyboard mappings; this precludes applying as system console mapping
* Note that XKB options may be overridden by the settings tools used with desktop environments like GNOME and KDE
* More info on setting keyboard layouts is found in the Arch Manual and Wiki, at: 
    - https://man.archlinux.org/man/localectl.1
    - https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Using_localectl
    - https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration#Persistent_configuration
* Thanks to: Daniele, i-c-u-p, Flomza and others at the Cmk Discord for helping find this out
<br><br>

Links
-----
See [DREYMAR'S BigBag XKB topic on the Colemak Forums][BigBag4X].
There are plenty of explanations and further links in there.
<br>

TODO/DONE for this repo are found in the [xmod folder README][xmREADME].
<br>

One good source of info on the `xkb-data` package is the [xkeyboard-config][XKB-conf] repository itself, and its `docs` folder. The repo is found at [GitLab][XKBgitLb].
<br>

Or, have a look in the X.Org Wiki.
https://www.x.org/wiki/XKB/
<br>

Arch has good documentation on all things XKB.
https://wiki.archlinux.org/title/X_keyboard_extension
https://wiki.archlinux.org/title/Xorg/Keyboard_configuration
<br>

Ivan Pascal is a grandmaster of XKB; to learn it better you should definitely consult his site. Though maybe a bit less complete for us who can't read Russian, it's well worth it.
http://pascal.tsu.ru/en/xkb
http://pascal.tsu.ru/en/xkb/gram-symbols.html
<br>

Happy XKB hacking!<br>&nbsp;&nbsp;
_DreymaR_


[XKB-conf]: https://www.freedesktop.org/wiki/Software/XKeyboardConfig/ (XKeyboard Config page)
[XKBgitLb]: https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config (XKB-config on GitLab)
[XKB-pkgs]: https://pkgs.org/download/xkb-data (pkgs.org xkb-data page)
[XKB-DebS]: https://packages.debian.org/sid/xkb-data (Debian Sid xkb-data download)
[BigBag]:   https://dreymar.colemak.org/ (DreymaR's Big Bag of Keyboard Tricks)
[BigBag4X]: http://forum.colemak.com/viewtopic.php?id=1438 (DreymaR's old BigBag for Linux/XKB on the Colemak Forum)
[BBREADME]: README.md                               (main BigBag4XKB README)
[xmREADME]: /xkb-data_xmod/README.md                (xmod BigBag4XKB README)

[XKB-2351]: https://debian.pkgs.org/sid/debian-main-amd64/xkb-data_2.35.1-1_all.deb.html (Debian Sid xkb-data page, 2022-12)
[BB-ExtFK]: /xkb-data_xmod/xkb/symbols/extend#L66   (BigBag4XKB – FKkey include in symbol/extend file)
