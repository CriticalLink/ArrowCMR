-------------------------------------------------------------------------------
--
--     o  0                          
--     | /       Copyright (c) 2017
--    (CL)---o   Critical Link, LLC  
--                                  
--       O                           
--
-- File       : dev_5cs_top.vhd
-- Company    : Critical Link, LLC
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Top level entity for the MitySOM-5CSX Development Board
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity dev_5cs_top is
	generic(
		HPS_DDR_D_SIZE    : integer := 40;
		HPS_DDR_A_SIZE    : integer := 15;
		HPS_DDR_NUM_CHIPS : integer := 5;
		FPGA_DDR_A_SIZE   : integer := 0
		);
	port(
		-- HPS DDR
		HPS_DDR_A         : out   std_logic_vector(HPS_DDR_A_SIZE-1 downto 0);
		HPS_DDR_BAS       : out   std_logic_vector(2 downto 0);
		HPS_DDR_CK_P      : out   std_logic;
		HPS_DDR_CK_N      : out   std_logic;
		HPS_DDR_CKE       : out   std_logic;
		HPS_DDR_CS0_N     : out   std_logic;
		HPS_DDR_RAS_N     : out   std_logic;
		HPS_DDR_CAS_N     : out   std_logic;
		HPS_DDR_WE_N      : out   std_logic;
		HPS_DDR_RESET_N   : out   std_logic;
		HPS_DDR_D         : inout std_logic_vector(HPS_DDR_D_SIZE-1 downto 0) := (others => 'X');
		HPS_DDR_DQS_P     : inout std_logic_vector(HPS_DDR_NUM_CHIPS-1 downto 0)  := (others => 'X');
		HPS_DDR_DQS_N     : inout std_logic_vector(HPS_DDR_NUM_CHIPS-1 downto 0)  := (others => 'X');
		HPS_DDR_DQM       : out   std_logic_vector(HPS_DDR_NUM_CHIPS-1 downto 0);
		HPS_RZQ0          : in    std_logic                     := 'X';
		HPS_ODT           : out   std_logic;
		-- RGMII1
		RGMII1_TX_CLK     : out   std_logic;
		RGMII1_TXD0       : out   std_logic;
		RGMII1_TXD1       : out   std_logic;
		RGMII1_TXD2       : out   std_logic;
		RGMII1_TXD3       : out   std_logic;
		RGMII1_RXD0       : in    std_logic                     := 'X';
		RGMII1_MDIO       : inout std_logic                     := 'X';
		RGMII1_MDC        : out   std_logic;
		RGMII1_RX_CTL     : in    std_logic                     := 'X';
		RGMII1_TX_CTL     : out   std_logic;
		RGMII1_RX_CLK     : in    std_logic                     := 'X';
		RGMII1_RXD1       : in    std_logic                     := 'X';
		RGMII1_RXD2       : in    std_logic                     := 'X';
		RGMII1_RXD3       : in    std_logic                     := 'X';
		RGMII1_RESET_N     : inout std_logic;
		-- QSPI
		QSPI_DQ0          : inout std_logic                     := 'X';
		QSPI_DQ1          : inout std_logic                     := 'X';
		QSPI_DQ2          : inout std_logic                     := 'X';
		QSPI_DQ3          : inout std_logic                     := 'X';
		QSPI_SS0          : out   std_logic;
		QSPI_SS1          : out   std_logic;
		QSPI_CLK          : out   std_logic;
		-- SDMMC
		MMC0_CMD  : inout std_logic := 'X';
		MMC0_DAT0 : inout std_logic := 'X';
		MMC0_DAT1 : inout std_logic := 'X';
		MMC0_CLK  : out   std_logic;
		MMC0_DAT2 : inout std_logic := 'X';
		MMC0_DAT3 : inout std_logic := 'X';

		-- USB1
		USB1_ULPI_D0      : inout std_logic := 'X';
		USB1_ULPI_D1      : inout std_logic := 'X';
		USB1_ULPI_D2      : inout std_logic := 'X';
		USB1_ULPI_D3      : inout std_logic := 'X';
		USB1_ULPI_D4      : inout std_logic := 'X';
		USB1_ULPI_D5      : inout std_logic := 'X';
		USB1_ULPI_D6      : inout std_logic := 'X';
		USB1_ULPI_D7      : inout std_logic := 'X';
		USB1_ULPI_CLK     : in    std_logic := 'X';
		USB1_ULPI_STP     : out   std_logic;
		USB1_ULPI_DIR     : in    std_logic := 'X';
		USB1_ULPI_NXT     : in    std_logic := 'X';
		USB1_ULPI_CS      : inout std_logic;
		USB1_ULPI_RESET_N : inout std_logic;
		USB_HUB_RST_N       : inout std_logic;
		-- UART0
		UART0_RX : in    std_logic := 'X';
		UART0_TX : out   std_logic;

		-- I2C0
		B7A_I2C0_SDA : inout std_logic := 'X';
		B7A_I2C0_SCL : inout std_logic := 'X';

		-- I2C3
		TEMP_I2C_SDA : inout std_logic := 'X';
		TEMP_I2C_SCL : inout std_logic := 'X';

		-- LEDs
		LED0 : inout std_logic := 'X';
		LED1 : inout std_logic := 'X';
		LED2 : inout std_logic := 'X';
		LED3 : inout std_logic := 'X';
		LED4 : inout std_logic := 'X';
		LED5 : inout std_logic := 'X';
		LED6 : inout std_logic := 'X';
		LED7 : inout std_logic := 'X';

		-- HDMI
		HDMI_I2C_SCL   : inout std_logic; -- LOANIO58
		HDMI_I2C_SDA   : inout std_logic; -- LOANIO57
		HDMI_INT       : inout std_logic; -- LOANIO62
		--HDMI_CLK       : out std_logic;
		--HDMI_D7        : out std_logic;
		--HDMI_D6        : out std_logic;
		--HDMI_D5        : out std_logic;
		--HDMI_D4        : out std_logic;
		--HDMI_D3        : out std_logic;
		--HDMI_D2        : out std_logic;
		--HDMI_D1        : out std_logic;
		--HDMI_D0        : out std_logic;

		-- FMC connections
		FMC1_9     : inout std_logic; -- H7: SINC0_D2
		FMC1_10    : inout std_logic;
		FMC1_11    : inout std_logic;
		FMC1_12    : inout std_logic;
		FMC1_13    : inout std_logic;
		FMC1_14    : inout std_logic;
		FMC1_17    : inout std_logic;
		FMC1_18    : inout std_logic;
		FMC1_19    : inout std_logic;
		FMC1_20    : inout std_logic;
		FMC1_23    : inout std_logic;
		FMC1_24    : inout std_logic;
		FMC1_25    : inout std_logic;
		FMC1_26    : inout std_logic;
		FMC1_29    : inout std_logic;
		FMC1_30    : inout std_logic;
		FMC1_31    : inout std_logic;
		FMC1_32    : inout std_logic;
		FMC1_35    : inout std_logic;
		FMC1_36    : inout std_logic;
		FMC1_37    : inout std_logic;
		FMC1_38    : inout std_logic; -- H8: /I_TRIP
		FMC1_41    : inout std_logic;
		FMC1_42    : inout std_logic;
		FMC1_43    : inout std_logic;
		FMC1_44    : inout std_logic;
		FMC1_47    : inout std_logic; -- G6: SINC0_CLK0
		FMC1_48    : inout std_logic; -- D8: SINC0_D0
		FMC1_49    : inout std_logic; -- G7: SINC0_CLK1
		FMC1_50    : inout std_logic; -- D9: SINC0_D1
		FMC1_53    : inout std_logic; -- G9: AH
		FMC1_54    : inout std_logic; -- H10: BH
		FMC1_55    : inout std_logic; -- G10: AL
		FMC1_56    : inout std_logic; -- H11: BL
		FMC1_61    : inout std_logic; -- D11: CH
		FMC1_62    : inout std_logic; -- C10: EN_PWM
		FMC1_63    : inout std_logic; -- D12: CL
		FMC1_64    : inout std_logic; -- C11: HALL_U_BUF
		FMC1_67    : inout std_logic; -- H13: HALL_V_BUF
		FMC1_68    : inout std_logic; -- G12: CHANNEL_A_BUF
		FMC1_69    : inout std_logic; -- H14: HALL_W_BUFF
		FMC1_70    : inout std_logic; -- G13: CHANNEL_B_BUF
		FMC1_73    : inout std_logic; -- D14: CHANNEL_INDEX_BUF
		FMC1_74    : inout std_logic;
		FMC1_75    : inout std_logic;
		FMC1_76    : inout std_logic;
		FMC1_81    : inout std_logic;
		FMC1_82    : inout std_logic;
		FMC1_83    : inout std_logic;
		FMC1_84    : inout std_logic;
		FMC1_87    : inout std_logic;
		FMC1_88    : inout std_logic;
		FMC1_89    : inout std_logic;
		FMC1_90    : inout std_logic;
		FMC1_91    : inout std_logic;
		FMC1_92    : inout std_logic;
		FMC1_93    : inout std_logic;
		FMC1_94    : inout std_logic;
		FMC2_100   : inout std_logic;
		FMC2_14    : inout std_logic;
		FMC2_18    : inout std_logic;
		FMC2_20    : inout std_logic;
		FMC2_23    : inout std_logic;
		FMC2_24    : inout std_logic;
		FMC2_25    : inout std_logic;
		FMC2_26    : inout std_logic;
		FMC2_29    : inout std_logic;
		FMC_SCL : inout std_logic; -- I2C1 
		FMC_SDA : inout std_logic; -- I2C1 
		FMC2_13    : inout std_logic;
		FMC2_17    : inout std_logic;
		FMC2_19    : inout std_logic;
		FMC2_30    : inout std_logic;
		FMC2_31    : inout std_logic;
		FMC2_32    : inout std_logic;
		FMC2_35    : inout std_logic;
		FMC2_36    : inout std_logic;
		FMC2_37    : inout std_logic;
		FMC2_38    : inout std_logic;
		FMC2_41    : inout std_logic;
		FMC2_42    : inout std_logic;
		FMC2_43    : inout std_logic;
		FMC2_44    : inout std_logic;
		FMC2_47    : inout std_logic;
		FMC2_48    : inout std_logic;
		FMC2_49    : inout std_logic;
		FMC2_50    : inout std_logic;
		FMC2_53    : inout std_logic;
		FMC2_54    : inout std_logic;
		FMC2_55    : inout std_logic;
		FMC2_56    : inout std_logic;
		FMC2_61    : inout std_logic;
		FMC2_62    : inout std_logic;
		FMC2_63    : inout std_logic;
		FMC2_64    : inout std_logic;
		FMC2_67    : inout std_logic;
		FMC2_68    : inout std_logic;
		FMC2_69    : inout std_logic; 
		FMC2_70    : inout std_logic;
		FMC2_73    : inout std_logic;
		FMC2_74    : inout std_logic;
		FMC2_75    : inout std_logic;
		FMC2_76    : inout std_logic;
		FMC2_81    : inout std_logic;
		FMC2_82    : inout std_logic;
		FMC2_83    : inout std_logic;
		FMC2_84    : inout std_logic;
		FMC2_87    : inout std_logic;
		FMC2_88    : inout std_logic;
		FMC2_89    : inout std_logic;
		FMC2_90    : inout std_logic;
		FMC2_93    : inout std_logic;
		FMC2_94    : inout std_logic;
		FMC2_95    : inout std_logic;
		FMC2_96    : inout std_logic;
		FMC2_97    : inout std_logic;
		FMC2_99    : inout std_logic;
		FMC3_36    : inout std_logic; -- GPIO56
		FMC3_38    : inout std_logic; -- GPIO54
		FMC3_39    : inout std_logic; -- GPIO55
		FMC3_41    : inout std_logic; -- GPIO52
		FMC3_73    : inout std_logic;
		FMC3_74    : inout std_logic;
		FMC3_75    : inout std_logic;
		FMC3_76    : inout std_logic;
		FMC3_79    : inout std_logic;
		FMC3_80    : inout std_logic;
		FMC3_81    : inout std_logic;
		FMC3_82    : inout std_logic;
		FMC3_85    : inout std_logic;
		FMC3_87    : inout std_logic
	);

