#!/bin/bash

## =================================================================
## ===  INSTALL-DREYMAR-XMOD.sh for DreymaR's XKB modifications  ===
## ===         by Øystein Bech "DreymaR" Gadmar, -2016           ===
## =================================================================
# 
HeadStr="DreymaR's Big Bag Of Tricks install script (by GadOE, 2016-06)"
DescStr=\
"\e[1mShell script to apply DreymaR's changes to the X keyboard files:\e[0m\n"\
"  - The Colemak [edition DreymaR] layout, using my own lv3-4 mappings,\n"\
"  - Curl/Angle/Wide Ergonomic keyboard models for pc104/pc105 keyboards,\n"\
"  - Extend mappings as a Misc option and CapsLock as a chooser (using lv5-8),\n"\
"  - locale variants of Colemak[eD] with 'keep local' or 'unified' symbol keys,\n"\
"  - phonetic variants of Colemak for other scripts such as Greek,\n"\
"  - mirrored Colemak[eD] for one-handed typing (if I ever break an arm...),\n"\
"  - and the Tarmak(1-4) transitional step-by-step Colemak learning layouts.\n"\
"\n"\
"- By default, this script creates a backup of the X11 files if none exist.\n"\
"- With '-o', overwrite the system X11 files (makes the mod GUI accessible).\n"\
"- With a ShortStr at the end, specify a model/layout to activate immediately.\n"\
"  - ShortStr format: '[4|5][n|a|c][w|f] loc [ks|us]'; 'loc'(ale) is 2-letter.\n"\
"  - E.g., '5n fr us' is normal pc105 model, French Cmk[eD]-'UniSym'.\n"\
"  - See setxkb.sh help for more info on ShortStr syntax.\n"\
"- With '-?', list further instructions and default values.\n"\
"- See http://forum.colemak.com/viewtopic.php?id=1438 for more info\n"
# 
FootStr="Happy xkb-hacking! ~ Øystein Bech 'DreymaR' Gadmar"
#"- With '-i <dir>', specify a directory path/name to install in.\n"\
#"- With '-g', also install GTK 2.0/3.0 config for XF86 Cut/Copy/Paste.\n"\

## NOTE: The mod directory has the form $DModTag="x-mod_v<VER>[_<DATE>]"
##		- Unless you change this tag, it should be in the same dir as this script
##		- It has subdirectories like 'xkb' that are to be installed (one, some or all)
## NOTE: This is now the preferred way instead of patching the system files:
##		- Backup system xkb to dbak-xkb_<DATE> (and the same for any other subdirs)
##		- Copy X11/xkb to ${InstDir}/dxkb, then modify files in dxkb
##		- Set up setxkb.sh to run from the modified dxkb [WARNING: This may not work now!]
##      - Or, (-o) overwrite the system files instead
## NOTE: The x-mod dir now holds x-mod*/xkb; eventually there may be a locale dir too.


##-------------- init ------------------------------------------

MyDATE=`date +"%Y-%m-%d_%H-%M"`
MyNAME=`basename $0`
MyPATH=`dirname $0`
## @@@ The default X11 dir under Debian/Ubuntu/etc is /usr/share/X11  @@@
## @@@ The default X11 dir under some (older) distros is /usr/lib/X11 @@@
X11DIR='/usr/share/X11'; [ -d "${X11DIR}" ] || X11DIR='/usr/lib/X11'
#~ XVERSION='2-17-1ub1'
XVERSION=''
ModDATE=''

