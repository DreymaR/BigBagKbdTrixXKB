#!/bin/bash
##  ====================================================================
##  ====    SETKB command to set the XKB keyboard options           ====
##  ====    BASH script by Øystein "DreymaR" Bech-Aase, 2014-       ====
##  ====    Uses the SETXKBMAP command [NB - Not always available]  ====
##  ====================================================================

HeadStr="DreymaR's setxkbmap bash-script (by OeBeAa, 2023-06)"
DescStr=\
"\e[1mBASH script to change X.org keyboard setup\e[0m\n"\
"  using the 'setxkbmap' command.\n"\
"  To make settings logon persistent,\n"\
"  source it, e.g., in your ~/.bashrc file,\n"\
"  or use -a to write the setxkbmap command to a file.\n"
FootStr="Happy xkb-hacking! ~ Øystein 'DreymaR' Bech-Aase"

##  NOTE: It now works with local xkb(-mod) dir
##      - By default, setxkbmap checks ./rules first!
##      - Need a full xkb dir then (not just the xkb-mod files)

##  NOTE: I made a handy shorthand for activating simple Cmk[eD] model/layout combos.
##      - See the help text of this script for more info on the model-locale-symbols syntax.
##      - Example: '5aw no us' activates model pc105awide, layout no(cmk_ed_us)
##      - Models: 4n 4a(pc104angle) 4w(pc104wide) 4aw(pc104awide) 4f(pc104awing)
##                5n 5a(pc105angle) 5w(pc105wide) 5aw(pc105awide)
##          - Curl(DH) "models" add a 'c' in front, like this: 4c, 5caw etc
##          - Sym "models" add a 's' at the end, like this: 4cas, 5caws etc
##          - Thus, the allowed model short strings are (4|5)(n|a|c|ca)[(w|f)][s]
##      - XKB options are left out of this: Too complex (e.g., replace or append?)

##  ----------  init  ----------------------------------------------------------------------

MyDATE=`date +"%Y-%m-%d_%H-%M"`
MyNAME=`basename $0`
MyPATH=`dirname $0`
#~ MyPATH=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")    # Alone, dirname gives relative paths like `.`
##  @@@ The default X11 dir under Debian/Ubuntu/etc is /usr/share/X11  @@@
##  @@@ The default X11 dir under some (older) distros is /usr/lib/X11 @@@
X11DIR='/usr/share/X11'; [ -d "${X11DIR}" ] || X11DIR='/usr/lib/X11'
XKBDIR="${X11DIR}/xkb"  					# The default X11 xkb dir
XKBLOC='./xkb-data_xmod/xkb'    			# The default local xkb dir in this repo

#~ XKBmodel=pc104awide  					# ANSI-104 keyboard w/ Angle(Z)Wide(Quote) mod
XKBmodel=pc105awide 						# ISO-105 keyboard w/ CurlAngleWide(Slash) mod
#~ XKBlayout='us(cmk_ed_us),gr(colemak),ru(colemak)'	# Multiple layouts
XKBlayout='us(cmk_ed_us)'   				# US English Colemak[eD]'Universal Symbols' layout
XKBoption='misc:extend,lv5:caps_switch_lock,grp:shifts_toggle,compose:menu'
Verbosity=9 								# (-v) How much info should setxkbmap print out?
KeepXKM='no'    							# (-k) Retain old /var/lib/xkb/server-*.xkm files?
XRunDir=${XKBDIR}   						# (-d) The xkb-type dir to run setxkbmap from
AddCmdYN='no'   							# (-a) Add setxkbmap cmd to file?
AddToDef=${MyPATH}/"add-to-rc-file" 		# "${HOME}/.bashrc" before; there are many options though
AddCmdTo=${AddToDef}    					# (-f) File (such as '~/.bashrc') to add setxkbmap cmd to
PrntCmd='no'    							# (-p) Print the setxkbmap command instead of running it?
ArgStr='' #'5caws us us'    				# (--) Shortcut string for setkb (model locale eD-variant)
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
"[-a] Add cmd line to file?     - '${AddCmdYN}' [toggle]\n"\
"[-f]   <file> to add cmd to    - '${AddCmdTo}'\n"\
"[-p] Print cmd; don't run it   - '${PrntCmd}' [toggle]\n"\
"[--] <ShortStr>                - '${ArgStr}'\n"\
"\nSpecify '-d-' to run from the local repo directory w/o installing.\n"\
"\n\e[1mShortStr syntax, defining eD model+layout as a short split string:\e[0m\n"\
"==================================================================\n"\
"  <kbd> 4/5   - ANSI-104/ISO-105 keyboard model, then...\n"\
"        n/a/c - Normal/Angle/Curl-DH, and optionally...\n"\
"        w/f   - Wide/A-Wing (a.k.a. 'A-Frame'), and...\n"\
"        s     - Sym\n"\
"  <loc> Two-letter locale layout code like 'us' for USA, 'gb' for UK etc\n"\
"  <sym> 'us'/'ks' for 'Universal' or 'Keep Locale' symbol variants\n\n"\
"  Examples: '5a    se us': Angle-ISO, Swedish Cmk[eD] 'UnifiedSym'\n"\
"            '4ca   gb ks': Curl(DH)Angle-ANSI, Eng.(UK) Cmk[eD] 'KeepSym'\n"\
"            '5caws': Curl(DH)AngleWideSym-ISO, keep current layout/variant\n"
#~ "     (See the script's comments for more info.)"


