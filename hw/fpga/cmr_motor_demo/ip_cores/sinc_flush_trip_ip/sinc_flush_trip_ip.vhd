-- Title: sinc_flush_trip_ip.vhd
--
--
--     o  0
--     | /       Copyright (c) 2020
--    (CL)---o   Critical Link, LLC
--      \
--       O
--
-- Company: Critical Link, LLC.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library WORK;
LIBRARY altera_mf;
USE altera_mf.all;

--! New wrapper as part of porting sinc_flush_trip_ip_v1_0.v to Altera/Intel Platform
entity sinc_flush_trip_ip is
	port 
	(
		reset : in std_logic := '0'; --! Required by qsys. Unused. 

		-- Interface for control, status, etc. registers
		i_reg_clk : in std_logic := '0'; 
		i_reg_addr : in std_logic_vector(6 downto 0) := (others => '0');
		i_reg_read_en : in std_logic := '0';
		o_reg_readdata : out std_logic_vector(31 downto 0);
		i_reg_write_en : in std_logic := '0';
		i_reg_writedata : in std_logic_vector(31 downto 0) := (others => '0');

		o_irq : out std_logic;

		o_sinc0_data_irq : out std_logic;
		SINC_MCLK : out std_logic;
		SINC0_TRIP : out std_logic;
		SINC1_TRIP : out std_logic;
		SINC_D0 : in std_logic;
		SINC_D1 : in std_logic;
		PWM_SYNC : in std_logic
	);
end entity sinc_flush_trip_ip;

