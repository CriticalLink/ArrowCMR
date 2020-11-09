set PROJECT_NAME "dev_5cs"

proc show_cmd_args {} {
  global DEVICE_TYPE
  global EXPANDEDIO
  global HPS_DDR_D_SIZE
  global HPS_DDR_A_SIZE
  global HPS_DDR_NUM_CHIPS
  global FPGA_DDR_A_SIZE

  foreach {name val} $::argv {
    if {$name == "DEVICE_TYPE"} {
      set DEVICE_TYPE $val
    } elseif {$name == "EXPANDEDIO"} {
      set EXPANDEDIO $val
    } elseif {$name == "HPS_DDR_D_SIZE"} {
      set HPS_DDR_D_SIZE $val
    } elseif {$name == "HPS_DDR_A_SIZE"} {
      set HPS_DDR_A_SIZE $val
    } elseif {$name == "HPS_DDR_NUM_CHIPS"} {
      set HPS_DDR_NUM_CHIPS $val
    } elseif {$name == "FPGA_DDR_A_SIZE"} {
      set FPGA_DDR_A_SIZE $val
    } else {
      puts "-> Rejected parameter: $name,  \tValue: $val"
      continue
    }
    
    puts "-> Accepted parameter: $name,  \tValue: $val"
  }
}
show_cmd_args


if [project_exists $PROJECT_NAME] {
        post_message -type error "project already exists..."
        post_message -type error "'$PROJECT_NAME'"
        qexit -error
}

project_new $PROJECT_NAME

set_global_assignment -name FAMILY "Cyclone V"
set_global_assignment -name DEVICE $DEVICE_TYPE 
set_global_assignment -name TOP_LEVEL_ENTITY dev_5cs_top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files

# Project files
set_global_assignment -name QIP_FILE dev_5cs/synthesis/dev_5cs.qip
set_global_assignment -name SDC_FILE dev_5cs.sdc
set_global_assignment -name VHDL_FILE dev_5cs_top.vhd

# Set IO Bank voltages
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 3B
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 4A
set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 6A
set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 6B
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 7A
set_global_assignment -name IOBANK_VCCIO 1.8V -section_id 7B
set_global_assignment -name IOBANK_VCCIO 3.3V -section_id 7C
set_global_assignment -name IOBANK_VCCIO 1.8V -section_id 7D
set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 8A
if {$FPGA_DDR_A_SIZE != 0} {
	set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 3A
	set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 5A
	set_global_assignment -name IOBANK_VCCIO 1.35V -section_id 5B
} else {
	set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 3A
	set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 5A
	if {$DEVICE_TYPE != "5CSEBA2U23C8S" && $DEVICE_TYPE != "5CSEBA4U23I7"} {
		set_global_assignment -name IOBANK_VCCIO 2.5V -section_id 5B
	}
}

# Set HPS IO assignments
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TX_CTL
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_MDC
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_MDIO
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RESETn
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RXD0
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RXD1
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RXD2
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RXD3
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RX_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_RX_CTL
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TXD0
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TXD1
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TXD2
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TXD3
set_instance_assignment -name IO_STANDARD "1.8 V" -to RGMII1_TX_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_DQ0
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_DQ1
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_DQ2
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_DQ3
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_SS0
set_instance_assignment -name IO_STANDARD "1.8 V" -to QSPI_SS1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_CMD
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_D0
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_D1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_D2
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SDMMC_D3
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_STP
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_CLK
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_CS
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D0
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D1
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D2
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D3
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D4
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D5
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D6
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_D7
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_DIR
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_NXT
set_instance_assignment -name IO_STANDARD "1.8 V" -to USB1_ULPI_RESET_N
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_CAN0_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_CAN0_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_CAN1_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_CAN1_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_I2C0_SCL
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_I2C0_SDA
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_UART0_RX
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to B7A_UART0_RX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to B7A_UART0_TX
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SW3
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SW1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to SW2
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to I2C1_SCL
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to I2C1_SDA
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to LED1
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to LED2
set_instance_assignment -name IO_STANDARD "3.3-V LVCMOS" -to LED3


