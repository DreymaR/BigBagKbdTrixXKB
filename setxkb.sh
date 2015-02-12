#!/bin/bash

## ======================================================
## ===  XKBSET.sh to set the XKB keyboard options     ===
## ===     by Øystein Bech "DreymaR" Gadmar, 2014     ===
## ======================================================

HeadStr="DreymaR's setxkbmap script (by GadOE, 2015-01)"
DescStr=\
"Shell script to change X.org keyboard setup\n"\
"    using the 'setxkbmap' command.\n"\
"    To override system settings after logon,\n"\
"    source it, e.g., in your ~/.bashrc file\n"
FootStr="Happy xkb-hacking! ~ Øystein Bech 'DreymaR' Gadmar"

## NOTE: It now works with local xkb(-mod) dir
#	By default, setxkbmap checks ./rules first!
#	Need a full xkb dir then (not just the xkb-mod files)

## NOTE: I made a handy shorthand for activating simple cmk_ed model/layout combos.
#		Example: -s '5w no us' activates model pc105awide-sl, layout no(cmk_ed_us)
#		Options left out of this: Too complex (replace all or add another, and if so, how?)
#		Models: 4n 4a(pc104angle-z) 4w(pc104wide-qu) 4e(pc104awide-zqu) 4f(pc104aframe)
#		        5n 5a(pc105angle-lg) 5w/5e(pc105awide-sl)

##-------------- init ------------------------------------------
## NOTE: '#(-a)' means that the value can be set by a command-line argument '-a <value>'

#~ MyDATE=`date +"%Y-%m-%d_%H-%M"`
MyNAME=`basename $0`
#~ MyPATH=`dirname $0`
## @@@ The default X11 dir under Debian/Ubuntu/etc is /usr/share/X11  @@@
## @@@ The default X11 dir under some (older) distros is /usr/lib/X11 @@@
X11DIR='/usr/share/X11'; [ -d "${X11DIR}" ] || X11DIR='/usr/lib/X11'

#~ XKBmodel=pc104awide-zqu	# ANSI-104 keyboard w/ Angle(Z)Wide(Quote) mod
XKBmodel=pc105awide-sl	# ISO-105 keyboard w/ AngleWide(Slash) mod
#~ XKBlayout='us(cmk_ed_us),gr(colemak),ru(colemak)'
XKBlayout='no(cmk_ed_us)'	# Norwegian Colemak[eD]'Universal Symbols' layout
XKBoption='misc:extend,lv5:caps_switch_lock,grp:shifts_toggle,compose:menu'
VerboseLvl=9			# (-v) How much info should setxkbmap print out?
KeepXKM='no'			# (-k) Retain old /var/lib/xkb/server-*.xkm files?
XKBdir="${X11DIR}/xkb"	# (-d) The xkb-type dir to run setxkbmap from
SetXStr='' #'5aw no us'	# (-s) Shortcut string for setxkb - 'model locale eD-variant(sym)'

HelpStr="Usage: bash ${MyNAME} [optional args]\n"\
"[-m] <model>                   - '${XKBmodel}'\n"\
"[-l] <layout>                  - '${XKBlayout}'\n"\
"[-o] <option>                  - \n"\
"     '${XKBoption}'\n"\
"[-v] <verbose level>           - '${VerboseLvl}'\n"\
"[-s] <ShortStr> 'mod lay sym'  - '${SetXStr}'\n"\
"[-d] Run from <directory>      - '${XKBdir}'\n"\
"[-k] Keep old XKB server(s)    - '${KeepXKM}'\n"\
"\n     ShortStr notation (option to provide a space separated string):\n"\
"     1) 4/5 - ANSI-104/ISO-105 keyboard,\n"\
"        n/a/v/b/c/d - Normal/Angle/Curl-Dvbg/Dbg/DvbgHm/DbgHk\n"\
"        w/f - Wide/(Angle)Frame\n"\
"     2) Two-letter layout code like 'us' for USA, 'gb' for UK etc\n"\
"     3) 'us'/'ks' for 'Universal'/'Keep Local' symbol locale variants\n"\
"     Example: '5aw se us': PC105-AngleWide, Swedish Cmk[eD] 'UniSym'\n"
#~ "     (See the script's comments for more info.)"


