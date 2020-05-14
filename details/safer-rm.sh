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
	echo "$(basename $0) - Enhansed verson of safe-rm, can filter out sub-directories and sub-files of items in the configuration file." >&2
	echo "Usage: Almost same as safe-rm, except that path like /usr/lib/* is not supported!" >&2
	echo "Notes:" >&2
	echo "(1) Configurations are: /etc/safer-rm.conf, ~/etc/safer-rm."
	echo "(2) A path to be deleted can not start with \"-\"."
	echo "(3) A path can not be protected while the deletion is done to its parent directory."
}

version()
{
	echo "$(basename $0): V1.00.00 2020/05/14"
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

source $LAZY_SCRIPT_HOME/import_lazy_script.sh

###############################################
###
### Put your contents below this comment block.
###
###############################################

GLOBAL_CONFIG=/etc/safer-rm.conf
USER_CONFIG="$HOME/etc/safer-rm"
DEFAULT_PROTECTED_DIRS=(
	"/bin"
	"/boot"
	"/dev"
	"/etc"
	"/lib"
	"/lib32"
	"/libx32"
	"/lib64"
	"/proc"
	"/run"
	"/sbin"
	"/sys"
	"/usr"
	"/var"
)

if [ ! -f $GLOBAL_CONFIG ] && [ ! -f "$USER_CONFIG" ]; then
	mkdir -p "$(dirname "$USER_CONFIG")"
	touch "$USER_CONFIG"
	for i in "${DEFAULT_PROTECTED_DIRS[@]}"
	do
		echo "$i" >> "$USER_CONFIG"
	done
fi

PROTECTED_LIST_FILE=/tmp/${SCRIPT_NAME}.protectedlist.$(date +%Y%m%d%H%M%S%N)
cat $GLOBAL_CONFIG "$USER_CONFIG" > $PROTECTED_LIST_FILE 2> /dev/null

cmd_params=("$@")
param_index=0
for param in "${cmd_params[@]}"
do
	[ "${param:0:1}" != "-" ] && param_real_path="$(realpath -e "$param")" || param_real_path=""
	if [ -n "$param_real_path" ]; then
		while read protected_item
		do
			item_real_path="$(realpath -e "$protected_item" 2> /dev/null)"
			[ -n "$item_real_path" ] || continue
			[ "$item_real_path" != "/" ] || continue

			item_len=${#item_real_path}
			if [ "${param_real_path:0:$item_len}" = "$item_real_path" ]; then
				echo "${SCRIPT_NAME}: skipping: ${cmd_params[$param_index]}" >&2
				unset cmd_params[$param_index]
				break
			fi
		done < $PROTECTED_LIST_FILE
	fi
	param_index=$(($param_index + 1))
done

/bin/rm $PROTECTED_LIST_FILE

echo "${SCRIPT_NAME}: /bin/rm ${cmd_params[@]}" >&2
/bin/rm "${cmd_params[@]}"