# Set HPS pin locations
set_location_assignment PIN_A17 -to B7A_CAN0_RX
set_location_assignment PIN_H17 -to B7A_CAN0_TX
set_location_assignment PIN_B18 -to B7A_CAN1_RX
set_location_assignment PIN_J17 -to B7A_CAN1_TX
set_location_assignment PIN_B16 -to B7A_I2C0_SCL
set_location_assignment PIN_C19 -to B7A_I2C0_SDA
set_location_assignment PIN_B19 -to B7A_UART0_RX
set_location_assignment PIN_C16 -to B7A_UART0_TX
set_location_assignment PIN_C28 -to HPS_DDR_A[0]
set_location_assignment PIN_B28 -to HPS_DDR_A[1]
set_location_assignment PIN_A24 -to HPS_DDR_A[10]
set_location_assignment PIN_B24 -to HPS_DDR_A[11]
set_location_assignment PIN_D24 -to HPS_DDR_A[12]
set_location_assignment PIN_C24 -to HPS_DDR_A[13]
set_location_assignment PIN_G23 -to HPS_DDR_A[14]
set_location_assignment PIN_E26 -to HPS_DDR_A[2]
set_location_assignment PIN_D26 -to HPS_DDR_A[3]
set_location_assignment PIN_J21 -to HPS_DDR_A[4]
set_location_assignment PIN_J20 -to HPS_DDR_A[5]
set_location_assignment PIN_C26 -to HPS_DDR_A[6]
set_location_assignment PIN_B26 -to HPS_DDR_A[7]
set_location_assignment PIN_F26 -to HPS_DDR_A[8]
set_location_assignment PIN_F25 -to HPS_DDR_A[9]
set_location_assignment PIN_A27 -to HPS_DDR_BAS[0]
set_location_assignment PIN_H25 -to HPS_DDR_BAS[1]
set_location_assignment PIN_G25 -to HPS_DDR_BAS[2]
set_location_assignment PIN_A26 -to HPS_DDR_CAS_N
set_location_assignment PIN_N20 -to HPS_DDR_CK_N
set_location_assignment PIN_N21 -to HPS_DDR_CK_P
set_location_assignment PIN_L28 -to HPS_DDR_CKE
set_location_assignment PIN_L21 -to HPS_DDR_CS0_N
set_location_assignment PIN_J25 -to HPS_DDR_D[0]
set_location_assignment PIN_J24 -to HPS_DDR_D[1]
set_location_assignment PIN_J27 -to HPS_DDR_D[10]
set_location_assignment PIN_J28 -to HPS_DDR_D[11]
set_location_assignment PIN_M27 -to HPS_DDR_D[12]
set_location_assignment PIN_M26 -to HPS_DDR_D[13]
set_location_assignment PIN_M28 -to HPS_DDR_D[14]
set_location_assignment PIN_N28 -to HPS_DDR_D[15]
set_location_assignment PIN_N24 -to HPS_DDR_D[16]
set_location_assignment PIN_N25 -to HPS_DDR_D[17]
set_location_assignment PIN_T28 -to HPS_DDR_D[18]
set_location_assignment PIN_U28 -to HPS_DDR_D[19]
set_location_assignment PIN_E28 -to HPS_DDR_D[2]
set_location_assignment PIN_N26 -to HPS_DDR_D[20]
set_location_assignment PIN_N27 -to HPS_DDR_D[21]
set_location_assignment PIN_R27 -to HPS_DDR_D[22]
set_location_assignment PIN_V27 -to HPS_DDR_D[23]
set_location_assignment PIN_R26 -to HPS_DDR_D[24]
set_location_assignment PIN_R25 -to HPS_DDR_D[25]
set_location_assignment PIN_AA28 -to HPS_DDR_D[26]
set_location_assignment PIN_W26 -to HPS_DDR_D[27]
set_location_assignment PIN_R24 -to HPS_DDR_D[28]
set_location_assignment PIN_T24 -to HPS_DDR_D[29]
set_location_assignment PIN_D27 -to HPS_DDR_D[3]
set_location_assignment PIN_Y27 -to HPS_DDR_D[30]
set_location_assignment PIN_AA27 -to HPS_DDR_D[31]
set_location_assignment PIN_T26 -to HPS_DDR_D[32]
set_location_assignment PIN_U25 -to HPS_DDR_D[33]
set_location_assignment PIN_AC28 -to HPS_DDR_D[34]
set_location_assignment PIN_V25 -to HPS_DDR_D[35]
set_location_assignment PIN_V19 -to HPS_DDR_D[36]
set_location_assignment PIN_V20 -to HPS_DDR_D[37]
set_location_assignment PIN_AE27 -to HPS_DDR_D[38]
set_location_assignment PIN_AD28 -to HPS_DDR_D[39]
set_location_assignment PIN_J26 -to HPS_DDR_D[4]
set_location_assignment PIN_K26 -to HPS_DDR_D[5]
set_location_assignment PIN_G27 -to HPS_DDR_D[6]
set_location_assignment PIN_F28 -to HPS_DDR_D[7]
set_location_assignment PIN_K25 -to HPS_DDR_D[8]
set_location_assignment PIN_L25 -to HPS_DDR_D[9]
set_location_assignment PIN_G28 -to HPS_DDR_DQM[0]
set_location_assignment PIN_P28 -to HPS_DDR_DQM[1]
set_location_assignment PIN_W28 -to HPS_DDR_DQM[2]
set_location_assignment PIN_AB28 -to HPS_DDR_DQM[3]
set_location_assignment PIN_AE28 -to HPS_DDR_DQM[4]
set_location_assignment PIN_R16 -to HPS_DDR_DQS_N[0]
set_location_assignment PIN_R18 -to HPS_DDR_DQS_N[1]
set_location_assignment PIN_T18 -to HPS_DDR_DQS_N[2]
set_location_assignment PIN_T20 -to HPS_DDR_DQS_N[3]
set_location_assignment PIN_V17 -to HPS_DDR_DQS_N[4]
set_location_assignment PIN_R17 -to HPS_DDR_DQS_P[0]
set_location_assignment PIN_R19 -to HPS_DDR_DQS_P[1]
set_location_assignment PIN_T19 -to HPS_DDR_DQS_P[2]
set_location_assignment PIN_U19 -to HPS_DDR_DQS_P[3]
set_location_assignment PIN_V18 -to HPS_DDR_DQS_P[4]
set_location_assignment PIN_A25 -to HPS_DDR_RAS_N
set_location_assignment PIN_V28 -to HPS_DDR_RESET_N
set_location_assignment PIN_E25 -to HPS_DDR_WE_N
set_location_assignment PIN_D28 -to HPS_ODT
set_location_assignment PIN_D25 -to HPS_RZQ0
set_location_assignment PIN_K18 -to I2C1_SCL
set_location_assignment PIN_A21 -to I2C1_SDA
set_location_assignment PIN_B21 -to LED1
set_location_assignment PIN_A22 -to LED2
set_location_assignment PIN_C21 -to LED3
set_location_assignment PIN_C14 -to QSPI_CLK
set_location_assignment PIN_A8 -to QSPI_DQ0
set_location_assignment PIN_H16 -to QSPI_DQ1
set_location_assignment PIN_A7 -to QSPI_DQ2
set_location_assignment PIN_J16 -to QSPI_DQ3
set_location_assignment PIN_A6 -to QSPI_SS0
set_location_assignment PIN_B14 -to QSPI_SS1
set_location_assignment PIN_A13 -to RGMII1_MDC
set_location_assignment PIN_E16 -to RGMII1_MDIO
set_location_assignment PIN_D15 -to RGMII1_RESETn
set_location_assignment PIN_J12 -to RGMII1_RX_CLK
set_location_assignment PIN_J13 -to RGMII1_RX_CTL
set_location_assignment PIN_A14 -to RGMII1_RXD0
set_location_assignment PIN_A11 -to RGMII1_RXD1
set_location_assignment PIN_C15 -to RGMII1_RXD2
set_location_assignment PIN_A9 -to RGMII1_RXD3
set_location_assignment PIN_J15 -to RGMII1_TX_CLK
set_location_assignment PIN_A12 -to RGMII1_TX_CTL
set_location_assignment PIN_A16 -to RGMII1_TXD0
set_location_assignment PIN_J14 -to RGMII1_TXD1
set_location_assignment PIN_A15 -to RGMII1_TXD2
set_location_assignment PIN_D17 -to RGMII1_TXD3
set_location_assignment PIN_B8 -to SDMMC_CLK
set_location_assignment PIN_D14 -to SDMMC_CMD
set_location_assignment PIN_C13 -to SDMMC_D0
set_location_assignment PIN_B6 -to SDMMC_D1
set_location_assignment PIN_B11 -to SDMMC_D2
set_location_assignment PIN_B9 -to SDMMC_D3
set_location_assignment PIN_A5 -to SW1
set_location_assignment PIN_H13 -to SW2
set_location_assignment PIN_A4 -to SW3
set_location_assignment PIN_G4 -to USB1_ULPI_CLK
set_location_assignment PIN_E4 -to USB1_ULPI_CS
set_location_assignment PIN_C10 -to USB1_ULPI_D0
set_location_assignment PIN_F5 -to USB1_ULPI_D1
set_location_assignment PIN_C9 -to USB1_ULPI_D2
set_location_assignment PIN_C4 -to USB1_ULPI_D3
set_location_assignment PIN_C8 -to USB1_ULPI_D4
set_location_assignment PIN_D4 -to USB1_ULPI_D5
set_location_assignment PIN_C7 -to USB1_ULPI_D6
set_location_assignment PIN_F4 -to USB1_ULPI_D7
set_location_assignment PIN_E5 -to USB1_ULPI_DIR
set_location_assignment PIN_D5 -to USB1_ULPI_NXT
set_location_assignment PIN_C6 -to USB1_ULPI_RESET_N
set_location_assignment PIN_C5 -to USB1_ULPI_STP

