#!/bin/bash

usage()
{
	echo "$(basename $0) - Finds path to a specified executable file" >&2
	echo "Usage: $(basename $0) <A single executable file name>" >&2
	echo "Example: $(basename $0) python" >&2
	echo "Note: This script acts just like command 'which' or 'whereis', but does not support multiple arguments." >&2
}

source $(dirname $0)/inner/_shell_common.sh

echo $PATH | awk -F : '{ for (i = 1; i <= NF; i++) print $i }' | while read i
do
	if [ -f "$i/$1" ]
	then
		echo "$i/$1"
	fi
done