##-------------- functions and line parser ---------------------

MyMsg()
{
	printf "\n@@@ $1 @@@\n\n"
}

PrintHelpAndExit()
{
	MyMsg "${HeadStr}"
	printf "${DescStr}\n"
	printf "${HelpStr}\n"
	MyMsg "${FootStr}"
	exit $1
}

MyEcho()
{
	printf "$1\n"
	[ -z "$2" ] || printf "$1\n" >> "$2"
}

MyError()
{
	MyMsg "$MyNAME - ERROR: ${@:-'Unknown'}"
	exit 1
}

MyCD()
{
	OldDir=`pwd`
	NewDir=${1:-`pwd`}
	cd ${NewDir} || MyError "Change to '${NewDir}' failed"
	MyEcho "¤ Changed dir to '${NewDir}'"
}

#~ if [ "$#" == 0 ]; then PrintHelpAndExit 2; fi # No args
while getopts "m:l:o:v:s:d:kh?" cmdarg; do
	case $cmdarg in
		m)  	XKBmodel="$OPTARG"		;;
		l)  	XKBlayout="$OPTARG"		;;
		o)  	XKBoption="$OPTARG"		;;
		v)  	VerboseLvl="$OPTARG"	;;
		s)		SetXStr=($OPTARG)		;;	# Split the string
		d)  	XKBdir="$OPTARG"		;;
		k)  	KeepXKM='yes'			;;
		h)		PrintHelpAndExit 0		;;
		\?)		PrintHelpAndExit 0		;;
		:)		PrintHelpAndExit 1		;;
	esac
done
#~ pos_arg=${@:$OPTIND:1} # Get the remaining (positional) arg

if [ -n "${SetXStr}" ]; then	# Use the ShortStr notation
	case ${SetXStr[0]} in
		 4n)	XKBmodel='pc104'			;;	# Generic ANSI-101/104-key
		 4a)	XKBmodel='pc104angle-z'		;;	# w/ Angle(Z) ergo mod
		 4w)	XKBmodel='pc104wide-qu'		;;	# w/ Wide(Quote) ergo mod
		4aw)	XKBmodel='pc104awide-zqu'	;;	# w/ Angle(Z)Wide(Quote) ergo mod
		 4f)	XKBmodel='pc104aframe'		;;	# w/ AngleFrame(Quote) ergo mod
		4af)	XKBmodel='pc104aframe'		;;	# w/ AngleFrame(Quote) ergo mod

		 4v)	XKBmodel='pc104curla-vz'	;;	# w/ Curl(Dvbg)Angle(Z) ergo mod
		 4b)	XKBmodel='pc104curla-bz'	;;	# w/ Curl(Dbg)Angle(Z) ergo mod
		4vw)	XKBmodel='pc104caw-vzqu'	;;	# w/ Curl(Dvbg)Angle(Z)Wide(Quote) mod
		4bw)	XKBmodel='pc104caw-bzqu'	;;	# w/ Curl(Dbg)Angle(Z)Wide(Quote) mod
		4vf)	XKBmodel='pc104caframe-v'	;;	# w/ Curl(Dvbg)AngleFrame(Quote) mod
		4bf)	XKBmodel='pc104caframe-b'	;;	# w/ Curl(Dbg)AngleFrame(Quote) mod
		 4c)	XKBmodel='pc104curla-vmz'	;;	# w/ Curl(DvbgHm)Angle(Z) ergo mod
		 4d)	XKBmodel='pc104curla-bkz'	;;	# w/ Curl(DbgHk)Angle(Z) ergo mod
		4cw)	XKBmodel='pc104caw-vmzqu'	;;	# w/ Curl(DvbgHm)Angle(Z)Wide(Quote) mod
		4dw)	XKBmodel='pc104caw-bkzqu'	;;	# w/ Curl(DbgHk)Angle(Z)Wide(Quote) mod
		4cf)	XKBmodel='pc104caframe-vm'	;;	# w/ Curl(DvbgHm)AngleFrame(Quote) mod
		4df)	XKBmodel='pc104caframe-bk'	;;	# w/ Curl(DbgHk)AngleFrame(Quote) mod

		 5n)	XKBmodel='pc105'			;;	# Generic ISO-102/105-key
		 5a)	XKBmodel='pc105angle-lg'	;;	# w/ Angle(LSGT) ergo mod
		 5w)	XKBmodel='pc105awide-sl'	;;	# w/ AngleWide(Slash) ergo mod
		5aw)	XKBmodel='pc105awide-sl'	;;	# w/ AngleWide(Slash) ergo mod

		 5v)	XKBmodel='pc105curla-v'		;;	# w/ Curl(Dvbg)Angle ergo mod
		 5b)	XKBmodel='pc105curla-b'		;;	# w/ Curl(Dbg)Angle ergo mod
		5vw)	XKBmodel='pc105caw-vsl'		;;	# w/ Curl(Dvbg)AngleWide(Slash) mod
		5bw)	XKBmodel='pc105caw-bsl'		;;	# w/ Curl(Dbg)AngleWide(Slash) mod
		 5c)	XKBmodel='pc105curla-vm'	;;	# w/ Curl(DvbgHm)Angle ergo mod
		 5d)	XKBmodel='pc105curla-bk'	;;	# w/ Curl(DbgHk)Angle ergo mod
		5cw)	XKBmodel='pc105caw-vmsl'	;;	# w/ Curl(DvbgHm)AngleWide(Slash) mod
		5dw)	XKBmodel='pc105caw-bksl'	;;	# w/ Curl(DbgHk)AngleWide(Slash) mod

		  *)	MyError "ShortStr model '${SetXStr[0]}' unknown!" ;;
	esac
	XKBlayout="${SetXStr[1]}(cmk_ed_${SetXStr[2]})"