# Base board Constraints
set_instance_assignment -name IO_STANDARD LVDS -to CLK2DDR
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to CLK2DDR
set_location_assignment PIN_Y13 -to CLK2DDR
set_location_assignment PIN_AF28 -to HSMC1_SMSDA
set_location_assignment PIN_AF27 -to HSMC1_SMSCL
set_location_assignment PIN_AG5 -to HSMC1_CLKOUT0
set_location_assignment PIN_Y15 -to HSMC1_CLKIN0
set_location_assignment PIN_AH21 -to HSMC1_D0
set_location_assignment PIN_AF18 -to HSMC1_D1
set_location_assignment PIN_AG21 -to HSMC1_D2
set_location_assignment PIN_AH12 -to HSMC1_D3
set_location_assignment PIN_AG10 -to HSMC1_CLKOUT1
set_location_assignment PIN_E8 -to HSMC1_CLKOUT2
set_location_assignment PIN_D12 -to HSMC1_CLKIN1
set_location_assignment PIN_E11 -to HSMC1_CLKIN2
set_location_assignment PIN_AF21 -to HSMC1_PRSNTn
set_location_assignment PIN_AH9 -to HSMC1_CLKOUT1_N
set_location_assignment PIN_D8 -to HSMC1_CLKOUT2_N
set_location_assignment PIN_C12 -to HSMC1_CLKIN1_N
set_location_assignment PIN_D11 -to HSMC1_CLKIN2_N
set_location_assignment PIN_AH23 -to HSMC1_TX0
set_location_assignment PIN_AF20 -to HSMC1_TX1
set_location_assignment PIN_AG19 -to HSMC1_TX2
set_location_assignment PIN_AG18 -to HSMC1_TX3
set_location_assignment PIN_AH17 -to HSMC1_TX4
set_location_assignment PIN_AG15 -to HSMC1_TX5
set_location_assignment PIN_AG14 -to HSMC1_TX6
set_location_assignment PIN_AG11 -to HSMC1_TX7
set_location_assignment PIN_AG9 -to HSMC1_TX8
set_location_assignment PIN_AG8 -to HSMC1_TX9
set_location_assignment PIN_AE8 -to HSMC1_TX10
set_location_assignment PIN_AE7 -to HSMC1_TX11
set_location_assignment PIN_AF5 -to HSMC1_TX12
set_location_assignment PIN_AF7 -to HSMC1_TX13
set_location_assignment PIN_AH6 -to HSMC1_TX14
set_location_assignment PIN_AE4 -to HSMC1_TX15
set_location_assignment PIN_AH3 -to HSMC1_TX16
set_location_assignment PIN_AH22 -to HSMC1_TX0_N
set_location_assignment PIN_AG20 -to HSMC1_TX1_N
set_location_assignment PIN_AH19 -to HSMC1_TX2_N
set_location_assignment PIN_AH18 -to HSMC1_TX3_N
set_location_assignment PIN_AH16 -to HSMC1_TX4_N
set_location_assignment PIN_AH14 -to HSMC1_TX5_N
set_location_assignment PIN_AH13 -to HSMC1_TX6_N
set_location_assignment PIN_AH11 -to HSMC1_TX7_N
set_location_assignment PIN_AH8 -to HSMC1_TX8_N
set_location_assignment PIN_AH7 -to HSMC1_TX9_N
set_location_assignment PIN_AF9 -to HSMC1_TX10_N
set_location_assignment PIN_AF8 -to HSMC1_TX11_N
set_location_assignment PIN_AF6 -to HSMC1_TX12_N
set_location_assignment PIN_AG6 -to HSMC1_TX13_N
set_location_assignment PIN_AH5 -to HSMC1_TX14_N
set_location_assignment PIN_AF4 -to HSMC1_TX15_N
set_location_assignment PIN_AH2 -to HSMC1_TX16_N
set_location_assignment PIN_AE20 -to HSMC1_RX0
set_location_assignment PIN_AA19 -to HSMC1_RX1
set_location_assignment PIN_AE19 -to HSMC1_RX2
set_location_assignment PIN_AD17 -to HSMC1_RX3
set_location_assignment PIN_W14 -to HSMC1_RX4
set_location_assignment PIN_AF17 -to HSMC1_RX5
set_location_assignment PIN_AF15 -to HSMC1_RX6
set_location_assignment PIN_U14 -to HSMC1_RX7
set_location_assignment PIN_AG13 -to HSMC1_RX8
set_location_assignment PIN_AE12 -to HSMC1_RX9
set_location_assignment PIN_AD11 -to HSMC1_RX10
set_location_assignment PIN_AF11 -to HSMC1_RX11
set_location_assignment PIN_T13 -to HSMC1_RX12
set_location_assignment PIN_T11 -to HSMC1_RX13
set_location_assignment PIN_V12 -to HSMC1_RX14
set_location_assignment PIN_V11 -to HSMC1_RX15
set_location_assignment PIN_AD10 -to HSMC1_RX16
set_location_assignment PIN_AD20 -to HSMC1_RX0_N
set_location_assignment PIN_AA18 -to HSMC1_RX1_N
set_location_assignment PIN_AD19 -to HSMC1_RX2_N
set_location_assignment PIN_AE17 -to HSMC1_RX3_N
set_location_assignment PIN_V13 -to HSMC1_RX4_N
set_location_assignment PIN_AG16 -to HSMC1_RX5_N
set_location_assignment PIN_AE15 -to HSMC1_RX6_N
set_location_assignment PIN_U13 -to HSMC1_RX7_N
set_location_assignment PIN_AF13 -to HSMC1_RX8_N
set_location_assignment PIN_AD12 -to HSMC1_RX9_N
set_location_assignment PIN_AE11 -to HSMC1_RX10_N
set_location_assignment PIN_AF10 -to HSMC1_RX11_N
set_location_assignment PIN_T12 -to HSMC1_RX12_N
set_location_assignment PIN_U11 -to HSMC1_RX13_N
set_location_assignment PIN_W12 -to HSMC1_RX14_N
set_location_assignment PIN_W11 -to HSMC1_RX15_N
set_location_assignment PIN_AE9 -to HSMC1_RX16_N
set_instance_assignment -name IO_STANDARD "2.5 V" -to HSMC1_*
set_location_assignment PIN_AH27 -to HSMC2_SMSDA
set_location_assignment PIN_AC22 -to HSMC2_D1_P
set_location_assignment PIN_AC23 -to HSMC2_D1_N
set_location_assignment PIN_AG24 -to HSMC2_TX0_P
set_location_assignment PIN_AH24 -to HSMC2_TX0_N
set_location_assignment PIN_AG26 -to HSMC2_TX1
set_location_assignment PIN_AG28 -to HSMC2_SMSCL
set_location_assignment PIN_AF25 -to HSMC2_D2_P
set_location_assignment PIN_AG25 -to HSMC2_D2_N
set_location_assignment PIN_AD23 -to HSMC2_RX0_P
set_location_assignment PIN_AE22 -to HSMC2_RX0_N
set_location_assignment PIN_AG23 -to HSMC2_RX1_P
set_location_assignment PIN_AF23 -to HSMC2_RX1_N
set_location_assignment PIN_AH26 -to HSMC2_PRSNTN
set_instance_assignment -name IO_STANDARD "2.5 V" -to HSMC2_*

