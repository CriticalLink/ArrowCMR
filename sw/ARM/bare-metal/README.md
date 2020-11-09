# CMR Bare Metal Application

This document contains details on how to modify, build and run the CMR bare 
 metal.

## Tools

Install Intel Quartus Prime Standard Edition 18.0 or 18.1. 

Install files can be found on shared (e.g. /shared/tools/altera/Quartus/Quartus_18.0_linux).

Make sure to install the Soc FPGA Embedded Development Suite (File SoCEDSSetup...)


# Building

Make sure you are in the Embedded Command Shell:
* On Linux the command will be "~/intelFPGA/18.0/embedded/embedded_command_shell.sh"
* *TODO*: add details on how to launch Embedded Command Shell in Windows...

Run "make" in directory trunk/sw/MityDSP/bare-metal


# Installing

Option 1:

Allow the system to boot into Linux

Mount the FAT parition with command "mount /dev/mmcblk0p1 /media/boot/"

Copy cmr.bin to /media/boot

Reboot the system and break into u-boot


Option 2:

Power off the system, remove the SD card and insert into a PC SD card reader.

Copy cmr.bin to the 268 MB FAT parition

Eject/unmount and put SD back into CMR board

Boot the system and break into u-boot


# Running

When the system is booting break into u-boot by pressing any key when the
 "Hit any key to stop autoboot:" countdown begins.

If this is the first time running the bare metal application you will need to
 setup a command to launch the bare metal application by running the following
 commands:
* setenv bm_exe "run mmcloadfpga; run fpgaload; fatload mmc 0:1 0x00100040 cmr.bin; go 0x00100040"
* saveenv

Start the application with the followig command:
* run bm_exe

