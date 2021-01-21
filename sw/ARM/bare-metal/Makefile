#
# Copyright Altera 2013,2014
# All Rights Reserved.
# This is based on https://github.com/dwesterg/soc-workshop/blob/master/WS1-IntroToSoC/software/BareMetal_fft/Makefile

##QSYS_HDR := hps_0.h
##QSYS_HDR_DIR := qsys_headers

# check that user created qsys_headers output
##ifneq ($(QSYS_HDR_DIR)/$(QSYS_HDR), $(wildcard $(QSYS_HDR_DIR)/$(QSYS_HDR)))
##$(error Contents of '$(QSYS_HDR_DIR)' does not appear to exist. Did you run 'sopc-create-header-files' as instructed for this lab?)
##endif

SOCEDS_ROOT ?= $(SOCEDS_DEST_ROOT)
HWLIBS_ROOT = $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
FPGA_GENDIR:= D:/work/arrow/cmr/ArrowCMR/hw/fpga/cmr_motor_demo/software/preloader/generated
#FPGA_GENDIR:= $(realpath $(ROOT_DIR)/../../hw/fpga/cmr_motor_demo/software/preloader/generated)
ALT_DEVICE_FAMILY = soc_cv_av

# look for SoC EDS 15.0 directory structure
ifneq (,$(wildcard $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib/include/soc_cv_av/socal))
SOCAL_ROOT := $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib/include/soc_cv_av
endif

# look for SoC EDS 14.0 directory structure
ifneq (,$(wildcard $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib/include/socal))
SOCAL_ROOT := $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib/include
endif

ifndef SOCAL_ROOT
$(error SOCAL_ROOT is undefined)
endif

#C_SRC       := $(wildcard src/*/*.c) $(wildcard $(HWLIBS_ROOT)/src/hwmgr/*.c) $(wildcard $(HWLIBS_ROOT)/src/hwmgr/$(ALT_DEVICE_FAMILY)/*.c)
VPATH = $(HWLIBS_ROOT)/src/hwmgr:$(HWLIBS_ROOT)/src/hwmgr/$(ALT_DEVICE_FAMILY)
HWLIB_SRC = alt_16550_uart.c \
alt_generalpurpose_io.c \
alt_interrupt.c \
alt_clock_manager.c \


#alt_spi.c \

#$(ALT_DEVICE_FAMILY)/alt_bridge_manager.c \
#$(ALT_DEVICE_FAMILY)/alt_clock_manager_init.c \
#$(ALT_DEVICE_FAMILY)/alt_ecc.c \
#$(ALT_DEVICE_FAMILY)/alt_fpga_manager.c \
#$(ALT_DEVICE_FAMILY)/alt_reset_manager.c \
#$(ALT_DEVICE_FAMILY)/alt_sdram.c \
#$(ALT_DEVICE_FAMILY)/alt_system_manager.c \ 

#alt_globaltmr.c \
#alt_timers.c \
#alt_interrupt_armcc.s \
#alt_interrupt_armclang.s \
#alt_address_space.c \
#alt_cache.c \
#alt_can.c \
#alt_dma.c \
#alt_dma_program.c \
#alt_i2c.c \
#alt_mmu.c \
#alt_nand.c \
#alt_qspi.c \
#alt_sdmmc.c \
#alt_watchdog.c

C_SRC       := $(wildcard src/*/*.c) $(HWLIB_SRC)

LINKER_SCRIPT := cycloneV-dk-ram-modified.ld

MULTILIBFLAGS := -mcpu=cortex-a9 -mfloat-abi=softfp -mfpu=neon
#CFLAGS  := -g -O0 -Wall -Werror -std=c99 $(MULTILIBFLAGS) -I$(HWLIBS_ROOT)/include -I. -Imsgdma -Iqsys_headers -I$(SOCAL_ROOT) -I./include -I./bsp/include
CFLAGS  := -g -O2 -Wall -std=c99 $(MULTILIBFLAGS) -I$(HWLIBS_ROOT)/include -I. -Imsgdma -Iqsys_headers -I$(SOCAL_ROOT) -I./include -D$(ALT_DEVICE_FAMILY) -I$(FPGA_GENDIR)
LDFLAGS := -T$(LINKER_SCRIPT) $(MULTILIBFLAGS)

CROSS_COMPILE := arm-altera-eabi-
CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)g++
NM := $(CROSS_COMPILE)nm
OC := $(CROSS_COMPILE)objcopy
OD := $(CROSS_COMPILE)objdump
RM := rm -rf
CP := cp -f

ELF ?= cmr.axf
OBJ := $(patsubst %.c,%.o,$(C_SRC))
BIN = cmr.bin

.PHONY: all
all: $(BIN)
	$(info $$ROOT_DIR is [${ROOT_DIR}])
	$(info $$FPGA_GENDIR is [${FPGA_GENDIR}])

.PHONY: clean
clean:
	$(RM) $(ELF) $(OBJ) $(BIN)
	$(RM) *.map
	$(RM) *.objdump

%.c: $(HWLIBS_ROOT)/src/hwmgr/%.c
	$(CP) $< $@

$(OBJ): %.o: %.c Makefile $(QSYS_HDR_DIR)/$(QSYS_HDR)
	$(CC) $(CFLAGS) -c $< -o $@

$(ELF): $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o $@
	$(NM) $@ > $@.map
	$(OD) -d $@ > $@.objdump

$(BIN): $(ELF)
	$(OC) -O binary $(ELF) $(BIN)

