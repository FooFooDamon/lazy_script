#
# _shell_common.sh
#
#  Created on: 2018-05-28
#
#      Author: WenXiongchang (udc577@126.com)
#
# Description: Some required or frequently used tools, such as constants,
#              (environment) variables, functions and prerequisite operations.
#
#       Usage: This script should be used by inner modules only.
#

shopt -s expand_aliases

###########################################################
#####
##### Variables
#####
###########################################################

_DATE_TIME_HINT="date +%Y-%m-%d_%H:%M:%S"

SCRIPT_NAME="$(basename $0)"
SCRIPT_DIR="$(dirname $0)"

_EXIT_SIG_LIST=(INT KILL TERM QUIT)
_SIG_ITEMS=(INT KILL TERM QUIT USR1 PIPE HUP)

###########################################################
#####
##### Functions
#####
###########################################################

#
# Usage: handle_signal <signal name> [signal handler]
# Example: handle_signal INT sigint_warning
# Note: Definition(usually exits as a function) of [signal handler] has to exists prior to this function.
#
handle_signal()
{
	local _sig=$1

	echo "$($_DATE_TIME_HINT): ${SCRIPT_NAME}: SIG$_sig captured" >&2

	if [ -n "$2" ]
	then
		sig_handler=$2
		echo "$($_DATE_TIME_HINT): ${SCRIPT_NAME}: Signal handler [$sig_handler] is about to run." >&2
		$sig_handler
	fi

	if [ -n "$(echo ${_EXIT_SIG_LIST[@]} | grep $_sig)" ]
	then
		echo "$($_DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon." >&2
		exit
	fi
}

is_integer()
{
	local _value=$1
	
	[[ $_value == *[!0-9+\-]* ]] && echo 0 || echo 1
}

lzwarn()
{
	echo -e "\e[0;33m$*\e[0m" >&2
}

lzerror()
{
	echo -e "\e[0;31m$*\e[0m" >&2
}

oops_quit()
{
	[ $# -gt 0 ] && lzerror "*** Oops: $*"
	exit 1
}

quit_if_command_not_installed()
{
	[ -z "`which \"$1\"`" ] && oops_quit "Command not installed: $1\nPlease intall it first!"
}

warn_if_command_not_installed()
{
	[ -z "`which \"$1\"`" ] && lzwarn "*** Command not installed: $1\nPlease intall it first!"
}


###########################################################
#####
##### Prerequisite operations
#####
###########################################################

for i in ${_SIG_ITEMS[@]}
do
	trap "handle_signal $i handle_sig$i" $i
done

