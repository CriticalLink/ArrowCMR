# ArrowCMR
Repository for FPGA and ARM code for Arrow CMR development board

# CMR Bare Metal Application

This document contains details on how to modify, build and run the CMR bare metal demo app.
Build is supported on linux x86/x64 platforms 

The FPGA build is required to provide the preloader, bootloader, and FPGA pin mapping (done by the preloader).

## Tools

Install Intel Quartus Prime Standard Edition 18.0 or 18.1. 

Make sure to install the Soc FPGA Embedded Development Suite (File SoCEDSSetup...)

## Building the Software

The u-boot bootloader is used to load and execute user applications on
the MitySoM 5CSX platform. As the ARM CPU is integrated with the FPGA on
the CycloneV, building the preloader and u-boot is done as part of the
FPGA development process.

Building u-Boot and the preloader (note the correct MitySoM variant is
5CSX-H5-4YA) is detailed in the following wiki:

<https://support.criticallink.com/redmine/projects/mityarm-5cs/wiki/Building_u-Boot_and_Preloader>

Building the demo application is done using the quartus soc eds tools,
which are a part of the Quartus installation. The demo project is hosted
on Critical Link LLC’s github <https://github.com/CriticalLink/ArrowCMR>

To build the demo app, follow these steps (where QUARTUS\_DIR is the top
level quartus installation directory):

  - git clone <https://github.com/CriticalLink/ArrowCMR.git>

  - cd ArrowCMR/sw/ARM/bare-metal/

  - ${QUARTUS\_DIR}/embedded/embedded\_command\_shell.sh make

This will build cmr.bin, which you can copy to the SD card to load onto
the dev board.

## Building the FPGA

The FPGA image is also hosted on Critical Link LLC’s github
<https://github.com/CriticalLink/ArrowCMR>

To build the demo FPGA image, follow these steps(where QUARTUS\_DIR is
the top level quartus installation directory):

  - git clone <https://github.com/CriticalLink/ArrowCMR.git>

  - cd ArrowCMR/hw/fpga/cmr\_motor\_demo

  - ${QUARTUS\_DIR}/embedded/embedded\_command\_shell.sh make rbf

  - ${QUARTUS\_DIR}/embedded/embedded\_command\_shell.sh make uboot
    ubootenv

This will actually build 4 components that are required to boot.

| output\_files/dev\_5cs.rbf                  | FPGA bitstream file  |
| ------------------------------------------- | -------------------- |
| software/preloader/preloader-mkpimage.bin   | Preloader executable |
| software/preloader/uboot-socfpga/u-boot.img | u-boot executable    |
| software/preloader/ubootenv.bin             | u-boot environment   |

As the preloader is responsible for configuring the FPGA IO pins, you
will need to update this image if you change any IO assignments. You
will only need to rebuild uboot if you are adding functionality to it.
The same is true for the ubootenv target, the default setup will load
cmr.bin from the FAT filesystem. If you change the executable name or
want to change other boot settings, this target will update the binary
uboot environment file, which you can reload onto the sd card.


# Installing

Power off the system, remove the SD card and insert into a PC SD card reader.

Copy cmr.bin to the FAT parition

Eject/unmount and put SD back into CMR board

Boot the system


# Running

The SD card u-boot environment has been configured to boot directly into the CMR app. If you need to change the runtime environment:
When the system is booting break into u-boot by pressing any key when the
 "Hit any key to stop autoboot:" countdown begins.

