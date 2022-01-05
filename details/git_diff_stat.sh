usage()
{
    echo "$(basename $0) - Wrapper for \"git diff --stat\" to the latest two commits" >&2
    echo "Usage: $(basename $0)"
}

version()
{
    echo "$(basename $0): V1.00.00 2018/06/08"
}

source $LAZY_SCRIPT_HOME/details/shell_common.sh

quit_if_not_installed git

version_numbers=(`git log | grep ^commit | head -2 | awk '{ print $2 }'`)

git diff ${version_numbers[1]} ${version_numbers[0]} --stat

echo -e "\nIf you want more details, use \"git log\" to fetch commit hash codes you need,\n"\
    "and then use \"git diff <code 1> <code 2> --stat\" to find out what files were changed,\n"\
    "finally use \"git diff <code 1> <code 2> <files that interest you> ...\" to see change details of each file.\n" >&2

