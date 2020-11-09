-- Title: pwm_ip.vhd
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

--! New wrapper as part of porting PWM_IP_v1_0.v to Altera/Intel Platform
entity pwm_ip is
	port 
	(
		reset : in std_logic := '0'; --! Required by qsys. Unused. 

		-- Interface for control, status, etc. registers
		i_reg_clk : in std_logic := '0'; 
		i_reg_addr : in std_logic_vector(5 downto 0) := (others => '0');
		i_reg_read_en : in std_logic := '0';
		o_reg_readdata : out std_logic_vector(31 downto 0);
		i_reg_write_en : in std_logic := '0';
		i_reg_writedata : in std_logic_vector(31 downto 0) := (others => '0');

		o_irq : out std_logic;

		pwm_sync : out std_logic;
		PWM_AL_out : out std_logic;
		PWM_AH_out : out std_logic;
		PWM_BL_out : out std_logic;
		PWM_BH_out : out std_logic;
		PWM_CL_out : out std_logic;
		PWM_CH_out : out std_logic;
		ITRIP : in std_logic;
		SINC0_TRIP : in std_logic;
		SINC1_TRIP : in std_logic;
		MSTR_SYNC : in std_logic;
		pwm_led_pin : out std_logic;
		PWM_EN_PIN : out std_logic
	);
end entity pwm_ip;

