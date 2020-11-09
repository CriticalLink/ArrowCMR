#! /bin/bash

usedriver=1

if [ $usedriver -eq 1 ]; then
    # This driver returns temperature as Celsius x1000.
    t=$(cat /sys/class/hwmon/hwmon0/temp1_input)
    if [ $? -eq 0 ]; then
        # Adjust Celsius for 1000x multiplier and convert to Fahrenheit.
        dc=$(echo "scale=2; $t / 1000" | bc)
        df=$(echo "scale=2; $dc * 9 / 5 + 32" | bc)
        echo $dc" deg C ("$df" deg F)"
    else
        echo "Unable to read temperature"
    fi
else
    # Read 10-bit Celsius temperature value directly via I2C.
    # Value is signed with 2 fractional bits.
    t=$(i2cget -y 3 0x49 0 w)
    if [ $? -eq 0 ]; then
        # Swap the bytes (i2cget has 2nd byte first) and keep just the 10 data bits.
        t=$(((($t % 256) << 2) + ($t >> 14)))
        # Make value negative, if necessary.
        if [ $t -ge 512 ]; then
            t=$(($t - 1024))
        fi
        # Adjust Celsius value for fraction, and convert to Fahrenheit.
        dc=$(echo "scale=2; $t / 4" | bc)
        df=$(echo "scale=2; $dc * 9 / 5 + 32" | bc)
        echo $dc" deg C ("$df" deg F)"
    else
        echo "Unable to read temperature"
    fi
fi
