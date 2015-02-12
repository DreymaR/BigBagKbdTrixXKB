#!/bin/bash

# ======================================================
# ===  installgtk.sh to enable cut/copy/paste keys   ===
# ===     by Øystein Bech "DreymaR" Gadmar, 2014     ===
# ======================================================

# - Thanks to Kuglee on the Colemak forum for researching these bindings!
# - With my Extend mappings for instance, you can make the keyboard send XF86 multimedia keys
# - These are called XF86### where ### is for instance Cut/Copy/Paste (on Extend X/C/V)
# - Those key events are sent to the OS but not all of them do anything useful currently
# - The below script tells GTK to map the edit keys to actions so they work (in GTK apps at least)


HeadStr="DreymaR's GTK install script (by GadOE, 2014)"
DescStr=\
"Shell script to enable cut/copy/paste XF86 keys\n"\
"    for GTK 2.0 and 3.0 config files in ~/ ."

#---------- init --------------------------------------

MyNAME=`basename $0`
#~ MyPATH=`dirname $0`

HelpStr="Usage: sh ${MyNAME} [no args]\n"\
"\n••• Please read this script's comments for more info on how it works •••\n"

gtkfile[2]='.gtkrc-2.0'
gtktext[2]='binding "gtk-xf86cut-copy-paste"
{
        bind "XF86Cut"   { "cut-clipboard" () }
        bind "XF86Copy"  { "copy-clipboard" () }
        bind "XF86Paste" { "paste-clipboard" () }
}

class "*" binding "gtk-xf86cut-copy-paste"
'

gtkfile[3]='.config/gtk-3.0/gtk.css'
gtktext[3]='@binding-set gtk-xf86cut-copy-paste
{
        bind "XF86Cut"   { "cut-clipboard" () };
        bind "XF86Copy"  { "copy-clipboard" () };
        bind "XF86Paste" { "paste-clipboard" () };
}

* {
        gtk-key-bindings: gtk-xf86cut-copy-paste
}
'

#---------- subroutines -------------------------------

MyMsg()
{
	printf "\n••• $1 •••\n\n"
}

PrintHelpAndExit()
{
	MyMsg "${HeadStr}"
	printf "${DescStr}\n"
	printf "${HelpStr}\n"
	exit $1
}

MyEcho()
{
	printf "$1\n"
	[ -z "$2" ] || printf "$1\n" >> "$2"
}

#---------- command line parser -----------------------

while getopts "h?" cmdarg; do
	case $cmdarg in
		h)		PrintHelpAndExit 0		;;
		\?)		PrintHelpAndExit 0		;;
		:)		PrintHelpAndExit 1		;;
	esac
done

#---------- main --------------------------------------

MyMsg "$HeadStr"
#~ MyEcho "• Working from `pwd`"

# If not already there, add GTK cut/copy/paste key bindings to GTK 2.0 and 3.0 config files
for i in 2 3; do
	#~ MyEcho "${i}.0: '$(grep "gtk-xf86cut-copy-paste" "$HOME/${gtkfile[$i]}")'"
	#~ MyEcho "\n${gtkfile[$i]}\n'''${gtktext[$i]}'''"; continue
	if [ "$(grep "gtk-xf86cut-copy-paste" "$HOME/${gtkfile[$i]}" 2> /dev/null)" == "" ]; then
		echo "${gtktext[$i]}" >> "$HOME/${gtkfile[$i]}"
		MyEcho "• GTK ${i}.0 Cut/Copy/Paste config generated"
	else
		MyEcho "• GTK ${i}.0 Cut/Copy/Paste config already present"
	fi
done

MyMsg "${MyNAME} finished!"; exit 0

# (Originally, I copied over files in the current dir using `cat ./"${gtkfile[$i]}"`)
#~ [ "$(grep "gtk-xf86cut-copy-paste" "$HOME/config/gtk-3.0/gtk.css")" == "" ] && \
	#~ cat ./gtk.css >> ~/.config/gtk-3.0/gtk.css || MyEcho "• GTK 3.0 config already present"