if {$FPGA_DDR_A_SIZE == 0} {
	set_location_assignment PIN_AF26 -to B5A_TX_R1_P
	set_location_assignment PIN_AE26 -to B5A_TX_R1_N
	set_location_assignment PIN_AE25 -to B5A_TX_R3_P
	set_location_assignment PIN_AD26 -to B5A_TX_R3_N
	set_location_assignment PIN_AC24 -to B5A_TX_R5_P
	set_location_assignment PIN_AB23 -to B5A_TX_R5_N
	set_location_assignment PIN_AA20 -to B5A_RX_R2_P
	set_location_assignment PIN_Y19 -to B5A_RX_R2_N
	set_location_assignment PIN_Y17 -to B5A_RX_R4_P
	set_location_assignment PIN_Y18 -to B5A_RX_R4_N
	set_instance_assignment -name IO_STANDARD "2.5 V" -to B5A_*
	set_location_assignment PIN_Y11 -to B3A_RX_B7_P
	set_location_assignment PIN_AA11 -to B3A_RX_B7_N
	set_location_assignment PIN_U10 -to B3A_RX_B5_P
	set_location_assignment PIN_V10 -to B3A_RX_B5_N
	set_location_assignment PIN_U9 -to B3A_RX_B3_P
	set_location_assignment PIN_T8 -to B3A_RX_B3_N
	set_location_assignment PIN_W8 -to B3A_RX_B1_P
	set_location_assignment PIN_Y8 -to B3A_RX_B1_N
	set_location_assignment PIN_AD5 -to B3A_TX_B8_P
	set_location_assignment PIN_AE6 -to B3A_TX_B8_N
	set_location_assignment PIN_AC4 -to B3A_TX_B6_P
	set_location_assignment PIN_AD4 -to B3A_TX_B6_N
	set_location_assignment PIN_AA4 -to B3A_TX_B4_P
	set_location_assignment PIN_AB4 -to B3A_TX_B4_N
	set_location_assignment PIN_Y5 -to B3A_TX_B2_P
	set_location_assignment PIN_Y4 -to B3A_TX_B2_N
	set_instance_assignment -name IO_STANDARD "2.5 V" -to B3A_*
}

