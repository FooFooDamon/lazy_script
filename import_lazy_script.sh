#!/bin/bash

usage()
{
	echo "Usage: export __LAZY_SCRIPT_HOME__=<Path to Lazy-script root directory>; . \$__LAZY_SCRIPT_HOME__/import_lazy_script.sh [-a]" >&2
	echo "    -a: import all bash setting scripts if specified, or import the core ones otherwise." >&2
	echo "Example: export __LAZY_SCRIPT_HOME__=/home/foo/lazy_script; . \$__LAZY_SCRIPT_HOME__/import_lazy_script.sh" >&2
}

if [ -z "$__LAZY_SCRIPT_HOME__" ] || [ ! -d "$__LAZY_SCRIPT_HOME__" ]
then
	usage
	echo "*** Current __LAZY_SCRIPT_HOME__ value: $__LAZY_SCRIPT_HOME__" >&2
	printf "*** Exit count-down:" >&2
	for i in `seq 1 10 | awk '{ printf("%02d\n", $1) }' | sort -r`
	do
		printf " $i" >&2
		sleep 1
	done
	exit 1
fi

. $__LAZY_SCRIPT_HOME__/details/inner/_shell_common.sh

quit_if_not_installed bash

. $__LAZY_SCRIPT_HOME__/details/inner/_bash_identity
. $__LAZY_SCRIPT_HOME__/details/inner/_bash_settings
. $__LAZY_SCRIPT_HOME__/details/inner/_bash_startup_check
[ -f $__LAZY_SCRIPT_HOME__/details/private/_bash_private ] && . $__LAZY_SCRIPT_HOME__/details/private/_bash_private
if [ "$1" == "-a" ]
then
	. $__LAZY_SCRIPT_HOME__/details/inner/_bash_welcome
fi

