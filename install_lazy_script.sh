#!/bin/bash

BASH_PROFILE_CANDIDATES=("$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile" "$HOME/.bash_login")

for i in ${BASH_PROFILE_CANDIDATES[*]}
do
	if [ -f $i ]
	then
		bash_profile=$i
		break
	fi
done

if [ -z "$bash_profile" ]
then
	echo "*** Can not find bashrc among these candidates: ${BASH_PROFILE_CANDIDATES[@]}" >&2
	exit 1
fi

if [ "$1" = "remove" ]
then
	is_add=0
else
	is_add=1
fi

__LAZY_SCRIPT_HOME__=`cd $(dirname $0) && pwd`

if [ $is_add -eq 1 ]
then
	if [ `grep lazy_script $bash_profile -c` -eq 0 ]
	then
		echo "Installing Lazy-script, please wait ..." >&2
	else
		echo "Lazy-script has been installed." >&2
		printf "${bash_profile}: "
		grep --color=auto "export __LAZY_SCRIPT_HOME__" $bash_profile
		printf "${bash_profile}: "
		grep --color=auto import_lazy_script $bash_profile
		exit 0
	fi
else
	echo "Removing Lazy-script, please wait ..." >&2
fi

# Let the user feel the installation/uninstallation process.
printf "Progress: 0%%" >&2
for i in `seq 1 4`
do
	sleep 1
	printf " $((25 * $i))%%" >&2
done

# The actual installation/uninstallation is quite simple, ha ha ha ...
if [ $is_add -eq 1 ]
then
	find "$__LAZY_SCRIPT_HOME__"/ -type f | xargs chmod 777
	echo "" >> $bash_profile
	echo "export __LAZY_SCRIPT_HOME__=$__LAZY_SCRIPT_HOME__" >> $bash_profile
	echo ". \$__LAZY_SCRIPT_HOME__/import_lazy_script.sh -a" >> $bash_profile
	ln -s -f -n $__LAZY_SCRIPT_HOME__/details/inner/_shell_common.sh $__LAZY_SCRIPT_HOME__/details/shell_common.sh
	printf "\nLazy-script was installed successfully! Now \e[0;33mstart a terminal manually to initialize this script box!\e[0m\n"
else
	source $__LAZY_SCRIPT_HOME__/details/inner/_shell_common.sh
	source $__LAZY_SCRIPT_HOME__/details/inner/_bash_identity
	source $__LAZY_SCRIPT_HOME__/details/inner/_bash_settings
	[ -f $bash_profile ] && sed -i "/LAZY_SCRIPT_HOME/d" $bash_profile
	#[ -f $VIMRC ] && sed -i "/LAZY_SCRIPT_HOME/d" $VIMRC
	echo "Lazy-script: Congratulations, you've get rid of me ~ ~ ~" >&2
	echo "You can manually remove these programs if you don't need them: ${_NECESSARY_TOOLS[@]}" >&2
	echo "And these directories: ${_NECESSARY_DIRS[@]}" >&2
	echo -e "Lazy-script: You \e[0;33mwon't see me again on next terminal\e[0m, bye! ~ ~ ~" >&2
fi

