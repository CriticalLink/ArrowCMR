#! /bin/bash

# iotest24.sh
# Run GPIO loopback test on FMC2 and FMC4.
# Make sure FMC2 and FMC4 test boards are present
# and no boards are connected at FMC1 and FMC3.
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
if [ $fmc2 -eq 0 ] && [ $fmc4 -eq 0 ] && [ $fmc1 -eq 1 ] && [ $fmc3 -eq 1 ]; then
    echo Performing GPIO tests on both FMC2 and FMC4...
    echo FMC2:
    iotest.sh /usr/bin/fmc2gpios
    echo FMC4:
    iotest.sh /usr/bin/fmc4gpios
else
    echo Check the test board connections:
    show_findboard_result "FMC2" $fmc2 0
    show_findboard_result "FMC4" $fmc4 0
    show_findboard_result "FMC1" $fmc1 1
    show_findboard_result "FMC3" $fmc3 1
fi
