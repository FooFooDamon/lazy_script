#!/bin/bash

#
# _shell_common.sh
#
#  Created on: 2018-05-28
#
#      Author: WenXiongchang (udc577@126.com)
#
# Description: Some required or frequently used tools, such as constants,
#              (environment) variables, functions and prerequisite operations.
#
#       Usage: This script should not be executed directly,
#              it should be imported into the target script file
#              using 'source' or '.' syntax.
#

if [ "$BASH_SOURCE" = "$0" ]
then
    echo -e "\e[0;31m*** $(basename $BASH_SOURCE) can not be executed directly!\e[0m Use it as below:" >&2
    echo "    . \"$BASH_SOURCE\"" >&2
    echo "or:" >&2
    echo "    source \"$BASH_SOURCE\"" >&2
    exit 1
fi

shopt -s expand_aliases

###########################################################
#####
##### Aliases
#####
###########################################################

alias return_false_if_no_args="[ $# -gt 0 ] || return -1"

alias filter_unused_config_lines_from_pipe="sed \"/^[\ \t]\{0,\}#/d\" | sed \"/^[\ \t]\{0,\}$/d\""
# TODO: filter_unused_config_lines_from_file does not work!
#alias filter_unused_config_lines_from_file='sed "/^[\ \t]\{0,\}#/d" "$1" | sed "/^[\ \t]\{0,\}$/d"'

alias lzreload='. $LAZY_SCRIPT_HOME/import_lazy_script.sh -a'

###########################################################
#####
##### Variables
#####
###########################################################

_DATE_TIME_HINT="date +%Y-%m-%d_%H:%M:%S.%N"

export SHELL="`which bash`"

if [[ "$0" = "bash" || "$0" = "-bash" || "$0" = "/bin/bash" ]]
then
    export SCRIPT_NAME=bash
    export SCRIPT_DIR=$HOME
else
    export SCRIPT_NAME=$(basename "$0")
    export SCRIPT_DIR=`cd $(dirname "$0") && pwd`
fi

# TODO: Use 'kill -l' to fetch these items automatically!
_SIG_ITEMS=(HUP INT QUIT ILL \
    TRAP ABRT BUS FPE \
    KILL USR1 SEGV USR2 \
    PIPE ALRM TERM STKFLT \
    CHLD CONT STOP TSTP \
    TTIN TTOU URG XCPU \
    XFSZ VTALRM PROF WINCH \
    IO PWR SYS)

export LZ_TRUE=0
export LZ_FALSE=1

export LZ_ERR_OK=0
export LZ_ERR_GENERAL=1
export LZ_ERR_BUILT_IN_COMMAND_ERROR=2
export LZ_ERR_EXECUTABLE_ERROR=126
export LZ_ERR_COMMAND_NOT_FOUND=127
export LZ_ERR_INVALID_ARGUMENT=128

if [ `echo $BASH_SOURCE | grep inner -c` -gt 0 ]
then
    export LAZY_SCRIPT_HOME=$(cd "$(dirname $BASH_SOURCE)"/../.. && pwd)
else
    export LAZY_SCRIPT_HOME=$(cd "$(dirname $BASH_SOURCE)"/.. && pwd)
fi

_LZ_COMMON_SCRIPT_BASE_NAME=$(basename "$BASH_SOURCE" .sh)

export LZ_PUBLIC_FUNCTIONS=(`grep "^[A-Za-z][A-Za-z0-9_]\{0,\}()" "$BASH_SOURCE" | sort | grep -v "lzhelp\|do_nothing" | sed "/()/s///g"`)
export LZ_PUBLIC_SCRIPT_BASE_NAMES=(`ls "$LAZY_SCRIPT_HOME"/details/shortcuts/ | grep -v ${_LZ_COMMON_SCRIPT_BASE_NAME/_/}`)

###########################################################
#####
##### Functions
#####
##### NOTE: For usage of boolean functions(that is:
#####     functions returning true or false), see is_integer().
#####
###########################################################

_to_stderr()
{
    echo -e "$*" >&2
}

do_nothing()
{
    printf ""
}

