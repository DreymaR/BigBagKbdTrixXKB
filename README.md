DreymaR's Big Bag of Keyboard Tricks
====================================
<br>

### For Linux using XKB

* New "Colemak[eD]" AltGr mappings (lv3-4) putting dead keys on AltGr+symbol keys and reworking most other mappings
* Angle/Wide ergo modifications to improve wrist angles, hand spacing and right pinky stretch/load effort
* Curl(DH) ergo modifications to encourage natural finger curvature
* An "Extend" layer using Caps Lock as a modifier (lv5-8) for navigation/editing from the home position and more
* For several locales, a 'Unified Symbols' layout with only a few necessary changes from the standard Colemak[eD];
  Also, a layout to 'Keep Local Symbols' like their default (QWERTY-type) counterparts for that locale
* Intuitive phonetic layouts for Cyrillic, Greek and Hebrew scripts
* Mirrored Colemak that allows one-handed typing (if I ever break an arm...)
* The 4 Tarmak transitional Colemak layouts for learning Colemak(-DH) in smaller steps if desired
<br>

More info
---------

Run the install and setxkb scripts with -h (or look inside them) for more help and info about their workings!

Learn about `setxkb.sh "model locale variant"` shortstring syntax in the [BigBag][BigBag4X].
The default is `"5caw us us"`: PC105(ISO) board with Curl(DH)AngleWide mods, US locale, Cmk-eD UniversalSymbols variant.
To switch to, say, an ANSI board without ergo mods, that's `4n` instead of `5caw`. Look in the scripts.

NOTE: It may be necessary to select "Use system defaults" if you have changed anything in the OS GUI layout settings.

These files are updated to [XKB-data v2.23.1-1ubuntu1][XKB-Ub18], 2018.
The xkb-data package is very consistent between distros. I use the [Debian xkb-data][XKB-DebS], sometimes with some Ubuntu updates.
The .deb packages may be opened using `dpkg -x` or `ar -xv` (from `binutils`) on Linux, and for instance PeaZip on Windows.
<br>

Links
-----
See [DREYMAR'S BigBag XKB topic on the Colemak Forums][BigBag4X].
There are plenty of explanations and further links in there.
<br>

Happy XKB hacking!
DreymaR, 2021-10
<br>

TODO:
-----
* Rename setxkb --> setkb? It's easier to type! Would have to update all docs including the Forum topic.
* Make a restore to default layout shortcut? It's only an alias for `setxkb 4n/5n`. Maybe `resetxkb 4/5`?
* To get Extend with the currently active layout, use `setxkbmap -v 9 -option "" -option "misc:extend,lv5:caps_switch_lock,compose:menu"`.
* Add lv5:lalt_switch_lock for LALT-Extend.
* Add compose:102? Inconsistent between ISO and ANSI, just add a pro-tip.
* The Curl(DH) model implementation has to go as it may mess w/ QWERTY. Instead, I should use two Extend variants.
	- It also seems very hard for some newcomers to understand. So yes, I should have the Angle mod only and not CurlAngle models.
	- Also, matrix users want the V-D swap without an Angle mod! Another nail in the coffin for the Curl models.
	- Actually, should I make a NoModel CurlAngle layout for the model impaired? Vanilla, Curl(DH) and Curl(DH)Angle then. ... No?
	- First, just make Curl with D-V swap built in. Let the Extend Paste function be where it falls for now.
* Check out the compose:102 option. This would be similar to what I now use in EPKL for Windows! It's also present in some other layouts.

* Problems with Super+<letter> shortcuts: https://github.com/DreymaR/BigBagKbdTrixXKB/issues/23#issuecomment-1027839924

* A purge option in addition to restore for the install script? So backup dirs etc are removed and the xkb dir restored to original state.

* Update xkb-data and start testing on a Wayland system! Use the GitLab repo as that's the freshest there is.

* A clarification by Peter Hutterer on the mystic .part files in the rules component:
	- https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/-/issues/327#note_1436334
	- The parts are numbered to get their sequence in the resulting files right. Only when there are differences, they start with base/evdev.
	- There are RMLVO (user interface) and KcCSGST (actual XKB) letter codes. The naming of those .part files is 1234-rmlvo-kccgst.part...
	- but with only the relevant bits. So, e.g., `0009-m_g.part` is the model to group mapping of the final rules file. `ml_s.part` is model + layout to symbols.
	- It seems that you can make layout commits by editing only the rules/base.xml (and symbols) file(s) though?

* Echo the setxkbmap command when using setxkb.sh, for ease of troubleshooting! Also make the script able to output the command for piping?
* Add a model-less Colemak-CAWS for people who want to switch to QWERTY? Or instructions on how to setxkb it? That's better, I think.
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
* From Daniele at the Cmk Discord: Try out localectl?
	- E.g., `localectl --no-convert set-x11-keymap us pc105aw-sl cmk_ed_dh lv5:caps_switch_lock,misc:extend` should work to make changes persistent
	- Tips from i-c-u-p: https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Using_localectl
		- https://wiki.archlinux.org/title/Linux_console/Keyboard_configuration#Persistent_configuration
	- The syntax is: `localectl [--no-convert] set-x11-keymap layout [model [variant [options]]]` where you can use for instance `us,us` then `,cmk_ed_us`
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
	- "I made that tweak to setxkb and some small changes to use a hardcoded $HOME dir path, and it appears good."
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
* 2020-11-05: Switched to the new DH = DHm standard (was DH = DHk)
* Changed the default layout for the setxkb.sh script to US (UniSym): In my experience, most users that struggle with the setup want US English.
* To get back to your old layout/model, use `setxkb 4n/5n [loc]`. You may also specify `mod loc [var]`; omit `var` for the default (basic) variant.
* Separated out the F# key block in the extend file: People complain that their TTY shortcuts aren't working because of it. Ext+AltGr+F# works though.
* Relieve the sudo requirement. And add an option to change the X11 dir since Nix uses another place. Pulled from fufexan@github.
	- https://github.com/DreymaR/BigBagKbdTrixXKB/issues/15#issuecomment-769431139


[XKB-conf]: https://www.freedesktop.org/wiki/Software/XKeyboardConfig/ (XKeyboard Config page)
[XKBgitlb]: https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config (XKB-config on GitLab)
[XKB-pkgs]: https://pkgs.org/download/xkb-data (pkgs.org xkb-data page)
[XKB-DebS]: https://packages.debian.org/sid/xkb-data (Debian Sid xkb-data download)
[XKB-Ub18]: https://ubuntu.pkgs.org/18.04/ubuntu-main-amd64/xkb-data_2.23.1-1ubuntu1_all.deb.html (Ubuntu 18.04 LTS xkb-data page)
[BigBag4X]: http://forum.colemak.com/viewtopic.php?id=1438 (DreymaR's BigBag for Linux/XKB on the Colemak Forum)