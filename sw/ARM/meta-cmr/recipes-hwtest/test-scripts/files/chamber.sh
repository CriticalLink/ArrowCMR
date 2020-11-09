#!/bin/bash

apppath=$(readlink -f $0)
appdir=$(dirname ${apppath})
app=$(basename $apppath)

# Time in seconds to spend running a given test.
interval=300

# Location of the iperf3 server
server=192.168.1.101

# Count for number of test loops run.
loopcount=0

# Print a usage message.
usage() {
    echo Usage:
    echo "$app [-i|--interval <seconds>]"
    echo "    -i Sets the interval over which each individual test is run"
    echo "    <server> The iperf3 server to which to connect"
}

 Parse any command line arguments.
temp=`getopt -o i:h --long interval:,help\
     -n $app -- "$@"`

[ $? != 0 ] && exit 1
eval set -- "$temp"
while true ; do
    case "$1" in
    -i|--interval) interval="$2"; shift 2;;
    -h|--help) usage ; exit 0; shift;;
    --) shift ; break ;;
    *) usage ; exit 1 ; shift;;
    esac
done

server=$1

echo Interval is $interval seconds

# Repeatedly run through a series of tests.
while true; do
    # Update and show the loop counter.
    loopcount=$((loopcount+1))
    echo "--------------------------------------------------------------------------------"
    echo "Test loop #"$loopcount":"
    echo "--------------------------------------------------------------------------------"

    # Run the gpio loopback test.
    end=$((SECONDS+$interval))
    while [ $SECONDS -lt $end ]; do
        iotestall.sh
    done

    # Show the temperature sensor's value.
    tmp-test.sh

    # Run the Ethernet stress test.
    stress-eth.sh -i 1 -d $interval $server

    # Show the temperature sensor's value.
    tmp-test.sh

    # Run the filesystem test on the sdcard.
    stress-drive.sh -d $interval -s 8 /dev/mmcblk0

    # Show the temperature sensor's value.
    tmp-test.sh

    # Run the filesystem test on the USB device.
    stress-drive.sh -d $interval -s 4 /dev/sda1

    # Show the temperature sensor's value.
    tmp-test.sh
done
