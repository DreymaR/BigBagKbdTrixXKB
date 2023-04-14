DreymaR's Big Bag of Keyboard Tricks
====================================
<br>

### For Linux using XKB

* Improved "Colemak[eD]" AltGr mappings (lv3-4), placing dead keys on AltGr+symbol keys
* Powerful Extend layers using Caps Lock as a lv5 modifier for navigation/editing from the home position and more!
* Comfy Angle/Wide ergo modifications to improve wrist angles(!), hand spacing and right pinky movement+load
* The Curl-DH ergo mod to allow a more natural finger curvature and avoid lateral stretches
    - The Colemak-DH layout is a combination of the Curl-DH and Angle mods, on normal row-staggered keyboards
* WIP: The Sym ergo mod to improve access to often-used symbol keys is planned to be implemented soon
* For several locales, a 'Unified Symbols' layout with only a few necessary changes from the standard Colemak[eD]
* Also, a layout to 'Keep Local Symbols' like their default (QWERTY-type) counterparts for that locale
* Intuitive phonetic layouts for Cyrillic, Greek and Hebrew scripts
* Mirrored Colemak that allows one-handed typing with practically no re-learning (if I ever break an arm...)
* The 4 Tarmak transitional Colemak layouts for learning Colemak(-DH) in smaller steps if so desired
<br>

