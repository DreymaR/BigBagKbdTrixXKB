XKB data for DreymaR's Big Bag of Keyboard Tricks
=================================================

VERSION
-------
	File description: Modified xkb-data files for DreymaR's Big Bag of Keyboard Tricks (Linux/XKB)
	Files found here: https://github.com/DreymaR/BigBagKbdTrixXKB
	xkb-data version: 2.35.1-1_all_eD
	Files repository: https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config
	XKB archive date: 2022-04-05 (changes: Cherry-picked commit bc927671, 2022-07-04)
	My starting date: 2023-05-31
<br>


INTRO
-----
This readme holds version info, TODO and DONE lists for the BigBagKbdTrixXKB repository.

For more general info, see the [main repo README][BBREADME].

The [xkeyboard-config][XKBgitLb] files in this folder are updated to match Debian (Sid) [XKB-data v2.35.1][XKB_2-35], 2022. 

They work just fine with nearly all other versions and distros, though.

Note that the `base` and `evdev` rules are compiled slightly differently, so I provide both. Their `.lst` and `.xml` counterparts are identical/aliases.
<br>

FIXD
----
* The setkb.sh script wasn't working as it should. It got an error saying, e.g., "model pc104 doesn't exist".
	- Shortstrs like `4ns` and `5cas` worked, as did `4aw` or `5w`. `4ws` didn't; gave "pc104/pc105 doesn't exist" errors.
	- Identified these bugs: `DH-Mod` -> `DH_Mod` && "#{ModStr}" -> "${ModStr}".
	- Furthermore, the layout was empty if setkb.sh can't run the setxkbmap cmd to determine layout.
		- Added a conditional to see if the command was run successfully or default to 'us'
	- Furthermore, the variant defaults to 'cmk_ed_us' instead of 'basic'? Because of a default setting, or what? It's OK though.
	- Models `5s`, `5c` or `5cs` still not working, giving errors like `5s doesn't exist`. `5ns` worked.
		- The error was not having a case model for the empty string ''.
	- Giving a weird KbdStr could lead to weirdness. Now it gives an error message.
<br>

2FIX
----
* No shortstr defaults to the `cmk_ed_us` variant. Should default to current variant, as w/ layout?
	- Instead of the fancy `setxkbmap -query` stuff, could just not use `-layout` nor `-variant` when empty?!
		- Unless set by `-l -o` switches?
	- Or keep setkb as a Cmk-eD setting tool, therefore defaulting to `cmk_ed_us`?

* Add a switch for resetting options?

* WSL1 uses xorg rules. I've only prepared for evdev and base. How to solve that? But xorg -> base by link!
	- Is there another reason, then, that setxkbmap using WSL1 can't see my changes? The files are installed.

* Local dir by setkb.sh isn't working?
<br>


TODO
----
* Move to .config to avoid editing the system files?!
	- https://github.com/DreymaR/BigBagKbdTrixXKB/issues/42
	- https://codeaffen.org/2023/09/16/custom-keyboard-layouts-with-xkb/

* The `pc105curl` model is actually a CurlAngle model, and thus badly named. Fix?!
	- All the Curl models seem messy? What was I thinking? But maybe to avoid the option thing, they could still be useful?
	- The option thing messes with QWERTY and other layouts on switch. Which may be acceptable for Sym? But not so much for Curl.
	- I think that all layout variants should instead have a DH counterpart. Can include vanilla then a mod.
		- Make a mod also for each non-Latin script then. And special includes for locales that change any of the affected keys.

* Add colemak-dh to the colemak symbols file and the US locale? Both ISO, ANSI and Ortho.
	- Would it be "allowable" to actually move both default and dh colemak _into_ the symbols/colemak file now?
		- If so, edit rules components accordingly
	- Consider editing all locale variants to include DH.
		- Especially useful for non-Latin and locales that change any of the DBG HMK keys.

* Not all distros source `~/.bashrc` by default. Seems that `~/.xinitrc` is mostly used by xinit and not generally sourced?
	- What about `~/.xsession`, `~/.xprofile` or `~/.profile`? Seems to be mostly legacy; used by `startx`? It's messy.
	- Look in `/etc/X11/Xsession` to see how thing are run at startup?
	- But `~/.Xresources` seems like a good option (and is sourced by xinitrc too)?
	- Its format is different though. And it doesn't list keyboard layout as one of its intended purposes.
	- There is the option of entering the file name manually. But the BigBag default should be the most sensible/common choice.
	- Or, switch tack completely and just have `setkb.sh` output a string that you can `>` into a file yourself?
		- If so, have it output nothing else! Or use another file descriptor (stderr is wrong!)? Use `echo <smth> 3>>` then `3> <file>`?
		- Change tack regarding the -af <file> switches. Could force users to use syntax like `setkb.sh -f > ~/.bashrc`?
		- Actually... If using file descriptor 3, it usually goes nowhere? So you wouldn't need a switch for it at all!?
	- Print out the command also when running it, for clarity.

