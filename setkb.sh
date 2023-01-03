#!/bin/bash

##  =================================================================
##  ===         SETKB.sh to set the XKB keyboard options          ===
##  ===          by Øystein "DreymaR" Bech-Aase, 2014-            ===
##  =================================================================

HeadStr="DreymaR's setxkbmap script (by OeBeAa, 2022-10)"
DescStr=\
"\e[1mShell script to change X.org keyboard setup\e[0m\n"\
"  using the 'setxkbmap' command.\n"\
"  To make settings logon persistent,\n"\
"  source it, e.g., in your ~/.bashrc file,\n"\
"  or use -a to write the setxkbmap command to a file.\n"
FootStr="Happy xkb-hacking! ~ Øystein 'DreymaR' Bech-Aase"

##  NOTE: It now works with local xkb(-mod) dir
##  	 By default, setxkbmap checks ./rules first!
##  	 Need a full xkb dir then (not just the xkb-mod files)

##  NOTE: I made a handy shorthand for activating simple Cmk[eD] model/layout combos.
##  	 See the help text of this script for more info on the model-locale-symbols syntax.
##  	 Example: '5w no us' activates model pc105aw-sl, layout no(cmk_ed_us)
##  	 Models: 4n 4a(pc104angle-z) 4w(pc104wide-qu) 4aw(pc104aw-zqu) 4f(pc104awing)
##  	         5n 5a(pc105angle) 5w/5aw(pc105aw-sl)
##  	     - Curl(DH) "models" add a 'c', like this: 4c, 5caw etc
##  	     - Thus, the allowed model short strings are (4|5)(n|a|c|ca)[(w|f)]
##  	 XKB options are left out of this: Too complex (e.g., replace or append?)

##-------------- init ------------------------------------------

#~ MyDATE=`date +"%Y-%m-%d_%H-%M"`
MyNAME=`basename $0`
#~ MyPATH=`dirname $0`
##  @@@ The default X11 dir under Debian/Ubuntu/etc is /usr/share/X11  @@@
##  @@@ The default X11 dir under some (older) distros is /usr/lib/X11 @@@
X11DIR='/usr/share/X11'; [ -d "${X11DIR}" ] || X11DIR='/usr/lib/X11'
XKBDIR="${X11DIR}/xkb"  		# The default X11 xkb dir
XKBLOC="./xkb-data_xmod/xkb"  	# The default local xkb dir in this repo

#~ XKBmodel=pc104aw-zqu  		# ANSI-104 keyboard w/ Angle(Z)Wide(Quote) mod
XKBmodel=pc105aw-sl 			# ISO-105 keyboard w/ CurlAngleWide(Slash) mod
#~ XKBlayout='us(cmk_ed_us),gr(colemak),ru(colemak)'	# Multiple layouts
XKBlayout='us(cmk_ed_us)' 		# US English Colemak[eD]'Universal Symbols' layout
XKBoption='misc:extend,lv5:caps_switch_lock,grp:shifts_toggle,compose:menu'
Verbosity=9 					# (-v) How much info should setxkbmap print out?
KeepXKM='no' 					# (-k) Retain old /var/lib/xkb/server-*.xkm files?
XRunDir=${XKBDIR}   			# (-d) The xkb-type dir to run setxkbmap from
AddCmdYN='no'   				# (-a) Add setxkbmap cmd to file?
AddDefault="${HOME}/.bashrc"
AddCmdTo=${AddDefault}  		# (-f) File (such as '~/.bashrc') to add setxkbmap cmd to
SetXStr='' #'5caw us us' 		# (--) Shortcut string for setkb (model locale eD-variant)
##  NOTE: '# (-a)' means that the value can be set by option argument '-a <value>'