DModDir=`dirname $0` 	# (-d) Path to the script (and mod?) root directory
ToolDir="${DModDir}/dreymar-xtools" 	# The loc. of tool scripts (like setxkb.sh)
DMod='xkb-data_xmod' 	# (--) The main name of the directory with modded xkb-data files
DModTag="${DMod}${XVERSION:+'_v'}${XVERSION}${ModDATE:+'_'}${ModDATE}" 	# (-t) Mod dir "prefix"
DBakFix='dbak-' 		# (--) Backup dir prefix
DModFix='d' 			# (--) Modded dir prefix
InstDir="${X11DIR}" 	# (-i) Path to install subfolder(s) in
#~ InstDir="${HOME}/drey-xmod" 	# (-i) Path to install subfolder(s) in
WriteSys='no' 			# (-o) Overwrite the original xkb dir with the modded one
Restore='0' 			# (-r) Reverse: Restore from backup # instead of installing
DoBackup='ifnone' 		# (-n/b) Default backup behavior is "if no backups are found"
SubDirs='all' 			# (-m) Directory/-ies inside X11 to modify (e.g., 'xkb locale', 'all')
InstGTK='no' 			# (-g) Whether to install the GTK 2.0/3.0 config (if not present)
NoSudo='no' 			# (-s) Do not use sudo. Helpful for local dir installation.
SetXMap='no' 			# (-x) Whether to run the setxkb script after installing
SetXStr='5caw us us' 	# (--) Shortcut string for setxkb - 'kbd loc sym' (model layout eD-variant)
## NOTE: '# (-a)' means that the value can be set by option argument '-a <value>'

HelpStr="\e[1mUsage: bash ${MyNAME} [optional args] [<kbd> [<loc> <sym>]]\e[0m\n"\
"       Run this from the directory containing the x-mod dir\n"\
"===========================================================\n"\
"[-#] Functionality                     - 'default'  \n"\
"===========================================================\n"\
"[-i] <Install path>                    - ${InstDir}\n"\
"[-c] Change path to X11                - ${X11DIR}\n"\
"[-o] Override install path w/ X11      - ${WriteSys}\n"\
"[-b] Force backup       |     location - ${X11DIR}\n"\
"[-n] Force no backup    |      default - ${DoBackup}\n"\
"[-r] <#> Restore backup |  1 is oldest - ${Restore}\n"\
"[-d] <mod dir path>                    - ${DModDir}\n"\
"[-m] <X11 subdir(s) to mod>            - ${SubDirs}\n"\
"[-t] <mod dir prefix tag>              - ${DModTag}\n"\
"[-g] Install GTK 2.0/3.0 edit config?  - ${InstGTK}\n"\
"[-x] Run the setxkbmap script?         - ${SetXMap}\n"\
"[-s] Install without using sudo?       - ${NoSudo}\n"\
"[--] [Setxkb ShortStr <kbd loc sym>]   - ${SetXStr}\n"
#~ "( - <val> : Default settings)\n"

##-------------- functions and line parser ---------------------

MyMsg()	# Formatted output: last arg is printf 'style[;fgcolor[;bgcolor]]'
{
	# Style: 0-Off, 1-Bold, 4-Underscore, 5-Blink, 7-Reverse, 8-Concealed
	# Color: (3#/4# FG/BG): 0-Black, 1-Red, 2-Green, 3-Yellow, 4-Blue, 5-Magenta, 6-Cyan, 7-White
	printf "\n\e[${3:-1;32;40}m@@@ $1 @@@\e[0m\n$2"	# default: Bold green on black
}

PrintHelpAndExit()
{
	MyMsg "${HeadStr}" "\n"
	printf "${DescStr}\n"
	printf "${HelpStr}"
	MyMsg "${FootStr}" "\n"
	exit $1
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

#~ MyCD()
#~ {
	#~ OldDir=`pwd`
	#~ NewDir=${1:-`pwd`}
	#~ cd ${NewDir} || MyError "Change to '${NewDir}' failed"
	#~ MyPoint "Changed dir to '${NewDir}'"
#~ }

#~ if [ "$#" == 0 ]; then PrintHelpAndExit 2; fi # No args
while getopts "obngxsm:i:c:d:t:r:h?" cmdarg; do
	case $cmdarg in
		o)	WriteSys='yes'			;;
		b)	DoBackup='yes'			;;
		n)	DoBackup='no'			;;
		g)	InstGTK='yes'			;;
		x)	SetXMap='yes'			;;
		s)	NoSudo='yes'			;;
		m)	SubDirs="$OPTARG"		;;
		i)	InstDir="$OPTARG"		;;
		c)	X11DIR="$OPTARG"		;;
		d)	DModDir="$OPTARG"		;;
		t)	DModTag="$OPTARG"		;;
		r)	Restore="$OPTARG"		;;
		h)		PrintHelpAndExit 0	;;
		\?)		PrintHelpAndExit 0	;;
		:)		PrintHelpAndExit 1	;;
