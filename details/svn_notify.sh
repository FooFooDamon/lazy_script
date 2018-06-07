#!/bin/bash

usage()
{
	echo "$(basename $0) - Notifies the Subversion server that the specified directories have been added or deleted some files or subdirectories." >&2
	echo "Usage: $(basename $0) <one or more directories> ..." >&2
	echo "Example: $(basename $0) ./dir1 /home/foo/dir2" >&2
}

source $LAZY_SCRIPT_HOME/details/shell_common.sh

if [ $# -lt 1 ]
then
	lzerror "*** Arguments insufficient!"
	usage
	exit 1
fi

quit_if_not_installed svn

SVN_SYMBOLS=("\?" "\!")
SVN_OPERATIONS=(add delete)
OP_COUNT=${#SVN_SYMBOLS[*]}

while [ $# -gt 0 ]
do
	target_dir="$1"
	
	shift

	if [ ! -d "$target_dir" ]
	then
		lzerror "*** Directory does not exist: $target_dir"
		continue
	fi

	for i in `seq 0 $(($OP_COUNT - 1))`
	do
		svn status "${target_dir}" | grep "^${SVN_SYMBOLS[$i]}" | sed "s/${SVN_SYMBOLS[$i]}\ *//g" | while read line
		do
			echo "svn ${SVN_OPERATIONS[$i]} \"${line}\""
			svn ${SVN_OPERATIONS[$i]} "${line}"
		done
	done
done