HelpStr="\e[1mUsage: bash ${MyNAME} [optional args] [<kbd> [<loc> <sym>]]\e[0m\n"\
"===========================================================\n"\
"[-#] Functionality             - 'default'  \n"\
"===========================================================\n"\
"[-m] <model>                   - '${XKBmodel}'\n"\
"[-l] <layout(variant)>         - '${XKBlayout}'\n"\
"[-o] <options>                 - \n"\
"     '${XKBoption}'\n"\
"[-v] <verbose level>           - '${Verbosity}'\n"\
"[-d] Run from <directory>      - '${XRunDir}'\n"\
"[-k] Keep old XKB server(s)    - '${KeepXKM}' [toggle, no arg.]\n"\
"[-a] Add cmd line to file?     - '${AddCmdYN}' [toggle, no arg.]\n"\
"[-f]   <file> to add cmd to    - '${AddCmdTo}'\n"\
"[--] <ShortStr>                - '${SetXStr}'\n"\
"\nSpecify '-d-' to run from the local repo directory w/o installing.\n"\
"\n\e[1mShortStr syntax, defining eD model+layout as a short split string:\e[0m\n"\
"==================================================================\n"\
"  <kbd> 4/5   - ANSI-104/ISO-105 keyboard model, then...\n"\
"        n/a/c - Normal/Angle/Curl-DH, and optionally...\n"\
"        w/f   - Wide/A-Wing (a.k.a. 'A-Frame')\n"\
"  <loc> Two-letter locale layout code like 'us' for USA, 'gb' for UK etc\n"\
"  <sym> 'us'/'ks' for 'Universal' or 'Keep Locale' symbol variants\n\n"\
"  Examples: '5a  se us': Angle-ISO, Swedish Cmk[eD] 'UnifiedSym'\n"\
"            '4ca gb ks': Curl(DH)Angle-ANSI, Eng.(UK) Cmk[eD] 'KeepSym'\n"\
"            '5caw': Curl(DH)AngleWide-ISO, keep current layout/variant\n"
#~ "     (See the script's comments for more info.)"


##-------------- functions and line parser ---------------------

MyMsg()	# Formatted output: last arg is printf 'style[;fgcolor[;bgcolor]]'
{
	# Style: 0-Off, 1-Bold, 4-Underscore, 5-Blink, 7-Reverse, 8-Concealed
	# Color: (3#/4# FG/BG): 0-Black, 1-Red, 2-Green, 3-Yellow, 4-Blue, 5-Magenta, 6-Cyan, 7-White
	printf "\n\e[${3:-1;32;40}m@@@ $1 @@@\e[0m\n$2"	# default: Bold green on black
}

MyEcho()
{
	printf "$1\n"
	[ -z "$2" ] || printf "$1\n" >> "$2"
}

MyPoint()
{
	MyEcho "\e[1;32m¤ \e[0m$@"	# Bold green
}

MyWarning()
{
	MyMsg "WARNING: ${@:-'Beware of nargles!'}" "\n" '1;36;44'	# Bold cyan on blue
#~	exit 1
}

MyError()
{
	MyMsg "$MyNAME - ERROR: ${@:-'Undefined error'}" "\n" '1;37;41'	# Bold white on red
	exit 1
}

PrintHelpAndExit()
{
	MyMsg "${HeadStr}" "\n"
	printf "${DescStr}\n"
	printf "${HelpStr}"
	MyMsg "${FootStr}" "\n"
	exit $1
}

MyCD()
{
	OldDir=`pwd`
	NewDir=${1:-`pwd`}
	cd ${NewDir} \
		&& MyPoint "Changed dir to '${NewDir}'" || MyError "Change to '${NewDir}' failed"
}

#~ if [ "$#" == 0 ]; then PrintHelpAndExit 2; fi 	# No args
while getopts "m:l:o:v:d:f:akh?" cmdarg; do
	case $cmdarg in
		m)  	XKBmodel="$OPTARG"  	;;
		l)  	XKBlayout="$OPTARG" 	;;
		o)  	XKBoption="$OPTARG" 	;;
		v)  	Verbosity="$OPTARG" 	;;
		d)  	XRunDir="$OPTARG"   	;;
		f)  	AddCmdTo="$OPTARG"  	;;
		a)  	AddCmdYN='yes'  		;;
		k)  	KeepXKM='yes'   		;;
		h)  	PrintHelpAndExit 0  	;;
		\?) 	PrintHelpAndExit 0  	;;
		:)  	PrintHelpAndExit 1  	;;