architecture rtl of sinc_flush_trip_ip is
	constant REG0_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(0, 7));
	constant REG1_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(1, 7));
	constant REG2_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(2, 7));
	constant REG3_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(3, 7));
	constant REG4_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(4, 7));
	constant REG5_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(5, 7));
	constant REG6_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(6, 7));
	constant REG7_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(7, 7));
	constant REG8_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(8, 7));
	constant REG9_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(9, 7));
	constant REG10_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(10, 7));
	constant REG11_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(11, 7));
	constant REG12_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(12, 7));
	constant REG13_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(13, 7));
	constant REG14_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(14, 7));
	constant REG15_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(15, 7));
	constant REG16_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16, 7));
	constant REG17_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(17, 7));
	constant REG18_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(18, 7));
	constant REG19_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(19, 7));
	constant REG20_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(20, 7));
	constant REG21_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(21, 7));
	constant REG22_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(22, 7));

	-- For enabling interrupts
	constant REG32_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(32, 7));
	-- For quering interrupt status
	constant REG33_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(33, 7));

	signal reset_SINC : std_logic := '0';
	signal sinc0_latest : std_logic_vector(15 downto 0) := (others => '0');
	signal decimation_rate : std_logic_vector(15 downto 0) := (others => '0');
	signal MDIV : std_logic_vector(15 downto 0) := (others => '0');
	signal scale : std_logic_vector(7 downto 0) := (others => '0');
	signal sinc1_latest : std_logic_vector(15 downto 0) := (others => '0');
	signal sinc_en_cnt : std_logic_vector(31 downto 0) := (others => '0');
	signal sinc_cfg : std_logic := '0';
	signal irq_rate : std_logic_vector(15 downto 0) := (others => '0');
	signal sinc0_synced : std_logic_vector(15 downto 0) := (others => '0');
	signal sinc1_synced : std_logic_vector(15 downto 0) := (others => '0');
	signal enable_mclk : std_logic := '0';
	signal trip_fil_out0 : std_logic_vector(15 downto 0) := (others => '0');
	signal trip_fil_out1 : std_logic_vector(15 downto 0) := (others => '0');
	signal trip0 : std_logic := '0';
	signal trip1 : std_logic := '0';
	signal reset_trip : std_logic := '0';
	signal decimation_rate_trip : std_logic_vector(15 downto 0) := (others => '0');
	signal en_trip : std_logic := '0';
	signal lmax : std_logic_vector(15 downto 0) := (others => '0');
	signal lmin : std_logic_vector(15 downto 0) := (others => '0');
	signal lcnt : std_logic_vector(3 downto 0) := (others => '0');
	signal lwin : std_logic_vector(3 downto 0) := (others => '0');

	signal sinc0_data_irq : std_logic := '0';
	signal sinc0_data_irq_r1 : std_logic := '0';
	signal sinc1_data_irq : std_logic := '0';

	signal sinc0_data_irq_en : std_logic := '0';
	signal sinc1_data_irq_en : std_logic := '0';
	signal force_irq : std_logic := '0';

	signal sinc0_data_int_clr : std_logic := '0';
	signal sinc0_data_int_clr_r1 : std_logic := '0';
	signal sinc1_data_int_clr : std_logic := '0';
	signal sinc1_data_int_clr_r1 : std_logic := '0';
	signal sinc0_data_int_set : std_logic := '0';
	signal sinc1_data_int_set : std_logic := '0';

	signal s_SINC_MCLK : std_logic := '0';

	signal s_o_sinc0_data_irq : std_logic := '0';

	component sinc_mod_clk
		port (
			sys_clk : in std_logic; -- used to clk filter
			MDIV : in std_logic_vector(15 downto 0);
			MCLK : out std_logic;
			reset : in std_logic;
			enable : in std_logic
		);
	end component;

	component sinc_module
		port (
			clk : in std_logic;
			mclk : in std_logic; -- used to clk filter
			reset : in std_logic; -- used to reset filter
			mdata : in std_logic; -- input data to be filtered
			DATA_LATEST : out std_logic_vector(15 downto 0); -- filtered output
			DATA_SYNCED : out std_logic_vector(15 downto 0); -- filtered output
			dec_rate : in std_logic_vector(15 downto 0);
			S : in std_logic_vector(7 downto 0);
			fclk_en_cnt : in std_logic_vector(31 downto 0);
			pwm_sync : in std_logic;
			sinc_mode : in std_logic;
			irq_rate : in std_logic_vector(15 downto 0);
			data_ready_irq : out std_logic
		);
	end component;

	component sinc_trip
		port (
			clk_trip : in std_logic;
			mclk_trip : in std_logic; -- used to clk filter
			reset_trip : in std_logic; -- used to reset filter
			mdata_trip : in std_logic; -- input data to be filtered
			dec_rate_trip : in std_logic_vector(15 downto 0);
			en_trip : in std_logic;
			lmax_trip : in std_logic_vector(15 downto 0);
			lmin_trip : in std_logic_vector(15 downto 0);
			lcnt_trip : in std_logic_vector(3 downto 0);
			lwin_trip : in std_logic_vector(3 downto 0);
			filter_out_trip : out std_logic_vector(15 downto 0); -- filtered output
			trip_status : out std_logic;
			trip_pin : out std_logic
		);
	end component;