* Better instructions for Wayland?
	- Depends on your Wayland Compositor (Sway is common?)
		https://wiki.archlinux.org/title/wayland#Compositors
	- Some good ones were posted at the Colemak Discord.
		https://discord.com/channels/409502982246236160/1059814838408319026/1059866421066203257
	- I'm uncertain about how to do it in Ubuntu GNOME now. It uses the Miriway compositor?

* Lockable lv5 modifier, for users who want Extend-lock. Maybe Shift+Extend to lock it, or something?
	- It's possible today to have two switch-or-lock lv5 modifiers. But it seems wasteful to use up two keys.

* Add some easy way of returning to the old xkbmap setup? But how? Can't unset settings, so we'd have to store it somehow? Or just let them go to us/us?
	- Could write setxkbmap output to a file. Check it isn't overwritten, like the normal backup.
	- Make a restore to default layout shortcut instead? It's only an alias for `setkb 4n/5n`. Maybe `resetkb 4/5`?

* Add a lv5:lalt_switch_lock definition for LALT-Extend.

* The Curl(DH) model implementation has to go as it may mess w/ QWERTY. Instead, I should use two Extend variants.
	- It also seems very hard for some newcomers to understand. So yes, I should have the Angle mod only and not CurlAngle models?
	- Also, matrix users want the V-D swap without an Angle mod! Another nail in the coffin for the Curl models.
	- The V-D swap also messes with the Extend mapping for Paste, which becomes Ctrl+D instead of Ctrl+V.
	- Actually, should I make a NoModel CurlAngle layout for the model impaired? Vanilla, Curl(DH) and Curl(DH)Angle then. ... No?
	- First, just make Curl with D-V swap built in. Let the Extend Paste function be where it falls for now?
	- Separate Angle mods for Curl and non-Curl? Probably not, as it'll still get silly when using both QWERTY and Cmk-eD.
	- Separate Extend-Angle includes! Similar to how EPKL handles this problem.

* Check out the compose:102 option. This would be similar to what I've used in EPKL for Windows! It's also present in some other layouts.
	- Add compose:102 in the default setkb options? Inconsistent between ISO and ANSI, just add a pro-tip?

* Add a localectl option to setkb.sh? So people can choose that or setxkbmap. Eventually, even more variants such as Sway?

* Problems with Super+<letter> shortcuts: https://github.com/DreymaR/BigBagKbdTrixXKB/issues/23#issuecomment-1027839924

* A purge option in addition to restore for the install script? So backup dirs etc are removed and the xkb dir restored to original state.

* Find out how to change the rules component properly to allow compiling and eventually merging to the main repo?
	- A clarification by Peter Hutterer on the mystic .part files in the rules component:
	- https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/-/issues/327#note_1436334
	- The parts are numbered to get their sequence in the resulting files right. Only when there are differences, they start with base/evdev.
	- There are RMLVO (user interface) and KcCSGST (actual XKB) letter codes. The naming of those .part files is 1234-rmlvo-kccgst.part...
	- but with only the relevant bits. So, e.g., `0009-m_g.part` is the model to group mapping of the final rules file. `ml_s.part` is model + layout to symbols.
	- It seems that you can make simple layout commits by editing only the rules/base.xml (and symbols) file(s) though?
	- We may need to provide both the uncompiled and compiled files (or a patch thereof) for different purposes.

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


HOLD
----
* Make a patch file of the mod dir?
	- WinMerge doesn't support patch generation. So it'd have to be by CLI.
	- It's a little cumbersome to have to update both the files and the patch file for each commit. So no, for now?

* Move the ks (Keep Local Symbols) variants out of the official sortiment? They're rather bad anyway, and may confuse newcomers?
	- Could leave them in so as to be addable by a simple modding: Links as commented-out lines in the symbols/colemak file or something.

* Transition ###.xml changes to ###.extras.xml? 
	- Some other Colemak locale variants reside there, like Latvian/Polish/Greek/Portuguese Colemak and Russian Rulemak.
	- But it's a mess: Others (such as Norwegian, Latam and Filipino) are in the main file!
	- It might be nice to keep all the BigBag locales in one place though? Or not?

* Rulemak (ru) has its own entry now, by its creator GHen (Geert Hendrickx). Bulmak (bg) is still provided in the BigBag.
	- There exists a ru(Polish) BigBag entry, copied over from pl. I think someone asked for it at some point?
	- It allows writing latinized Slavic for Colemak users. It is not defined in rules but can be used by the command line.

* Non-Fn-key Extend is now the default. Add a separate option for FKey Extend?
	- Many new users struggled with Extend overriding `Ctrl+Alt+FK##` TTY server control keys, or other FKey setups they were using.
	- Add a FKey Extend option to misc? So people can activate `misc:extend` and `misc:extend_fk` separately.
	- I already added `Extend+AltGr+FK##` mappings so even with FK Extend you have TTY hotkeys. But they aren't on by default now.
<br>


DONE
----
* Echo the setxkbmap command when using setkb.sh, for ease of troubleshooting! Also make the script able to output the command for piping?