#		s)	SetXStr="$OPTARG"		
#			SetXMap='yes'			;;
	esac
done
#~ pos_arg=${@:$OPTIND:1}	# Get the remaining positional arg (old way)
shift $(( $OPTIND - 1 ))		# Remove already processed args
[[ "$@" == "" ]] || SetXStr=$@	# Don't split the ShortString here!

##-------------- main ------------------------------------------

MyMsg "$HeadStr"
#~ MyPoint "Working from '`pwd`'"

##	Check for a mod dir (the latest found) and if found, get its full name
DModDir=`find "${DModDir%/}/${DModTag}"* -maxdepth 0 -type d 2>/dev/null | tail -n 1`
[ -n "${DModDir}" ] || MyError "Mod root dir not found!"
MyPoint "Found mod root dir '${DModDir}'"

##	Read the mod subdirs
if [ "${SubDirs}" == "all" ]; then
	SubDirs=`find "${DModDir}/"* -maxdepth 0 -type d -exec basename '{}' \; 2>/dev/null`
	SubDirs=`echo ${SubDirs}` # A trick to make a var space separated for the following echo cmd
	[ -n "${SubDirs}" ] || MyError "No mod subdirs found!"
fi
MyPoint "Subdirectories to mod: '${SubDirs}'"

##	For each subdir, backup if either DoBackup = 'yes' or DoBackup = 'ifnone' and no backup exists
BackIt=''
if [ ${DoBackup} == 'yes' ]; then
	BackIt="${SubDirs}"
elif [ ${DoBackup} == 'ifnone' ] && [ ${Restore} == '0' ]; then
	for That in ${SubDirs}; do
		MyPoint "Looking for '${That}' backup in '${X11DIR}'..."
		# Test for (at least one) backup dir; if none found then proceed without errors
#		if [ -z `find "${X11DIR}/${DBakFix}${That}"* -maxdepth 0 -type d 2>/dev/null | head -n 1` ]; then
		if [ -z `find "${X11DIR}/${DBakFix}${That}"* -maxdepth 0 -type d -print -quit 2>/dev/null` ]; then
			[ -n "${BackIt}" ] && BackIt+=' '	# join with ' '; note that += is a bashism
			BackIt+="${That}"
		fi
	done
fi
[ -z "${BackIt}" ] && MyPoint "Backing up: None" || MyPoint "Backing up: '${BackIt}'"

## Check for root privileges (if not root, sudo command); note that root is only needed in some cases!
DoSudo=''
if [ ${NoSudo} = 'yes' ]; then
	MyPoint "Not using sudo."
else
	if [ "$EUID" -ne 0 ]; then # not root, so test for and use sudo instead (but some distros don't have it!)
		#[ command -v sudo >/dev/null 2>&1 ] || MyError "Root access needed - sudo won't run!"
		( command -v sudo >/dev/null 2>&1 ) || MyWarning "Root/superuser access may be needed!"
		DoSudo='sudo'
	fi
fi

## Perform the actual backup(s)
## NOTE: cp -a makes an "archive" copy, preserving all attributes and links
for That in ${BackIt}; do
	[ -d "${X11DIR}/${That}" ] || MyError "Unable to backup '${That}': Directory not found!"
	${DoSudo} cp -a "${X11DIR}/${That}" "${X11DIR}/${DBakFix}${That}_${MyDATE}" || MyError "Copy error!"
done

