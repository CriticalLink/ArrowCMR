################################################
#
# Makefile to Manage QuartusII/QSys Design
#
# Copyright Altera (c) 2016
# All Rights Reserved
#
################################################

SHELL := /bin/bash

# Delete the default suffixes
.SUFFIXES:

# enable/disable timing check
DO_TIMING_CHECK := 1

# disable timing check if the file is missing
ifeq ($(wildcard check_timing.tcl),)
DO_TIMING_CHECK := 0
endif

################################################

# Project directory structure
SOFTWARE_DIR := software
PRELOADER_DIR := $(SOFTWARE_DIR)/preloader
HEADER_DIR  := $(SOFTWARE_DIR)/headers

################################################

# Tools
CAT := cat
CD := cd
CHMOD := chmod
CP := cp -rf
ECHO := echo
DATE := date
FIND := find
GREP := grep
HEAD := head
MKDIR := mkdir -p
MV := mv
RM := rm -rf
SED := sed
TAR := tar
TOUCH := touch
WHICH := which

# Helpful Macros
SPACE := $(empty) $(empty)

ifndef COMSPEC
ifdef ComSpec
COMSPEC = $(ComSpec)
endif # ComSpec
endif # COMSPEC

ifdef COMSPEC # if Windows OS
IS_WINDOWS_HOST := 1
endif

ifeq ($(IS_WINDOWS_HOST),1)
ifneq ($(shell $(WHICH) cygwin1.dll 2>/dev/null),)
IS_CYGWIN_HOST := 1
endif
endif

ifneq ($(shell $(WHICH) quartus 2>/dev/null),)
HAVE_QUARTUS := 1
endif

ifeq ($(HAVE_QUARTUS),1)
HAVE_QSYS := 1
endif

#<unused>
#ifneq ($(shell $(WHICH) quartus_pgm 2>/dev/null),)
#HAVE_QUARTUS_PGM := 1
#endif

################################################


################################################
#
# Design Settings
#  If you change any design settings, you need 
#  to run "make scrub_clean" followed by
#  "make generate_from_tcl" for the settings
#  to be applied.
#
SOM_MODEL := 5csx-h6-4ya


qsys_args = --cmd="set DEVICE_TYPE $(1); set HPS_DDR_D_SIZE $(2); set HPS_DDR_A_SIZE $(3); set HPS_DDR_NUM_CHIPS $(4); set FPGA_DDR_A_SIZE $(5); set HPS_CLK_RATE $(6)"
quartus_args = DEVICE_TYPE $(1) HPS_DDR_D_SIZE $(2) HPS_DDR_A_SIZE $(3) HPS_DDR_NUM_CHIPS $(4) FPGA_DDR_A_SIZE $(5) EXPANDEDIO $(6)


ifeq ($(SOM_MODEL),5cse-h4-3ya)
RBF_NAME := dev_5cse_h4_3ya
DTS_NAME := mitysom5cse-h4-3ya
QSYS_TCL_ARGS := $(call qsys_args,'5CSEBA4U23I7',40,15,5,0,800.0)
QUARTUS_TCL_ARGS := $(call quartus_args,'5CSEBA4U23I7',40,15,5,0,1)

else ifeq ($(SOM_MODEL),5cse-h4-8ya)
RBF_NAME := dev_5cse_h4_8ya
DTS_NAME := mitysom5cse-h4-8ya
QSYS_TCL_ARGS := $(call qsys_args,'5CSEBA4U23I7',40,15,5,0,800.0)
QUARTUS_TCL_ARGS := $(call quartus_args,'5CSEBA4U23I7',40,15,5,0,1)

else ifeq ($(SOM_MODEL),5cse-l2-3y8)
RBF_NAME := dev_5cse_l2_3y8
DTS_NAME := mitysom5cse
QSYS_TCL_ARGS := $(call qsys_args,'5CSEBA2U23C8S',16,15,2,0,600.0)
QUARTUS_TCL_ARGS := $(call quartus_args,'5CSEBA2U23C8S',16,15,2,0,1)

else ifeq ($(SOM_MODEL),5csx-h5-4ya)
RBF_NAME := dev_5csx_h5_4ya
DTS_NAME := mitysom5csx-h6-4ya
QSYS_TCL_ARGS := $(call qsys_args,'5CSXFC5C6U23C7',40,15,5,0,800.0)
QUARTUS_TCL_ARGS := $(call quartus_args,'5CSXFC5C6U23C7',40,15,5,0,1)

