#!/bin/bash

usage()
{
    echo "$(basename $0): Prints tips on GNU configure script usage." >&2
    echo "Usage: $(basename $0)" >&2
}

version()
{
    echo "$(basename $0): V1.00.00 2018/06/10"
}

source $LAZY_SCRIPT_HOME/details/shell_common.sh

echo "A frequently used and not so complex example:"
echo "    ./configure --prefix=/usr/local --bindir=/usr/local/bin --libdir=/usr/local/lib --headerdir=/usr/local/include"
echo "For more options info, just run:"
echo "    ./configure --help"