##	For each subfolder: Restore from backup #, overwrite X11 files or make new mod folder
for That in ${SubDirs}; do
	if [ ${Restore} != '0' ]; then	# Restore from specified backup
		## Restore from backup. Pick a backup # by parameter, 1 being oldest; use 999 or such for the last one
		BackIt=`find "${X11DIR}/${DBakFix}${That}"* -maxdepth 0 -type d 2>/dev/null | head -n ${Restore} | tail -n 1`
		[ -d "${BackIt}" ] || MyError "Unable to locate restore dir '$(basename "${BackIt}")'"
		MyPoint "Restoring from backup '$(basename "${BackIt}")'"
		${DoSudo} cp -a "${BackIt}/"* "${X11DIR}/${That}" 2>/dev/null \
			&& MyPoint "Restore done" || MyError "Restore copy error!"
		XKBDir="${X11DIR}/xkb"	# Setxkbmap will default to the X11 dir, but this makes it unambigous
	elif [ ${WriteSys} == 'yes' ] || [ ${InstDir} == ${X11DIR} ] && [ -d "${DModDir}/${That}" ]; then	# Overwrite OS files
		MyPoint "Replacing files in '${X11DIR}/${That}' with mod"
		${DoSudo} cp -a "${DModDir}/${That}/"* "${X11DIR}/${That}" 2>/dev/null \
			&& MyPoint "System install done" || MyError "System files copy error!"
		XKBDir="${X11DIR}/xkb"
	else	## Make new mod folder (will not show up in keyboard settings GUI; use setxkbmap instead)
		DoSudo=''
		mkdir -p "${InstDir}" 2>/dev/null && [ -w "${InstDir}" ] || DoSudo='sudo'	# check whether sudo is needed
		MyDir="${InstDir%/}/${DModFix}${That}"
		#~ MyDir="$(dirname "${MyDir}")/${DModFix}$(basename "${MyDir}")"	# Insert prefix in path/name
		MyPoint "Installing mod files in '${MyDir}'"
		MyWarning "It seems that setxkbmap w/ local dir isn't working now?!"
		${DoSudo} mkdir -p "${MyDir}" || MyError "Can't make '${MyDir}'!"
		${DoSudo} cp -a "${X11DIR}/${That}/"* "${MyDir}" 2>/dev/null || MyError "Local files copy error!"
		${DoSudo} cp -a "${DModDir}/${That}/"* "${MyDir}" 2>/dev/null \
			&& MyPoint "Local install done" || MyError "Local files copy error!"
		XKBDir="${InstDir%/}/${DModFix}xkb"	# Prepare for setxkbmap
		cp -a setxkb.sh ${InstDir}	# Copy over the setxkb.sh script to the new dir
	fi
done

##	If selected, call the DreymaR GTK bindings install script
## The DreymaR gtk edit install script sets GTK Cut/Copy/Paste key config (if not already present)
if [ ${InstGTK} == 'yes' ]; then
	"${ToolDir}/gtk_edit_install.sh" || MyError "gtk_edit_install.sh failed!"
fi

#~ ##	Call the DreymaR setxkbmap script unless 'q' is pressed, to activate the new (default) layout
#~ That=''	#; [ ${InstGTK} == 'yes' ] && That=" and GTK edit config"
#~ MyMsg "Press any key to set the new xkb map${That}, or 'q' to quit"
#~ read -p '$>' -n 1 keypress
#~ if [ "${keypress}" == 'q' ]; then

##	If selected, call the DreymaR setxkbmap script to activate the new (default) layout
if [ "${SetXMap}" != 'yes' ]; then
	MyMsg "XKBmap activation skipped" "" '1;33;40'
else
	bash ./setxkb.sh -d "${XKBDir}" ${SetXStr} || MyError "setxkb.sh failed!"
fi

MyMsg "${MyNAME} finished!" "\n"
exit 0

##-------------- misc ------------------------------------------

#~ MyWarning "'${MyNAME}' debug - exiting!"; exit 0
#~ echo "$1 $2 $3 $4 $5"; exit 0	# debug