# HPS DDR Constraints
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_RZQ0 -tag __hps_sdram_p0
for {set i 0} {$i < $HPS_DDR_D_SIZE} {incr i} {
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_D[$i] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to HPS_DDR_D[$i] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_D[$i] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_D[$i] -tag __hps_sdram_p0
}

for {set i 0} {$i < $HPS_DDR_NUM_CHIPS} {incr i} {
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to HPS_DDR_DQS_P[$i] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to HPS_DDR_DQS_P[$i] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_DQS_P[$i] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to HPS_DDR_DQS_N[$i] -tag __hps_sdram_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to HPS_DDR_DQS_N[$i] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_DQS_N[$i] -tag __hps_sdram_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_DQM[$i] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to HPS_DDR_DQM[$i] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_DQM[$i] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_DQS_P[$i] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_DQS_N[$i] -tag __hps_sdram_p0
}

set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to HPS_DDR_CK_P -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_DDR_CK_P -tag __hps_sdram_p0
set_instance_assignment -name D5_DELAY 2 -to HPS_DDR_CK_P -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to HPS_DDR_CK_N -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_DDR_CK_N -tag __hps_sdram_p0
set_instance_assignment -name D5_DELAY 2 -to HPS_DDR_CK_N -tag __hps_sdram_p0

