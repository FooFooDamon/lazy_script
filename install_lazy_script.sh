_BASH_PROFILE_CANDIDATES=("$HOME/.bash_profile" "$HOME/.bashrc")

for i in ${_BASH_PROFILE_CANDIDATES[*]}
do
	if [ -f $i ]
	then
		_bash_profile=$i
		break
	fi
done

__LAZY_SCRIPT_HOME__=`cd $(dirname $0) && pwd`

if [ `grep lazy_script $_bash_profile -c` -eq 0 ]
then
	echo "Installing Lazy-script, please wait ..." >&2

	# Let the user feel the installation process.
	printf "Progress: 0%%" >&2
	for i in `seq 1 4`
	do
		sleep 1
		printf " $((25 * $i))%%" >&2
	done

	# The actual installation is quite simple, ha ha ha ...
	echo "export __LAZY_SCRIPT_HOME__=$__LAZY_SCRIPT_HOME__" >> $_bash_profile
	echo ". \$__LAZY_SCRIPT_HOME__/import_lazy_script.sh -a" >> $_bash_profile

	printf "\nLazy-script was installed successfully! Enjoy!\n"
else
	echo "Lazy-script has been installed." >&2
	printf "${_bash_profile}: "
	grep --color=auto "export __LAZY_SCRIPT_HOME__" $_bash_profile
	printf "${_bash_profile}: "
	grep --color=auto import_lazy_script $_bash_profile
fi