#
# Lists usage of all public functions and scripts.
#
# TODO:
#     1. More script types: .py, .pl, .exp, .js, etc. .
#     2. Private functions and scripts.
#     3. Checking that if a private script supports -h option.
#     4. Smart hint.
#
lzhelp()
{
    echo "${LZ_PUBLIC_FUNCTIONS[*]}" | sed "/ /s//\n/g" > /tmp/lz_functions.txt
    echo "${LZ_PUBLIC_SCRIPT_BASE_NAMES[*]}" | sed "/ /s//\n/g" > /tmp/lz_scripts.txt
    echo ""

    if [ $# -eq 0 ]
    then
        echo -e "################## Functions start ##################\n"
        while read i
        do
            _USAGE_OF_$i 2>&1 | head -1
            echo ""
        done < /tmp/lz_functions.txt
        echo -e "################## Functions end ##################\n"
        
        echo -e "################## Scripts start ##################\n"
        while read i
        do
            #$i -h 2>&1 | head -1 # might cause crash, weird!!
            $i -h 2>&1 | sed -n "1p"
            echo ""
        done < /tmp/lz_scripts.txt
        echo -e "################## Scripts end ##################\n"
    else
        printf "" > /tmp/lz_functions_queried.txt
        printf "" > /tmp/lz_scripts_queried.txt
        for i in "$@"
        do
            if [ `grep "^${i}$" /tmp/lz_functions.txt -c` -gt 0 ]
            then
                [ $# -gt 1 ] && printf "[Function start] " || printf "[Function] "
                #[ $# -le 5 ] && _USAGE_OF_$i 2>&1 || _USAGE_OF_$i 2>&1 | head -1
                _USAGE_OF_$i 2>&1
                [ $# -gt 1 ] && echo -e "[Function end] -------- $i --------"
                sed -i "/^${i}$/d" /tmp/lz_functions.txt
                echo "$i" >> /tmp/lz_functions_queried.txt
            elif [ `grep "^${i}$" /tmp/lz_scripts.txt -c` -gt 0 ]
            then
                [ $# -gt 1 ] && printf "[Script start] " || printf "[Script] "
                $i -h 2>&1
                [ $# -gt 1 ] && echo -e "[Script end] -------- $i --------"
                sed -i "/^${i}$/d" /tmp/lz_scripts.txt
                echo "$i" >> /tmp/lz_scripts_queried.txt
            elif [[ `grep "^${i}$" /tmp/lz_functions_queried.txt -c` -gt 0 || `grep "^${i}$" /tmp/lz_scripts_queried.txt -c` -gt 0 ]]
            then
                do_nothing # It's repeated item.
            else
                lzwarn "Not a Function or script: $i"
            fi
            echo ""
        done
    fi

}

_USAGE_OF_lzret()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Show description of a return code"
    _to_stderr "Usage: $_target_func <return-code>"
    _to_stderr "Example: $_target_func 1"
}

lzret()
{
    if [ "$1" = "" ]; then
        lzerror "Return code not specified"
        return LZ_ERR_GENERAL
    fi

    if [ "$1" = "$LZ_ERR_OK" ]; then
        echo "${1}: OK"
    elif [ "$1" = "$LZ_ERR_GENERAL" ]; then
        echo "${1}: Catchall for general errors"
    elif [ "$1" = "$LZ_ERR_BUILT_IN_COMMAND_ERROR" ]; then
        echo "${1}: Misuse of shell built-in commands"
    elif [ "$1" = "$LZ_ERR_EXECUTABLE_ERROR" ]; then
        echo "${1}: Not an executable, or permission denied"
    elif [ "$1" = "$LZ_ERR_COMMAND_NOT_FOUND" ]; then
        echo "${1}: Command not found"
    elif [ "$1" = "$LZ_ERR_INVALID_ARGUMENT" ]; then
        echo "${1}: Invalid argument"
    elif [ "$1" -ge 64 ] && [ "$1" -le 78 ]; then
        local _errmsg=$(grep "\<$1\>" /usr/include/sysexits.h | grep -v "\<EX__BASE\>\|\<EX__MAX\>" | sed "s/.*\/\*\(.*\)\*\//\1/")
        echo "${1}: $_errmsg"
    elif [ "$1" -gt 128 ] && [ "$1" -le 192 ]; then
        local _signum=$(($1 - 128))
        local _signame=$(kill -l | grep "\<${_signum}\>)" | sed "/.*\<${_signum}\>)[ \t]\{0,\}\([A-Za-z0-9+-]*\).*/s//\1/g")
        echo "${1}: Interrupted or killed by signal $_signame"
    else
        echo "${1}: Unknown error"
    fi
}

_USAGE_OF_lzwarn()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Prints colorful warning messages"
    _to_stderr "Usage: $_target_func <message 1> <message 2> ..."
    _to_stderr "Example: $_target_func \"Warning fragment 1\" \"Warning fragment 2\" \"Warning fragment 3\""
}

lzwarn()
{
    _to_stderr "\e[0;33m$*\e[0m"
}

_USAGE_OF_lzerror()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Prints colorful error messages"
    _to_stderr "Usage: $_target_func <message 1> <message 2> ..."
    _to_stderr "Example: $_target_func \"Error fragment 1\" \"Error fragment 2\" \"Error fragment 3\""
}

lzerror()
{
    _to_stderr "\e[0;31m$*\e[0m"
}

_USAGE_OF_is_integer()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Checks if a string is an integer."
    _to_stderr "\nUsage: $_target_func <string to check>"
    _to_stderr "  And it will return $LZ_TRUE if the string is an integer, or $LZ_FALSE otherwise."
    _to_stderr "\nExample 1:"
    _to_stderr "if ($_target_func 123456)"
    _to_stderr "then"
    _to_stderr "    echo \"It's an integer.\""
    _to_stderr "else"
    _to_stderr "    echo \"It's not an integer.\""
    _to_stderr "fi"
    _to_stderr "\nExample 2:"
    _to_stderr "($_target_func 123456) && echo \"It's an integer\" || echo \"It's not an integer\""
    _to_stderr "\nNote that the parentheses are optional but recommended.\n"
}

is_integer()
{
    _filtered_str=`echo "$1" | grep "^[+-]\{0,1\}[0-9]\{1,\}$"`
    [ -n "$_filtered_str" ] && return $LZ_TRUE || return $LZ_FALSE
}

_USAGE_OF_to_lower_case()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Converts all letters into lower case ones."
    _to_stderr "Usage: $_target_func <string 1> <string 2> ..."
    _to_stderr "Example: $_target_func \"China is 中国\" \"America is 美国\""
    _to_stderr "  will get the result: china is 中国 america is 美国"
}