for {set i 0} {$i < $HPS_DDR_A_SIZE} {incr i} {
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_A[$i] -tag __hps_sdram_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_DDR_A[$i] -tag __hps_sdram_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_A[$i] -tag __hps_sdram_p0
}
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_BAS[0] -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_DDR_BAS[0] -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_BAS[1] -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_DDR_BAS[1] -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_BAS[2] -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_DDR_BAS[2] -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_CAS_N -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_DDR_CAS_N -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_CKE -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_DDR_CKE -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_CS0_N -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_DDR_CS0_N -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_RAS_N -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_DDR_RAS_N -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_WE_N -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_DDR_WE_N -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_ODT -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_ODT -tag __hps_sdram_p0
set_instance_assignment -name IO_STANDARD "SSTL-135" -to HPS_DDR_RESET_N -tag __hps_sdram_p0
set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to HPS_DDR_RESET_N -tag __hps_sdram_p0
set_instance_assignment -name BOARD_MODEL_FAR_PULLUP_R OPEN -to HPS_DDR_RESET_N -tag __hps_sdram_p0
set_instance_assignment -name BOARD_MODEL_NEAR_PULLUP_R OPEN -to HPS_DDR_RESET_N -tag __hps_sdram_p0
set_instance_assignment -name BOARD_MODEL_FAR_PULLDOWN_R OPEN -to HPS_DDR_RESET_N -tag __hps_sdram_p0
set_instance_assignment -name BOARD_MODEL_NEAR_PULLDOWN_R OPEN -to HPS_DDR_RESET_N -tag __hps_sdram_p0

set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_BAS[0] -tag __hps_sdram_p0
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_BAS[1] -tag __hps_sdram_p0
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_BAS[2] -tag __hps_sdram_p0
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_CAS_N -tag __hps_sdram_p0
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_CKE -tag __hps_sdram_p0
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_CS0_N -tag __hps_sdram_p0
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_RAS_N -tag __hps_sdram_p0
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_WE_N -tag __hps_sdram_p0
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_ODT -tag __hps_sdram_p0
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_RESET_N -tag __hps_sdram_p0
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_CK_P -tag __hps_sdram_p0
set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to HPS_DDR_CK_N -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_mem_stable_n -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|ureset|phy_reset_n -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[0].read_capture_clk_buffer -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[0] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[0] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[1].read_capture_clk_buffer -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[1] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[1] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[2].read_capture_clk_buffer -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[2] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[2] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[3].read_capture_clk_buffer -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[3] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[3] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uio_pads|dq_ddio[4].read_capture_clk_buffer -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_write_side[4] -tag __hps_sdram_p0
set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|hps_0|hps_io|border|hps_sdram_inst|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[4] -tag __hps_sdram_p0
set_instance_assignment -name ENABLE_BENEFICIAL_SKEW_OPTIMIZATION_FOR_NON_GLOBAL_CLOCKS ON -to u0|hps_0|hps_io|border|hps_sdram_inst -tag __hps_sdram_p0
set_instance_assignment -name PLL_COMPENSATION_MODE DIRECT -to u0|hps_0|hps_io|border|hps_sdram_inst|pll0|fbout -tag __hps_sdram_p0

