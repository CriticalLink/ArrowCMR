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

# Exit codes:
# 0 = Success
# 1 = No board found on the given FMC connector
# 2 = Wrong board found on the given FMC connector
# 3 = Other

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
            if [ $verbose -gt 0 ]; then
                echo $1 connected.
            fi
        else
            if [ $verbose -gt 0 ]; then
                echo Error: $1 has the wrong board.
                echo Board id = $board_id, expected $2
            fi
            exit 2
        fi
    else
        if [ $verbose -gt 0 ]; then
            echo $board_id
            echo Error: $1 not found.
        fi
        exit 1
    fi
}

if [ $# -ne 1 ]; then
    exit 3
fi

case $1 in
    1) name="FMC1"; id=$fmc1_id; addr=$fmc1_addr;;
    2) name="FMC2"; id=$fmc2_id; addr=$fmc2_addr;;
    3) name="FMC3"; id=$fmc3_id; addr=$fmc3_addr;;
    4) name="FMC4"; id=$fmc4_id; addr=$fmc4_addr;;
    *) if [ $verbose -gt 0 ]; then echo Invalid option; fi; exit 3;;
esac

if [ $verbose -gt 0 ]; then
    echo Looking for $name test board...
fi

check_for_board "$name" "$id" "$addr" "$id_addr" "$id_len"

if [ $verbose -gt 0 ]; then
    echo $name test board found.
fi
