#!/bin/sh

# =====================================================
# ===  XEV.sh for DreymaR's XKB modifications       ===
# ===    by Øystein Bech "DreymaR" Gadmar, 2014     ===
# =====================================================
#
# Shell script to run a keypress-specific XEV
#
# Usage: 'sh [scriptpath]' or
#        allow executing file then run in a term window
#
# Happy xkb-hacking! Øystein Bech Gadmar (2014)

#---------- init --------------------------------------
SETXKB='setxkbmap -print -v 7'

#---------- main --------------------------------------
echo "*** Running $XEV: ***"
xev | sed -ne '/^KeyPress/,/^$/p'
echo "\n*** Press <ENTER> to finish: ***"
read dummy

