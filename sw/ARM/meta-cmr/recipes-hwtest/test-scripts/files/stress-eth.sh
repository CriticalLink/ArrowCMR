#!/bin/bash
apppath=$(readlink -f $0)
appdir=$(dirname ${apppath})
app=$(basename $apppath)

SERVER=192.168.1.101
DURATION=30
LOG_INTERVAL=5
BANDWIDTH=1000m

usage()
{
        echo Usage:
        echo "$app [-d|--duration <seconds>] [-i|--interval <seconds>] [-b|--bandwidth 10m|100m|1000m] <server>"
        echo "    -d Sets the number of seconds to run the test for"
        echo "    -i Sets the log interval in seconds"
        echo "    -b Sets the network bandwidth in bits/s (10m/100m/1000m)"
        echo "    <server> the iperf3 server to connect to"
}

TEMP=`getopt -o d:b:hi: --long duration:,bandwidth:,interval:,help\
     -n $app -- "$@"`

[ $? != 0 ] && exit 1
eval set -- "$TEMP"
while true ; do
        case "$1" in
        -d|--duration) DURATION="$2"; shift 2;;
        -i|--interval) LOG_INTERVAL="$2"; shift 2;;
        -b|--bandwidth) BANDWIDTH="$2"; shift 2;;
        -h|--help) usage ; exit 0; shift;;
        --) shift ; break ;;
        *) usage ; exit 1 ; shift;;
        esac
done

SERVER="$1"

echo TCP test...
iperf3 -c $SERVER -i $LOG_INTERVAL -t $DURATION -b $BANDWIDTH

echo UDP test...
iperf3 -c $SERVER -i $LOG_INTERVAL -t $DURATION -b $BANDWIDTH -u

# (Options are from an existing version of this script.)
#iperf3 -c $SERVER -i $LOG_INTERVAL -t $DURATION -u -b $BANDWIDTH -l 1400 -w 320k
