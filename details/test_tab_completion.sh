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
	echo "$(basename $0) - A test script for Tab completion" >&2
	echo "Usage: $(basename $0) <Tab> <Tab>" >&2
}

version()
{
	echo "$(basename $0): <Define the version number of your script here>"
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

source $LAZY_SCRIPT_HOME/details/shell_common.sh || exit 1

###############################################
###
### Put your contents below this comment block.
###
###############################################

echo "Press Tab key twice please ..."
echo "Reference: https://blog.csdn.net/q1302182594/article/details/52344503"

