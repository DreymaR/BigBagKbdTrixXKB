DreymaR's Big Bag of Keyboard Tricks
====================================

### For Linux (updated to [XKB-data v2.23.1-1ubuntu1][XKBdat], 2018-08)

* New "Colemak[eD]" AltGr mappings (lv3-4) putting dead keys on AltGr+symbol keys and reworking most other mappings
* Angle/Wide ergo modifications to improve wrist angles, hand spacing and right pinky stretch/load effort
* Curl(DH) ergo modifications to encourage natural finger curvature
* An "Extend" layer using Caps Lock as a modifier (lv5-8) for navigation/editing from the home position and more
* For several locales, a 'Unified Symbols' layout with only a few necessary changes from the standard Colemak[eD];
  Also, a layout to 'Keep Local Symbols' like their default (QWERTY-type) counterparts for that locale
* Intuitive phonetic layouts for Cyrillic, Greek and Hebrew scripts
* Mirrored Colemak that allows one-handed typing (if I ever break an arm...)
* The 4 Tarmak transitional Colemak layouts for learning Colemak (or Colemak-Curl) in smaller steps if desired

More info
---------

Run the install and setxkb scripts with -h (or look inside them) for more help and info about their workings!


Links
-----

See [DREYMAR'S XKB topic on the Colemak Forums](http://forum.colemak.com/viewtopic.php?id=1438) (http://forum.colemak.com).
There are plenty of explanations and further links in there, as well as links to files.

Happy XKB hacking!
DreymaR, 2018-08

TODO:
-----
* Migrate from `~/.bashrc` to `~/.xprofile`? The latter is more appropriate, but which setups source it and which ones don't?
* Note: It may be necessary to select "Use system defaults" if you have changed anything in the OS GUI layout settings.
* The Curl(DH) model implementation may have to go as it may mess w/ QWERTY, and instead I should use two Extend variants?
* Could use an <EXT> key code alias defined in keycodes/evdev (alias <EXT> = <CAPS>), instead of the <CAPS> code?
* Choose another default layout for the setxkb.sh script than Norwegian! But which one? I want to diffferentiate between the US locale and the US variant (Universal Symbols).


[XKBdat]: https://ubuntu.pkgs.org/18.04/ubuntu-main-amd64/xkb-data_2.23.1-1ubuntu1_all.deb.html (xkb-data download page)