fi
##TODO: Add curl mods to models?!? Then, new shortstr codes are needed
#       Enough to do the left hand and full!
#       So, [4|5][n|a|v|b|c|d][-|w|f]? (Or m|k for c|d?)

##-------------- main ------------------------------------------

MyMsg "$HeadStr"
#~ MyCD "${XKBpath%/}/${XKBdir%/}"
if [ -n "${SetXStr}" ]; then
	MyEcho "¤ Using model/layout '$XKBmodel'/'$XKBlayout' from ShortStr"
fi
MyCD "${XKBdir%/}"
#~ MyEcho "¤ Running from `pwd`"

## Purge the old xkb server files
MyEcho "¤ Looking for and removing any old .xkm server files"
if [ ${KeepXKM} == 'no' ]; then
	sudo rm -f /var/lib/xkb/server-*.xkm || MyEcho "¤ No .xkm files"
fi

## Clear the xkb options (to avoid duplicates)
setxkbmap -option ''

## Run the actual setxkbmap command
MyEcho "¤ Running setxkbmap:\n"
setxkbmap -model "$XKBmodel" -layout "$XKBlayout" \
          -option "$XKBoption" -v $VerboseLvl
MyEcho ""

MyCD "${OldDir}"

## When run in a terminal window, wait for a key press
## so you can see the results before the window closes
#~ MyMsg "Press any key to proceed:"
#~ read -n 1

MyMsg "${MyNAME} finished!"
exit 0

##-------------- misc ------------------------------------------

#~ echo "'$XKBmodel' '$XKBlayout'"; for i in 0 1 2; do echo "'${SetXStr[i]}'"; done; exit 0

## US/ANSI Wide ergo mod,
## Colemak[eD] US layout,
## Extend mappings w/ Caps switch:
#~ setxkbmap \
#~ -model pc104wide-qu, \
#~ -layout "us(cmk_ed_us)", \
#~ -option "misc:extend,lv5:caps_switch_lock"

## Euro/ISO AngleWide ergo mod,
## Norwegian Cmk[eD] "US" layout (grp1),
## Greek phonetic Colemak layout (grp2),
## Extend mappings w/ Caps switch (for both),
## Switch grp w/ 2xCtrl; Compose on Menu key:
#~ setxkbmap \
#~ -model pc105awide-sl, \
#~ -layout "no(cmk_ed_us),gr(colemak)", \
#~ -option "misc:extend,lv5:caps_switch_lock,"\
#~         "grp:rctrl_switch_ctrls_toggle,compose:menu"
