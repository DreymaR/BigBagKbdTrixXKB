XKB data for DreymaR's Big Bag of Keyboard Tricks
=================================================

This readme holds version info, and also TODO and DONE lists for the BigBag-4-XKB repo.

For more general info, see the [main repo README][BBREADME].

The [xkeyboard-config][XKBgitHb] files in this folder are updated to [XKB-data v2.23.1-1ubuntu1][XKB-Ub18], 2018. 

They work fine with other versions though, in nearly all cases.
<br>


VERSION:
--------
	File description: Modified xkb-data files for DreymaR's Big Bag of Keyboard Tricks (Linux/XKB)
	Files found here: https://github.com/DreymaR/BigBagKbdTrixXKB
	xkb-data version: 2-23-1-1ub1, edition DreymaR
	XKB archive date: 2018-02-02
	My starting date: 2018-08-21


TODO:
-----
* Make a patch file of the mod dir.
* Update all forum.colemak.com links with new BigBag links: Locale topic (id=1458) -> https://dreymar.colemak.org/variants.html#locales etc.
* Better instructions for Wayland?
	- Depends on your Wayland Compositor (Sway is common?)
		https://wiki.archlinux.org/title/wayland#Compositors
	- Didn't we have some good ones at the Colemak Discord? Where?
		https://discord.com/channels/409502982246236160/1059814838408319026/1059866421066203257
* Lockable lv5 modifier, for users who want Extend-lock. Maybe Shift+Extend to lock it, or something?
	- It's possible today to have two switch-or-lock lv5 modifiers. But it seems wasteful to use up two keys.
* Non-Fn-key Extend is now the default. Add a separate option for FKey Extend? Many new users struggled with this, or have weird FKey setups.
	- Add a FKey Extend option to misc? So people can activate `misc:extend` and `misc:extend_fk` separately.
* Add colemak-dh to the colemak symbols file and the US locale? Both ISO, ANSI and Ortho.
	- Would it be "allowable" to actually move both default and dh colemak _into_ the symbols/colemak file now?
	- If so, edit rules components accordingly, and consider editing all locale variants to include them
* Not all distros source `~/.bashrc` by default. Seems that `~/.xinitrc` is mostly used by xinit and not generally sourced?
	- What about `~/.xsession` or `~/.profile`? Seems to be mostly legacy; used by `startx`? It's messy.
	- Look in `/etc/X11/Xsession` to see how thing are run at startup?
	- But `~/.Xresources` seems like a good option (and is sourced by xinitrc too)?
	- Its format is different though. And it doesn't list keyboard layout as one of its intended purposes.
* Add some easy way of returning to the old xkbmap setup? But how? Can't unset settings, so we'd have to store it somehow? Or just let them go to us/us?
	- Could write setxkbmap output to a file. Check it isn't overwritten, like the normal backup.
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
	- The V-D swap also messes with the Extend mapping for Paste, which becomes Ctrl+D instead of Ctrl+V.
	- Actually, should I make a NoModel CurlAngle layout for the model impaired? Vanilla, Curl(DH) and Curl(DH)Angle then. ... No?
	- First, just make Curl with D-V swap built in. Let the Extend Paste function be where it falls for now?
	- Separate Angle mods for Curl and non-Curl? Probably not, as it'll still get silly when using both QWERTY and Cmk-eD.
	- Separate Extend-Angle includes! Similar to how EPKL handles this problem.
* Check out the compose:102 option. This would be similar to what I've used in EPKL for Windows! It's also present in some other layouts.
* Echo the setxkbmap command when using setkb.sh, for ease of troubleshooting! Also make the script able to output the command for piping?
* Add a localectl option to setkb.sh? So people can choose that or setxkbmap. Eventually, even more variants such as Sway?

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
<br>


DONE:
-----
* Fixed key repetition with Extend, particularly vis-a-vis Wayland.
	- Added `repeat=yes` after the key actions, to all keys that have actions.
	- https://discord.com/channels/409502982246236160/1066499260322943006/1080488398403424256
	- http://web.archive.org/web/20190320180541/http://pascal.tsu.ru/en/xkb/gram-symbols.html
	- I couldn't devise a way to do this once and for instead of by-key (looked at compat but no?).
* Moved Space to the "letters" block to ensure a consistent Space key implementation for `_ks` layouts etc. Many xkb layouts are sloppy about that.
* Renamed setkb --> setkb: It's easier to type. Updated all docs including the Forum topic.
* Switched to the new DH = DHm standard (was DH = DHk, 2017–2020).
* Changed the default layout for the setkb.sh script to US (UniSym): In my experience, most users that struggle with the setup want US English.
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
[BBREADME]: README.md (main BigBag4XKB README)
