DreymaR's Big Bag of Keyboard Tricks
====================================

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
  
  
More info
---------

Run the install and setxkb scripts with -h (or look inside them) for more help and info about their workings!
  
Learn about `setxkb.sh "model locale variant"` shortstring syntax in the [BigBag][BigBagTx].
The default is `"5cw us us"`: PC105(ISO) board with Curl(DH)AngleWide mods, US locale, Cmk-eD UniversalSymbols variant.
To switch to, say, an ANSI board without ergo mods, that's `4n` instead of `5cw`. Look in the scripts.
  
NOTE: It may be necessary to select "Use system defaults" if you have changed anything in the OS GUI layout settings.
  
These files are updated to [XKB-data v2.23.1-1ubuntu1][XKB-Ub18], 2018.
The xkb-data package is consistent enough between distros. I use the [Debian xkb-data][XKB-DebS], sometimes with some Ubuntu updates.
The .deb packages may be opened using `dpkg -x` or `ar -xv` (from `binutils`) on Linux, and for instance PeaZip on Windows.
  

Links
-----

See [DREYMAR'S BigBag XKB topic on the Colemak Forums][BigBagTx].
There are plenty of explanations and further links in there.
  
  
Happy XKB hacking!
DreymaR, 2021-01
  
  
TODO:
-----
* Is there a way to clear the LevelFive mod on all the Extend mappings by default? Or must I be more careful with each RedirectKey()?
	- Example: `Q -> Esc -> Caps` caused people trouble, as Ext+Q would act as Esc+Caps.
	- Possibly, finally make a new key type EIGHT_LEVEL_EXTEND with the action clearmods=LevelFive added to state 5-8? No, no actions.
	- In xkb/types/level5 under EIGHT_LEVEL_SEMIALPHABETIC I used `preserve[Shift] = Shift;`. We need the opposite here, to discard lvl5.
	- See for instance https://www.x.org/releases/X11R7.5/doc/input/XKB-Enhancing.html
	- "Usually, all modifiers introduced in 'modifiers=<list of modifiers>' list are used for shift level calculation and then discarded."
	- Does this mean that LevelFive should've been discarded but isn't? Is it an XKB bug?
* From Daniele at the Cmk Discord: Try out localectl?
	- E.g., 'localectl set-x11-keymap us pc105aw-sl cmk_ed_dh lv5:caps_switch_lock,misc:extend' should work to make changes persistent?
* The Curl(DH) model implementation have to go as it may mess w/ QWERTY. Instead, I should use two Extend variants.
	- It also seems very hard for some newcomers to understand. So yes, I should have the Angle mod only and not CurlAngle models.
	- Also, matrix users want the V-D swap without an Angle mod! Another nail in the coffin for the Curl models.
	- Actually, should I make a NoModel CurlAngle layout for the model impaired? Vanilla, Curl(DH) and Curl(DH)Angle then.
	- Could just make a CurlAngle option!
	- But first, just the Curl with D-V swap built in. Just let the Extend Paste function be where it falls for now.
* Update to the latest xkb-data: https://ubuntu.pkgs.org/20.04/ubuntu-main-amd64/xkb-data_2.29-2_all.deb.html
* Find out how to change the rules component properly to allow compiling and eventually merging to the main repo?
* Migrate from `~/.bashrc` to `~/.xprofile`? The latter is more appropriate, but which setups source it and which ones don't?
* Could use an <XTND> key code alias defined in keycodes/evdev (alias <XTND> = <CAPS>), instead of the <CAPS> code?
* Test this method for using a local dir: 
	- Copy the `xkb-data_mod/xkb` dir to, say, `/usr/local/bigbag/xkb` and `setenv MYXKB <dir>` (setenv not necessary, just for here)
	- `setxkbmap <parameters> -print | xkbcomp -I -I$MYXKB -I/usr/share/X11/xkb - $DISPLAY`
	- See https://github.com/DreymaR/BigBagKbdTrixXKB/issues/14
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
  
  
DONE:
-----
* 2020-11-05: Switched to the new DH = DHm standard (was DH = DHk)
* Changed the default layout for the setxkb.sh script to US (UniSym): In my experience, most users that struggle with the setup want US English.
* To get back to your old layout/model, use `setxkb 4n/5n [loc]`. You may also specify `mod loc [var]`; omit `var` for the default (basic) variant.
* Separated out the F# key block in the extend file: People complain that their TTY shortcuts aren't working because of it. Ext+AltGr+F# works though.


[XKB-conf]: https://www.freedesktop.org/wiki/Software/XKeyboardConfig/ (XKeyboard Config page)
[XKBgitlb]: https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config (XKB-config on GitLab)
[XKB-pkgs]: https://pkgs.org/download/xkb-data (pkgs.org xkb-data page)
[XKB-DebS]: https://packages.debian.org/sid/xkb-data (Debian Sid xkb-data download)
[XKB-Ub18]: https://ubuntu.pkgs.org/18.04/ubuntu-main-amd64/xkb-data_2.23.1-1ubuntu1_all.deb.html (Ubuntu 18.04 LTS xkb-data page)
[BigBagTx]: http://forum.colemak.com/viewtopic.php?id=1438 (DreymaR's BigBag on the Colemak Forum)