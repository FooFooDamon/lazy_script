#!/bin/bash

usage()
{
	echo "$(basename $0) - Creates one or more Bash script files from template" >&2
	echo "Usage: $(basename $0) <path to file 1> <path to file 2> ..." >&2
	echo "Example: $(basename $0) /home/foo/xx.sh /home/foo/yy.sh" >&2
}

source $LAZY_SCRIPT_HOME/details/shell_common.sh

for i in "$@"
do
	if [ -f "$i" ]
	then
		lzwarn "*** File already exists: $i"
		continue
	else
		mkdir -p $(dirname "$i")
		cp $(dirname $0)/etc/bash.tpl "$i"
		echo "~ ~ ~ Bash script file was generated successfully: $i"
	fi
done

