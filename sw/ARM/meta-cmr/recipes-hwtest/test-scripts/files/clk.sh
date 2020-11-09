#!/bin/bash
app=$(basename $0)
# Simple script to toggle a gpio.  You never know when you'll want to use this.
if [ $# -eq 0 ]; then
    echo "Usage: $app <gpio number>"
    exit
fi

gpio=$1
echo -n "Toggling GPIO ${gpio} "
grep ${gpio} /sys/kernel/debug/gpio |sed -n 's/.*(\([^ ]*\).*/\1/p' 2>/dev/null

echo $gpio > /sys/class/gpio/export 2>/dev/null

if [ ! -e /sys/class/gpio/gpio${gpio} ]; then
        echo Error: Unable to export gpio${gpio}
        exit
fi
echo out > /sys/class/gpio/gpio${gpio}/direction

echo Outputing 5Hz clock train on gpio${gpio}
while true
do
	echo 1 > /sys/class/gpio/gpio${gpio}/value
	sleep 0.1
	echo 0 > /sys/class/gpio/gpio${gpio}/value
	sleep 0.1
done

echo $gpio > /sys/class/gpio/unexport

echo Done.