##  ----------  functions and line parser  -------------------------------------------------

MyMsg()     								# Formatted output: last arg is printf 'style[;fgcolor[;bgcolor]]'
{
	##  Style: 0-Off, 1-Bold, 4-Underscore, 5-Blink, 7-Reverse, 8-Concealed
	##  Color: (3#/4# FG/BG): 0-Black, 1-Red, 2-Green, 3-Yellow, 4-Blue, 5-Magenta, 6-Cyan, 7-White
	printf "\n\e[${3:-1;32;40}m@@@ $1 @@@\e[0m\n$2"	# default: Bold green on black
}

MyEcho()    								# What it says...
{
	printf "$1\n"
	[ -z "$2" ] || printf "$1\n" >> "$2"
}

MyPoint()   								# Bulleted output
{
	MyEcho "\e[1;32m¤ \e[0m$@"  										# Bold green
}

MyWarning() 								# Blue reverse text
{
	MyMsg "WARNING: ${@:-'Beware of nargles!'}" "\n" '1;36;44'      	# Bold cyan on blue
#~	exit 1
}

MyError()   								# Red reverse text; crash out
{
	MyMsg "$MyNAME - ERROR: ${@:-'Undefined error'}" "\n" '1;37;41' 	# Bold white on red
	exit 1
}

MyCD()      								# Change dir, keeping track
{
	OldDir=`pwd`
	NewDir=${1:-`pwd`}
	cd ${NewDir} \
		&& MyPoint "Changing dir to '${NewDir}'" || MyError "Change to '${NewDir}' failed"
}

PrintHelpAndExit()  						# Invoked with `-h`
{
	MyMsg "${HeadStr}" "\n"
	printf "${DescStr}\n"
	printf "${HelpStr}"
	MyMsg "${FootStr}" "\n"
	exit $1
}

ModLayVar()         						# WIP: A fn to sort out model/layout/variant
{
	[[ ${Set} == 'y' ]] && A='' || A="'"
	[ -n "$1" ] && StrXKB="-model ${A}${1}${A}" || MyError "ShortStr model not found"
	[ -n "$2" ] && StrXKB="${StrXKB} -layout ${A}${2}${A}"
	[ -n "$3" ] && StrXKB="${StrXKB} -variant ${A}${3}${A}"
}

#~ if [ "$#" == 0 ]; then PrintHelpAndExit 2; fi 				# No args
while getopts "m:l:o:v:d:f:pakh?" cmdarg; do
	case $cmdarg in
		m)  	XKBmodel="$OPTARG"  	;;
		l)  	XKBlayout="$OPTARG" 	;;
		o)  	XKBoption="$OPTARG" 	;;
		v)  	Verbosity="$OPTARG" 	;;
		d)  	XRunDir="$OPTARG"   	;;
		f)  	AddCmdTo="$OPTARG"  	;;
		p)  	PrntCmd='yes'   		;;
		a)  	AddCmdYN='yes'  		;;
		k)  	KeepXKM='yes'   		;;
		h)  	PrintHelpAndExit 0  	;;
		\?) 	PrintHelpAndExit 0  	;;
		:)  	PrintHelpAndExit 1  	;;