# FPGA DDR Constraints
if {$FPGA_DDR_A_SIZE != 0} {

	set_location_assignment PIN_AA20 -to FPGA_DDR_A[0]
	set_location_assignment PIN_W21 -to FPGA_DDR_A[1]
	set_location_assignment PIN_AF26 -to FPGA_DDR_A[2]
	set_location_assignment PIN_W20 -to FPGA_DDR_A[3]
	set_location_assignment PIN_AA23 -to FPGA_DDR_A[4]
	set_location_assignment PIN_AE25 -to FPGA_DDR_A[5]
	set_location_assignment PIN_AD26 -to FPGA_DDR_A[6]
	set_location_assignment PIN_Y24 -to FPGA_DDR_A[7]
	set_location_assignment PIN_AA26 -to FPGA_DDR_A[8]
	set_location_assignment PIN_W24 -to FPGA_DDR_A[9]
	set_location_assignment PIN_V16 -to FPGA_DDR_A[10]
	set_location_assignment PIN_AA24 -to FPGA_DDR_A[11]
	set_location_assignment PIN_AC24 -to FPGA_DDR_A[12]
	set_location_assignment PIN_AE26 -to FPGA_DDR_A[13]
	set_location_assignment PIN_Y4 -to FPGA_DDR_A[14]
	set_location_assignment PIN_Y19 -to FPGA_DDR_BAS[0]
	set_location_assignment PIN_AB23 -to FPGA_DDR_BAS[1]
	set_location_assignment PIN_Y18 -to FPGA_DDR_BAS[2]
	set_location_assignment PIN_Y16 -to FPGA_DDR_CAS_N[0]
	set_location_assignment PIN_AA4 -to FPGA_DDR_CKE[0]
	set_location_assignment PIN_AA11 -to FPGA_DDR_CK_N[0]
	set_location_assignment PIN_Y11 -to FPGA_DDR_CK_P[0]
	set_location_assignment PIN_AC4 -to FPGA_DDR_DQM0[0]
	set_location_assignment PIN_Y8 -to FPGA_DDR_D[0]
	set_location_assignment PIN_Y5 -to FPGA_DDR_D[1]
	set_location_assignment PIN_U10 -to FPGA_DDR_D[2]
	set_location_assignment PIN_AB4 -to FPGA_DDR_D[3]
	set_location_assignment PIN_AE6 -to FPGA_DDR_D[4]
	set_location_assignment PIN_AD4 -to FPGA_DDR_D[5]
	set_location_assignment PIN_V10 -to FPGA_DDR_D[6]
	set_location_assignment PIN_AD5 -to FPGA_DDR_D[7]
	set_location_assignment PIN_T8 -to FPGA_DDR_DQS0_N[0]
	set_location_assignment PIN_U9 -to FPGA_DDR_DQS0_P[0]
	set_location_assignment PIN_V15 -to FPGA_DDR_RAS_N[0]
	set_location_assignment PIN_AB26 -to FPGA_DDR_RESET_N
	set_location_assignment PIN_Y17 -to FPGA_DDR_WE_N[0]
	set_location_assignment PIN_AB25 -to RZQ_2
	set_location_assignment PIN_W8 -to FPGA_DDR_CS_N[0]

	set_instance_assignment -name IO_STANDARD "SSTL-135" -to RZQ_2 -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[0] -tag __fpga_ddr_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[0] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[0] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[1] -tag __fpga_ddr_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[1] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[1] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[2] -tag __fpga_ddr_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[2] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[2] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[3] -tag __fpga_ddr_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[3] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[3] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[4] -tag __fpga_ddr_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[4] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[4] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[5] -tag __fpga_ddr_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[5] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[5] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[6] -tag __fpga_ddr_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[6] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[6] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_D[7] -tag __fpga_ddr_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_D[7] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_D[7] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to FPGA_DDR_DQS0_P[0] -tag __fpga_ddr_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_DQS0_P[0] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_DQS0_P[0] -tag __fpga_ddr_p0
	set_instance_assignment -name D5_DELAY 4 -to FPGA_DDR_DQS0_P[0] -tag __fpga_ddr_p0
	set_instance_assignment -name D6_DELAY 0 -to FPGA_DDR_DQS0_P[0] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to FPGA_DDR_DQS0_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name INPUT_TERMINATION "PARALLEL 60 OHM WITH CALIBRATION" -to FPGA_DDR_DQS0_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_DQS0_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name D5_DELAY 4 -to FPGA_DDR_DQS0_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name D6_DELAY 0 -to FPGA_DDR_DQS0_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to FPGA_DDR_CK_P[0] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_CK_P[0] -tag __fpga_ddr_p0
	set_instance_assignment -name D5_DELAY 2 -to FPGA_DDR_CK_P[0] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "DIFFERENTIAL 1.35-V SSTL" -to FPGA_DDR_CK_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_CK_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name D5_DELAY 2 -to FPGA_DDR_CK_N[0] -tag __fpga_ddr_p0
	for {set i 0} {$i < $FPGA_DDR_A_SIZE} {incr i} {
		set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_A[$i] -tag __fpga_ddr_p0
		set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_A[$i] -tag __fpga_ddr_p0
		set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_A[$i] -tag __fpga_ddr_p0
	}
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_BAS[0] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_BAS[0] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_BAS[1] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_BAS[1] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_BAS[2] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_BAS[2] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_CS_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_CS_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_WE_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_WE_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_RAS_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_RAS_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_CAS_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_CAS_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_CKE[0] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_CKE[0] -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_RESET_N -tag __fpga_ddr_p0
	set_instance_assignment -name BOARD_MODEL_FAR_PULLUP_R OPEN -to FPGA_DDR_RESET_N -tag __fpga_ddr_p0
	set_instance_assignment -name BOARD_MODEL_NEAR_PULLUP_R OPEN -to FPGA_DDR_RESET_N -tag __fpga_ddr_p0
	set_instance_assignment -name BOARD_MODEL_FAR_PULLDOWN_R OPEN -to FPGA_DDR_RESET_N -tag __fpga_ddr_p0
	set_instance_assignment -name BOARD_MODEL_NEAR_PULLDOWN_R OPEN -to FPGA_DDR_RESET_N -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITHOUT CALIBRATION" -to FPGA_DDR_RESET_N -tag __fpga_ddr_p0
	set_instance_assignment -name IO_STANDARD "SSTL-135" -to FPGA_DDR_DQM0[0] -tag __fpga_ddr_p0
	set_instance_assignment -name OUTPUT_TERMINATION "SERIES 34 OHM WITH CALIBRATION" -to FPGA_DDR_DQM0[0] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_D[0] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_D[1] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_D[2] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_D[3] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_D[4] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_D[5] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_D[6] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_D[7] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_DQM0[0] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_DQS0_P[0] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_DQS0_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_BAS[0] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_BAS[1] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_BAS[2] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_CS_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_WE_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_RAS_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_CAS_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_CKE[0] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_RESET_N -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_CK_P[0] -tag __fpga_ddr_p0
	set_instance_assignment -name PACKAGE_SKEW_COMPENSATION OFF -to FPGA_DDR_CK_N[0] -tag __fpga_ddr_p0
	set_instance_assignment -name GLOBAL_SIGNAL "GLOBAL CLOCK" -to u0|fpga_ddr|pll0|pll_afi_clk -tag __fpga_ddr_p0
	set_instance_assignment -name GLOBAL_SIGNAL "DUAL-REGIONAL CLOCK" -to u0|fpga_ddr|pll0|pll_addr_cmd_clk -tag __fpga_ddr_p0
	set_instance_assignment -name GLOBAL_SIGNAL "DUAL-REGIONAL CLOCK" -to u0|fpga_ddr|pll0|pll_avl_clk -tag __fpga_ddr_p0
	set_instance_assignment -name GLOBAL_SIGNAL "DUAL-REGIONAL CLOCK" -to u0|fpga_ddr|pll0|pll_config_clk -tag __fpga_ddr_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|fpga_ddr|p0|umemphy|ureset|phy_reset_mem_stable_n -tag __fpga_ddr_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|fpga_ddr|p0|umemphy|ureset|phy_reset_n -tag __fpga_ddr_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|fpga_ddr|s0|sequencer_rw_mgr_inst|rw_mgr_inst|rw_mgr_core_inst|rw_soft_reset_n -tag __fpga_ddr_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|fpga_ddr|p0|umemphy|uread_datapath|reset_n_fifo_write_side[0] -tag __fpga_ddr_p0
	set_instance_assignment -name GLOBAL_SIGNAL OFF -to u0|fpga_ddr|p0|umemphy|uread_datapath|reset_n_fifo_wraddress[0] -tag __fpga_ddr_p0
	set_instance_assignment -name ENABLE_BENEFICIAL_SKEW_OPTIMIZATION_FOR_NON_GLOBAL_CLOCKS ON -to u0|fpga_ddr -tag __fpga_ddr_p0
	set_instance_assignment -name PLL_COMPENSATION_MODE DIRECT -to u0|fpga_ddr|pll0|fbout -tag __fpga_ddr_p0
	set_global_assignment -name USE_DLL_FREQUENCY_FOR_DQS_DELAY_CHAIN ON
	set_global_assignment -name UNIPHY_SEQUENCER_DQS_CONFIG_ENABLE ON
	set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON
	set_global_assignment -name ECO_REGENERATE_REPORT ON
}