end entity dev_5cs_top;

-------------------------------------------------------------------------------

architecture rtl of dev_5cs_top is
	component dev_5cs is
		port(
			hps_ddr_mem_a                    : out   std_logic_vector(HPS_DDR_A_SIZE-1 downto 0);
			hps_ddr_mem_ba                   : out   std_logic_vector(2 downto 0);
			hps_ddr_mem_ck                   : out   std_logic;
			hps_ddr_mem_ck_n                 : out   std_logic;
			hps_ddr_mem_cke                  : out   std_logic;
			hps_ddr_mem_cs_n                 : out   std_logic;
			hps_ddr_mem_ras_n                : out   std_logic;
			hps_ddr_mem_cas_n                : out   std_logic;
			hps_ddr_mem_we_n                 : out   std_logic;
			hps_ddr_mem_reset_n              : out   std_logic;
			hps_ddr_mem_dq                   : inout std_logic_vector(HPS_DDR_D_SIZE-1 downto 0)    := (others => 'X');
			hps_ddr_mem_dqs                  : inout std_logic_vector(HPS_DDR_NUM_CHIPS-1 downto 0) := (others => 'X');
			hps_ddr_mem_dqs_n                : inout std_logic_vector(HPS_DDR_NUM_CHIPS-1 downto 0) := (others => 'X');
			hps_ddr_mem_odt                  : out   std_logic;
			hps_ddr_mem_dm                   : out   std_logic_vector(HPS_DDR_NUM_CHIPS-1 downto 0);
			hps_ddr_oct_rzqin                : in    std_logic                                      := 'X';
			hps_io_hps_io_emac1_inst_TX_CLK  : out   std_logic;
			hps_io_hps_io_emac1_inst_TXD0    : out   std_logic;
			hps_io_hps_io_emac1_inst_TXD1    : out   std_logic;
			hps_io_hps_io_emac1_inst_TXD2    : out   std_logic;
			hps_io_hps_io_emac1_inst_TXD3    : out   std_logic;
			hps_io_hps_io_emac1_inst_RXD0    : in    std_logic                                      := 'X';
			hps_io_hps_io_emac1_inst_MDIO    : inout std_logic                                      := 'X';
			hps_io_hps_io_emac1_inst_MDC     : out   std_logic;
			hps_io_hps_io_emac1_inst_RX_CTL  : in    std_logic                                      := 'X';
			hps_io_hps_io_emac1_inst_TX_CTL  : out   std_logic;
			hps_io_hps_io_emac1_inst_RX_CLK  : in    std_logic                                      := 'X';
			hps_io_hps_io_emac1_inst_RXD1    : in    std_logic                                      := 'X';
			hps_io_hps_io_emac1_inst_RXD2    : in    std_logic                                      := 'X';
			hps_io_hps_io_emac1_inst_RXD3    : in    std_logic                                      := 'X';
			hps_io_hps_io_qspi_inst_SS1      : out   std_logic;
			hps_io_hps_io_qspi_inst_IO0      : inout std_logic                                      := 'X';
			hps_io_hps_io_qspi_inst_IO1      : inout std_logic                                      := 'X';
			hps_io_hps_io_qspi_inst_IO2      : inout std_logic                                      := 'X';
			hps_io_hps_io_qspi_inst_IO3      : inout std_logic                                      := 'X';
			hps_io_hps_io_qspi_inst_SS0      : out   std_logic;
			hps_io_hps_io_qspi_inst_CLK      : out   std_logic;
			hps_io_hps_io_sdio_inst_CMD      : inout std_logic                                      := 'X';
			hps_io_hps_io_sdio_inst_D0       : inout std_logic                                      := 'X';
			hps_io_hps_io_sdio_inst_D1       : inout std_logic                                      := 'X';
			hps_io_hps_io_sdio_inst_CLK      : out   std_logic;
			hps_io_hps_io_sdio_inst_D2       : inout std_logic                                      := 'X';
			hps_io_hps_io_sdio_inst_D3       : inout std_logic                                      := 'X';
			hps_io_hps_io_usb1_inst_D0       : inout std_logic                                      := 'X';
			hps_io_hps_io_usb1_inst_D1       : inout std_logic                                      := 'X';
			hps_io_hps_io_usb1_inst_D2       : inout std_logic                                      := 'X';
			hps_io_hps_io_usb1_inst_D3       : inout std_logic                                      := 'X';
			hps_io_hps_io_usb1_inst_D4       : inout std_logic                                      := 'X';
			hps_io_hps_io_usb1_inst_D5       : inout std_logic                                      := 'X';
			hps_io_hps_io_usb1_inst_D6       : inout std_logic                                      := 'X';
			hps_io_hps_io_usb1_inst_D7       : inout std_logic                                      := 'X';
			hps_io_hps_io_usb1_inst_CLK      : in    std_logic                                      := 'X';
			hps_io_hps_io_usb1_inst_STP      : out   std_logic;
			hps_io_hps_io_usb1_inst_DIR      : in    std_logic                                      := 'X';
			hps_io_hps_io_usb1_inst_NXT      : in    std_logic                                      := 'X';
			hps_io_hps_io_uart0_inst_RX      : in    std_logic                                      := 'X';
			hps_io_hps_io_uart0_inst_TX      : out   std_logic;
			hps_io_hps_io_i2c0_inst_SDA      : inout std_logic                                      := 'X';
			hps_io_hps_io_i2c0_inst_SCL      : inout std_logic                                      := 'X';
			hps_io_hps_io_i2c1_inst_SDA      : inout std_logic                                      := 'X';
			hps_io_hps_io_i2c1_inst_SCL      : inout std_logic                                      := 'X';
			hps_io_hps_io_gpio_inst_GPIO00   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO00
			hps_io_hps_io_gpio_inst_GPIO09   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_io_hps_io_gpio_inst_GPIO28   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO28
			hps_io_hps_io_gpio_inst_GPIO37   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO37
			hps_io_hps_io_gpio_inst_GPIO40   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
			hps_io_hps_io_gpio_inst_GPIO41   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO41
			hps_io_hps_io_gpio_inst_GPIO42   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO42
			hps_io_hps_io_gpio_inst_GPIO44   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO44
			hps_io_hps_io_gpio_inst_GPIO48   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48
			hps_io_hps_io_gpio_inst_GPIO49   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO49
			hps_io_hps_io_gpio_inst_GPIO50   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO50
			hps_io_hps_io_gpio_inst_GPIO53   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			hps_io_hps_io_gpio_inst_GPIO54   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
			hps_io_hps_io_gpio_inst_GPIO55   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO55
			hps_io_hps_io_gpio_inst_GPIO56   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO56
			hps_io_hps_io_gpio_inst_GPIO59   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO59
			hps_io_hps_io_gpio_inst_GPIO62   : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO62
			hps_io_hps_io_gpio_inst_LOANIO43 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO43
			hps_io_hps_io_gpio_inst_LOANIO57 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO57
			hps_io_hps_io_gpio_inst_LOANIO58 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO58
			hps_io_hps_io_gpio_inst_LOANIO60 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO60
			hps_io_hps_io_gpio_inst_LOANIO61 : inout std_logic                     := 'X';             -- hps_io_gpio_inst_LOANIO61
			loan_io_in                       : out   std_logic_vector(66 downto 0);                   -- in
			loan_io_out                      : in    std_logic_vector(66 downto 0)                  := (others => 'X'); -- out
			loan_io_oe                       : in    std_logic_vector(66 downto 0)                  := (others => 'X'); -- oe
			i2c2_scl_in_clk                  : in    std_logic                                      := 'X';             -- clk
			i2c2_clk_clk                     : out   std_logic;                                       -- clk
			i2c2_out_data                    : out   std_logic;                                       -- out_data
			i2c2_sda                         : in    std_logic                                      := 'X'      ;        -- sda
			i2c3_out_data                    : out   std_logic;                                        -- out_data
			i2c3_sda                         : in    std_logic                     := 'X';             -- sda
			i2c3_clk_clk                     : out   std_logic;                                        -- clk
			i2c3_scl_in_clk                  : in    std_logic                     := 'X';             -- clk
			pio_0_export                     : inout std_logic_vector(31 downto 0)                  := (others => 'X');
			pio_1_export                     : inout std_logic_vector(31 downto 0)                  := (others => 'X');
			pio_2_export                     : inout std_logic_vector(31 downto 0)                  := (others => 'X');
			pio_3_export                     : inout std_logic_vector(27 downto 0)                  := (others => 'X');
			pwm_sigs_pwm_sync                : out   std_logic;                                        -- pwm_sync
			pwm_sigs_PWM_AL_out              : out   std_logic;                                        -- PWM_AL_out
			pwm_sigs_PWM_AH_out              : out   std_logic;                                        -- PWM_AH_out
			pwm_sigs_PWM_BL_out              : out   std_logic;                                        -- PWM_BL_out
			pwm_sigs_PWM_BH_out              : out   std_logic;                                        -- PWM_BH_out
			pwm_sigs_PWM_CL_out              : out   std_logic;                                        -- PWM_CL_out
			pwm_sigs_PWM_CH_out              : out   std_logic;                                        -- PWM_CH_out
			pwm_sigs_ITRIP                   : in    std_logic                     := 'X';             -- ITRIP
			pwm_sigs_SINC0_TRIP              : in    std_logic                     := 'X';             -- SINC0_TRIP
			pwm_sigs_SINC1_TRIP              : in    std_logic                     := 'X';             -- SINC1_TRIP
			pwm_sigs_MSTR_SYNC               : in    std_logic                     := 'X';             -- MSTR_SYNC
			pwm_sigs_pwm_led_pin             : out   std_logic;                                        -- pwm_led_pin
			pwm_sigs_PWM_EN_PIN              : out   std_logic;                                        -- PWM_EN_PIN
			qep_sigs_A                       : in    std_logic                     := 'X';             -- A
			qep_sigs_B                       : in    std_logic                     := 'X';             -- B
			qep_sigs_Z                       : in    std_logic                     := 'X';             -- Z
			qep_sigs_HALL                    : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- HALL
			qep_sigs_sync_strobe             : in    std_logic                     := 'X';             -- sync_strobe
			sinc_flush_trip_sigs_o_sinc0_data_irq : out   std_logic;                                        -- o_sinc0_data_irq
			sinc_flush_trip_sigs_SINC_MCLK   : out   std_logic;                                        -- SINC_MCLK
			sinc_flush_trip_sigs_SINC0_TRIP  : out   std_logic;                                        -- SINC0_TRIP
			sinc_flush_trip_sigs_SINC1_TRIP  : out   std_logic;                                        -- SINC1_TRIP
			sinc_flush_trip_sigs_SINC_D0     : in    std_logic                     := 'X';             -- SINC_D0
			sinc_flush_trip_sigs_SINC_D1     : in    std_logic                     := 'X';             -- SINC_D1
			sinc_flush_trip_sigs_PWM_SYNC    : in    std_logic                     := 'X'              -- PWM_SYNC
		);
	end component dev_5cs;
	component hdmi_ddio
		PORT
		(
			datain_h		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
			datain_l		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
			outclock		: IN STD_LOGIC ;
			dataout		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
		);
	end component;

	signal s_hdmi_clk        : std_logic;
	signal s_hdmi_dv         : std_logic;
	signal s_hdmi_h_sync     : std_logic;
	signal s_hdmi_v_sync     : std_logic;
	signal s_hdmi_data       : std_logic_vector(15 downto 0);
	signal s_loan_io_in      : std_logic_vector(66 downto 0);                    -- in
	signal s_loan_io_out     : std_logic_vector(66 downto 0) := (others => '0'); -- out
	signal s_loan_io_oe      : std_logic_vector(66 downto 0) := (others => '0'); -- oe
	signal s_i2c2_scl_in_clk : std_logic                     := 'X';             -- clk
	signal s_i2c2_clk_clk    : std_logic;                                       -- clk
	signal s_i2c2_out_data   : std_logic;                                       -- out_data
	signal s_i2c2_sda        : std_logic                     := 'X'      ;        -- sda
	signal s_i2c3_scl_in_clk : std_logic                     := 'X';             -- clk
	signal s_i2c3_clk_clk    : std_logic;                                       -- clk
	signal s_i2c3_out_data   : std_logic;                                       -- out_data
	signal s_i2c3_sda        : std_logic                     := 'X'      ;        -- sda

	signal A : std_logic := '0';
	signal B : std_logic := '0';
	signal Z : std_logic := '0';
	signal HALL : std_logic_vector(2 downto 0) := (others => '0');
	signal ITRIP : std_logic := '0';
	signal MSTR_SYNC : std_logic := '0';
	signal SINC_D0 : std_logic := '0';
	signal SINC_D1 : std_logic := '0';
	signal PWM_AH : std_logic := '0';
	signal PWM_AL : std_logic := '0';
	signal PWM_BH : std_logic := '0';
	signal PWM_BL : std_logic := '0';
	signal PWM_CH : std_logic := '0';
	signal PWM_CL : std_logic := '0';
	signal PWM_EN_PIN : std_logic := '0';
	signal pwm_led_pin : std_logic := '0';
	signal SINC_MCLK : std_logic := '0';

	signal SINC0_TRIP : std_logic := '0';
	signal SINC1_TRIP : std_logic := '0';
	signal pwm_sync : std_logic := '0';

