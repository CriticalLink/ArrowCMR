#!/bin/bash

# Array of gpio numbers where each is an input reading a switch.
gpionums=(353 352 351 350)

# Array of switch names corresponding to the gpio numbers.
switchnames=("S3" "S4" "S5" "S6")

# Array of current switch values.
current_values=()

# Array of number of times each switch has changed.
switch_count=()

# Minimum number of switch presses+releases required (so 2 means pressing then releasing once, ...).
minimum_count=2

# Flag that controls extra script output.
verbose=0

# Helper function that reads all switch values
update_values () {
    local i=0
    while [ $i -lt ${#gpionums[@]} ]; do
        new_value=$( cat /sys/class/gpio/gpio${gpionums[$i]}/value )
        if [ ${current_values[$i]} != $new_value ]; then
            if [ ${switch_count[$i]} -eq 0 ]; then
                echo "${switchnames[$i]}"
            fi
            switch_count[i]=$((switch_count[i]+1))
        fi
        current_values[i]=$new_value
        i=$((i+1))
    done
    ##echo ${current_values[@]}
    ##echo ${switch_count[@]}
}

# Helper function to test if all switch count values are >= minimum.
check_switch_count () {
    remaining=${#switch_count[@]}
    for i in ${switch_count[@]}; do
        if [ $i -ge $minimum_count ]; then
            remaining=$((remaining-1))
        fi
    done
}

echo Pushbutton Test...
if [ $verbose -gt 0 ]; then
    echo ${#gpionums[@]} pins: ${gpionums[@]}
fi

# Export gpio signals and make them all inputs.
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
    echo in > /sys/class/gpio/gpio${i}/direction
    current_values+=( $( cat /sys/class/gpio/gpio${i}/value ) )
    switch_count+=( 0 )
done

if [ $verbose -gt 1 ]; then
    echo Current values: ${current_values[@]}
    echo ${switch_count[@]}
fi

# Loop while watching for button presses.
# Exit the loop after all buttons are pressed (& released) or time expires.
loop=300
while [ $loop -gt 0 ]; do
    sleep 0.2
    update_values
    check_switch_count
    if [ $remaining -eq 0 ]; then
        echo All buttons were detected.
        break
    fi
    loop=$((loop-1))
done

# Unexport gpio signals.
for i in ${gpionums[@]}; do
    if [ -e /sys/class/gpio/gpio${i} ]; then
        if [ $verbose -gt 1 ]; then
            echo Unexporting gpio${i}
        fi
        echo $i > /sys/class/gpio/unexport
    fi
done

if [ $verbose -gt 1 ]; then
    echo Button presses: ${switch_count[@]}
fi

if [ $remaining -ne 0 ]; then
    echo Not all buttons were detected.
else
    echo Pushbutton test complete.
fi