#		s)  	SetXStr=($OPTARG)   	;;  		# Split the string
	esac
done
shift $(( $OPTIND - 1 ))							# Remove already processed args
[[ "$@" == "" ]] || SetXStr=($@)					# Split the ShortString

[[ "${XRunDir}" == '-' ]] && XRunDir="${XKBLOC}"    # Use the default local dir

if [ -n "${SetXStr}" ]; then 						# Use ShortString notation
	case ${SetXStr[0]} in
		 4n|4c)       XKBmodel='pc104'  		;;	# Generic ANSI-101/104-key
		 4a|4ca)      XKBmodel='pc104angle-z' 	;;	# w/ Angle(Z) ergo mod
		 4w|4cw)      XKBmodel='pc104wide-qu' 	;;	# w/ Wide(Quote) ergo mod
		 4aw|4caw)    XKBmodel='pc104aw-zqu' 	;;	# w/ Angle(Z)Wide(Quote) ergo mod
		 4f|4af|4cf)  XKBmodel='pc104awing' 	;;	# w/ AngleWing(Quote) ergo mod

		 5n|5c)       XKBmodel='pc105'  		;;	# Generic ISO-102/105-key
		 5a|5ca)      XKBmodel='pc105angle' 	;;	# w/ Angle(LSGT) ergo mod
		 5w|5aw|5caw) XKBmodel='pc105aw-sl' 	;;	# w/ AngleWide(Slash) ergo mod

		  *)	MyError "ShortStr model '${SetXStr[0]}' unknown!" ;;
	esac
	##case ${SetXStr[0]} in # eD WIP: Check for Sym mods, add as option. Can we do a search for s in the string?
	##  Also double the model checks above.
	##  Can we lop of 4/5 first, and make a model string 'pc10#' based on that, to simplify the above?
	##  Can we search for c and s separately in the string? The c will be first after 4/5, and s at the end.
	if [ -n "${SetXStr[2]}" ]; then 				# If there are three parts, ...
		case ${SetXStr[2]} in   					# ...determine the layout variant.
			  us)   XKBvar='cmk_ed_us'  		;;	# Cmk-eD Unified Symbols variant
			  ks)   XKBvar='cmk_ed_ks'  		;;	# Cmk-eD Keep Locale Symbols variant
			   *)   XKBvar=${SetXStr[2]} 		;;	# Use specified variant
		esac
	else
		            XKBvar='basic'  				# Default variant
	fi
	if [ -n "${SetXStr[1]}" ]; then 				# If there are two or more parts, ...
		XKBlayout="${SetXStr[1]}($XKBvar)"  		# ...use the lay(var) string. 
	else 											# Otherwise, use existing layout.
		XKBlayout=`setxkbmap -query | grep layout | awk '{print $2}'`
	fi
fi

##  NOTE: The code below post processes Curl models into model+option, as per my XKB implementation.
[[ ${SetXStr[0]} =~ "c" ]] && XKBoption+=',misc:cmk_curl_dh'
##  [[ ${SetXStr[0]} =~ "s" ]] && XKBoption+=',misc:ed_sym-w'  	# TODO: Implement Sym, for both Wide and non-Wide configs

##-------------- main ------------------------------------------

MyMsg "$HeadStr"
#~ MyCD "${XKBpath%/}/${XRunDir%/}"
if [ -n "${SetXStr}" ]; then
	MyPoint "Using model/layout '$XKBmodel'/'$XKBlayout' from ShortStr"
fi

MyCD "${XRunDir%/}"  								# Change to the xkb dir first

