#!/bin/bash

###############################################
###
### Contents generated from
### $LAZY_SCRIPT_HOME/details/etc/bash.tpl.
###
### Edit these contents before they can be used.
###
###############################################

DATE_TIME_HINT="date +%Y-%m-%d_%H:%M:%S"

usage()
{
	echo "$(basename $0) - Encodes/Decodes special URL characters" >&2
	echo -e "\nUsage: $(basename $0) [ -d | -e ] <One or more raw or encoded URL strings> ..." >&2
	echo "+++ -d: [D]ecodes the specified string(s). Default option if no option specified." >&2
	echo "+++ -e: [E]ecodes the specified string(s)" >&2
	echo -e "\nExample 1: $(basename $0) -e \"https://www.google.com/\"" >&2
	echo "  will get the result: http%3A%2F%2Fwww.google.com%2F" >&2
	echo -e "\nExample 2: $(basename $0) \"https%3A%2F%2Fwww.google.com%2F\" \"https%3A%2F%2Fwww.baidu.com%2F\"" >&2
	echo "  will get the result:" >&2
	echo "[https%3A%2F%2Fwww.google.com%2F] -> [https://www.google.com/]" >&2
	echo -e "[https%3A%2F%2Fwww.baidu.com%2F] -> [https://www.baidu.com/]\n" >&2
}

version()
{
	echo "$(basename $0): V1.00.01 2018/06/10"
	#echo "$(basename $0): V1.00.00 2018/06/08"
}

handle_sigHUP()
{
	echo "TODO: Define what to do here when SIGHUP arises."
}

handle_sigINT()
{
	echo "TODO: Define what to do here when SIGINT arises."
	lzwarn "$($DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
	exit
}

handle_sigQUIT()
{
	echo "TODO: Define what to do here when SIGQUIT arises."
	lzwarn "$($DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
	exit
}

handle_sigILL()
{
	echo "TODO: Define what to do here when SIGILL arises."
}

handle_sigTRAP()
{
	echo "TODO: Define what to do here when SIGTRAP arises."
}

handle_sigABRT()
{
	echo "TODO: Define what to do here when SIGABRT arises."
	lzwarn "$($DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
	exit
}

handle_sigBUS()
{
	echo "TODO: Define what to do here when SIGBUS arises."
}

handle_sigFPE()
{
	echo "TODO: Define what to do here when SIGFPE arises."
}

handle_sigKILL()
{
	echo "TODO: Define what to do here when SIGKILL arises."
	lzwarn "$($DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
	exit
}

handle_sigUSR1()
{
	echo "TODO: Define what to do here when SIGUSR1 arises."
}

handle_sigSEGV()
{
	echo "TODO: Define what to do here when SIGSEGV arises."
}

handle_sigUSR2()
{
	echo "TODO: Define what to do here when SIGUSR2 arises."
}

handle_sigPIPE()
{
	echo "TODO: Define what to do here when SIGPIPE arises."
}

handle_sigALRM()
{
	echo "TODO: Define what to do here when SIGALRM arises."
}

handle_sigTERM()
{
	echo "TODO: Define what to do here when SIGTERM arises."
	lzwarn "$($DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
	exit
}

handle_sigSTKFLT()
{
	echo "TODO: Define what to do here when SIGSTKFLT arises."
}

handle_sigCHLD()
{
	echo "TODO: Define what to do here when SIGCHLD arises."
}

handle_sigCONT()
{
	echo "TODO: Define what to do here when SIGCONT arises."
}

handle_sigSTOP()
{
	echo "TODO: Define what to do here when SIGSTOP arises."
	lzwarn "$($DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
	exit
}

handle_sigTSTP()
{
	echo "TODO: Define what to do here when SIGTSTP arises."
}

handle_sigTTIN()
{
	echo "TODO: Define what to do here when SIGTTIN arises."
}

handle_sigTTOU()
{
	echo "TODO: Define what to do here when SIGTTOU arises."
}

handle_sigURG()
{
	echo "TODO: Define what to do here when SIGURG arises."
}

handle_sigXCPU()
{
	echo "TODO: Define what to do here when SIGXCPU arises."
}

handle_sigXFSZ()
{
	echo "TODO: Define what to do here when SIGXFSZ arises."
}

handle_sigVTALRM()
{
	echo "TODO: Define what to do here when SIGVTALRM arises."
}

handle_sigPROF()
{
	echo "TODO: Define what to do here when SIGPROF arises."
}

handle_sigWINCH()
{
	echo "TODO: Define what to do here when SIGWINCH arises."
}

handle_sigIO()
{
	echo "TODO: Define what to do here when SIGIO arises."
}

handle_sigPWR()
{
	echo "TODO: Define what to do here when SIGPWR arises."
}

handle_sigSYS()
{
	echo "TODO: Define what to do here when SIGSYS arises."
}

source $LAZY_SCRIPT_HOME/details/shell_common.sh || exit 1

###############################################
###
### Put your contents below this comment block.
###
###############################################


# NOTE: The "%" must be the first!
# TODO: How to support Chinese characters?
ORIGINAL_CHARS=("%"   " "   "!"   \"    "#"   "&"   "("   ")"   "+"   ","   "/"   ":"   ";"   "<"   "="   ">"   "?"   "@"   \\    "|")
ENCODED_CHARS=( "%25" "%20" "%21" "%22" "%23" "%26" "%28" "%29" "%2B" "%2C" "%2F" "%3A" "%3B" "%3C" "%3D" "%3E" "%3F" "%40" "%5C" "%7C")

is_encode=0
target_count=0

for i in "$@"
do
	if [ "$i" = "-d" ]
	then
		is_encode=0
	elif [ "$i" = "-e" ]
	then
		is_encode=1
	else
		target_count=$(($target_count + 1))
	fi
done

while [ $# -gt 0 ]
do
	if [[ "$1" = "-d" || "$1" = "-e" ]]
	then
		shift
		continue
	fi

	old_string="$1"
	new_string="$old_string"
		
	for i in `seq 0 $((${#ORIGINAL_CHARS[*]} - 1))`
	do
		if [ $is_encode -eq 1 ]
		then
			new_string=${new_string//"${ORIGINAL_CHARS[$i]}"/"${ENCODED_CHARS[$i]}"}
		else
			new_string=${new_string//"${ENCODED_CHARS[$i]}"/"${ORIGINAL_CHARS[$i]}"}
		fi
	done

	if [ $target_count -le 1 ]
	then
		echo "$new_string"
	else
		echo "[$old_string] -> [$new_string]"
	fi

	shift
done

