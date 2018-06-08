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
#       Usage: This script should not be executed directly,
#              it should be imported into the target script file
#              using 'source' or '.' syntax.
#

shopt -s expand_aliases

###########################################################
#####
##### Variables
#####
###########################################################

_DATE_TIME_HINT="date +%Y-%m-%d_%H:%M:%S"

SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=`cd $(dirname "$0") && pwd`

#_EXIT_SIG_LIST=(INT KILL TERM QUIT STOP)

# TODO: Use 'kill -l' to fetch these items automatically!
_SIG_ITEMS=(HUP INT QUIT ILL \
	TRAP ABRT BUS FPE \
	KILL USR1 SEGV USR2 \
	PIPE ALRM TERM STKFLT \
	CHLD CONT STOP TSTP \
	TTIN TTOU URG XCPU \
	XFSZ VTALRM PROF WINCH \
	IO PWR SYS)

LZ_TRUE=0
LZ_FALSE=-1

###########################################################
#####
##### Functions
#####
##### NOTE: For usage of boolean functions(that is:
#####     functions returning true or false), see is_integer().
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

	if [ -n "$2" ]
	then
		sig_handler=$2
		if [ "$_sig" != "CHLD" ]
		then
			lzwarn "$($_DATE_TIME_HINT): ${SCRIPT_NAME}: SIG$_sig captured"
			lzwarn "$($_DATE_TIME_HINT): ${SCRIPT_NAME}: Signal handler [$sig_handler] is about to run."
		fi
		$sig_handler
	fi

	#
	# It's up to the user to decide whether to exit.
	#
	#if [ -n "$(echo ${_EXIT_SIG_LIST[@]} | grep $_sig)" ]
	#then
	#	lzwarn "$($_DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
	#	exit
	#fi
}

#
# Usage example:
#
# if (is_integer 123456)
# then
#     echo "It's an integer."
# else
#     echo "It's not an integer"
# fi
#
# Or:
#
# (is_integer 123456) && echo "It's an integer" || echo "It's not an integer"
#
# Any functions returning true or false can be used like this.
# Note that the parentheses are optional but recommended.
#
is_integer()
{
	[[ $1 == *[!0-9+\-]* ]] && return $LZ_TRUE || return $LZ_FALSE
}

to_lower_case()
{
	echo $* | tr 'A-Z' 'a-z'
}

to_upper_case()
{
	echo $* | tr 'a-z' 'A-Z'
}

is_strictly_matched()
{
	[[ "$1" == "$2" ]] && return $LZ_TRUE || return $LZ_FALSE
}

is_case_insensitively_matched()
{
	[[ "`to_lower_case $1`" == "`to_lower_case $2`" ]] && return $LZ_TRUE || return $LZ_FALSE
}

str_contains()
{
	[[ -n "$2" ]] || return $LZ_FALSE
	[[ `echo "$1" | grep "$2" -c` -gt 0 ]] && return $LZ_TRUE || return $LZ_FALSE
}

str_contains_case_insensitively()
{
	[[ -n "$2" ]] || return $LZ_FALSE
	[[ `echo "$1" | grep -i "$2" -c` -gt 0 ]] && return $LZ_TRUE || return $LZ_FALSE
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

count_down_quit()
{
	printf "*** Script going to exit:" >&2
	for i in `seq 1 10 | awk '{ printf("%02d\n", $1) }' | sort -r`
	do
		printf " $i" >&2
		sleep 1
	done
	exit
}

is_installed()
{
	[ -n "`which \"$1\"`" ] && return $LZ_TRUE || return $LZ_FALSE
}

quit_if_not_installed()
{
	is_installed "$1" || oops_quit "Command not installed: $1\nPlease intall it first!"
}

warn_if_not_installed()
{
	is_installed "$1" || lzwarn "*** Command not installed: $1\nPlease intall it first!"
}

quit_if_not_root()
{
	if [ "$USER" != "root" ]
	then
		lzerror "*** Current operation requires root user. Or you can try \"sudo\"."
		exit 1
	fi
}

env_var_push()
{
	if [ $# -lt 3 ]
	then
		echo "Usage: $FUNCNAME --head | --tail <environment variable name>"\
			" <environment variable value 1> <environment variable value 2> ..." >&2
		echo "Examples:" >&2
		echo "    1) \"$FUNCNAME --head PATH /path1\" equals to \"export PATH=/path1:\$PATH\"" >&2
		echo "    2) \"$FUNCNAME --tail PATH /path_without_spaces \"/path with spaces\"\" equals to"\
			" \"export PATH=\$PATH:/path_without_spaces:\"/path with spaces\"\"" >&2
		return $LZ_FALSE
	fi

	local _add_flag="$1"
	local _env_name="$2"
	local _initial_env_value="${!2}"

	shift
	shift

	if [ -z "$_initial_env_value" ]
	then
		export $_env_name="$1"
		shift
	fi

	while [ $# -gt 0 ] 
	do
		local _env_value="$1"

		shift

		# Checks if this environment variable already exists.
		if [ -n "`echo ${!_env_name} | grep \"$_env_value\"`" ]
		then
			continue
		fi

		if [ "$_add_flag" = "--head" ]
		then
			export $_env_name="$_env_value"":${!_env_name}"
		else
			export $_env_name="${!_env_name}"":$_env_value"
		fi
	done
}

env_var_push_front()
{
	env_var_push --head $*
}

env_var_push_back()
{
	env_var_push --tail $*
}


###########################################################
#####
##### Prerequisite operations
#####
###########################################################

#
# Registers signals.
#
for i in ${_SIG_ITEMS[@]}
do
	# TODO: SIGCHLD arises all the time, it's annoying.
	#       Any idea of knowning if we're in a script or a terminal currently??
	if [ "$i" != "CHLD" ]
	then
		trap "handle_signal $i handle_sig$i" $i
	fi
done

#
# Checks if user wants help.
# The script to which this _shell_common.sh is imported
# MUST implement the usage() function!
#
# ***Note that it must be "$@" here, not $@, $* or "$*" !!!***
#
for i in "$@"
do
	if (is_strictly_matched "$i" "-h" || is_strictly_matched "$i" "--help")
	then
		usage
		exit 0
	fi
done

