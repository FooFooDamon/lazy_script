export __LAZY_SCRIPT_HOME__=$(dirname $0)/..
source $__LAZY_SCRIPT_HOME__/import_lazy_script.sh

is_installed || sudo $PROG_INSTALL npm

sudo npm cache clean -f && sudo npm install n -g && sudo n stable && echo "NodeJS version after upgrade: $(node -v)"
echo "If you find any problem, visit:"
echo "    https://blog.csdn.net/tlbaba/article/details/79412433"
echo "or use seach engines to look for the solution."

