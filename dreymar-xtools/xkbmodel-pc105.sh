#!/bin/sh

# ======================================================
# ===  XMODEL.sh to set the XKB keyboard model       ===
# ===     by Øystein Bech "DreymaR" Gadmar, 2013     ===
# ======================================================
#

#---------- init --------------------------------------
#XKBmodel='pc104'
#XKBmodel='pc104angle-z'
#XKBmodel='pc104wide-qu'
#XKBmodel='pc104aw-zqu'
#XKBmodel='pc104curl-z'
#XKBmodel='pc104caw-zqu'
XKBmodel='pc105'
#XKBmodel='pc105angle'
#XKBmodel='pc105aw-sl'
#XKBmodel='pc105caw-sl'
VerboseLvl=9
UsageStr="sh $0 [-m model]"
HelpStr="Usage: $UsageStr\n"\
"*** Please read this script's comments for info on how it works ***"

#---------- subroutines -------------------------------
PrintHelpAndExit()
{
	printf "\n$HelpStr\n"
	exit $1
}

#---------- command line parser -----------------------
while getopts "m:v:h" cmdarg; do
	case $cmdarg in
		m)  	XKBmodel="$OPTARG"		;;
		v)  	VerboseLvl="$OPTARG"		;;
		h)  	PrintHelpAndExit 1		;;
		\?) 	PrintHelpAndExit 2		;;
	esac
done

#---------- main --------------------------------------

setxkbmap -model $XKBmodel -v $VerboseLvl