* Reworked ergo model names.
	- Mods should have modularly related names, e.g., `pc104awide`/`pc105awide` instead of `pc104aw-zqu`/`pc105aw-sl`.
	- Converted, therefore, to `#angle`, `#wide`, `#awide` (and the "arcane" `pc104awing`, now hidden from menus).

* Sym mod implementation.
	- The Sym mod can not be implemented as hard/model, as it must not rearrange Extend. Like Curl, it is an `option` mod.
	- Made a symbols/symkeys file, and put all symbol key definitions in there.
	- There are `non-wide`, `wide-104` and `wide-105` variants. The latter two build on the Colemak-Wide ergo mods.
	- The `setkb.sh` script is updated to handle these with an `s` shortstr syntax, so it respects `caws` nomenclature.
	- This should be nice for use with any other layouts that don't touch symbol keys as well! Even QWERTY.

* Update xkb-data to 2.35.1.1 as of 2023-05-31 (package updated 2022-04-05).
	- The [freedesktop.org GitLab repo][XKBgitLb] is the freshest there is? But it has the rules in raw/uncompiled format.
	- So, instead use the [Debian Sid xkb-data package][XKB-DebS] which is the most updated one in actual use.
	- Add the patch that fixes the hobbled Colemak (LatAm, Colemak for Gaming) variant
		- Commit bc927671 "symbols/latam: remove a hobbled Colemak variant" by Benno Schulenberg 2022-07-04
		- https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/-/commit/bc927671

* Added <!--  >->  DreymaR's  BigBagKbdTrix  --> and <!--  <-<  DreymaR  --> comments around my changes in evdev.xml.
	- There are some others there now, typically like `<!-- Keyboard indicator for <locale> layouts -->`.

* Changed my comment arrow format to `>>-->`/`<--<<`.
	- Using `-->` arrows is confusing vis-a-vis html/xml. `»->`/`<-«`? caused encoding trouble, at least in WinMerge.

* Is `any` equivalent to `NoSymbol` in the definitions? If so, we could make symbols/extend tidier!
	- According to Benno Schulenberg, yes, but there's little documentation for it.
	- There are some other compact forms of notation, like leaving out symbols entirely, but those are less clear.
	- In the repo, I've seen `NoSymbol` been replaced with `any`, and `VoidSymbol` with `none`.
	- Is it implemented everywhere yet, though? Hard to find good docs on it, methinks.

* Fixed key repetition with Extend, particularly vis-a-vis Wayland.
	- Added `repeat=yes` after the key actions, to all keys that have actions.
	- https://discord.com/channels/409502982246236160/1066499260322943006/1080488398403424256
	- http://web.archive.org/web/20190320180541/http://pascal.tsu.ru/en/xkb/gram-symbols.html
	- I couldn't devise a way to do this once and for instead of by-key (looked at compat but no?).

* Moved Space to the Colemak "letters" block to ensure a consistent Space key implementation for `_ks` layouts etc.
	- Some basic layouts don't define some keys (no Space?!). To compensate, "nbsp(level4)" was included to define SPCE as necessary.
	- After moving SPCE into the Colemak letter block, this is only needed for non-Latin scripts (il gr; bg ru have SPCE definitions).

* Renamed setkb --> setkb: It's easier to type. Updated all docs including the Forum topic.

* Switched to the DH = DHm Colemak-DH standard (was DH = DHk, 2017–2020).

* Changed the default layout for the setkb.sh script to US (UniSym): In my experience, most users that struggle with the setup want US English.

* Relieved the sudo requirement. And added an option to change the X11 dir since Nix uses another place. Pulled from fufexan@github.
	- https://github.com/DreymaR/BigBagKbdTrixXKB/issues/15#issuecomment-769431139



[XKB-conf]: https://www.freedesktop.org/wiki/Software/XKeyboardConfig/ (XKeyboard Config page)
[XKBgitLb]: https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config (XKB-config on GitLab)
[XKB-pkgs]: https://pkgs.org/download/xkb-data (pkgs.org xkb-data page)
[XKB-DebS]: https://packages.debian.org/sid/xkb-data (Debian Sid xkb-data download)
[BigBag]:   https://dreymar.colemak.org/ (DreymaR's Big Bag of Keyboard Tricks)
[BigBag4X]: http://forum.colemak.com/viewtopic.php?id=1438 (DreymaR's old BigBag for Linux/XKB on the Colemak Forum)
[BBREADME]: README.md                               (main BigBag4XKB README)
[xmREADME]: /xkb-data_xmod/README.md                (xmod BigBag4XKB README)

[XKB_Ub18]: https://ubuntu.pkgs.org/18.04/ubuntu-main-amd64/xkb-data_2.23.1-1ubuntu1_all.deb.html (Ubuntu LTS xkb-data page, 2018-04)
[XKB_Ub22]: https://ubuntu.pkgs.org/22.04/ubuntu-main-amd64/xkb-data_2.33-1_all.deb.html (Ubuntu LTS xkb-data page, 2022-04)
[XKB_2-35]: https://debian.pkgs.org/sid/debian-main-amd64/xkb-data_2.35.1-1_all.deb.html (Debian Sid xkb-data page, 2022-12)
