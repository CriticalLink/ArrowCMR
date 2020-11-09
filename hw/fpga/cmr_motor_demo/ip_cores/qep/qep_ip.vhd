-- Title: qep_ip.vhd
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

--! New wrapper as part of porting qep_IP_v1_0.v to Altera/Intel Platform
entity qep_ip is
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

		A : in std_logic;
		B : in std_logic;
		Z : in std_logic;
		HALL : in std_logic_vector(2 downto 0);
		
		sync_strobe : in std_logic
	);
end entity qep_ip;

architecture rtl of qep_ip is
	constant REG0_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(0, 7));
	constant REG1_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(1, 7));
	constant REG2_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(2, 7));
	constant REG3_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(3, 7));
	constant REG4_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(4, 7));
	constant REG5_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(5, 7));

	constant REG16_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(16, 7));
	constant REG17_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(17, 7));
	constant REG18_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(18, 7));
	constant REG19_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(19, 7));
	constant REG20_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(20, 7));
	constant REG21_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(21, 7));
	constant REG22_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(22, 7));
	constant REG23_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(23, 7));
	constant REG24_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(24, 7));
	constant REG25_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(25, 7));
	constant REG26_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(26, 7));
	constant REG27_OFFSET : std_logic_vector(6 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(27, 7));

	signal reg_config : std_logic_vector(6 downto 0) := (others => '0');
	signal reg_mpw_cnt_lim : std_logic_vector(31 downto 0) := (others => '0');
	signal reg_qd_cnt_wrap : std_logic_vector(31 downto 0) := (others => '0');
	signal qd_rst : std_logic := '0';
	signal qd_en : std_logic := '0';
	signal reg_qd_M : std_logic_vector(31 downto 0) := (others => '0');
	signal reg_qd_cnt : std_logic_vector(31 downto 0) := (others => '0');
	signal reg_qd_cnt_idx_latch : std_logic_vector(31 downto 0) := (others => '0');
	signal reg_qd_cnt_strobe_latch : std_logic_vector(31 downto 0) := (others => '0');
	signal hall_filtered : std_logic_vector(2 downto 0) := (others => '0');
	signal reg_qd_N_by_M : std_logic_vector(31 downto 0) := (others => '0');
	signal reg_qd_N_by_1 : std_logic_vector(31 downto 0) := (others => '0');
	signal reg_qd_N_by_M_strobe_latch : std_logic_vector(31 downto 0) := (others => '0');
	signal reg_qd_N_by_1_strobe_latch : std_logic_vector(31 downto 0) := (others => '0');
	signal reg_qd_tcnt_N_by_M : std_logic_vector(31 downto 0) := (others => '0');
	signal reg_qd_tcnt_N_by_1 : std_logic_vector(31 downto 0) := (others => '0');
	signal qd_dir_status : std_logic := '0';
	signal qd_dir_strobe_latch : std_logic := '0';

	signal data : std_logic_vector(5 downto 0) := (others => '0');
	signal data_synced : std_logic_vector(5 downto 0) := (others => '0');
	signal data_filtered : std_logic_vector(5 downto 0) := (others => '0');

	signal A_filtered : std_logic := '0';
	signal B_filtered : std_logic := '0';
	signal Z_filtered : std_logic := '0';

	signal qd_idx_strobe : std_logic := '0';
	signal qd_trans_err_strobe : std_logic := '0';

	component min_pulse_width
		generic (
			COUNTER_WIDTH : natural := 32
		);
		port (
			clk : in std_logic;
			rst : in std_logic;
			in_wire : in std_logic;
			cnt_lim : in std_logic_vector(COUNTER_WIDTH-1 downto 0);
			out_reg : out std_logic
		);
	end component;

	component quadrature_decoder 
		generic (
			COUNTER_WIDTH : natural := 32    
		);
		port (
			clk : in std_logic;
			rst : in std_logic;
			en : in std_logic;
			A : in std_logic;
			B : in std_logic;
			Z : in std_logic;
			latch_strobe : in std_logic;
			A_neg : in std_logic;
			B_neg : in std_logic;
			Z_neg : in std_logic;
			idx_mode : in std_logic_vector(1 downto 0);
			strobe_en : in std_logic;
			cnt_dir : in std_logic;
			cnt_wrap : in std_logic_vector(COUNTER_WIDTH-1 downto 0);
			M : in std_logic_vector(COUNTER_WIDTH-1 downto 0);

			idx_strobe : out std_logic;
			trans_err_strobe : out std_logic;

			dir_status : out std_logic;
			dir_strobe_latch : out std_logic;
			cnt : out std_logic_vector(COUNTER_WIDTH-1 downto 0);
			cnt_idx_latch : out std_logic_vector(COUNTER_WIDTH-1 downto 0);
			cnt_strobe_latch : out std_logic_vector(COUNTER_WIDTH-1 downto 0);
			N_by_M : out std_logic_vector(COUNTER_WIDTH-1 downto 0);
			N_by_1 : out std_logic_vector(COUNTER_WIDTH-1 downto 0);
			N_by_M_strobe_latch : out std_logic_vector(COUNTER_WIDTH-1 downto 0);
			N_by_1_strobe_latch : out std_logic_vector(COUNTER_WIDTH-1 downto 0);
			tcnt_N_by_M : out std_logic_vector(COUNTER_WIDTH-1 downto 0);
			tcnt_N_by_1 : out std_logic_vector(COUNTER_WIDTH-1 downto 0)
		);
	end component;

	component sync_domain
		port (
			clk : in std_logic;
			in_wire : in std_logic;
			out_wire : out std_logic;
			rst : in std_logic
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
						reg_config <= i_reg_writedata(6 downto 0);

					when REG1_OFFSET =>
						reg_mpw_cnt_lim <= i_reg_writedata(31 downto 0);

					when REG2_OFFSET =>
						reg_qd_cnt_wrap <= i_reg_writedata(31 downto 0);

					when REG3_OFFSET =>
						qd_rst <= i_reg_writedata(0);

					when REG4_OFFSET =>
						qd_en <= i_reg_writedata(0);

					when REG5_OFFSET =>
						reg_qd_M <= i_reg_writedata(31 downto 0);

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

			if (i_reg_read_en = '1') then
				case i_reg_addr is
					when REG0_OFFSET =>
						o_reg_readdata(6 downto 0) <= reg_config;

					when REG1_OFFSET =>
						o_reg_readdata(31 downto 0) <= reg_mpw_cnt_lim;

					when REG2_OFFSET =>
						o_reg_readdata(31 downto 0) <= reg_qd_cnt_wrap;

					when REG3_OFFSET =>
						o_reg_readdata(0) <= qd_rst;

					when REG4_OFFSET =>
						o_reg_readdata(0) <= qd_en;

					when REG5_OFFSET =>
						o_reg_readdata(31 downto 0) <= reg_qd_M;

					when REG16_OFFSET =>
						o_reg_readdata(31 downto 0) <= reg_qd_cnt;

					when REG17_OFFSET =>
						o_reg_readdata(31 downto 0) <= reg_qd_cnt_idx_latch;

					when REG18_OFFSET =>
						o_reg_readdata(31 downto 0) <= reg_qd_cnt_strobe_latch;

					when REG19_OFFSET =>
						o_reg_readdata(2 downto 0) <= hall_filtered;

					when REG20_OFFSET =>
						o_reg_readdata(31 downto 0) <= reg_qd_N_by_M;

					when REG21_OFFSET =>
						o_reg_readdata(31 downto 0) <= reg_qd_N_by_1;

					when REG22_OFFSET =>
						o_reg_readdata(31 downto 0) <= reg_qd_N_by_M_strobe_latch;

					when REG23_OFFSET =>
						o_reg_readdata(31 downto 0) <= reg_qd_N_by_1_strobe_latch;

					when REG24_OFFSET =>
						o_reg_readdata(31 downto 0) <= reg_qd_tcnt_N_by_M;

					when REG25_OFFSET =>
						o_reg_readdata(31 downto 0) <= reg_qd_tcnt_N_by_1;

					when REG26_OFFSET =>
						o_reg_readdata(0) <= qd_dir_status;

					when REG27_OFFSET =>
						o_reg_readdata(0) <= qd_dir_strobe_latch;

					when others => 
						null;
				end case;
			end if;
		end if;
	end process REG_READ_PROC;

	data <= HALL & Z & B & A;
	A_filtered <= data_filtered(0);
	B_filtered <= data_filtered(1);
	Z_filtered <= data_filtered(2);
	hall_filtered <= data_filtered(5 downto 3);   


	PREFILTER_GEN : for i in 0 to 5 generate
		SD_INST : sync_domain
			port map(
				clk => i_reg_clk,
				rst => reset, --TODO: could be problematic since reset never really triggers...
				in_wire => data(i),
				out_wire => data_synced(i)
			);

		MPW_INST : min_pulse_width
			port map (
				clk => i_reg_clk,
				rst => reset, --TODO: could be problematic since reset never really triggers...
				in_wire => data_synced(i),
				cnt_lim => reg_mpw_cnt_lim,
				out_reg => data_filtered(i)
			);
	end generate PREFILTER_GEN;
    
	QD_INST : quadrature_decoder
		port map (
			clk => i_reg_clk,
			rst => qd_rst,
			en => qd_en,
			A => A_filtered,
			B => B_filtered,
			Z => Z_filtered,
			latch_strobe => sync_strobe,
			A_neg => reg_config(0),
			B_neg => reg_config(1),
			Z_neg => reg_config(2),
			cnt_dir => reg_config(3),
			idx_mode => reg_config(5 downto 4),
			strobe_en => reg_config(6),    
			idx_strobe => qd_idx_strobe,
			trans_err_strobe => qd_trans_err_strobe,
			cnt_wrap => reg_qd_cnt_wrap,
			M => reg_qd_M,    
			dir_status => qd_dir_status,
			dir_strobe_latch => qd_dir_strobe_latch,
			cnt => reg_qd_cnt,
			cnt_idx_latch => reg_qd_cnt_idx_latch,
			cnt_strobe_latch => reg_qd_cnt_strobe_latch,
			N_by_M => reg_qd_N_by_M,
			N_by_1 => reg_qd_N_by_1,
			N_by_M_strobe_latch => reg_qd_N_by_M_strobe_latch,
			N_by_1_strobe_latch => reg_qd_N_by_1_strobe_latch,
			tcnt_N_by_M => reg_qd_tcnt_N_by_M,
			tcnt_N_by_1 => reg_qd_tcnt_N_by_1
		);

end architecture rtl; -- of qep_ip

