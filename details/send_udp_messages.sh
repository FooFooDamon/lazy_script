#!/bin/bash

usage()
{
	echo "$(basename $0) - Sends simple text messages via UDP" >&2
	echo "Usage: $(basename $0) <IP>:<Port> <One or more strings to send> ..." >&2
	echo "Example: $(basename $0) 127.0.0.1:8888 \"Do you like programming?\" \"No, I don't like it at all!\"" >&2
}

version()
{
	echo "$(basename $0): V1.00.01 2021/01/05" # Use dynamic file descriptor.
	#echo "$(basename $0): V1.00.00 2018/06/08" # Create.
}

handle_sigPIPE()
{
	lzerror "Failed to send UDP message: $current_msg"
}

source $LAZY_SCRIPT_HOME/details/shell_common.sh

if [ $# -lt 2 ]
then
	lzerror "*** Arguments insufficient"
	usage
	exit 1
fi

ip=`echo "$1" | awk -F : '{ print $1 }'`
port=`echo "$1" | awk -F : '{ print $2 }'`
[ -n "$port" ] || oops_quit "Invalid address format, should be like: 127.0.0.1:8888"

exec {fd}<> /dev/udp/$ip/$port || exit 1
shift
while [ $# -gt 0 ]
do
	current_msg="$1"
	echo -e "Sending message to ${ip}:${port}: $current_msg"
	echo -e "$current_msg" >&${fd}
	shift
done

