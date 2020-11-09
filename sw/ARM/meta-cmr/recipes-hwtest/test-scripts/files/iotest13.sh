#! /bin/bash

# iotest13.sh
# Run GPIO loopback test on FMC1 and FMC3.
# Make sure FMC1 and FMC3 test boards are present
# and no boards are connected at FMC2 and FMC4.
# Test script findboard.sh is assumed to be in the path.
# findboard.sh returns:
#   0 if given board is connected
#   1 if given board is not connected
#   2 if wrong board is connected

# Function to show the result from calling findboard.sh.
# Parameter $1 is the name of the board.
# Parameter $2 result code for that board.
# Parameter $3 expected result for that board.
show_findboard_result () {
    if [ $2 -ne $3 ]; then
        case $2 in
            0) echo $1 should be disconnected.;;
            1) echo $1 has no board detected.;;
            2) echo $1 has the incorrect board;;
            *) echo FMC$1 failure;;
        esac
    fi
}

# Check all four FMC connections.
(findboard.sh 1)
fmc1=$?
(findboard.sh 2)
fmc2=$?
(findboard.sh 3)
fmc3=$?
(findboard.sh 4)
fmc4=$?

#echo Result "$fmc1" "$fmc2" "$fmc3" "$fmc4"

# Because of the GPIO pin arrangement, FMC1 and FMC2 cannot be tested together
# and FMC3 and FMC4 cannot be tested together but one from each pair can.
if [ $fmc1 -eq 0 ] && [ $fmc3 -eq 0 ] && [ $fmc2 -eq 1 ] && [ $fmc4 -eq 1 ]; then
    echo Performing GPIO tests on both FMC1 and FMC3...
    echo FMC1:
    iotest.sh /usr/bin/fmc1gpios
    echo FMC3:
    iotest.sh /usr/bin/fmc3gpios
else
    echo Check the test board connections:
    show_findboard_result "FMC1" $fmc1 0
    show_findboard_result "FMC3" $fmc3 0
    show_findboard_result "FMC2" $fmc2 1
    show_findboard_result "FMC4" $fmc4 1
fi
