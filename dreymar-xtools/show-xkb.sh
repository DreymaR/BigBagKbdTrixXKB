#!/bin/bash

# =====================================================
# ===  SHOW-XKB.sh for DreymaR's XKB modifications  ===
# ===    by Øystein Bech "DreymaR" Gadmar, 2012     ===
# =====================================================
#
# Shell script to show the active Gnome XKB settings
#
# Usage: 'sudo sh [scriptpath]' or
#        allow executing file then run in a term window
#
# Happy xkb-hacking! Øystein Bech Gadmar (2012)

HeadStr="DreymaR's Show XKB info script (by GadOE, 2014)"

#-------------- functions and line parser ---------------------

MyMsg()
{
	printf "\n••• $1 •••\n\n"
}

MyEcho()
{
	printf "$1\n"
	[ -z "$2" ] || printf "$1\n" >> "$2"
}

#---------- init --------------------------------------
HDR='Output from '
XPROP='xprop -root | grep "XKB"'
GSETT='gsettings list-recursively org.gnome.libgnomekbd.keyboard'
SETXK='setxkbmap -print' # -v 9'

#---------- main --------------------------------------

MyMsg "$HeadStr"

MyMsg "$HDR'$XPROP':"
eval "$XPROP"
#echo "`$XPROP`" | grep "XKB"
MyMsg "$HDR'$GSETT':"
eval "$GSETT"
MyMsg "$HDR'$SETXK':"
eval "$SETXK"
MyMsg "Press any key to finish:"
read -n 1