to_lower_case()
{
    echo $* | tr 'A-Z' 'a-z'
}

_USAGE_OF_to_upper_case()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Converts all letters into upper case ones."
    _to_stderr "Usage: $_target_func <string 1> <string 2> ..."
    _to_stderr "Example: $_target_func \"China is 中国\" \"America is 美国\""
    _to_stderr "  will get the result: CHINA IS 中国 AMERICA IS 美国"
}

to_upper_case()
{
    echo $* | tr 'a-z' 'A-Z'
}

_USAGE_OF_quit_if_no_args()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Causes the whole script to quit if the calling function or script accepts no arguments."
    _to_stderr "Usage: $_target_func"
}

quit_if_no_args()
{
    [ $# -gt 0 ] || exit 1
}

_USAGE_OF_register_signal()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Registers a specified signal."
    _to_stderr "Usage: $_target_func <signal name>"
    _to_stderr "Example: $_target_func INT"
    _to_stderr "  Then handle_sigINT will be called when signal INT arises."
}

register_signal()
{
    return_false_if_no_args

    if [[ "$0" = "bash" || "$0" = "-bash" || "$0" = "/bin/bash" ]]
    then
        do_nothing
    else
        #trap "[ \"$1\" != \"CHLD\" ] && lzwarn \"\$($_DATE_TIME_HINT): ${SCRIPT_NAME}: SIG$1 captured, signal handler [handle_sig$1] is about to run.\"; handle_sig$1" $1
        #trap "lzwarn \"\$($_DATE_TIME_HINT): ${SCRIPT_NAME}: SIG$1 captured, signal handler [handle_sig$1] is about to run.\"; handle_sig$1" $1
        trap "handle_sig$1" $1
    fi
}

_USAGE_OF_oops_quit()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Causes the whole script to quit with Oops complaint."
    _to_stderr "Usage: $_target_func <something you want to complain about>"
    _to_stderr "Example: $_target_func cmake not installed"
}

oops_quit()
{
    [ $# -gt 0 ] && lzerror "*** Oops: $*"
    exit 1
}

_USAGE_OF_count_down_quit()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Causes the whole script to quit after a count-down."
    _to_stderr "Usage: $_target_func"
}

# TODO: Can we customize the time and the exit code?
count_down_quit()
{
    printf "*** Script going to exit:" >&2
    for i in `seq 1 10 | awk '{ printf("%02d\n", $1) }' | sort -r`
    do
        printf " $i" >&2
        sleep 1
    done
    exit
}

_USAGE_OF_is_installed()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Checks if a program has been installed."
    _to_stderr "\nUsage: $_target_func <program to check>"
    _to_stderr "  And it will return $LZ_TRUE if the program has been installed, or $LZ_FALSE otherwise."
    _to_stderr "\nExample 1:"
    _to_stderr "if ($_target_func cmake)"
    _to_stderr "then"
    _to_stderr "    echo \"cmake installed.\""
    _to_stderr "else"
    _to_stderr "    echo \"cmake not installed.\""
    _to_stderr "fi"
    _to_stderr "\nExample 2:"
    _to_stderr "($_target_func cmake) && echo \"cmake installed\" || echo \"cmake not installed\""
    _to_stderr "\nNote that the parentheses are optional but recommended.\n"
}

is_installed()
{
    [ -n "`which \"$1\"`" ] && return $LZ_TRUE || return $LZ_FALSE
}

_USAGE_OF_quit_if_not_installed()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Causes the whole script to quit if the specified program is not installed."
    _to_stderr "Usage: $_target_func <program to check>"
    _to_stderr "Example: $_target_func cmake"
}

