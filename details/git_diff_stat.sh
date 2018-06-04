usage()
{
	echo "$(basename $0) - Wrapper for \"git diff --stat\" to the latest two commits" >&2
	echo "Usage: $(basename $0)"
}

source $(dirname $0)/inner/_shell_common.sh

version_numbers=(`git log | grep ^commit | head -2 | awk '{ print $2 }'`)

git diff ${version_numbers[1]} ${version_numbers[0]} --stat

echo -e "\nIf you want more details, use \"git log\" to fetch commit hash codes you need,\n"\
	"and then use \"git diff <code 1> <code 2> --stat\" to find out what files were changed,\n"\
	"finally use \"git diff <code 1> <code 2> <files that interest you> ...\" to see change details of each file.\n" >&2
