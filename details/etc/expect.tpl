#!/usr/bin/env expect

###############################################
###
### Contents generated from
### $LAZY_SCRIPT_HOME/details/etc/expect.tpl.
###
### Edit these contents before they can be used.
###
###############################################

proc usage {} {
	global argv0
	set this_script_name [ file tail "$argv0" ]

	puts stderr "$this_script_name - <Simple descriptions about this script>"
	puts stderr "Usage: $this_script_name <Usage format of this script>"
	puts stderr "Example: $this_script_name <Usage examples of this script>"
}

proc version {} {
	global argv0
	set this_script_name [ file tail "$argv0" ]

	puts stdout "${this_script_name}: V1.00.00 2018/06/08"
}

set timeout -1

foreach i $argv {
	if { "$i" == "-h" } {
		usage
		exit 0
	}
	
	if { "$i" == "-v" } {
		version
		exit 0
	}
}

###############################################
###
### Put your contents below this comment block.
###
###############################################