begin                                   -- architecture rtl

	----------------------------------------------------------------------------
	-- Component instantiations
	----------------------------------------------------------------------------

	u0 : component dev_5cs
		port map(
			hps_ddr_mem_a                   => HPS_DDR_A,
			hps_ddr_mem_ba                  => HPS_DDR_BAS,
			hps_ddr_mem_ck                  => HPS_DDR_CK_P,
			hps_ddr_mem_ck_n                => HPS_DDR_CK_N,
			hps_ddr_mem_cke                 => HPS_DDR_CKE,
			hps_ddr_mem_cs_n                => HPS_DDR_CS0_N,
			hps_ddr_mem_ras_n               => HPS_DDR_RAS_N,
			hps_ddr_mem_cas_n               => HPS_DDR_CAS_N,
			hps_ddr_mem_we_n                => HPS_DDR_WE_N,
			hps_ddr_mem_reset_n             => HPS_DDR_RESET_N,
			hps_ddr_mem_dq                  => HPS_DDR_D,
			hps_ddr_mem_dqs                 => HPS_DDR_DQS_P,
			hps_ddr_mem_dqs_n               => HPS_DDR_DQS_N,
			hps_ddr_mem_odt                 => HPS_ODT,
			hps_ddr_mem_dm                  => HPS_DDR_DQM,
			hps_ddr_oct_rzqin               => HPS_RZQ0,
			hps_io_hps_io_emac1_inst_TX_CLK => RGMII1_TX_CLK,
			hps_io_hps_io_emac1_inst_TXD0   => RGMII1_TXD0,
			hps_io_hps_io_emac1_inst_TXD1   => RGMII1_TXD1,
			hps_io_hps_io_emac1_inst_TXD2   => RGMII1_TXD2,
			hps_io_hps_io_emac1_inst_TXD3   => RGMII1_TXD3,
			hps_io_hps_io_emac1_inst_RXD0   => RGMII1_RXD0,
			hps_io_hps_io_emac1_inst_RXD1   => RGMII1_RXD1,
			hps_io_hps_io_emac1_inst_RXD2   => RGMII1_RXD2,
			hps_io_hps_io_emac1_inst_RXD3   => RGMII1_RXD3,
			hps_io_hps_io_emac1_inst_MDIO   => RGMII1_MDIO,
			hps_io_hps_io_emac1_inst_MDC    => RGMII1_MDC,
			hps_io_hps_io_emac1_inst_RX_CTL => RGMII1_RX_CTL,
			hps_io_hps_io_emac1_inst_TX_CTL => RGMII1_TX_CTL,
			hps_io_hps_io_emac1_inst_RX_CLK => RGMII1_RX_CLK,
			hps_io_hps_io_qspi_inst_SS1      => QSPI_SS1,
			hps_io_hps_io_qspi_inst_IO0      => QSPI_DQ0,
			hps_io_hps_io_qspi_inst_IO1      => QSPI_DQ1,
			hps_io_hps_io_qspi_inst_IO2      => QSPI_DQ2,
			hps_io_hps_io_qspi_inst_IO3      => QSPI_DQ3,
			hps_io_hps_io_qspi_inst_SS0      => QSPI_SS0,
			hps_io_hps_io_qspi_inst_CLK      => QSPI_CLK,
			hps_io_hps_io_sdio_inst_CMD      => MMC0_CMD,
			hps_io_hps_io_sdio_inst_D0       => MMC0_DAT0,
			hps_io_hps_io_sdio_inst_D1       => MMC0_DAT1,
			hps_io_hps_io_sdio_inst_D2       => MMC0_DAT2,
			hps_io_hps_io_sdio_inst_D3       => MMC0_DAT3,
			hps_io_hps_io_sdio_inst_CLK      => MMC0_CLK,
			hps_io_hps_io_usb1_inst_D0       => USB1_ULPI_D0,
			hps_io_hps_io_usb1_inst_D1       => USB1_ULPI_D1,
			hps_io_hps_io_usb1_inst_D2       => USB1_ULPI_D2,
			hps_io_hps_io_usb1_inst_D3       => USB1_ULPI_D3,
			hps_io_hps_io_usb1_inst_D4       => USB1_ULPI_D4,
			hps_io_hps_io_usb1_inst_D5       => USB1_ULPI_D5,
			hps_io_hps_io_usb1_inst_D6       => USB1_ULPI_D6,
			hps_io_hps_io_usb1_inst_D7       => USB1_ULPI_D7,
			hps_io_hps_io_usb1_inst_CLK      => USB1_ULPI_CLK,
			hps_io_hps_io_usb1_inst_STP      => USB1_ULPI_STP,
			hps_io_hps_io_usb1_inst_DIR      => USB1_ULPI_DIR,
			hps_io_hps_io_usb1_inst_NXT      => USB1_ULPI_NXT,
			hps_io_hps_io_uart0_inst_RX      => UART0_RX,
			hps_io_hps_io_uart0_inst_TX      => UART0_TX,
			hps_io_hps_io_i2c0_inst_SDA      => B7A_I2C0_SDA,
			hps_io_hps_io_i2c0_inst_SCL      => B7A_I2C0_SCL,
			hps_io_hps_io_i2c1_inst_SDA      => FMC_SDA,
			hps_io_hps_io_i2c1_inst_SCL      => FMC_SCL,
			hps_io_hps_io_gpio_inst_GPIO00   => USB1_ULPI_CS,
			hps_io_hps_io_gpio_inst_GPIO09   => USB1_ULPI_RESET_N,
			hps_io_hps_io_gpio_inst_GPIO28   => RGMII1_RESET_N,
			hps_io_hps_io_gpio_inst_GPIO37   => USB_HUB_RST_N,
			hps_io_hps_io_gpio_inst_GPIO40   => LED5,
			hps_io_hps_io_gpio_inst_GPIO41   => LED6,
			hps_io_hps_io_gpio_inst_GPIO42   => LED7,
			hps_io_hps_io_gpio_inst_GPIO44   => LED4,
			hps_io_hps_io_gpio_inst_GPIO48   => LED3,
			hps_io_hps_io_gpio_inst_GPIO49   => LED2,
			hps_io_hps_io_gpio_inst_GPIO50   => LED1,
			hps_io_hps_io_gpio_inst_GPIO53   => FMC3_41,
			hps_io_hps_io_gpio_inst_GPIO54   => FMC3_38,
			hps_io_hps_io_gpio_inst_GPIO55   => FMC3_39,
			hps_io_hps_io_gpio_inst_GPIO56   => FMC3_36,
			hps_io_hps_io_gpio_inst_GPIO59   => FMC2_36,
			hps_io_hps_io_gpio_inst_GPIO62   => HDMI_INT,
			hps_io_hps_io_gpio_inst_LOANIO43  => TEMP_I2C_SCL,
			hps_io_hps_io_gpio_inst_LOANIO57 => HDMI_I2C_SDA,
			hps_io_hps_io_gpio_inst_LOANIO58 => HDMI_I2C_SCL,
			hps_io_hps_io_gpio_inst_LOANIO60 => LED0,
			hps_io_hps_io_gpio_inst_LOANIO61   => TEMP_I2C_SDA,
			loan_io_in        => s_loan_io_in,
			loan_io_out       => s_loan_io_out,
			loan_io_oe        => s_loan_io_oe,
			i2c2_scl_in_clk   => s_i2c2_scl_in_clk,
			i2c2_clk_clk      => s_i2c2_clk_clk,
			i2c2_out_data     => s_i2c2_out_data,
			i2c2_sda          => s_i2c2_sda,
			i2c3_scl_in_clk   => s_i2c3_scl_in_clk,
			i2c3_clk_clk      => s_i2c3_clk_clk,
			i2c3_out_data     => s_i2c3_out_data,
			i2c3_sda          => s_i2c3_sda,
			--cvo_vid_clk       => s_hdmi_clk,
			--cvo_vid_data      => s_hdmi_data,
			--cvo_underflow     => open,
			--cvo_vid_trs => open,
			--cvo_vid_ln => open, 
			pio_0_export(0)  => FMC1_9,
			pio_0_export(1)  => FMC1_10,
			pio_0_export(2)  => FMC1_11,
			pio_0_export(3)  => open, --FMC1_12,
			pio_0_export(4)  => open, --FMC1_13,
			pio_0_export(5)  => open, --FMC1_14,
			pio_0_export(6)  => open, --FMC1_17,
			pio_0_export(7)  => open, --FMC1_18,
			pio_0_export(8)  => open, --FMC1_19,
			pio_0_export(9)  => open, --FMC1_20,
			pio_0_export(10) => open, --FMC1_23,
			pio_0_export(11) => open, --FMC1_24,
			pio_0_export(12) => open, --FMC1_25,
			pio_0_export(13) => open, --FMC1_26,
			pio_0_export(14) => open, --FMC1_29,
			pio_0_export(15) => open, --FMC1_30,
			pio_0_export(16) => open, --FMC1_31,
			pio_0_export(17) => FMC1_32,
			pio_0_export(18) => FMC1_35,
			pio_0_export(19) => FMC1_36,
			pio_0_export(20) => FMC1_37,
			pio_0_export(21) => open, --FMC1_41,
			pio_0_export(22) => open, --FMC1_42,
			pio_0_export(23) => FMC1_43,
			pio_0_export(24) => open, --FMC1_44,
			pio_0_export(25) => FMC1_47,
			pio_0_export(26) => FMC1_48,
			pio_0_export(27) => FMC1_49,
			pio_0_export(28) => FMC1_50,
			pio_0_export(29) => FMC1_53,
			pio_0_export(30) => FMC1_54,
			pio_0_export(31) => FMC1_55,
			pio_1_export(0)  => FMC1_56,
			pio_1_export(1)  => FMC1_61,
			pio_1_export(2)  => FMC1_62,
			pio_1_export(3)  => open, --FMC1_63,
			pio_1_export(4)  => FMC1_64,
			pio_1_export(5)  => FMC1_67,
			pio_1_export(6)  => FMC1_68,
			pio_1_export(7)  => FMC1_69,
			pio_1_export(8)  => FMC1_70,
			pio_1_export(9)  => FMC1_73,
			pio_1_export(10) => FMC1_74,
			pio_1_export(11) => FMC1_75,
			pio_1_export(12) => FMC1_76,
			pio_1_export(13) => FMC1_81,
			pio_1_export(14) => FMC1_82,
			pio_1_export(15) => FMC1_83,
			pio_1_export(16) => FMC1_84,
			pio_1_export(17) => FMC1_87,
			pio_1_export(18) => FMC1_88,
			pio_1_export(19) => FMC1_89,
			pio_1_export(20) => FMC1_90,
			pio_1_export(21) => FMC1_91,
			pio_1_export(22) => FMC1_92,
			pio_1_export(23) => FMC1_93,
			pio_1_export(24) => FMC1_94,
			pio_1_export(25) => FMC2_14,
			pio_1_export(26) => FMC2_18,
			pio_1_export(27) => FMC2_20,
			pio_1_export(28) => FMC2_23,
			pio_1_export(29) => FMC2_24,
			pio_1_export(30) => FMC2_25,
			pio_1_export(31) => FMC2_26,
			pio_2_export(0)  => FMC2_29,
			pio_2_export(1)  => FMC2_30,
			pio_2_export(2)  => FMC2_31,
			pio_2_export(3)  => FMC2_32,
			pio_2_export(4)  => FMC2_35,
			pio_2_export(5)  => FMC2_37,
			pio_2_export(6)  => FMC2_38,
			pio_2_export(7)  => FMC2_41,
			pio_2_export(8)  => FMC2_42,
			pio_2_export(9)  => FMC2_43,
			pio_2_export(10) => FMC2_44,
			pio_2_export(11) => FMC2_53,
			pio_2_export(12) => FMC2_54,
			pio_2_export(13) => FMC2_55,
			pio_2_export(14) => FMC2_56,
			pio_2_export(15) => FMC2_61,
			pio_2_export(16) => FMC2_62,
			pio_2_export(17) => FMC2_63,
			pio_2_export(18) => FMC2_64,
			pio_2_export(19) => FMC2_67,
			pio_2_export(20) => FMC2_68,
			pio_2_export(21) => FMC2_69,
			pio_2_export(22) => FMC2_70,
			pio_2_export(23) => FMC2_73,
			pio_2_export(24) => FMC2_74,
			pio_2_export(25) => FMC2_75,
			pio_2_export(26) => FMC2_76,
			pio_2_export(27) => FMC2_81,
			pio_2_export(28) => FMC2_82,
			pio_2_export(29) => FMC2_83,
			pio_2_export(30) => FMC2_84,
			pio_2_export(31) => FMC2_87,
			pio_3_export(0)  => FMC2_88,
			pio_3_export(1)  => FMC2_89,
			pio_3_export(2)  => FMC2_90,
			pio_3_export(3)  => FMC2_93,
			pio_3_export(4)  => FMC2_94,
			pio_3_export(5)  => FMC2_95,
			pio_3_export(6)  => FMC2_96,
			pio_3_export(7)  => FMC2_97,
			pio_3_export(8)  => FMC2_99,
			pio_3_export(9)  => FMC3_73,
			pio_3_export(10) => FMC3_74,
			pio_3_export(11) => FMC3_75,
			pio_3_export(12) => FMC3_76,
			pio_3_export(13) => FMC3_79,
			pio_3_export(14) => FMC3_80,
			pio_3_export(15) => FMC3_81,
			pio_3_export(16) => FMC3_82,
			pio_3_export(17) => FMC3_85,
			pio_3_export(18) => FMC3_87,
			pio_3_export(19) => FMC2_17,
			pio_3_export(20) => FMC2_48,
			pio_3_export(21) => FMC2_50,
			pio_3_export(22) => FMC2_13,
			pio_3_export(23) => FMC2_19,
			pio_3_export(24) => FMC2_47,
			pio_3_export(25) => FMC2_49,
			pio_3_export(26) => FMC1_38,
			pio_3_export(27) => FMC2_100,
			pwm_sigs_pwm_sync => pwm_sync,
			pwm_sigs_PWM_AL_out => PWM_AL,
			pwm_sigs_PWM_AH_out => PWM_AH,
			pwm_sigs_PWM_BL_out => PWM_BL,
			pwm_sigs_PWM_BH_out => PWM_BH,
			pwm_sigs_PWM_CL_out => PWM_CL,
			pwm_sigs_PWM_CH_out => PWM_CH,
			pwm_sigs_ITRIP => ITRIP,
			pwm_sigs_SINC0_TRIP => SINC0_TRIP,
			pwm_sigs_SINC1_TRIP => SINC1_TRIP,
			pwm_sigs_MSTR_SYNC => MSTR_SYNC,
			pwm_sigs_pwm_led_pin => pwm_led_pin,
			pwm_sigs_PWM_EN_PIN => PWM_EN_PIN,
			qep_sigs_A => A,
			qep_sigs_B => B,
			qep_sigs_Z => Z,
			qep_sigs_HALL => HALL,
			qep_sigs_sync_strobe => pwm_sync,
			sinc_flush_trip_sigs_o_sinc0_data_irq => FMC1_63, --TODO: debug
			sinc_flush_trip_sigs_SINC_MCLK => SINC_MCLK,
			sinc_flush_trip_sigs_SINC0_TRIP => SINC0_TRIP,
			sinc_flush_trip_sigs_SINC1_TRIP => SINC1_TRIP,
			sinc_flush_trip_sigs_SINC_D0 => SINC_D0,
			sinc_flush_trip_sigs_SINC_D1 => SINC_D1,
			sinc_flush_trip_sigs_PWM_SYNC => pwm_sync
		);

	--TODO: These pins are updated to use FMC1 (Communications FMC Interface?) Instead of FMC2 (Motor Control FMC Interface) due to rework mistake	
	--	CHANGE THESE BACK ONCE BOARD IS RESPUN
	A <= FMC1_29; --FMC1_68;
	B <= FMC1_31; --FMC1_70;
	Z <= FMC1_30; --FMC1_73;
	HALL(0) <= FMC1_26; --FMC1_69;
	HALL(1) <= FMC1_24; --FMC1_67;
	HALL(2) <= FMC1_25; --FMC1_64;
	ITRIP <= FMC1_13; --FMC1_38;
	-- Not used (and goes nowhere in current version of pwm_ip)
	MSTR_SYNC <= '0';
	SINC_D0 <= FMC1_42; --FMC1_48;
	SINC_D1 <= FMC1_44; --FMC1_50;

	FMC1_12 <= PWM_AH; --FMC1_53 <= PWM_AH;
	FMC1_14 <= PWM_AL; --FMC1_55 <= PWM_AL;
	FMC1_17 <= PWM_BH; --FMC1_54 <= PWM_BH;
	FMC1_19 <= PWM_BL; --FMC1_56 <= PWM_BL;
	FMC1_18 <= PWM_CH; --FMC1_61 <= PWM_CH;
	FMC1_20 <= PWM_CL; --FMC1_63 <= PWM_CL;
	FMC1_23 <= PWM_EN_PIN; --FMC1_62 <= PWM_EN_PIN;
	FMC1_41 <= SINC_MCLK; --FMC1_47 <= SINC_MCLK;

	-- LED0 controlled by PWM_IP core
	s_loan_io_out(60) <= '0';
	s_loan_io_oe(60) <= pwm_led_pin;

	-- I2C2 routed to HDMI I2C
	s_loan_io_out(58) <= '0';
	s_loan_io_oe(58) <= s_i2c2_clk_clk;
	s_i2c2_scl_in_clk <= s_loan_io_in(58);
	s_loan_io_out(57) <= '0';
	s_loan_io_oe(57) <= s_i2c2_out_data;
	s_i2c2_sda <= s_loan_io_in(57);

	-- I2C3 routed to TEMP I2C
	s_loan_io_out(43) <= '0';
	s_loan_io_oe (43) <= s_i2c3_clk_clk;
	s_i2c3_scl_in_clk <= s_loan_io_in(43);
	s_loan_io_out(61) <= '0';
	s_loan_io_oe(61) <= s_i2c3_out_data;
	s_i2c3_sda <= s_loan_io_in(61);

--	hdmi_ddio0 : component hdmi_ddio
--		port map (
--			datain_h(8)          => '1',
--			datain_h(7 downto 0) => s_hdmi_data(15 downto 8),
--			datain_l(8)          => '0',
--			datain_l(7 downto 0) => s_hdmi_data(7 downto 0),
--			outclock              => s_hdmi_clk,
--			dataout (8)           => HDMI_CLK,
--			dataout (7)           => HDMI_D7,
--			dataout (6)           => HDMI_D6,
--			dataout (5)           => HDMI_D5,
--			dataout (4)           => HDMI_D4,
--			dataout (3)           => HDMI_D3,
--			dataout (2)           => HDMI_D2,
--			dataout (1)           => HDMI_D1,
--			dataout (0)           => HDMI_D0
--		);
--
end architecture rtl;

-------------------------------------------------------------------------------