quit_if_not_installed()
{
    is_installed "$1" || oops_quit "Program not installed: $1\nPlease intall it first!"
}

_USAGE_OF_warn_if_not_installed()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Prints warnings if the specified program is not installed."
    _to_stderr "Usage: $_target_func <program to check>"
    _to_stderr "Example: $_target_func cmake"
}

warn_if_not_installed()
{
    is_installed "$1" || lzwarn "*** Program not installed: $1\nPlease intall it first!"
}

_USAGE_OF_quit_if_not_root()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Causes the whole script to quit if the current script executor is not root user or does not use \"sudo\"."
    _to_stderr "Usage: $_target_func"
}

quit_if_not_root()
{
    if [ "$USER" != "root" ]
    then
        lzerror "*** Current operation requires root user. Or you can try \"sudo\"."
        exit 1
    fi
}

_env_var_push()
{
    if [ $# -lt 3 ]
    then
        _to_stderr "Usage: $FUNCNAME --head | --tail <environment variable name>"\
            " <environment variable value 1> <environment variable value 2> ..."
        _to_stderr "Examples:"
        _to_stderr "    1) \"$FUNCNAME --head PATH /path1\" equals to \"export PATH=/path1:\$PATH\""
        _to_stderr "    2) \"$FUNCNAME --tail PATH /path_without_spaces \"/path with spaces\"\" equals to"\
            " \"export PATH=\$PATH:/path_without_spaces:\"/path with spaces\"\""
        return $LZ_FALSE
    fi

    local _add_flag="$1"
    local _env_name="$2"
    local _initial_env_value="${!2}"

    shift
    shift

    if [ -z "$_initial_env_value" ]
    then
        export $_env_name="$1"
        shift
    fi

    while [ $# -gt 0 ] 
    do
        local _env_value="$1"

        shift

        # Checks if this environment variable already exists.
        if [ -n "`echo ${!_env_name} | grep \"$_env_value\"`" ]
        then
            continue
        fi

        if [ "$_add_flag" = "--head" ]
        then
            export $_env_name="$_env_value"":${!_env_name}"
        else
            export $_env_name="${!_env_name}"":$_env_value"
        fi
    done
}

_USAGE_OF_env_var_push_front()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Pushes new values into the front of the specified environment variable."
    _to_stderr "Usage: $_target_func <environment variable name> <value 1> <value 2> ..."
    _to_stderr "Example: $_target_func PATH /home/foo/bin /usr/local/bin"
    _to_stderr "  will get the result: /usr/local/bin:/home/foo/bin:<Old PATH value>"
    _to_stderr "Note: This function is able to check the null variable and repeated value items."
}

env_var_push_front()
{
    _env_var_push --head $*
}

_USAGE_OF_env_var_push_back()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Pushes new values into the end of the specified environment variable."
    _to_stderr "Usage: $_target_func <environment variable name> <value 1> <value 2> ..."
    _to_stderr "Example: $_target_func PATH /home/foo/bin /usr/local/bin"
    _to_stderr "  will get the result: <Old PATH value>:/home/foo/bin:/usr/local/bin"
    _to_stderr "Note: This function is able to check the null variable and repeated value items."
}

env_var_push_back()
{
    _env_var_push --tail $*
}

_USAGE_OF_set_tab_completion()
{
    local _target_func=${FUNCNAME[0]/_USAGE_OF_/}
    _to_stderr "$_target_func - Sets tab completion for a command."
    _to_stderr "Usage: $_target_func <command name> \"<word list for completion, delimited by spaces>\""
    _to_stderr "Example: $_target_func lzhelp \"aa bb cc\""
    _to_stderr "  will get the result: aa bb cc"
    _to_stderr "  when Tab key is pressed twice after \"lzhelp<Space key>\"."
    _to_stderr "Note: This function may supports more complex formats in future."
}

set_tab_completion()
{
    [ $# -ge 2 ] || return $LZ_FALSE

    local _target="$1"
    local _word_list="$2"

    complete -d -f -W "$_word_list" "$_target"
}


###########################################################
#####
##### Prerequisite operations
#####
###########################################################

#
# Registers signals.
#
for i in ${_SIG_ITEMS[@]}
do
    register_signal $i
done

#
# Checks if user wants help or version printing.
# The script to which this _shell_common.sh is imported
# MUST implement the usage() function!
#
# ***Note that it must be "$@" here, not $@, $* or "$*" !!!***
#
for i in "$@"
do
    if [[ "$i" = "-h" || "$i" = "--help" ]]
    then
        usage
        exit 0
    fi
    
    if [[ "$i" = "-v" || "$i" = "--version" ]]
    then
        version
        exit 0
    fi
done