else ifeq ($(SOM_MODEL),5csx-h6-42a)
RBF_NAME := dev_5csx_h6_42a
DTS_NAME := mitysom5csx
QSYS_TCL_ARGS := $(call qsys_args,'5CSXFC6C6U23C7',40,15,5,15,800.0)
QUARTUS_TCL_ARGS := $(call quartus_args,'5CSXFC6C6U23C7',40,15,5,15,0)

else ifeq ($(SOM_MODEL),5csx-h6-4ya)
RBF_NAME := dev_5csx_h6_4ya
DTS_NAME := mitysom5csx-h6-4ya
QSYS_TCL_ARGS := $(call qsys_args,'5CSXFC6C6U23C7',40,15,5,0,800.0)
QUARTUS_TCL_ARGS := $(call quartus_args,'5CSXFC6C6U23C7',40,15,5,0,1)

else ifeq ($(SOM_MODEL),5csx-h6-53b)
RBF_NAME := dev_5csx_h6_53b
DTS_NAME := mitysom5csx-h6-53b
QSYS_TCL_ARGS := $(call qsys_args,'5CSXFC6C6U23C7',40,16,5,16,800.0)
QUARTUS_TCL_ARGS := $(call quartus_args,'5CSXFC6C6U23C7',40,16,5,16,0)

else
$(error ERROR: SOM model number not supported: $(SOM_MODEL))
endif

################################################


################################################
.PHONY: default
default: help
################################################


################################################
.PHONY: all
all: preloader uboot ubootenv dts dtb

ifeq ($(HAVE_QUARTUS),1)
all: sof rbf
endif
################################################


################################################
# Target Stamping

SOCEDS_VERSION := $(if $(wildcard $(SOCEDS_DEST_ROOT)/version.txt),$(shell $(CAT) $(SOCEDS_DEST_ROOT)/version.txt 2>/dev/null | $(GREP) Version | $(HEAD) -n1 | $(SED) -e 's,^Version[: \t=]*\([0-9.]*\).*,\1,g' 2>/dev/null))

define get_stamp_dir
stamp$(if $(SOCEDS_VERSION),/$(SOCEDS_VERSION))
endef

define get_stamp_target
$(get_stamp_dir)$(if $1,/$1.stamp,$(error ERROR: Arg 1 missing to $0 function))
endef

define stamp_target
@$(MKDIR) $(@D)
@$(TOUCH) $@
endef

################################################


################################################
# Archiving & Cleaning your QuartusII/QSys Project