begin
	
	--! Process to handle register writes to HPS over Light Weight Bus
	REG_WRITE_PROC : process(i_reg_clk)
	begin
		if rising_edge(i_reg_clk) then
			if (i_reg_write_en = '1') then
				case i_reg_addr is
					when REG0_OFFSET =>
						reset_SINC <= i_reg_writedata(0);


					when REG2_OFFSET =>
						decimation_rate <= i_reg_writedata(15 downto 0);

					when REG3_OFFSET =>
						MDIV <= i_reg_writedata(15 downto 0);

					when REG4_OFFSET =>
						scale <= i_reg_writedata(7 downto 0);


					when REG6_OFFSET =>
						sinc_en_cnt <= i_reg_writedata(31 downto 0);

					when REG7_OFFSET =>
						sinc_cfg <= i_reg_writedata(0);

					when REG8_OFFSET =>
						irq_rate <= i_reg_writedata(15 downto 0);


					when REG11_OFFSET =>
						enable_mclk <= i_reg_writedata(0);


					when REG16_OFFSET =>
						reset_trip <= i_reg_writedata(0);

					when REG17_OFFSET =>
						decimation_rate_trip <= i_reg_writedata(15 downto 0);

					when REG18_OFFSET =>
						en_trip <= i_reg_writedata(0);

					when REG19_OFFSET =>
						lmax <= i_reg_writedata(15 downto 0);

					when REG20_OFFSET =>
						lmin <= i_reg_writedata(15 downto 0);

					when REG21_OFFSET =>
						lcnt <= i_reg_writedata(3 downto 0);

					when REG22_OFFSET =>
						lwin <= i_reg_writedata(3 downto 0);

					when REG32_OFFSET =>
						sinc0_data_irq_en <= i_reg_writedata(0);
						sinc1_data_irq_en <= i_reg_writedata(1);
						
						force_irq <= i_reg_writedata(16);

					when REG33_OFFSET =>
						if (i_reg_writedata(0) = '1') then
							sinc0_data_int_clr <= not(sinc0_data_int_clr);
						end if;
						if (i_reg_writedata(1) = '1') then
							sinc1_data_int_clr <= not(sinc1_data_int_clr);
						end if;

					when others => 
						null;
				end case;
			end if;
		end if;
	end process REG_WRITE_PROC;

	--! Process to handle register reads to HPS over Light Weight Bus
	REG_READ_PROC : process(i_reg_clk)
	begin
		if rising_edge(i_reg_clk) then
			o_reg_readdata <= (others => '0');

			sinc0_data_int_clr_r1 <= sinc0_data_int_clr;
			if (sinc0_data_int_clr /= sinc0_data_int_clr_r1) then
				sinc0_data_int_set <= '0';	
			end if;
			sinc0_data_irq_r1 <= sinc0_data_irq;
			if (sinc0_data_irq = '1') then
				sinc0_data_int_set <= '1';	
				if (sinc0_data_irq_r1 = '0') then
					s_o_sinc0_data_irq <= not(s_o_sinc0_data_irq);
				end if;
			end if;

			sinc1_data_int_clr_r1 <= sinc1_data_int_clr;
			if (sinc1_data_int_clr /= sinc1_data_int_clr_r1) then
				sinc1_data_int_set <= '0';	
			end if;
			if (sinc1_data_irq = '1') then
				sinc1_data_int_set <= '1';	
			end if;

			if (i_reg_read_en = '1') then
				case i_reg_addr is
					when REG0_OFFSET =>
						o_reg_readdata(0) <= reset_SINC;

					when REG1_OFFSET =>
						o_reg_readdata(15 downto 0) <= sinc0_latest;

					when REG2_OFFSET =>
						o_reg_readdata(15 downto 0) <= decimation_rate;

					when REG3_OFFSET =>
						o_reg_readdata(15 downto 0) <= MDIV;

					when REG4_OFFSET =>
						o_reg_readdata(7 downto 0) <= scale;

					when REG5_OFFSET =>
						o_reg_readdata(15 downto 0) <= sinc1_latest;

					when REG6_OFFSET =>
						o_reg_readdata(31 downto 0) <= sinc_en_cnt;

					when REG7_OFFSET =>
						o_reg_readdata(0) <= sinc_cfg;

					when REG8_OFFSET =>
						o_reg_readdata(15 downto 0) <= irq_rate;

					when REG9_OFFSET =>
						o_reg_readdata(15 downto 0) <= sinc0_synced;

					when REG10_OFFSET =>
						o_reg_readdata(15 downto 0) <= sinc1_synced;

					when REG11_OFFSET =>
						o_reg_readdata(0) <= enable_mclk;

					when REG12_OFFSET =>
						o_reg_readdata(15 downto 0) <= trip_fil_out0;

					when REG13_OFFSET =>
						o_reg_readdata(15 downto 0) <= trip_fil_out1;

					when REG14_OFFSET =>
						o_reg_readdata(0) <= trip0;

					when REG15_OFFSET =>
						o_reg_readdata(0) <= trip1;

					when REG16_OFFSET =>
						o_reg_readdata(0) <= reset_trip;

					when REG17_OFFSET =>
						o_reg_readdata(15 downto 0) <= decimation_rate_trip;

					when REG18_OFFSET =>
						o_reg_readdata(0) <= en_trip;

					when REG19_OFFSET =>
						o_reg_readdata(15 downto 0) <= lmax;

					when REG20_OFFSET =>
						o_reg_readdata(15 downto 0) <= lmin;

					when REG21_OFFSET =>
						o_reg_readdata(3 downto 0) <= lcnt;

					when REG22_OFFSET =>
						o_reg_readdata(3 downto 0) <= lwin;

					when REG32_OFFSET =>
						o_reg_readdata(0) <= sinc0_data_irq_en;
						o_reg_readdata(1) <= sinc1_data_irq_en;

						o_reg_readdata(16) <= force_irq;

					when REG33_OFFSET =>
						o_reg_readdata(0) <= sinc0_data_int_set;
						o_reg_readdata(1) <= sinc1_data_int_set;

					when others => 
						null;
				end case;
			end if;
		end if;
	end process REG_READ_PROC;

	SINC_MOD_CLK_INST : sinc_mod_clk 
		port map (
			sys_clk => i_reg_clk,
			MDIV => MDIV,
			MCLK => s_SINC_MCLK,
			reset => reset_SINC,
			enable => enable_mclk
		);  
                            
	SINC_MODULE_INST0 : sinc_module
		port map (
			clk => i_reg_clk,
			mclk => s_SINC_MCLK,
			reset => reset_SINC, -- used to reset filter
			mdata => SINC_D0, -- input data to be filtered
			DATA_LATEST => sinc0_latest,
			DATA_SYNCED => sinc0_synced,
			dec_rate => decimation_rate,
			S => scale,
			fclk_en_cnt => sinc_en_cnt,
			pwm_sync => PWM_SYNC, 
			sinc_mode => sinc_cfg,
			irq_rate => irq_rate,
			data_ready_irq => sinc0_data_irq
		);                 

	SINC_MODULE_INST1 : sinc_module 
		port map (
			clk => i_reg_clk,
			mclk => s_SINC_MCLK,
			reset => reset_SINC, -- used to reset filter
			mdata => SINC_D1, -- input data to be filtered
			DATA_LATEST => sinc1_latest, -- filtered output
			DATA_SYNCED => sinc1_synced, -- filtered output
			dec_rate => decimation_rate,
			S => scale,
			fclk_en_cnt => sinc_en_cnt,
			pwm_sync => PWM_SYNC,
			sinc_mode => sinc_cfg,
			irq_rate => irq_rate,
			data_ready_irq => sinc1_data_irq
		); 

	SINC_TRIP_INST0 : sinc_trip 
		port map (
			clk_trip => i_reg_clk,
			mclk_trip => s_SINC_MCLK, -- used to clk filter
			reset_trip => reset_trip, -- used to reset filter
			mdata_trip => SINC_D0, -- input data to be filtered
			dec_rate_trip => decimation_rate_trip,
			en_trip => en_trip,
			lmax_trip => lmax,
			lmin_trip => lmin,
			lcnt_trip => lcnt,
			lwin_trip => lwin,
			filter_out_trip => trip_fil_out0,
			trip_status => trip0,
			trip_pin => SINC0_TRIP
		); 

	SINC_TRIP_INST1 : sinc_trip 
		port map (
			clk_trip => i_reg_clk,
			mclk_trip => s_SINC_MCLK, -- used to clk filter
			reset_trip => reset_trip, -- used to reset filter
			mdata_trip => SINC_D1, -- input data to be filtered
			dec_rate_trip => decimation_rate_trip,
			en_trip => en_trip,
			lmax_trip => lmax,
			lmin_trip => lmin,
			lcnt_trip => lcnt,
			lwin_trip => lwin,
			filter_out_trip => trip_fil_out1,
			trip_status => trip1,
			trip_pin => SINC1_TRIP
		); 

	SINC_MCLK <= s_SINC_MCLK;

	o_irq <= 	(sinc0_data_int_set and sinc0_data_irq_en) or
			(sinc1_data_int_set and sinc1_data_irq_en) or
			force_irq;	

	o_sinc0_data_irq <= s_o_sinc0_data_irq;

end architecture rtl; -- of sinc_flush_trip_ip

