#!/bin/sh

# Exit status codes:
# -1 - Invocation error
# 0 - Success
# 1 - Sensor not found
# 2 - Sensor read error
# 3 - Sensor too low
# 4 - Sensor too high

if [ "$#" -ne 6 ]; then
	echo "Usage: $0 hwmon_dir hwmon_name hwmon_description sensor_file low_range high_range"
	exit -1
fi

HWMONDIR=$1
HWMONNAME=$2
label="$3"
SENSOR=$4
LOW=$5
HIGH=$6

# Make sure we're looking at the hwmon with the name we expect
REALNAME=$(cat "$HWMONDIR/name")
if [ "$HWMONNAME" != "$REALNAME" ]; then
	echo "FAILED: wrong name for $(basename $HWMONDIR): (expect $HWMONNAME, found $REALNAME)"
	exit 1
fi

HWMONIN="$HWMONDIR/$SENSOR"

if [ ! -f "$HWMONIN" ]; then
	echo "FAILED: sensor not found: $HWMONIN"
	exit 1
fi

echo Testing HW Monitor
echo Sensor: $HWMONIN
echo Label: "$label"
echo Low Limit: $LOW
echo High Limit: $HIGH

HWMONVAL=$(cat $HWMONIN)
if [ $? -ne 0 ]; then
	echo "FAILED: read error"
	exit 2
fi
echo Current Value: $HWMONVAL

if [ "$HWMONVAL" -lt "$LOW" ]; then
	echo "FAILED: sensor too low"
	exit 3
fi

if [ "$HWMONVAL" -gt "$HIGH" ]; then
	echo "FAILED: sensor too high"
	exit 4
fi

echo "PASSED"