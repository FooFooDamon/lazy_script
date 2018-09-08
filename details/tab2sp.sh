#!/bin/bash

###############################################
###
### Contents generated from
### $LAZY_SCRIPT_HOME/details/etc/bash.tpl.
###
### Edit these contents before they can be used.
###
###############################################

DATE_TIME_HINT="date +%Y-%m-%d_%H:%M:%S.%N"

usage()
{
	echo "$(basename $0) - Converts tabs in a file into spaces" >&2
	echo "Usage: $(basename $0) [-N] [ -H | --header-only ] [ -F | --force ] <file 1> <file 2> ..." >&2
	echo "    -N:  N is width of the tab, default value is 4." >&2
	echo "    -H, --header-only:  Only converts tabs at the beginning of each line." >&2
	echo "    -F, --force:  Forces the convertion to continue no matter what type of a file is." >&2
}

version()
{
	echo "$(basename $0): V1.00.00 2018/09/08"
}

handle_sigHUP()
{
	echo "TODO: Define what to do here when SIGHUP arises."
}

handle_sigINT()
{
	echo "TODO: Define what to do here when SIGINT arises."
	lzwarn "\$($DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
	exit
}

handle_sigQUIT()
{
	echo "TODO: Define what to do here when SIGQUIT arises."
	lzwarn "\$($DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
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
	lzwarn "\$($DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
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
	lzwarn "\$($DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
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
	lzwarn "\$($DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
	exit
}

handle_sigSTKFLT()
{
	echo "TODO: Define what to do here when SIGSTKFLT arises."
}

handle_sigCHLD()
{
	# TODO: This is the default and general handling for SIGCHLD,
	#       you can comment it and define your own specific operations if necessary.
	do_nothing
}

handle_sigCONT()
{
	echo "TODO: Define what to do here when SIGCONT arises."
}

handle_sigSTOP()
{
	echo "TODO: Define what to do here when SIGSTOP arises."
	lzwarn "\$($DATE_TIME_HINT): ${SCRIPT_NAME}: Script will exit soon."
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

source $LAZY_SCRIPT_HOME/import_lazy_script.sh

###############################################
###
### Put your contents below this comment block.
###
###############################################

tab_width=4
header_only=0
to_all_types=0

for i in "$@"
do
	if (is_integer "$i")
	then
		[[ ! -f "$i" && "$i" -lt 0 ]] && tab_width=$(echo "$i" | sed "/^-/s///")
	elif [[ "$i" == "-H" || "$i" == "--header-only" ]]
	then
		header_only=1
	elif [[ "$i" == "-F" || "$i" == "--force" ]]
	then
		to_all_types=1
	fi
done

options="--tabs=$tab_width"
[ $header_only -ne 0 ] && options="$options --initial"

SUFFIXES_FILE_NAME=$(basename "$0" .sh).suffixes.txt
if [ ! -f "$HOME/etc/$SUFFIXES_FILE_NAME" ]; then
	DEFAULT_SUFFIXES=(.c .C .cc .cpp .cxx .c++ .h .hpp .hxx .pch .java .sh .py .pl .js)
    mkdir -p $HOME/etc
    echo ${DEFAULT_SUFFIXES[@]} | sed "/\ /s//\n/g" > "$HOME/etc/$SUFFIXES_FILE_NAME"
fi
 
SUFFIXES=(`cat "$HOME/etc/$SUFFIXES_FILE_NAME"`)
#echo "${SUFFIXES[@]}"

for i in "$@"
do
	if (is_integer "$i")
	then
		[[ ! -f "$i" && "$i" -lt 0 ]] && continue
	elif [[ "$i" == "-H" || "$i" == "--header-only" ]]
	then
		continue
	elif [[ "$i" == "-F" || "$i" == "--force" ]]
	then
		continue
	else
		if [ ! -f "$i" ]
		then
			lzerror "*** File does not exist, or not a file: $i"
			continue
		fi

		if [ $to_all_types -eq 0 ]
		then
			is_valid_type=0

			for suffix in ${SUFFIXES[@]}
			do
				filtered_str="$(echo "$i" | grep ${suffix}$)"
				[ -n "$filtered_str" ] && is_valid_type=1
			done

			if [ $is_valid_type -eq 0 ]
			then
				lzerror "*** [$i]: Invalid file type, use the -F option if you're sure you want to convert this file."
				continue
			fi
		fi

		expand $options "$i" > "$i".tmp
		cat "$i".tmp > "$i"
		rm "$i".tmp
		echo "tab-to-space conversion successful: $i"
	fi
done