AR_TIMESTAMP := $(if $(SOCEDS_VERSION),$(subst .,_,$(SOCEDS_VERSION))_)$(subst $(SPACE),,$(shell $(DATE) +%m%d%Y_%k%M%S))
AR_DIR := tgz
AR_FILE := $(AR_DIR)/$(basename $(firstword $(wildcard *.qpf)))_$(AR_TIMESTAMP).tar.gz
AR_FILTER_OUT += %_tb.qsys
AR_REGEX += \
	Makefile ip readme.txt README ds5 \
	altera_avalon* *.qpf *.qsf *.sdc *.v *.sv *.vhd *.qsys *.tcl *.terp *.stp \
	*.sed quartus.ini *.sof *.rbf *.sopcinfo *.jdi output_files \
	hps_isw_handoff */*.svd */synthesis/*.svd */synth/*.svd *.dts *.dtb *.xml \
	COPYING *.sh *.xlsm ip_cores \
	$(SOFTWARE_DIR)

################################################


################################################
# Build QuartusII/QSys Project
#

#############
# QSys

QSYS_FILE := $(firstword $(wildcard *top*.qsys) $(wildcard dev_*.qsys) $(wildcard *main*.qsys) $(wildcard *soc*.qsys) $(wildcard *.qsys))

OTHER_QSYS_FILES :=

QSYS_FILES += $(QSYS_FILE_TOP) $(OTHER_QSYS_FILES)

ifeq ($(QSYS_FILE),)
$(error ERROR: QSYS_FILE *.qsys file not set and could not be discovered)
endif

QSYS_DEPS += $(wildcard *.qsys)
QSYS_BASE := $(basename $(QSYS_FILE))
QSYS_QIP := $(wildard $(QSYS_BASE)/synthesis/$(QSYS_BASE).qip) $(wildcard $(QSYS_BASE)/$(QSYS_BASE).qip)
QSYS_SOPCINFO := $(QSYS_BASE).sopcinfo
QSYS_STAMP := $(call get_stamp_target,qsys)

# Under cygwin, ensure TMP env variable is not a cygwin style path
# before calling ip-generate
ifeq ($(IS_CYGWIN_HOST),1)
ifneq ($(shell $(WHICH) cygpath 2>/dev/null),)
SET_QSYS_GENERATE_ENV = TMP="$(shell cygpath -m "$(TMP)")"
endif
endif

SCRUB_CLEAN_FILES += $(wildcard .qsys_edit)
ifeq ($(HAVE_QSYS),1)
SCRUB_CLEAN_FILES += $(QSYS_QIP) $(QSYS_SOPCINFO) $(QSYS_BASE) 
endif

HELP_TARGETS += qsys_edit
qsys_edit.HELP := Launch QSys GUI.
ifneq ($(HAVE_QSYS),1)
qsys_edit.HELP := $(qsys_edit.HELP) (Install Quartus II Software to enable)
endif

.PHONY: qsys_compile
qsys_compile: $(QSYS_STAMP)

ifeq ($(HAVE_QSYS),1)
$(QSYS_SOPCINFO) $(QSYS_QIP): $(QSYS_STAMP)
endif

$(QSYS_STAMP): $(QSYS_DEPS)
	$(SET_QSYS_GENERATE_ENV) qsys-generate $(QSYS_FILE) --synthesis=VHDL $(QSYS_GENERATE_ARGS)
	$(stamp_target)

.PHONY: qsys_edit
qsys_edit:
	qsys-edit $(QSYS_FILE) &

#############
# Quartus II

QUARTUS_QPF := $(firstword $(wildcard *.qpf))
ifeq ($(QUARTUS_QPF),)
$(error ERROR: QUARTUS_QPF *.qpf file not set and could not be discovered)
endif

QUARTUS_QSF := $(patsubst %.qpf,%.qsf,$(QUARTUS_QPF))
QUARTUS_BASE := $(basename $(QUARTUS_QPF))
QUARTUS_HDL_SOURCE := $(wildcard *.v *.sv *.vhd)
QUARTUS_MISC_SOURCE := $(wildcard *.stp *.sdc)
QUARTUS_PIN_ASSIGNMENTS_STAMP := $(call get_stamp_target,quartus_pin_assignments)
QUARTUS_DEPS += $(QUARTUS_QPF) $(QUARTUS_QSF) $(QUARTUS_HDL_SOURCE) $(QUARTUS_MISC_SOURCE) $(QSYS_STAMP) $(QSYS_QIP) $(QUARTUS_PIN_ASSIGNMENTS_STAMP)
QUARTUS_STAMP := $(call get_stamp_target,quartus)

HELP_TARGETS += quartus_edit
quartus_edit.HELP := Launch Quartus II GUI.
ifneq ($(HAVE_QUARTUS),1)
quartus_edit.HELP := $(quartus_edit.HELP) (Install Quartus II Software to enable)
endif

ifeq ($(DO_TIMING_CHECK),1)
QUARTUS_DEPS += check_timing.tcl
endif

.PHONY: quartus_compile
quartus_compile: $(QUARTUS_STAMP)

$(QUARTUS_PIN_ASSIGNMENTS_STAMP): $(QSYS_STAMP)
	quartus_map $(QUARTUS_QPF)
	quartus_cdb --merge $(QUARTUS_QPF)
	#$(MAKE) quartus_apply_tcl_pin_assignments QUARTUS_ENABLE_PIN_ASSIGNMENTS_APPLY=1
	$(stamp_target)

$(QUARTUS_STAMP): $(QUARTUS_DEPS)
	quartus_stp $(QUARTUS_BASE)
	quartus_sh --flow compile $(QUARTUS_QPF)
ifeq ($(DO_TIMING_CHECK),1)
	quartus_sh -t check_timing.tcl -project $(QUARTUS_BASE)
endif
	$(stamp_target)

.PHONY: quartus_edit
quartus_edit:
	quartus $(QUARTUS_QPF) &

################################################


################################################
# SOF

BATCH_TARGETS += sof
HELP_TARGETS += sof
sof.HELP := QSys generate & Quartus compile.
ifneq ($(HAVE_QUARTUS),1)
sof.HELP := $(sof.HELP) (Install Quartus II Software to enable)
endif
QUARTUS_SOF := output_files/$(QUARTUS_BASE).sof

.PHONY: sof
sof: $(QUARTUS_SOF)

ifeq ($(HAVE_QUARTUS),1)
$(QUARTUS_SOF): $(QUARTUS_STAMP)
endif


#######
# we need to recursively call this makefile to 
# apply *_pin_assignments.tcl script because the
# pin_assignment.tcl files may not exist yet 
# when makefile was originally called
ifeq ($(QUARTUS_ENABLE_PIN_ASSIGNMENTS_APPLY),1)
QUARTUS_TCL_PIN_ASSIGNMENTS = $(wildcard $(QSYS_BASE)/synthesis/submodules/*_pin_assignments.tcl) $(wildcard $(QSYS_BASE)/synth/submodules/*_pin_assignments.tcl)
QUARTUS_TCL_PIN_ASSIGNMENTS_APPLY_TARGETS = $(patsubst %,quartus_apply_tcl-%,$(QUARTUS_TCL_PIN_ASSIGNMENTS))

.PHONY: quartus_apply_tcl_pin_assignments
quartus_apply_tcl_pin_assignments: $(QUARTUS_TCL_PIN_ASSIGNMENTS_APPLY_TARGETS)

.PHONY: $(QUARTUS_TCL_PIN_ASSIGNMENTS_APPLY_TARGETS)
$(QUARTUS_TCL_PIN_ASSIGNMENTS_APPLY_TARGETS): quartus_apply_tcl-%: %
	@$(ECHO) "Applying $<... to $(QUARTUS_QPF)..."
	quartus_sta -t $< $(QUARTUS_QPF)

endif # QUARTUS_ENABLE_PIN_ASSIGNMENTS_APPLY == 1
######

################################################


################################################
# RBF

# This converts the sof into compressed, unencrypted 
# raw binary format corresponding to MSEL value of 8 
# in the FPGAMGRREGS_STAT register. If you read the 
# the whole register, it should be 0x50.
#
# CVSoC DevBoard SW1 MSEL should be set to up,down,up,down,up,up

HELP_TARGETS += rbf
rbf.HELP := Convert SOF to RBF.
QUARTUS_RBF := $(patsubst %.sof,%.rbf,$(QUARTUS_SOF))
QUARTUS_CPF_ENABLE_COMPRESSION ?= 0

ifeq ($(QUARTUS_CPF_ENABLE_COMPRESSION),1)
QUARTUS_CPF_ARGS += -o bitstream_compression=on
endif

ifeq ($(HAVE_QUARTUS),1)
SCRUB_CLEAN_FILES += $(QUARTUS_SOF) $(QUARTUS_RBF) output_files hps_isw_handoff
endif

.PHONY: rbf
rbf: $(QUARTUS_RBF)

$(QUARTUS_RBF): %.rbf: %.sof
	quartus_cpf -c $(QUARTUS_CPF_ARGS) $< $@

ifeq ($(HAVE_QUARTUS),1)
$(QUARTUS_RBF): $(QUARTUS_STAMP)
endif

.PHONY: create_rbf
create_rbf:
	quartus_cpf -c $(QUARTUS_CPF_ARGS) $(QUARTUS_SOF) $(QUARTUS_RBF)

.PHONY: generate_headers
generate_headers:
	@$(RM) $(HEADER_DIR)
	@$(MKDIR) $(HEADER_DIR)
	sopc-create-header-files --output-dir $(HEADER_DIR)
	@cat $(HEADER_DIR)/$(QSYS_BASE).h |grep HPS_0_ARM_A9_0_ | grep BASE|grep 0xff2|sed -e 's/HPS_0_ARM_A9_0_//g' > $(HEADER_DIR)/fpga_registers.h

################################################


################################################
# Device Tree Source (dts)

#DTS.BOARDINFO ?= $(QSYS_BASE)_board_info.xml
#DTS.COMMON ?= hps_common_board_info.xml
DTS.DTC := dtc
#DTS.EXTRA_DEPS += $(DTS.BOARDINFO) $(DTS.COMMON)
DTS.SOPC2DTS := sopc2dts
#DTS.SOPC2DTS_ARGS += $(if $(DTS.BOARDINFO),--board $(DTS.BOARDINFO))
#DTS.SOPC2DTS_ARGS += $(if $(DTS.COMMON),--board $(DTS.COMMON))
DTS.SOPC2DTS_ARGS += --bridge-removal all
DTS.SOPC2DTS_ARGS += --clocks

define dts.sopc2dts
$(if $(DTS.BOARDINFO),,$(warning WARNING: DTS BoardInfo file was not specified or found))
$(DTS.SOPC2DTS) --input $1 --output $2 $3 $(DTS.SOPC2DTS_ARGS)
endef

HELP_TARGETS += dts
dts.HELP := Generate a device tree source for this QSYS design.
DEVICE_TREE_SOURCE := $(patsubst %.sopcinfo,%.dts,$(QSYS_SOPCINFO))
SCRUB_CLEAN_FILES += $(DEVICE_TREE_SOURCE)

.PHONY: dts
dts: $(DEVICE_TREE_SOURCE)

ifeq ($(HAVE_QSYS),1)
$(DEVICE_TREE_SOURCE): $(QSYS_STAMP)
endif

$(DEVICE_TREE_SOURCE): %.dts: %.sopcinfo #$(DTS.EXTRA_DEPS)
	$(call dts.sopc2dts,$<,$@)

################################################


################################################
# Device Tree Blob (dtb)

HELP_TARGETS += dtb
dtb.HELP := Generate a device tree blob for this QSYS design.
DEVICE_TREE_BLOB := $(patsubst %.sopcinfo,%.dtb,$(QSYS_SOPCINFO))
SCRUB_CLEAN_FILES += $(DEVICE_TREE_BLOB)

.PHONY: dtb
dtb: $(DEVICE_TREE_BLOB)

ifeq ($(HAVE_QSYS),1)
$(DEVICE_TREE_BLOB): $(QSYS_STAMP)
endif

$(DEVICE_TREE_BLOB): %.dtb: %.dts
	$(DTS.DTC) -I dts -O dtb -o $@ $<

################################################


################################################
# Quartus Programming

QUARTUS_PGM_STAMP := $(call get_stamp_target,quartus_pgm)

# set these for your board
# BOARD_CABLE =

# FPGA Board Device Index. Default to 2 since this is the most
#  common setting for dev board
# For SoCKIT board, this should be set to 1
BOARD_DEVICE_INDEX ?= 2

define quartus_pgm_sof
jtagconfig
quartus_pgm --mode=jtag $(if $(BOARD_CABLE),--cable="$(BOARD_CABLE)") --operation=p\;$1$(if $(BOARD_DEVICE_INDEX),"@$(BOARD_DEVICE_INDEX)")
jtagconfig $(if $(BOARD_CABLE),-c "$(BOARD_CABLE)") -n
endef

.PHONY: pgm
pgm: $(QUARTUS_PGM_STAMP)

$(QUARTUS_PGM_STAMP): $(QUARTUS_SOF)
	$(call quartus_pgm_sof,$<)
	$(stamp_target)

HELP_TARGETS += program_fpga
program_fpga.HELP := Quartus program SOF to your attached dev board.

.PHONY: program_fpga
program_fpga:
	$(call quartus_pgm_sof,$(QUARTUS_SOF))

# HPS Device Index. Default to 1 since this is the most
#  common setting for dev board
BOARD_HPS_DEVICE_INDEX ?= 1

define quartus_hps_pgm_qspi
jtagconfig
quartus_hps $(if $(BOARD_CABLE),--cable="$(BOARD_CABLE)") $(if $(BOARD_HPS_DEVICE_INDEX),--device=$(BOARD_HPS_DEVICE_INDEX)) --operation=PV $1
endef

HELP_TARGETS += program_qspi
program_qspi.HELP := Flash program preloader into QSPI flash.

.PHONY: program_qspi
program_qspi: $(PRELOADER_DIR)/preloader-mkpimage.bin
	$(call quartus_hps_pgm_qspi,$<)

# GHRD HPS Reset Targets
ifneq ($(wildcard ghrd_reset.tcl),)
# use the already programmed fpga to reset the hps
HPS_RESET_TARGETS := hps_cold_reset hps_warm_reset hps_debug_reset

.PHONY: $(HPS_RESET_TARGETS) 
$(HPS_RESET_TARGETS): hps_%_reset:
	quartus_stp --script=ghrd_reset.tcl $(if $(BOARD_CABLE),--cable-name "$(BOARD_CABLE)") $(if $(BOARD_DEVICE_INDEX),--device-index "$(BOARD_DEVICE_INDEX)") --$*-reset
endif

################################################


################################################
# QSYS/Quartus Project Generation

#  - we don't run this generation step automatically because 
#    it will destroy any changes and/or customizations that 
#    you've made to your qsys or your quartus project

QSYS_QSYS_GEN := $(firstword $(wildcard create_*_qsys.tcl))
QUARTUS_TOP_GEN := $(firstword $(wildcard create_*_top.tcl))
QUARTUS_QSF_QPF_GEN := $(firstword $(wildcard create_*_quartus.tcl))

.PHONY: quartus_generate_qsf_qpf
ifneq ($(QUARTUS_QSF_QPF_GEN),)
quartus_generate_qsf_qpf: $(QUARTUS_QSF_QPF_GEN)
	$(RM) $(QUARTUS_QSF) $(QUARTUS_QPF)
	quartus_sh --script=$< $(QUARTUS_TCL_ARGS)
else
quartus_generate_qsf_qpf:
	@$(ECHO) "Make target '$@' is not supported for this design"
endif

.PHONY: quartus_generate_top
ifneq ($(QUARTUS_TOP_GEN),)
quartus_generate_top: $(QUARTUS_TOP_GEN)
	@$(RM) *_top.v
	quartus_sh --script=$< $(QUARTUS_TCL_ARGS)
else
quartus_generate_top:
	@$(ECHO) "Make target '$@' is not supported for this design"
endif

.PHONY: qsys_generate_qsys
ifneq ($(QSYS_QSYS_GEN),)

# Note that this target has a strange & known issue 
# that requires the Stratix V device family to be installed.
# If the stratix V device family is not installed then the target 
# will hang. This issue will hopefully be resolved in a future
# version of quartus/qsys.

qsys_generate_qsys: $(QSYS_QSYS_GEN)
	$(RM) $(QSYS_FILE)
	qsys-script --script=$< $(QSYS_TCL_ARGS)
else
qsys_generate_qsys:
	@$(ECHO) "Make target '$@' is not supported for this design"
endif

HELP_TARGETS += generate_from_tcl
generate_from_tcl.HELP := Delete and regenerate the Quartus Project source files from tcl script source

.PHONY: generate_from_tcl
generate_from_tcl:
	$(MAKE) -s scrub_clean
	$(MAKE) quartus_generate_qsf_qpf quartus_generate_top qsys_generate_qsys ubootenvtxt

################################################


################################################
# Preloader

QSYS_HPS_INST_NAME ?= hps_0

HELP_TARGETS += preloader
preloader.HELP := Build preloader BSP into '$(PRELOADER_DIR)'.
PRELOADER := $(PRELOADER_DIR)/preloader-mkpimage.bin
PRELOADER_MAKEFILE := $(PRELOADER_DIR)/Makefile
PRELOADER_ID := hps_isw_handoff/$(QSYS_BASE)_$(QSYS_HPS_INST_NAME)/id
PRELOADER_DEPS += $(PRELOADER_ID)
PRELOADER_EXTRA_ARGS += --set spl.PRELOADER_TGZ uboot-socfpga.tar.gz

UBOOT_REPO := git://support.criticallink.com/home/git/u-boot-socfpga.git
UBOOT_BRANCH := socfpga_v2013.01.01
UBOOT_TAR := $(PRELOADER_DIR)/uboot-socfpga.tar.gz

SBT.CREATE_SETTINGS := bsp-create-settings
#SBT.GENERATE := bsp-generate-files

# If enabled, ...
PRELOADER_DISABLE_WATCHDOG ?= 1
ifeq ($(PRELOADER_DISABLE_WATCHDOG),1)
PRELOADER_EXTRA_ARGS += --set spl.boot.WATCHDOG_ENABLE false
endif

# If enabled, we should scrub all 1GB of DDR. This may be overkill
PRELOADER_ENABLE_ECC_SCRUBBING ?= 1
ifeq ($(PRELOADER_ENABLE_ECC_SCRUBBING),1)
PRELOADER_EXTRA_ARGS += --set spl.boot.SDRAM_SCRUBBING true
endif

ifeq ($(HAVE_QUARTUS),1)
PRELOADER_DEPS += $(QUARTUS_STAMP)
$(PRELOADER_ID): $(QUARTUS_STAMP) 
endif

.PHONY: preloader
preloader: $(PRELOADER)

# Create and build preloader with watchdog disabled.
# This is useful for board bring up and troubleshooting.
$(PRELOADER): $(PRELOADER_DEPS)
	@$(MKDIR) $(PRELOADER_DIR)
	$(SBT.CREATE_SETTINGS) \
		--type spl \
		--bsp-dir $(PRELOADER_DIR) \
		--preloader-settings-dir "hps_isw_handoff/$(QSYS_BASE)_$(QSYS_HPS_INST_NAME)" \
		--settings $(PRELOADER_DIR)/settings.bsp \
		$(PRELOADER_EXTRA_ARGS)
	$(SED) -i 's/socfpga_\$$(DEVICE_FAMILY)/mitysom-5csx/' $(PRELOADER_MAKEFILE)
	$(SED) -i 's/altera\/socfpga/cl\/mitysom-5csx/' $(PRELOADER_MAKEFILE)
	git archive --format=tar.gz --prefix=uboot-socfpga/ --remote=$(UBOOT_REPO) $(UBOOT_BRANCH) >$(UBOOT_TAR)
	$(MAKE) -C $(PRELOADER_DIR)

################################################


################################################
# U-Boot

ifeq ($(IS_WINDOWS_HOST),1)
EXE_EXT := .exe
endif

HELP_TARGETS += uboot
uboot.HELP := Build U-Boot into '$(PRELOADER_DIR)'.
UBOOT := $(PRELOADER_DIR)/uboot-socfpga/u-boot.img
MKENVIMAGE := $(PRELOADER_DIR)/uboot-socfpga/tools/mkenvimage$(EXE_EXT)

.PHONY: uboot
uboot: $(UBOOT)

$(UBOOT): $(PRELOADER)
	$(MAKE) -C $(PRELOADER_DIR) uboot

################################################


################################################
# U-Boot Environemnt

HELP_TARGETS += ubootenv
ubootenv.HELP := Build U-Boot environment from 'uBootMMCEnv.txt'.
UBOOTENV := $(PRELOADER_DIR)/ubootenv.bin
UBOOTENV_RAW := $(PRELOADER_DIR)/uBootMMCEnv.txt.orig
UBOOTENV_TXT := $(PRELOADER_DIR)/uBootMMCEnv.txt

DONT_SCRUB_CLEAN_FILES += $(UBOOTENV_RAW)

.PHONY: ubootenv
ubootenv: $(UBOOTENV)

$(UBOOTENV): $(MKENVIMAGE) $(UBOOTENV_TXT)
	$(MKENVIMAGE) -s 4096 -o $(UBOOTENV) $(UBOOTENV_TXT)

$(MKENVIMAGE): $(UBOOT)

ubootenvtxt: $(UBOOTENV_RAW)
	$(SED) "s/mitysom5csx/$(DTS_NAME)/" $(UBOOTENV_RAW) >$(UBOOTENV_TXT)
	$(SED) -i "s/dev_5csx_h6_42a/$(RBF_NAME)/" $(UBOOTENV_TXT)
ifeq ($(SOM_MODEL),5csx-h6-53b)
	$(SED) -i "s/\(qspiinitfsramsize=0x\)1000000/\12000000/" $(UBOOTENV_TXT)
	$(ECHO) "intrid_high=0x20000000" >>$(UBOOTENV_TXT)
endif

################################################


################################################
# Create SD Card Image

HELP_TARGETS += sd_image
sd_image.HELP := Build an SD card image in '$(PRELOADER_DIR)'. Edit the top of this Makefile to change settings.
SD_IMAGE := $(PRELOADER_DIR)/sd_card.img
SD_SCRIPT := $(PRELOADER_DIR)/make_sd.sh
SD_DEVICE := CycloneV
SD_EXTRA_ARGS := 
FILESYSTEM_TAR := $(PRELOADER_DIR)/mitysom-image-base-mitysom-c5.tar.gz
DONT_SCRUB_CLEAN_FILES += $(SD_SCRIPT) $(FILESYSTEM_TAR)

.PHONY: sd_image
sd_image: $(SD_IMAGE)

$(SD_IMAGE): $(PRELOADER) $(UBOOT) $(UBOOTENV) $(RBF)
ifeq ($(wildcard $(SD_SCRIPT)),)
        echo "Missing script: '$(PRELOADER_DIR)/make_sd.sh'"
else ifeq ($(wildcard $(FILESYSTEM_TAR)),)
        echo "Missing filesystem tarball: '$(FILESYSTEM_TAR)'"
else
        ./$(SD_SCRIPT) -d $(SD_DEVICE) -p $(PRELOADER) -u $(UBOOT) -e $(UBOOTENV) -f $(QUARTUS_RBF) -o $(SD_IMAGE) $(SD_EXTRA_ARGS) $(FILESYSTEM_TAR)
endif

################################################


################################################
# Preloader/Uboot SD Card Programming

# Update the A2 Partition on your sd card with
# the preloader and uboot that build with this design
#
# These targets assume you have a pre-imaged sd card
# or an sd card *.img file 
# An example sd image for the Altera SoC Development
# Board can be found here:
# <soceds_install>/embeddedsw/socfpga/prebuilt_images

ALT_BOOT_DISK_UTIL := alt-boot-disk-util

ifeq ($(IS_WINDOWS_HOST),1)
ifeq ($(SDCARD),)
ifeq ($(SD_DRIVE_LETTER),)
GUESS_DRIVE_LETTER = $(firstword $(foreach drive_letter,d e f g h i j k l m n o p q r s t u v w x y z,$(if $(wildcard $(drive_letter):/zImage),$(drive_letter))))
SD_DRIVE_LETTER = $(GUESS_DRIVE_LETTER)
endif # SD_DRIVE_LETTER == <empty>
SDCARD ?= $(if $(SD_DRIVE_LETTER),-d $(SD_DRIVE_LETTER),$(error ERROR: SD_DRIVE_LETTER not specified. Try "make $(MAKECMDGOALS) SD_DRIVE_LETTER=[sd_card_windows_drive_letter]"))
endif # SDCARD == <empty>
else # if not a Windows Host
SDCARD ?= $(error ERROR: SD Card not specified. Try "make $(MAKECMDGOALS) SDCARD=/dev/sdX", where X represents your target SD Card device)
endif

.PHONY: sd-update-preloader
sd-update-preloader: $(PRELOADER)
	$(ALT_BOOT_DISK_UTIL) -p $< -a write $(SDCARD)

.PHONY: sd-update-uboot
sd-update-uboot: $(UBOOT)
	$(ALT_BOOT_DISK_UTIL) -b $< -a write $(SDCARD)

.PHONY: sd-update-preloader-uboot
sd-update-preloader-uboot: sd-update-preloader sd-update-uboot

################################################


################################################
# Archive

HELP_TARGETS += tgz
tgz.HELP := Create a tarball with the barebones source files that comprise this design.
AR_FILES += $(filter-out $(AR_FILTER_OUT),$(wildcard $(AR_REGEX)))

.PHONY: tarball tgz
tarball tgz: $(AR_FILE)

$(AR_FILE):
	@$(MKDIR) $(@D)
	@$(if $(wildcard $(@D)/*.tar.gz),$(MKDIR) $(@D)/.archive;$(MV) $(@D)/*.tar.gz $(@D)/.archive)
	@$(ECHO) "Generating $@..."
	@$(TAR) -czf $@ $(AR_FILES)

################################################


################################################
# Clean-up

HELP_TARGETS += scrub_clean
scrub_clean.HELP := Restore design to its barebones state.
CLEAN_FILES += $(filter-out $(AR_DIR) $(AR_FILES) $(NEVER_SCRUB_CLEAN_FILES),$(wildcard *))
SCRUB_CLEAN_FILES := $(filter-out $(NEVER_SCRUB_CLEAN_FILES),$(SCRUB_CLEAN_FILES))
SCRUB_CLEAN_FILES += $(CLEAN_FILES)

.PHONY: clean
clean:
	@$(ECHO) "Cleaning stamp files (which will trigger rebuild)"
	@$(RM) $(get_stamp_dir)
	@$(ECHO) " TIP: Use 'make scrub_clean' to get a deeper clean"

.PHONY: scrub scrub_clean
scrub scrub_clean:
	$(if $(strip $(wildcard $(SCRUB_CLEAN_FILES))),$(RM) $(wildcard $(SCRUB_CLEAN_FILES)),@$(ECHO) "You're already as clean as it gets!")

.PHONY: tgz_scrub_clean
tgz_scrub_clean:
	$(FIND) $(SOFTWARE_DIR) \( -name '*.o' -o -name '.depend*' -o -name '*.d' -o -name '*.dep' \) -delete || true
	$(MAKE) tgz AR_FILE=$(AR_FILE)
	$(MAKE) -s scrub_clean
	$(TAR) -xzf $(AR_FILE)

################################################


################################################
# Running Batch Jobs

ifneq ($(BATCH_TARGETS),)

BATCH_DIR := $(if $(TMP),$(TMP)/)batch/$(AR_TIMESTAMP)

.PHONY: $(patsubst %,batch-%,$(BATCH_TARGETS))
$(patsubst %,batch-%,$(BATCH_TARGETS)): batch-%: $(AR_FILE)
	@$(RM) $(BATCH_DIR)
	@$(MKDIR) $(BATCH_DIR)
	$(CP) $< $(BATCH_DIR) 
	$(CD) $(BATCH_DIR) && $(TAR) -xzf $(notdir $<) && $(CHMOD) -R 755 *
	$(MAKE) -C $(BATCH_DIR) $*

endif # BATCH_TARGETS != <empty>
################################################


################################################
# Help system

HELP_TARGETS += help
help.HELP := Displays this info, the available targets.
HELP_TARGETS_X := $(patsubst %,help-%,$(sort $(HELP_TARGETS)))

.PHONY: help
help: help-init help-targets help-fini

.PHONY: $(HELP_TARGETS_X)
help-targets: $(HELP_TARGETS_X)
$(HELP_TARGETS_X): help-%:
	@$(ECHO) "*********************"
	@$(ECHO) "* Target: $*"
	@$(ECHO) "*   $($*.HELP)"

.PHONY: help-init
help-init:
	@$(ECHO) "*****************************************"
	@$(ECHO) "*                                       *"
	@$(ECHO) "* Manage QuartusII/QSys design          *"
	@$(ECHO) "*                                       *"
	@$(ECHO) "*     Copyright (c) 2016                *"
	@$(ECHO) "*     All Rights Reserved               *"
	@$(ECHO) "*                                       *"
	@$(ECHO) "*****************************************"
	@$(ECHO) ""

.PHONY: help-fini
help-fini:
	@$(ECHO) "*********************"

################################################
