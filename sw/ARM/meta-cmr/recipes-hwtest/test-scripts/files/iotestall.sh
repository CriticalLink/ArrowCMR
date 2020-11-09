#! /bin/bash

# iotestall.sh
# Run GPIO loopback test on any FMC site where a test board is detected.
# Note that FMC1 and FMC2, and FMC3 and FMC4, are mutually exclusive
# because some signals are shared on different FMC pin numbers.
# Test scripts findboard.sh and iotest.sh are assumed to be in the path.
# GPIO pin files fmc?gpios are assumed to be in /usr/bin.

# Function to show the result from calling findboard.sh.
# Parameter $1 is the name of the board.
# Parameter $2 result code for that board.
# findboard.sh returns:
#   0 if given board is connected
#   1 if given board is not connected
#   2 if wrong board is connected
show_findboard_result () {
    case $2 in
        0) echo $1 board connected;;
        1) echo $1 no board detected;;
        2) echo $1 board connected;;
        *) echo $1 failure $2;;
    esac
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

# Show what's found at each connector.
show_findboard_result "FMC1" $fmc1
show_findboard_result "FMC2" $fmc2
show_findboard_result "FMC3" $fmc3
show_findboard_result "FMC4" $fmc4

# Test each connected board in turn.
if [ $fmc1 -ne 1 ]; then
    echo
    echo FMC1:
    iotest.sh /usr/bin/fmc1gpios
fi
if [ $fmc2 -ne 1 ]; then
    echo
    echo FMC2:
    iotest.sh /usr/bin/fmc2gpios
fi
if [ $fmc3 -ne 1 ]; then
    echo
    echo FMC3:
    iotest.sh /usr/bin/fmc3gpios
fi
if [ $fmc4 -ne 1 ]; then
    echo
    echo FMC4:
    iotest.sh /usr/bin/fmc4gpios
fi