#		s)  	ArgStr=($OPTARG)    	;;  					# Split the string
	esac
done
shift $(( $OPTIND - 1 ))										# Remove already processed args
[[ "${XRunDir}" == '-' ]] && XRunDir="${XKBLOC}"    			# Use the default local dir

[[ "$@" == "" ]] || ArgStr=($@) 								# Split the ShortString, if present
if [ -n "${ArgStr}" ]; then 									# Use ShortString notation
	ModStr="${ArgStr[0]}"
	KbdStr="${ModStr:0:1}"     ; ModStr="${ModStr:1}"   		# 1st chr = Kbd type: 4/5 for ANSI/ISO
	[[ "${KbdStr}" =~ [45] ]] || MyError "Kbd model 'pc10${KbdStr}' unknown!"
	[[ "${ModStr:0:1}" == 'c' ]] && DH_Mod='y' || DH_Mod='n' 	# 2nd chr may be 'c' for the Curl mod
	[[ ${DH_Mod}    == 'y' ]] && ModStr="${ModStr:1}"   		#   (remove the found character)
	[[ "${ModStr: -1}" == 's' ]] && SymMod='y' || SymMod='n' 	# Last chr may be 's' for the Sym mod
	if [[ ${SymMod} == 'y' ]]; then
		ModStr="${ModStr:: -1}"
		if [[ "${ModStr}" =~ [w] ]]; then   					# Sort out Sym variants
			case "${KbdStr}" in
				  4)    SymStr='wide-104'   	;;  			# symkeys(sym_w-104)
				  5)    SymStr='wide-105'   	;;  			# symkeys(sym_w-105)
			esac
		else
				        SymStr='non-wide'   					# symkeys(sym_non-w)
		fi
		SymStr="sym_${SymStr}"
	fi
	case "${ModStr}" in
		  n|'') ModStr=''       	;;  						# Generic pc104(ANSI)/pc105(ISO) kbd
		  a)    ModStr='angle'  	;;  						# w/ Angle     ergo mod
		  w)    ModStr='-wide'  	;;  						# w/      Wide ergo mod
		  aw)   ModStr='awide'  	;;  						# w/ AngleWide ergo mod
		  f|af) ModStr='awing'  	;;  						# w/ AngleWing ergo mod
		  *)    MyError "ShortStr model '${ArgStr[0]}' unknown!" ;;
	esac
	XKBmodel="pc10${KbdStr}${ModStr}"   						# Kbd type and Angle/Wide define xkb model
	[[ ${DH_Mod} == 'y' ]] && XKBoption+=',misc:cmk_curl_dh' 	# Curl-DH is an XKB option
	[[ ${SymMod} == 'y' ]] && XKBoption+=",misc:${SymStr}"  	# Sym mod is an XKB option

	if [ -n "${ArgStr[2]}" ]; then  							# If there are three parts, ...
		case "${ArgStr[2]}" in  								# ...determine the layout variant.
			  us)   XKBvar='cmk_ed_us'  	;;  				# Cmk-eD Unified Symbols variant
			  ks)   XKBvar='cmk_ed_ks'  	;;  				# Cmk-eD Keep Locale Symbols variant
			   *)   XKBvar="${ArgStr[2]}" 	;;  				# Use specified variant
		esac
	else
		            XKBvar='basic'  							# Use the default variant for this locale
	fi
	if [ -n "${ArgStr[1]}" ]; then  							# If there are two or more parts, ...
		XKBlayout="${ArgStr[1]}($XKBvar)"   					# ...use the lay(var) string. 
	else 														# Otherwise, use existing layout.
		[[ XKBlayout=`setxkbmap -query | grep layout | awk '{print $2}'` ]] \
		|| XKBlayout='us'   									# If not found, default to the US locale
	fi
fi
##  TODO: Also set the right Extend variant option for Curl, when it gets implemented.

