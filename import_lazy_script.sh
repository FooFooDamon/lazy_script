#!/bin/bash

usage_of_import_script()
{
	echo "Usage: export __LAZY_SCRIPT_HOME__=<Path to Lazy-script root directory>; . \$__LAZY_SCRIPT_HOME__/import_lazy_script.sh [-a]" >&2
	echo "+++ -a: import all bash setting scripts if specified, or import the core ones otherwise." >&2
	echo "Example: export __LAZY_SCRIPT_HOME__=/home/foo/lazy_script; . \$__LAZY_SCRIPT_HOME__/import_lazy_script.sh" >&2
}

#
# No need to get value of __LAZY_SCRIPT_HOME__ from outside.
# Use $BASH_SOURCE instead to determine it automatically.
#
#if [ -z "$__LAZY_SCRIPT_HOME__" ] || [ ! -d "$__LAZY_SCRIPT_HOME__" ]
#then
#	usage_of_import_script
#	echo "*** Current __LAZY_SCRIPT_HOME__ value: $__LAZY_SCRIPT_HOME__" >&2
#	printf "*** Exit count-down:" >&2
#	for i in `seq 1 10 | awk '{ printf("%02d\n", $1) }' | sort -r`
#	do
#		printf " $i" >&2
#		sleep 1
#	done
#	exit 1
#fi
__LAZY_SCRIPT_HOME__=$(dirname "$BASH_SOURCE")

if [ "$BASH_SOURCE" = "$0" ]
then
	echo -e "\e[0;33m*** $(basename $0) can not be executed directly! Use it as below:\e[0m" >&2
	usage_of_import_script
	exit 1
fi

. "$__LAZY_SCRIPT_HOME__"/details/inner/_shell_common.sh

quit_if_not_installed bash

. "$__LAZY_SCRIPT_HOME__"/details/inner/_bash_identity
. "$__LAZY_SCRIPT_HOME__"/details/inner/_bash_settings
if [ "$1" == "-a" ]
then
	. "$__LAZY_SCRIPT_HOME__"/details/inner/_bash_startup_check
	. "$__LAZY_SCRIPT_HOME__"/details/inner/_bash_completion
	[ -f "$__LAZY_SCRIPT_HOME__"/details/private/_bash_private ] && . "$__LAZY_SCRIPT_HOME__"/details/private/_bash_private -a
	. "$__LAZY_SCRIPT_HOME__"/details/inner/_bash_welcome
else
	[ -f "$__LAZY_SCRIPT_HOME__"/details/private/_bash_private ] && . "$__LAZY_SCRIPT_HOME__"/details/private/_bash_private
fi

