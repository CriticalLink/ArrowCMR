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

Building the demo application is done using the GNU Arm Embedded Toolchain from ARM,
available here

 https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads
 
 At the time of this writing, the project is being built with:
 https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2

It is important to note that the project requires the use of the hardware floating point unit in the MitySoM and therefore the compiler provided with the Intel Quartus tools is not sufficent.
You _must_ use a toolchain that supports the **-mfloat-abi=softfp** floating-point ABI and the **-mfpu=neon** fpu options.

The demo project is hosted on Critical Link LLC’s github <https://github.com/CriticalLink/ArrowCMR>

To build the demo app, follow these steps:

  - git clone <https://github.com/CriticalLink/ArrowCMR.git>

  - cd ArrowCMR/sw/ARM/bare-metal/

  - source the environment setup file ( environment_setup.sh )
  
  - make clean all

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


u-Boot environment variables:

The u-Boot variables shown below are not intended to show the complete u-Boot environment.... just the portion required to load and run this example.
The u-Boot application looks for a variable called bootcmd, and if set, it will run it to boot. For this demo exercise, the bootcmd simply
calls "run bm_exe". The bm_exe command makes sure the FPGA is loaded and then loads and executes the cmr.bin image from the SD card.

<pre>

autoload=no
axibridge=ffd0501c
axibridge_handoff=0x00000005
baudrate=115200
bm_exe=run mmcloadfpga; run fpgaload;flashled;fatload mmc 0:1 0x00100040 cmr.bin;go 0x00100040
bootcmd=run bm_exe
bootdelay=5
bridge_disable=mw $fpgaintf 0; mw $fpga2sdram 0; go $fpga2sdram_apply; mw $axibridge 0; mw $l3remap 0x1
bridge_enable_handoff=mw $fpgaintf ${fpgaintf_handoff}; go $fpga2sdram_apply; mw $fpga2sdram ${fpga2sdram_handoff}; mw $axibridge ${axibridge_handoff}; mw $l3remap ${l3remap_handoff}
clmodelnum=5CSX-H5-4YA-RI
ethact=mii0
ethaddr=c4:ff:bc:70:4b:b8
filesize=0x6aebe4
flashled=gpio set 40;gpio set 41;gpio set 42;gpio set 44;gpio clear 40; gpio clear 41; gpio clear 42; gpio clear 44;sleep .25;gpio set 40;gpio set 41;gpio set 42;gpio set 44
fpga=0
fpga2sdram=ffc25080
fpga2sdram_apply=3ff76598
fpga2sdram_handoff=0x00000000
fpgaintf=ffd08028
fpgaintf_handoff=0x00000000
fpgaload=run bridge_disable;fpga load 0 ${loadfpgaaddr} ${loadfpgasize}; run bridge_enable_handoff
ipaddr=10.0.37.4
l3remap=ff800000
l3remap_handoff=0x00000011
loadaddr=0x00100040
loadfdtaddr=0x00000100
loadfpgaaddr=0x2000000
loadfpgasize=0x700000
loadinitramfsaddr=0x3000000
loadkerneladdr=0xA000
mmcfatpart=1
mmcfpgaloc=/dev_5cs.rbf
mmcloadfpga=fatload mmc 0:${mmcfatpart} ${loadfpgaaddr} ${mmcfpgaloc}
mmcloadpart=2
mmcroot=/dev/mmcblk0p3
preboot=run setup_usb; ab1805 cs ${rtccal};run setup_eth
setup_eth=gpio clear 28;gpio set 28;gpio clear 28
setup_usb=gpio set 0
stderr=serial
stdin=serial
stdout=serial
verify=n

</pre>