The main Big Bag pages are found at [https://dreymar.colemak.org/][BigBag]. To see XKB info boxes there, select the Tux platform icon.

These [xkeyboard-config][XKBgitHb] files are updated to [XKB-data v2.23.1-1ubuntu1][XKB-Ub18], 2018. They work fine with other versions though, in nearly all cases.
<br>

Some info
---------

First, run the install script. This copies my modified files into the system X11 directory. Original files are backed up by default.

You can now probably use the system's layout settings to choose a setup. For info on what the choices are, consult the [Big Bag][BigBag].

However, some layout settings won't let you set the model component that I use for some ergo mods.

The setkb script activates a Big Bag layout setup (model, layout and option components) using a `setxkbmap` command.

The setkb script can write its command to a file that gets sourced at startup, like `~/.bashrc`; check your distro for which file(s) to use.

Run the install and setkb scripts with -h (or look inside them) for more help and info about their workings!

Learn about `setkb.sh "model locale variant"` shortstring syntax in the [BigBag][BigBag4X].
The default is `"5caw us us"`: PC105(ISO) board with Curl(DH)AngleWide mods, US locale, Cmk-eD UniversalSymbols variant.
To switch to, say, an ANSI board without ergo mods, that's `4n` instead of `5caw`. Look in the scripts.

NOTE: It may be necessary to select "Use system defaults" if you have changed anything in the OS GUI layout settings.
<br>

Tips
----
* Before trying out the BigBag, you may want to find out what your current XKB settings are. One way of seeing what you use is `setxkbmap -v 9`.
	- To get the standard US default layout back, you can use `setkb 4n` for ANSI keyboards (`5n` for ISO). What you want may depend on your locale.
* Due to complaints from new users that Extend on F# keys interferes with `Ctrl+Alt+F#` TTY shortcuts, FKey Extend is now disabled by default.
    - You can enable FKey Extend by activating the [include "extend(lv5_fk)"][BB-ExtFK] bit (delete the trailing slashes) in the `symbols/extend` file.
    - If you had already installed the BigBag you must either edit the file in its target X11 directory, or edit and then reinstall the files.
    - In theory, we could make such shortcuts part of Extend so you can have both them and the Multimedia key shortcuts. I'll think about it.
* The 'Keep Symbols' layouts are intended for those who aren't ready to give up their symbol mappings. Not the best option, but "training wheels".
    - The Unified 'us' variants are usually much better. The 'ks' ones will miss out on some symbols and many dead keys.
* The `xkb-data` package is very consistent between distros. I've use [Debian xkb-data][XKB-DebS], sometimes with some Ubuntu updates.
* Any .deb package may be opened using `dpkg -x` or `ar -xv` (from `binutils`) on Linux, and any decent zip manager such as PeaZip on Windows.
<br>

localectl
---------
* You can use the `localectl set-x11-keymap` command to make changes persistent; you may have to run it with `sudo` privileges
* Syntax: `[sudo] localectl [--no-convert] set-x11-keymap layout [model [variant [options]]]`
* Example: `sudo localectl set-x11-keymap us pc105aw-sl cmk_ed_us "lv5:caps_switch_lock,misc:extend"`
* For `layout` and `[variant]`, you can use for instance `"us,us"` and `"cmk_ed_us,"` to switch between Cmk-eD and the default us layout
* Unfortunately, you can't switch between multiple models nor options this way – so your QWERTY may have the Angle (and Curl!) mods...
* Add `--no-convert` to not convert between closest matching console and X11 keyboard mappings; this precludes applying as system console mapping
* Note that XKB options may be overridden by the settings tools used with desktop environments like GNOME and KDE
* More info on setting keyboard layouts is found in the Arch Manual and Wiki, at: 
	https://man.archlinux.org/man/localectl.1
	https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Using_localectl
	https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration#Persistent_configuration
* Thanks to: Daniele, i-c-u-p, Flomza and others at the Cmk Discord for helping find this out
<br>

Wayland & Friends
-----------------
Wayland has a different tack: It uses xkb-data files, but not an X server. So the setkb script won't work there, but the BigBag as such will.

It depends on which Wayland Compositor you're using. See its docs?

For the Sway compositor, add a piece like this example to your `~/.config/sway/config` file:
```
input * {
  xkb_model     pc105
  xkb_layout    us
  xkb_variant   cmk_ed_us
  xkb_options   lv5:caps_switch_lock,misc:extend,compose:menu
}
```
<br>

Links
-----
See [DREYMAR'S BigBag XKB topic on the Colemak Forums][BigBag4X].
There are plenty of explanations and further links in there.
<br>

One good source of info on the `xkb-data` package is the [xkeyboard-config][XKB-conf] repository itself, and its `docs` folder. The repo is found both on [GitHub][XKBgitHb] and [GitLab][XKBgitLb].
<br>

Ivan Pascal is a grandmaster of XKB; to learn it you should definitely consult his pages. They're a bit incomplete for us who don't speak Russian, but well worth it nonetheless.
http://pascal.tsu.ru/en/xkb
http://pascal.tsu.ru/en/xkb/gram-symbols.html
<br>

Happy XKB hacking!
_DreymaR, 2023-01_
<br><br>

TODO:
-----
* Update all forum.colemak.com links with new BigBag links: Locale topic (id=1458) -> https://dreymar.colemak.org/variants.html#locales etc.
* Fix key repetition with Extend, particularly vis-a-vis Wayland.
	- Seems we have to add `repeat=yes` after the key actions to all keys that have actions.
	- https://discord.com/channels/409502982246236160/1066499260322943006/1080488398403424256
	- http://web.archive.org/web/20190320180541/http://pascal.tsu.ru/en/xkb/gram-symbols.html
	- I couldn't devise a way to do this once and for instead of by-key (looked at compat but no?).
* Better instructions for Wayland
	- Depends on your Wayland Compositor (Sway is common?)
		https://wiki.archlinux.org/title/wayland#Compositors
	- Didn't we have some good ones at the Colemak Discord? Where?
		https://discord.com/channels/409502982246236160/1059814838408319026/1059866421066203257
* Lockable lv5 modifier, for users who want Extend-lock. Maybe Shift+Extend to lock it, or something?
	- It's possible today to have two switch-or-lock lv5 modifiers. But it seems wasteful to use up two keys.
* Non-Fn-key Extend is now the default. Add a separate option for FKey Extend? Many new users struggled with this, or have weird FKey setups.
	- Add a FKey Extend option to misc? So people can activate `misc:extend` and `misc:extend_fk` separately.
* Add colemak-dh to the colemak symbols file and the US locale? Both ISO, ANSI and Ortho.
* Not all distros source `~/.bashrc` by default. Seems that `~/.xinitrc` is mostly used by xinit and not generally sourced?
	- What about `~/.xsession` or `~/.profile`? Seems to be mostly legacy; used by `startx`? It's messy.
	- Look in `/etc/X11/Xsession` to see how thing are run at startup?
	- But `~/.Xresources` seems like a good option (and is sourced by xinitrc too)?
	- Its format is different though. And it doesn't list keyboard layout as one of its intended purposes.
* Add some easy way of returning to the old xkbmap setup? But how? Can't unset settings, so we'd have to store it somehow? Or just let them go to us/us?
	- Make a restore to default layout shortcut instead? It's only an alias for `setkb 4n/5n`. Maybe `resetkb 4/5`?
* Transition many ###.xml changes to ###.extras.xml? Other Colemak locale variants reside there. But it's a mess: Many (such as Norwegian) are in the main file!
	- It might be nice to keep all the BigBag locales in one place though? Or not?
* To get Extend with the currently active layout, use `setxkbmap -v 9 -option "" -option "misc:extend,lv5:caps_switch_lock,compose:menu"`.
	- The first `-option ""` clears any existing option settings, while the one with non-empty arguments add to existing options.
* Add lv5:lalt_switch_lock for LALT-Extend.
* Add compose:102? Inconsistent between ISO and ANSI, just add a pro-tip.
* The Curl(DH) model implementation has to go as it may mess w/ QWERTY. Instead, I should use two Extend variants.
	- It also seems very hard for some newcomers to understand. So yes, I should have the Angle mod only and not CurlAngle models?
	- Also, matrix users want the V-D swap without an Angle mod! Another nail in the coffin for the Curl models.
	- Actually, should I make a NoModel CurlAngle layout for the model impaired? Vanilla, Curl(DH) and Curl(DH)Angle then. ... No?
	- First, just make Curl with D-V swap built in. Let the Extend Paste function be where it falls for now.
	- Separate Angle mods for Curl and non-Curl? Probably not, as it'll still get silly when using both QWERTY and Cmk-eD.
* Check out the compose:102 option. This would be similar to what I've used in EPKL for Windows! It's also present in some other layouts.

* Problems with Super+<letter> shortcuts: https://github.com/DreymaR/BigBagKbdTrixXKB/issues/23#issuecomment-1027839924

* A purge option in addition to restore for the install script? So backup dirs etc are removed and the xkb dir restored to original state.

* Update xkb-data and then start testing on a Wayland system!
	- Use the [GitLab][XKBgitLb]/[GitHub][XKBgitHb] repo as that's the freshest there is.

* A clarification by Peter Hutterer on the mystic .part files in the rules component:
	- https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/-/issues/327#note_1436334
	- The parts are numbered to get their sequence in the resulting files right. Only when there are differences, they start with base/evdev.
	- There are RMLVO (user interface) and KcCSGST (actual XKB) letter codes. The naming of those .part files is 1234-rmlvo-kccgst.part...
	- but with only the relevant bits. So, e.g., `0009-m_g.part` is the model to group mapping of the final rules file. `ml_s.part` is model + layout to symbols.
	- It seems that you can make layout commits by editing only the rules/base.xml (and symbols) file(s) though?

* Echo the setxkbmap command when using setkb.sh, for ease of troubleshooting! Also make the script able to output the command for piping?
* Add a model-less Colemak-CAWS for people who want to switch to QWERTY? Or instructions on how to setkb it? That's better, I think.
* Problem: Using Google Spreadsheets, hitting Caps Lock (which is mapped to ISO_Level5_Shift) clears the current spreadsheet cell.
	- https://forum.colemak.com/topic/1438-dreymars-big-bag-of-keyboard-tricks-linuxxkb-files-included/p15/#p23838
	- This solves it by convincing Google Sheets that the Caps key is a Win key: `sudo setkeycodes 0x3a 125`
	- But it only works for built-in laptop keyboards and not USB/Bluetooth ones? 
* Is there a way to clear the LevelFive mod on all the Extend mappings by default? Or must I be more careful with each RedirectKey()?
	- Example: `Q -> Esc -> Caps` caused people trouble, as Ext+Q would act as Esc+Caps.
	- Possibly, finally make a new key type EIGHT_LEVEL_EXTEND with the action clearmods=LevelFive added to state 5-8? No, no actions.
	- In xkb/types/level5 under EIGHT_LEVEL_SEMIALPHABETIC I used `preserve[Shift] = Shift;`. We need the opposite here, to discard lvl5.
	- See for instance https://www.x.org/releases/X11R7.5/doc/input/XKB-Enhancing.html
	- "Usually, all modifiers introduced in 'modifiers=<list of modifiers>' list are used for shift level calculation and then discarded."
	- Does this mean that LevelFive should've been discarded but isn't? Is it an XKB bug?
* Update to the latest xkb-data: https://ubuntu.pkgs.org/20.04/ubuntu-main-amd64/xkb-data_2.29-2_all.deb.html
* Find out how to change the rules component properly to allow compiling and eventually merging to the main repo?
* Migrate from `~/.bashrc` to `~/.xprofile`? The latter is more appropriate, but which setups source it and which ones don't?
	- Include both? Or, people can just enter the file names.
* Could use an <XTND> key code alias defined in keycodes/evdev (alias <XTND> = <CAPS>), instead of the <CAPS> code?
* Test this method for using a local dir, by Bjørnar "zkf" Hansen: 
	- Copy the `xkb-data_mod/xkb` dir to, say, `/usr/local/bigbag/xkb` if desired.
	- Set `setenv MYXKB <dir>` or `export MYKXB=<dir>` as appropriate (not necessary for this, just practical here).
	- `setxkbmap -rules evdev -option '' <parameters> -print | xkbcomp -I -I$MYXKB -I/usr/share/X11/xkb - $DISPLAY`
	- See https://github.com/DreymaR/BigBagKbdTrixXKB/issues/14
	- More useful info in this comment: https://github.com/DreymaR/BigBagKbdTrixXKB/issues/14#issuecomment-767590722
	- "-I/usr/local/share/X11/xkb can be written more succinctly as -I. if you first cd into this directory."
	- Another reason to first cd into the local xkb dir is that the rules dir is expected to be in the pwd.
* An earlier comment on the local dir subject, by neeasade@github in issue 1:
	- https://github.com/DreymaR/BigBagKbdTrixXKB/issues/1#issuecomment-462952051
	- https://unix.stackexchange.com/questions/397716/custom-keyboard-layout-without-root
	- `setxkbmap -I $MYXKB -rules evdev <params> -print | xkbcomp -I $MYXKB - "$DISPLAY"
	- "I made that tweak to setkb and some small changes to use a hardcoded $HOME dir path, and it appears good."
	- Another attempt by birdspider, with some tripups and solutions:
		https://github.com/DreymaR/BigBagKbdTrixXKB/issues/1#issuecomment-818880299
* For an EsAlt variant as in EPKL:
```
    key <AE04> { [             4,        dollar,       dead_currency,            EuroSign ] }; // 4
    key <AD07> { [             l,             L,               U2039,       guillemotleft ] }; // QWE U Cmk L
    key <AD08> { [             u,             U,                   ú,                   Ú ] }; // QWE I Cmk U - EsAlt
    key <AC01> { [             a,             A,                   á,                   Á ] }; // QWE A Cmk A - EsAlt
    key <AC06> { [             h,             H,           leftarrow,          rightarrow ] }; // QWE H Cmk H
//    key <AC07> { [             n,             N,                   ñ,                   Ñ ] }; // QWE J Cmk N - EsAlt ANSI
    key <AC08> { [             e,             E,                   é,                   É ] }; // QWE K Cmk E - EsAlt
    key <AC09> { [             i,             I,                   í,                   Í ] }; // QWE L Cmk I - EsAlt
    key <AC10> { [             o,             O,                   ó,                   Ó ] }; // QWE ; Cmk O - EsAlt
    key <LSGT> { [             ñ,             Ñ,                  oe,                  OE ] }; // <>          - EsAlt ISO
//    key <AB06> { [             k,             K,              endash,             uparrow ] }; // QWE N Cmk K - ANSI
    key <AD11> { [   bracketleft,     braceleft,           masculine,         ordfeminine ] }; // [{
```
* To change the logon keyboard layout:
	- `sudo dpkg-reconfigure keyboard-configuration`
<br>

DONE:
-----
* Moved Space to the "letters" block to ensure a consistent Space key implementation for `_ks` layouts etc. Many xkb layouts are sloppy about that.
* 2023-01-03: Renamed setkb --> setkb: It's easier to type. Updated all docs including the Forum topic.
* 2020-11-05: Switched to the new DH = DHm standard (was DH = DHk)
* Changed the default layout for the setkb.sh script to US (UniSym): In my experience, most users that struggle with the setup want US English.
* To get back to your old layout/model, use `setkb 4n/5n [loc]`. You may also specify `mod loc [var]`; omit `var` for the default (basic) variant.
* Separated out the F# key block in the extend file: People complain that their TTY shortcuts aren't working because of it. Ext+AltGr+F# works though.
* Relieve the sudo requirement. And add an option to change the X11 dir since Nix uses another place. Pulled from fufexan@github.
	- https://github.com/DreymaR/BigBagKbdTrixXKB/issues/15#issuecomment-769431139


[XKB-conf]: https://www.freedesktop.org/wiki/Software/XKeyboardConfig/ (XKeyboard Config page)
[XKBgitHb]: https://github.com/freedesktop/xkeyboard-config (XKB-config on GitHub)
[XKBgitLb]: https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config (XKB-config on GitLab)
[XKB-pkgs]: https://pkgs.org/download/xkb-data (pkgs.org xkb-data page)
[XKB-DebS]: https://packages.debian.org/sid/xkb-data (Debian Sid xkb-data download)
[XKB-Ub18]: https://ubuntu.pkgs.org/18.04/ubuntu-main-amd64/xkb-data_2.23.1-1ubuntu1_all.deb.html (Ubuntu 18.04 LTS xkb-data page)
[XKB-Ub22]: https://ubuntu.pkgs.org/22.04/ubuntu-main-amd64/xkb-data_2.33-1_all.deb.html (Ubuntu 22.04 LTS xkb-data page)
[XKB-2351]: https://debian.pkgs.org/sid/debian-main-amd64/xkb-data_2.35.1-1_all.deb.html (Debian Sid xkb-data page, 2022-12)
[BigBag]:   https://dreymar.colemak.org/ (DreymaR's Big Bag of Keyboard Tricks)
[BigBag4X]: http://forum.colemak.com/viewtopic.php?id=1438 (DreymaR's old BigBag for Linux/XKB on the Colemak Forum)
[BB-ExtFK]: https://github.com/DreymaR/BigBagKbdTrixXKB/blob/a8db6e705e78721a1f2d82c54fcebfe304b4d66a/xkb-data_xmod/xkb/symbols/extend#L64 (BigBag – FK include in symbol/extend)
