# =================================================================
# ===  INSTALL-DREYMAR-XMOD.sh for DreymaR's XKB modifications  ===
# ===         by Øystein Bech "DreymaR" Gadmar, 2015            ===
# =================================================================
# 
# DreymaR's Big Bag Of Tricks install script (by GadOE, 2015-01)
# 
# Shell script to apply DreymaR's changes to the X keyboard files:
#   - AngleWide Ergonomic keyboard models for pc104/pc105 keyboards,
#   - Extend mappings as a Misc option and CapsLock as a chooser (using lv5-8),
#   - the Colemak [edition DreymaR] layout, using my own lv3-4 mappings,
#   - locale variants of Colemak[eD] with 'local' or 'unified' symbol keys,
#   - mirrored Colemak[eD] for one-handed typing,
#   - and the Tarmak(1-4) transitional (step-by-step) Colemak learning layouts.
# 
# - By default, this script creates a backup of the X11 files if none exist.
# - With '-o', overwrite the system X11 files (makes the mod GUI accessible).
# - With '-s <mdl loc sym>', specify a model/layout to activate immediately.
#     (Shortstring format: -s '[4|5][n|a|w] loc [ks|us]'; 'loc'(ale) is 2-letter.
#      Some model shortstr examples: '4n' is pc104, '5w' is pc105AngleWide etc.
#      E.g.: -s '5n fr us' is normal pc105 model, French Colemak[eD]'USym'.)
# - With '-?', list further instructions and default values.
# 
# Happy xkb-hacking! Øystein Bech "DreymaR" Gadmar
