#!/bin/bash

usage()
{
	echo "$(basename $0) - Sends simple text messages via TCP" >&2
	echo "Usage: $(basename $0) <IP>:<Port> <One or more strings to send> ..." >&2
	echo "Example: $(basename $0) 127.0.0.1:8888 \"Do you like programming?\" \"No, I don't like it at all!\"" >&2
}

handle_sigPIPE()
{
	lzerror "Failed to send TCP message: $current_msg"
}

source $(dirname $0)/inner/_shell_common.sh

if [ $# -lt 2 ]
then
	lzerror "*** Arguments insufficient"
	usage
	exit 1
fi

ip=`echo "$1" | awk -F : '{ print $1 }'`
port=`echo "$1" | awk -F : '{ print $2 }'`
[ -n "$port" ] || oops_quit "Invalid address format, should be like: 127.0.0.1:8888"

exec 8<> /dev/tcp/$ip/$port || exit 1
shift
while [ $# -gt 0 ]
do
	current_msg="$1"
	echo -e "Sending message to ${ip}:${port}: $current_msg"
	echo -e "$current_msg" >&8
	shift
done

