#! /bin/bash

# I2C bus number on which the FMC boards are connected.
i2c_bus=1

# EEPROM I2C addresses for each FMC board.
fmc1_addr="0x50"
fmc2_addr="0x51"
fmc3_addr="0x52"
fmc4_addr="0x53"

# EEPROM address of the board ID string.
id_addr="0"

# Board ID string length.
id_len=4

# FMC board ID strings as stored in each board's EEPROM memory
# and as returned by using 'i2ctransfer' to read.
fmc1_id="0x46 0x4d 0x43 0x31"
fmc2_id="0x46 0x4d 0x43 0x32"
fmc3_id="0x46 0x4d 0x43 0x33"
fmc4_id="0x46 0x4d 0x43 0x34"

# Value that controls extra script output.
verbose=0

# Function that checks for the given board at the given I2C address.
# Parameter $1 is the board name.
# Parameter $2 is the expected board id string.
# Parameter $3 is the board memory I2C address.
# Paremeter $4 is the memory address of the id string.
# Parameter $5 is the length of the id string.
check_for_board () {
    if [ $verbose -gt 0 ]; then
        echo Checking for board $1:
    fi
    board_id=$(i2ctransfer -y 1 w"$i2c_bus"@"$3" "$4" r"$5" 2>&1)
    if [ $? -eq 0 ]; then
        if [ "$board_id" == "$2" ]; then
            echo $1 connected.
        else
            echo Error: $1 has the wrong board.
            if [ $verbose -gt 0 ]; then
                echo Board id = $board_id, expected $2
            fi
        fi
    else
        if [ $verbose -gt 0 ]; then
            echo $board_id
        fi
        echo $1 not found.
    fi
}

echo Running I2C test...

# Verify that each board is found at the expected I2C address.
if [ $verbose -gt 0 ]; then
    echo Checking for FMC boards...
fi
check_for_board "FMC1" "$fmc1_id" "$fmc1_addr" "$id_addr" "$id_len"
check_for_board "FMC2" "$fmc2_id" "$fmc2_addr" "$id_addr" "$id_len"
check_for_board "FMC3" "$fmc3_id" "$fmc3_addr" "$id_addr" "$id_len"
check_for_board "FMC4" "$fmc4_id" "$fmc4_addr" "$id_addr" "$id_len"

echo I2C test complete.
