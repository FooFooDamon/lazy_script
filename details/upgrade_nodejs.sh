#!/bin/bash

usage()
{
	echo "$(basename $0) - Upgrades NodeJS to the latest version." >&2
	echo "Usage: $(basename $0)" >&2
}

version()
{
	# Removed the npm automic installation
	echo "$(basename $0): V1.00.01 2018/06/15"

	# Created.
	#echo "$(basename $0): V1.00.00 2018/06/08"
}

source "$LAZY_SCRIPT_HOME"/import_lazy_script.sh

is_installed npm || oops_quit "npm not installed! Please install it first and run this script again."

sudo npm cache clean -f && sudo npm install n -g && sudo n stable && echo "NodeJS version after upgrade: $(node -v)"

