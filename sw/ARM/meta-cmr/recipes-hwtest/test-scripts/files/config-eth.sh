#!/bin/bash

apppath=$(readlink -f $0)
appdir=$(dirname ${apppath})
app=$(basename $apppath)

# Pring a usage message.
usage () {
    echo Usage "$app auto|1000|100|10"
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi
if [ "$1" = "auto" ]; then
    ethtool -s eth0 speed 1000 duplex full autoneg on
else
    ethtool -s eth0 speed "$1" duplex full
fi