##  Check for root privileges (if not root, needs the sudo command)
DoSudo=''
if [ "$EUID" -ne 0 ]; then # or [ `whoami` = 'root' ]; not root, so test for sudo instead
    ( command -v sudo >/dev/null 2>&1 ) || MyError "Need root access and sudo won't run!"
    DoSudo='sudo'
fi

##  Purge the old xkb server files (usually desirable)
if [ ${KeepXKM} == 'no' ]; then
	MyPoint "Looking for and removing any old .xkm server files"
	${DoSudo} rm -f /var/lib/xkb/server-*.xkm || MyPoint "No .xkm files removed"
fi

##  Clear the xkb options (to avoid duplicates)
setxkbmap -option ''

##  Run the actual setxkbmap command
SetXKB="-model ${XKBmodel} -layout ${XKBlayout} -option ${XKBoption}"
if [ ${XRunDir} == ${XKBDIR} ]; then
	MyPoint "Running setxkbmap with the system XKB dir:\n"
	OptXKB="-v ${Verbosity}"  	# Note: Verbosity doesn't work well with -print
else
	MyPoint "Running setxkbmap with a local XKB dir:\n"  	# . is the local dir
	OptXKB="-print | xkbcomp -I -I. -I${XKBDIR} $DISPLAY 2>/dev/null"   # Wasn't there a hyphen before $DISPLAY?
fi
setxkbmap $SetXKB $OptXKB
MyEcho ""

##  Add the setxkbmap command to a file, if specified. Note the quotes necessary for FileXKB.
if [ ${AddCmdYN} == 'yes' ] || [ ${AddCmdTo} != ${AddDefault} ]; then
	FileXKB="-model '${XKBmodel}' -layout '${XKBlayout}' -option '${XKBoption}'"
	MyPoint "Adding setxkbmap cmd to ${AddCmdTo}\n"
	[ -w ${AddCmdTo} ] || MyError "Writing to '${AddCmdTo}' failed"
	printf "\n%s\n%s\n%s\n" \
		"##-> DreymaR's SetXKB.sh: Activate layout" \
		"setxkbmap ${FileXKB} ${OptXKB}" \
		"##<- DreymaR's SetXKB.sh" \
		>> ${AddCmdTo}
fi

MyCD "${OldDir}"

##  When run in a terminal window, wait for a key press
##  so you can see the results before the window closes
#~ MyMsg "Press any key to proceed:"
#~ read -n 1

##  A silly trick to not print the last Enter if called from the install script :-)
extraEnter='';[[ `ps --no-headers -o comm= $PPID` == 'install-dreymar' ]] || extraEnter='\n'
MyMsg "${MyNAME} finished!" ${extraEnter}
exit 0

##-------------- misc ------------------------------------------

#~ MyWarning "'${MyNAME}' debug - exiting!"; exit 0
#~ echo "'$XKBmodel' '$XKBlayout'"; for i in 0 1 2; do echo "'${SetXStr[i]}'"; done; exit 0

##  US/ANSI Wide ergo mod,
##  Colemak[eD] US layout,
##  Extend mappings w/ Caps switch:
#~ setxkbmap \
#~ -model pc104wide-qu, \
#~ -layout "us(cmk_ed_us)", \
#~ -option "misc:extend,lv5:caps_switch_lock"

##  Euro/ISO AngleWide ergo mod,
##  Norwegian Cmk[eD] "US" layout (grp1),
##  Greek phonetic Colemak layout (grp2),
##  Extend mappings w/ Caps switch (for both),
##  Switch grp w/ 2xCtrl; Compose on Menu key:
#~ setxkbmap \
#~ -model pc105aw-sl, \
#~ -layout "no(cmk_ed_us),gr(colemak)", \
#~ -option "misc:extend,lv5:caps_switch_lock,"\
#~         "grp:rctrl_switch_ctrls_toggle,compose:menu"
