#!/bin/bash

apppath=$(readlink -f $0)
appdir=$(dirname ${apppath})
app=$(basename $apppath)

# Script exit codes:
# 1 - Unrecognized command line argument
# 2 - Issue with the input file
# 3 - Unable to export GPIO pin
# 4 - GPIO pin test failure

# Array of gpio numbers where each consecutive pair is externally connected together.
gpionums=()

# Array of gpio initial input values that should not change when other pairs are tested.
gpiovals=()

# Counter for number of errors found.
numerrors=0

# Flag that controls extra script output.
verbose=0

# Print a simple usage message.
usage () {
    echo Usage: "$app [-v|--verbose <0-2> gpio_pin_file"
}

# Debug helper function that shows the current value of all gpio signals.
current_values () {
    currvals=()
    local i
    for i in ${gpionums[@]}; do
        currvals+=( $( cat /sys/class/gpio/gpio${i}/value ) )
    done
    if [ $verbose -gt 0 ]; then
        echo current values: ${currvals[@]}
    fi
}

# Helper function that checks that gpio input values haven't changed.
# Excludes the gpios in the array at the given indexes.
# Parameters $1 and $2 are array indexes of the gpio pins to exclude.
check_other_inputs () {
    if [ $verbose -gt 1 ]; then
        echo Checking inputs:
    fi
    local i
    for i in ${!gpionums[@]}; do
        if [ $i != $1 ] && [ $i != $2 ]; then
            level=$( cat /sys/class/gpio/gpio${gpionums[i]}/value )
            if [ $verbose -gt 1 ]; then
                echo gpio${gpionums[i]} is $level expecting ${gpiovals[i]}
            fi

            if [ $level != ${gpiovals[i]} ]; then
                echo Error: gpio${gpionums[i]} changed unexpectedly while testing gpios $gpio_out"->"$gpio_in
                numerrors=$((numerrors+1))
#                exit 4
            fi
        fi
    done
}

# Helper function that sets a given gpio pin to an output,
# changes the value, and checks that a given gpio input pin
# shows that value while all other pins remain unchanged.
# Parameter $1 is the array index of the gpio input pin.
# Parameter $2 is the array index of the gpio output pin.
loopback_test () {
    gpio_in=gpio${gpionums[$1]}
    gpio_out=gpio${gpionums[$2]}
    if [ $verbose -gt 1 ]; then
        echo $gpio_out to $gpio_in loopback test:
    fi
    # Set pin directions.
    echo in > /sys/class/gpio/$gpio_in/direction
    echo out > /sys/class/gpio/$gpio_out/direction
    # Set output to low.
    echo 0 > /sys/class/gpio/$gpio_out/value
    # Verify input is low.
    level=$( cat /sys/class/gpio/$gpio_in/value )
    if [ $verbose -gt 1 ]; then
        echo Setting $gpio_out low, $gpio_in is $level
    fi
    if [ $level != "0" ]; then
        echo Error: Set $gpio_out low, $gpio_in = $level, failed to read as low
        numerrors=$((numerrors+1))
#        echo in > /sys/class/gpio/$gpio_out/direction
#        exit 4
    fi
    # Verify all other signals are unchanged.
    check_other_inputs $1 $2
    # Set output to high.
    echo 1 > /sys/class/gpio/$gpio_out/value
    # Verify input is high.
    level=$( cat /sys/class/gpio/$gpio_in/value )
    if [ $verbose -gt 1 ]; then
        echo Setting $gpio_out high, $gpio_in is $level
    fi
    if [ $level != "1" ]; then
        echo Error: Set $gpio_out high, $gpio_in = $level, failed to read as high
        numerrors=$((numerrors+1))
#        echo in > /sys/class/gpio/$gpio_out/direction
#        exit 4
    fi
    # Verify all other signals are unchanged.
    check_other_inputs $1 $2
    # Restore the original value.
    echo ${gpiovals[$2]} > /sys/class/gpio/$gpio_out/value
    # Change the output back to an input.
    echo in > /sys/class/gpio/$gpio_out/direction
}

# Sort out command line options.
temp=`getopt -o v:h --long verbose:,help\
     -n $app -- "$@"`

[ $? != 0 ] && exit 1
eval set -- "$temp"
while true ; do
    case "$1" in
    -v|--verbose) verbose="$2"; shift 2;;
    -h|--help) usage ; exit 0; shift;;
    --) shift ; break ;;
    *) usage ; exit 1 ; shift;;
    esac
done

echo GPIO Loopback Test...
if [ $verbose -gt 0 ]; then
    echo File = $1
fi

# Read gpio pin numbers from a file and store in an array.
if [ "$1" == "" ]; then
    echo No input file specified
    usage
    exit 2
fi
if [ ! -f $1 ]; then
    echo Input file $1 not found
    exit 2
fi
lastifs=$IFS
IFS=","
while read pin1 pin2
do
    if [ $verbose -gt 1 ]; then
        echo Pins _"$pin1"_ and _"$pin2"_
    fi
    gpionums+=(${pin1// /})
    gpionums+=(${pin2// /})
done < $1
IFS=$lastifs
if [ $verbose -gt 0 ]; then
    echo ${#gpionums[@]} pins: ${gpionums[@]}
fi
if [ ${#gpionums[@]} -eq 0 ]; then
    echo No GPIO pins were found in file $1
    exit 2
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
        exit 3
    fi
    echo in > /sys/class/gpio/gpio${i}/direction
done

# Save each input value for later comparison (read -after- setting all to inputs).
for i in ${gpionums[@]}; do
    gpiovals+=( $( cat /sys/class/gpio/gpio${i}/value ) )
done
if [ $verbose -gt 0 ]; then
    echo initial values: ${gpiovals[@]}
fi

# Loop through pairs of gpios that should be connected to each other
# (if the proper circuit is attached) and verify their connection to
# each other and isolation from the rest.
i=0
while [ $i -lt ${#gpionums[@]} ]; do
    if [ $verbose -gt 0 ]; then
        echo "------------------------------------------------"
        echo Testing gpio${gpionums[$i]} and gpio${gpionums[$i+1]}:
    fi

    current_values
    loopback_test $i $((i+1))
    current_values
    loopback_test $((i+1)) $i
    current_values

    i=$((i + 2))
done

if [ $verbose -gt 0 ]; then
    echo "------------------------------------------------"
fi

# Unexport gpio signals.
for i in ${gpionums[@]}; do
    if [ -e /sys/class/gpio/gpio${i} ]; then
        if [ $verbose -gt 1 ]; then
            echo Unexporting gpio${i}
        fi
        echo $i > /sys/class/gpio/unexport
    fi
done

# If any test errors were found then exit with the proper code.
if [ $numerrors -ne 0 ]; then
    exit 4
fi

echo GPIO tests passed.
