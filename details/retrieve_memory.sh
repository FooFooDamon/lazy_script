#!/bin/bash

usage()
{
    echo "$(basename $0) - Retrieves unused memory" >&2
    echo "Usage: sudo $(basename $0)" >&2
}

version()
{
    echo "$(basename $0): V1.00.00 2018/06/08"
}

source $LAZY_SCRIPT_HOME/details/shell_common.sh

quit_if_not_root

echo ">>>>>>>> Memory usage before cleaning:"
free -m

sync
echo 3 > /proc/sys/vm/drop_caches

echo ">>>>>>>> Memory usage after cleaning:"
free -m