##  ----------  main  ----------------------------------------------------------------------

MyMsg "$HeadStr"
#~ MyCD "${XKBpath%/}/${XRunDir%/}"
if [ -n "${ArgStr}" ]; then
	MyPoint "ShortStr model/layout: ${XKBmodel} / ${XKBlayout}"
	MyPoint "ShortStr lay. options: Curl(DH) - '${DH_Mod}'; Sym - '${SymMod}'."
else
	MyPoint "No ShortStr; using model/layout: ${XKBmodel} / ${XKBlayout}"
fi
MyEcho

MyCD "${XRunDir%/}"  											# Change to the xkb dir first

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

##  Run and/or print out the actual setxkbmap command
[[ ${PrntCmd} == 'yes' ]] && RunPrt='Printing' || RunPrt='Running'
# Set='y'
SetXKB="-model ${XKBmodel} -layout ${XKBlayout} -option ${XKBoption}"
if [ ${XRunDir} == ${XKBDIR} ]; then
	MyPoint "${RunPrt} setxkbmap command using the system XKB dir:\n"
	OptXKB="-v ${Verbosity}"  	# Note: Verbosity doesn't work well with -print
else
	MyPoint "${RunPrt} setxkbmap command with a local XKB dir:\n"   	# . is the local dir
	OptXKB="-print | xkbcomp -I -I. -I${XKBDIR} $DISPLAY 2>/dev/null"   # Wasn't there a hyphen before $DISPLAY?
fi
MyEcho "> setxkbmap ${SetXKB} ${OptXKB}"    					# 
MyEcho ""
if [ ${PrntCmd} != 'yes' ]; then
	setxkbmap ${SetXKB} ${OptXKB}
	MyEcho ""
fi

MyCD "${OldDir}"

##  Add the setxkbmap command to a file, if specified. Note the quotes necessary for FileXKB.
if [ ${AddCmdYN} == 'yes' ] || [ ${AddCmdTo} != ${AddToDef} ]; then 	# Changing file name alone works
	rcFi=${AddCmdTo}
#	Set='n'
	FileXKB="-model '${XKBmodel}' -layout '${XKBlayout}' -option '${XKBoption}'"
	MyPoint "Adding setxkbmap cmd to ${rcFi}\n"
#	exec 66> ${rcFi} 	#>&1 	#/dev/null  				# New file descriptor (`ls -l /proc/$$/fd` to list fds) 	# NOTE: This _will_ create a file, but always empty!!!
#	MyEcho "Listing file descriptors:\n `ls -l /proc/$$/fd`" 	# eD DEBUG
	[ cat >> ${rcFi} ] && [ -w ${rcFi} ] || MyError "Writing to '${rcFi}' failed" 	# `touch` didn't create a file?
	printf "\n%s\n%s\n%s\n" \
		"## --> DreymaR's setkb, ${MyDATE}: Source this command to activate your layout." \
		"setxkbmap ${FileXKB} ${OptXKB}" \
		"## <-- DreymaR's setkb" >> ${rcFi}
#		>>&66 	# Redirect to a file descriptor? But we're getting a "#: Bad file descriptor" error.
	exec 66>&-   												# Now close the file descriptor (not really necessary?)
	MyEcho ""
fi

##  When run in a terminal window, wait for a key press
##  so you can see the results before the window closes
#~ MyMsg "Press any key to proceed:"
#~ read -n 1

##  A silly trick to not print the last Enter if called from the install script :-)
extraEnter='';[[ `ps --no-headers -o comm= $PPID` == 'install-dreymar' ]] || extraEnter='\n'
MyMsg "${MyNAME} finished!" ${extraEnter}
exit 0

##  ----------  misc  ----------------------------------------------------------------------

#~ MyWarning "'${MyNAME}' debug - exiting!"; exit 0
#~ echo "'$XKBmodel' '$XKBlayout'"; for i in 0 1 2; do echo "'${ArgStr[i]}'"; done; exit 0

##  US/ANSI Wide ergo mod,
##  Colemak[eD] US layout,
##  Extend mappings w/ Caps switch:
#~ setxkbmap \
#~ -model pc104wide, \
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