architecture rtl of pwm_ip is
	constant REG0_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(0, 6));
	constant REG1_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(1, 6));
	constant REG2_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(2, 6));
	constant REG3_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(3, 6));
	constant REG4_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(4, 6));
	constant REG5_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(5, 6));
	constant REG6_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(6, 6));
	constant REG7_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(7, 6));
	constant REG8_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(8, 6));
	constant REG9_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(9, 6));
	constant REG10_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(10, 6));
	constant REG11_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(11, 6));
	constant REG12_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(12, 6));
	constant REG13_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(13, 6));

	-- For enabling interrupts
	constant REG16_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16, 6));
	-- For quering interrupt status
	constant REG17_OFFSET : std_logic_vector(5 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(17, 6));

	signal reset_pwm : std_logic := '0';
	signal enable_pwm : std_logic := '0';
	signal trip_clear : std_logic := '0';

	signal ton_a : std_logic_vector(15 downto 0) := (others => '0');
	signal toff_a: std_logic_vector(15 downto 0) := (others => '0');
	signal ton_b : std_logic_vector(15 downto 0) := (others => '0');
	signal toff_b: std_logic_vector(15 downto 0) := (others => '0');
	signal ton_c : std_logic_vector(15 downto 0) := (others => '0');
	signal toff_c: std_logic_vector(15 downto 0) := (others => '0');

	signal deadtime : std_logic_vector(15 downto 0) := (others => '0');

	signal s_pwm_sync : std_logic := '0';

	signal pwm_fault_irq : std_logic := '0';
	signal pwm_fault_irq_en : std_logic := '0';
	signal pwm_fault_int_clr : std_logic := '0';
	signal pwm_fault_int_clr_r1 : std_logic := '0';
	signal pwm_fault_int_set : std_logic := '0';

	signal pwm_status : std_logic_vector(7 downto 0) := (others => '0');

	signal reset_sync : std_logic := '0';
	signal master_cnt_max : std_logic_vector(31 downto 0) := (others => '0');

	signal pwm_sync_irq : std_logic := '0';
	signal pwm_sync_irq_en : std_logic := '0';
	signal pwm_sync_int_clr : std_logic := '0';
	signal pwm_sync_int_clr_r1 : std_logic := '0';
	signal pwm_sync_int_set : std_logic := '0';

	signal enable_sync : std_logic := '0';

	signal force_irq : std_logic := '0';

	component sync_gen
		port (
			clock_sync : in std_logic;
			reset : in std_logic;
			enable : in std_logic;
			cnt_max : in std_logic_vector(31 downto 0);
			network_sync : in std_logic;
			master_sync : out std_logic;
			interrupt_sig : out std_logic
		);
	end component;

	component PWM_timer
		port (
			clock : in std_logic; -- Clock input
			reset : in std_logic; -- Active low reset input
			en : in std_logic; -- Enable PWM input
			tripN : in std_logic; -- Active low trip input
			sinc0_trip : in std_logic;
			sinc1_trip : in std_logic;
			trip_reset : in std_logic; -- Trip reset
			ton_a : in std_logic_vector(15 downto 0);
			toff_a : in std_logic_vector(15 downto 0);
			ton_b : in std_logic_vector(15 downto 0);
			toff_b : in std_logic_vector(15 downto 0);
			ton_c : in std_logic_vector(15 downto 0);
			toff_c : in std_logic_vector(15 downto 0);
			deadtime : in std_logic_vector(15 downto 0); -- Dead time
			pwm_sync : in std_logic;
			PWM_AL : out std_logic; -- PWM output - low side
			PWM_AH : out std_logic; -- PWM output - high side
			PWM_BL : out std_logic;             
			PWM_BH : out std_logic;
			PWM_CL : out std_logic;             
			PWM_CH : out std_logic;
			led_out : out std_logic;
			fault_irq : out std_logic;
			status : out std_logic_vector(7 downto 0);
			pwm_en_pin : out std_logic
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
						enable_sync <= i_reg_writedata(0);

					when REG1_OFFSET =>
						reset_sync <= i_reg_writedata(0);

					when REG2_OFFSET =>
						master_cnt_max <= i_reg_writedata(31 downto 0);

					when REG3_OFFSET =>
						enable_pwm <= i_reg_writedata(0);

					when REG4_OFFSET =>
						reset_pwm <= i_reg_writedata(0);

					when REG5_OFFSET =>
						deadtime <= i_reg_writedata(15 downto 0);

					when REG6_OFFSET =>
						ton_a <= i_reg_writedata(15 downto 0);

					when REG7_OFFSET =>
						toff_a <= i_reg_writedata(15 downto 0);

					when REG8_OFFSET =>
						ton_b <= i_reg_writedata(15 downto 0);

					when REG9_OFFSET =>
						toff_b <= i_reg_writedata(15 downto 0);

					when REG10_OFFSET =>
						ton_c <= i_reg_writedata(15 downto 0);

					when REG11_OFFSET =>
						toff_c <= i_reg_writedata(15 downto 0);

					when REG12_OFFSET =>
						trip_clear <= i_reg_writedata(0);

					when REG16_OFFSET =>
						pwm_fault_irq_en <= i_reg_writedata(0);
						pwm_sync_irq_en <= i_reg_writedata(1);

						force_irq <= i_reg_writedata(16);

					when REG17_OFFSET =>
						if (i_reg_writedata(0) = '1') then
							pwm_fault_int_clr <= not(pwm_fault_int_clr);
						end if;
						if (i_reg_writedata(1) = '1') then
							pwm_sync_int_clr <= not(pwm_sync_int_clr);
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

			pwm_fault_int_clr_r1 <= pwm_fault_int_clr;
			if (pwm_fault_int_clr /= pwm_fault_int_clr_r1) then
				pwm_fault_int_set <= '0';	
			end if;
			if (pwm_fault_irq = '1') then
				pwm_fault_int_set <= '1';	
			end if;

			pwm_sync_int_clr_r1 <= pwm_sync_int_clr;
			if (pwm_sync_int_clr /= pwm_sync_int_clr_r1) then
				pwm_sync_int_set <= '0';	
			end if;
			if (pwm_sync_irq = '1') then
				pwm_sync_int_set <= '1';	
			end if;

			if (i_reg_read_en = '1') then
				case i_reg_addr is
					when REG0_OFFSET =>
						o_reg_readdata(0) <= enable_sync;

					when REG1_OFFSET =>
						o_reg_readdata(0) <= reset_sync;

					when REG2_OFFSET =>
						o_reg_readdata(31 downto 0) <= master_cnt_max;

					when REG3_OFFSET =>
						o_reg_readdata(0) <= enable_pwm;

					when REG4_OFFSET =>
						o_reg_readdata(0) <= reset_pwm;

					when REG5_OFFSET =>
						o_reg_readdata(15 downto 0) <= deadtime;

					when REG6_OFFSET =>
						o_reg_readdata(15 downto 0) <= ton_a;

					when REG7_OFFSET =>
						o_reg_readdata(15 downto 0) <= toff_a;

					when REG8_OFFSET =>
						o_reg_readdata(15 downto 0) <= ton_b;

					when REG9_OFFSET =>
						o_reg_readdata(15 downto 0) <= toff_b;

					when REG10_OFFSET =>
						o_reg_readdata(15 downto 0) <= ton_c;

					when REG11_OFFSET =>
						o_reg_readdata(15 downto 0) <= toff_c;

					when REG12_OFFSET =>
						o_reg_readdata(0) <= trip_clear;

					when REG13_OFFSET =>
						o_reg_readdata(7 downto 0) <= pwm_status;

					when REG16_OFFSET =>
						o_reg_readdata(0) <= pwm_fault_irq_en;
						o_reg_readdata(1) <= pwm_sync_irq_en;

						o_reg_readdata(16) <= force_irq;

					when REG17_OFFSET =>
						o_reg_readdata(0) <= pwm_fault_int_set;
						o_reg_readdata(1) <= pwm_sync_int_set;

					when others => 
						null;
				end case;
			end if;
		end if;
	end process REG_READ_PROC;

	SYNC_GEN_INST : sync_gen
		port map (
			clock_sync => i_reg_clk,
			reset => reset_sync,
			enable => enable_sync,
			cnt_max => master_cnt_max,
			network_sync => '1',
			master_sync => s_pwm_sync,
			interrupt_sig => pwm_sync_irq
		);

	PWM_TIMER_INST : PWM_timer
		port map (
		    clock => i_reg_clk,
		    reset => reset_pwm,
		    en => enable_pwm,
		    tripN => ITRIP,
		    sinc0_trip => SINC0_TRIP,
		    sinc1_trip => SINC1_TRIP,
		    trip_reset => trip_clear,
		    ton_a => ton_a,
		    toff_a => toff_a,
		    ton_b => ton_b,
		    toff_b => toff_b,
		    ton_c => ton_c,
		    toff_c => toff_c,
		    deadtime => deadtime,
		    pwm_sync => s_pwm_sync,
		    PWM_AL => PWM_AL_out,
		    PWM_AH => PWM_AH_out,
		    PWM_BL => PWM_BL_out,
		    PWM_BH => PWM_BH_out,
		    PWM_CL => PWM_CL_out,
		    PWM_CH => PWM_CH_out,
		    led_out => pwm_led_pin,
		    fault_irq => pwm_fault_irq,
		    status => pwm_status,
		    pwm_en_pin => PWM_EN_PIN
	    );

	pwm_sync <= s_pwm_sync;

	o_irq <= 	(pwm_fault_int_set and pwm_fault_irq_en) or
			(pwm_sync_int_set and pwm_sync_irq_en) or
			force_irq;

end architecture rtl; -- of pwm_ip

