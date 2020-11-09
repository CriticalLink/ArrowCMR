#!/bin/bash

# Array of gpio numbers where each is an output controlling an LED.
# (First two are active-low and the rest are active-high.)
gpionums=(301 303 346 345 341 337 338 339)

# Flag that controls extra script output.
verbose=0

# Function to turn on an LED.
# Parameter $1 is LED number starting at zero.
led_on () {
    if [ $verbose -gt 0 ]; then
        echo LED$1/gpio${gpionums[$1]} on
    fi
    # Note that some LEDs have different polarity on this hardware.
    if [ $1 -lt 2 ]; then
        echo 1 > /sys/class/gpio/gpio${gpionums[$1]}/value
    else
        echo 0 > /sys/class/gpio/gpio${gpionums[$1]}/value
    fi
}

# Function to turn off an LED.
# Parameter $1 is LED number starting at zero.
led_off () {
    if [ $verbose -gt 0 ]; then
        echo LED$1/gpio${gpionums[$1]} off
    fi
    # Note that some LEDs have different polarity on this hardware.
    if [ $1 -lt 2 ]; then
        echo 0 > /sys/class/gpio/gpio${gpionums[$1]}/value
    else
        echo 1 > /sys/class/gpio/gpio${gpionums[$1]}/value
    fi
}

echo LED Test...
if [ $verbose -gt 0 ]; then
    echo ${#gpionums[@]} pins: ${gpionums[@]}
fi

# Export gpio signals and make them all outputs.
for i in ${gpionums[@]}; do
    if [ ! -e /sys/class/gpio/gpio${i} ]; then
        if [ $verbose -gt 1 ]; then
            echo Exporting gpio${i}
        fi
        echo $i > /sys/class/gpio/export
    fi
    if [ ! -e /sys/class/gpio/gpio${i} ]; then
        echo Error: Unable to export gpio${i}
        exit
    fi
    echo out > /sys/class/gpio/gpio${i}/direction
done

# Turn on all LEDs.
for i in ${!gpionums[@]}; do
    led_on $i
done
sleep 1
# Turn off all LEDs.
for i in ${!gpionums[@]}; do
    led_off $i
done
sleep 1
# Turn on then off each LED in turn.
for i in ${!gpionums[@]}; do
    led_on $i
    sleep 0.5
    led_off $i
done

# Make LED gpios inputs when done?
#for i in ${gpionums[@]}; do
#    echo in > /sys/class/gpio/gpio${i}/direction
#done

# Unexport gpio signals.
for i in ${gpionums[@]}; do
    if [ -e /sys/class/gpio/gpio${i} ]; then
        if [ $verbose -gt 1 ]; then
            echo Unexporting gpio${i}
        fi
        echo $i > /sys/class/gpio/unexport
    fi
done

echo LED test complete.
