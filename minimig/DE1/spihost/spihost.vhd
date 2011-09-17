-- Copyright (C) 1991-2007 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM "Quartus II"
-- VERSION "Version 7.2 Build 151 09/26/2007 SJ Web Edition"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY spihost IS 
	port
	(
		Host_clk :  IN  STD_LOGIC;
		SD_DI :  IN  STD_LOGIC;
		host_reset :  IN  STD_LOGIC;
		memwait :  IN  STD_LOGIC;
		data_rd :  IN  STD_LOGIC_VECTOR(7 downto 0);
		di_floppy :  IN  STD_LOGIC_VECTOR(15 downto 0);
		di_user :  IN  STD_LOGIC_VECTOR(7 downto 0);
		sw :  IN  STD_LOGIC_VECTOR(3 downto 0);
		UART_TXD :  OUT  STD_LOGIC;
		SD_CLK :  OUT  STD_LOGIC;
		SD_DO :  OUT  STD_LOGIC;
		mem_wr :  OUT  STD_LOGIC;
		romled :  OUT  STD_LOGIC;
		enaled :  OUT  STD_LOGIC;
		addr :  OUT  STD_LOGIC_VECTOR(15 downto 0);
		data_wr :  OUT  STD_LOGIC_VECTOR(7 downto 0);
		do_floppy :  OUT  STD_LOGIC_VECTOR(15 downto 0);
		do_user :  OUT  STD_LOGIC_VECTOR(7 downto 0);
		links :  OUT  STD_LOGIC_VECTOR(15 downto 0);
		rechts :  OUT  STD_LOGIC_VECTOR(15 downto 0);
		SD_CS :  OUT  STD_LOGIC_VECTOR(7 downto 0);
		zstate :  OUT  STD_LOGIC_VECTOR(2 downto 0)
	);
END spihost;

ARCHITECTURE bdf_type OF spihost IS 

component tfz80
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 interrupt : IN STD_LOGIC;
		 clkena_in : IN STD_LOGIC;
		 data_in : IN STD_LOGIC_VECTOR(7 downto 0);
		 IO_in : IN STD_LOGIC_VECTOR(7 downto 0);
		 io_wr : OUT STD_LOGIC;
		 io_rd : OUT STD_LOGIC;
		 int_ack : OUT STD_LOGIC;
		 mem_wr : OUT STD_LOGIC;
		 mem_ce : OUT STD_LOGIC;
		 fetchOPC : OUT STD_LOGIC;
		 decodeOPC : OUT STD_LOGIC;
		 o_wordread : OUT STD_LOGIC;
		 o_worddone : OUT STD_LOGIC;
		 o_wordreaddirect : OUT STD_LOGIC;
		 execOPC : OUT STD_LOGIC;
		 wr : OUT STD_LOGIC;
		 clkena_o : OUT STD_LOGIC;
		 refresh : OUT STD_LOGIC;
		 wrena : OUT STD_LOGIC;
		 address : OUT STD_LOGIC_VECTOR(15 downto 0);
		 data_write : OUT STD_LOGIC_VECTOR(7 downto 0);
		 memaddr : OUT STD_LOGIC_VECTOR(15 downto 0);
		 microaddr : OUT STD_LOGIC_VECTOR(7 downto 0);
		 o_AF : OUT STD_LOGIC_VECTOR(15 downto 0);
		 o_BC : OUT STD_LOGIC_VECTOR(15 downto 0);
		 o_DE : OUT STD_LOGIC_VECTOR(15 downto 0);
		 o_Flags : OUT STD_LOGIC_VECTOR(7 downto 0);
		 o_HL : OUT STD_LOGIC_VECTOR(15 downto 0);
		 o_IX : OUT STD_LOGIC_VECTOR(15 downto 0);
		 o_IY : OUT STD_LOGIC_VECTOR(15 downto 0);
		 o_SP : OUT STD_LOGIC_VECTOR(15 downto 0);
		 opcode : OUT STD_LOGIC_VECTOR(7 downto 0);
		 prefix : OUT STD_LOGIC_VECTOR(3 downto 0);
		 registerin : OUT STD_LOGIC_VECTOR(15 downto 0);
		 state : OUT STD_LOGIC_VECTOR(1 downto 0)
	);
end component;

component txd
	PORT(clk : IN STD_LOGIC;
		 ld : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(7 downto 0);
		 TxD : OUT STD_LOGIC;
		 txbusy : OUT STD_LOGIC
	);
end component;

component sdfifo
	PORT(wrreq : IN STD_LOGIC;
		 rdreq : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(31 downto 0);
		 almost_full : OUT STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end component;

component spi
	PORT(zclk : IN STD_LOGIC;
		 ziord : IN STD_LOGIC;
		 ziowr : IN STD_LOGIC;
		 spiclk : IN STD_LOGIC;
		 nreset : IN STD_LOGIC;
		 sd_di : IN STD_LOGIC;
		 tx_busy : IN STD_LOGIC;
		 zena : IN STD_LOGIC;
		 di_floppy : IN STD_LOGIC_VECTOR(15 downto 0);
		 di_user : IN STD_LOGIC_VECTOR(7 downto 0);
		 sw : IN STD_LOGIC_VECTOR(3 downto 0);
		 zaddr : IN STD_LOGIC_VECTOR(15 downto 0);
		 zdata_i : IN STD_LOGIC_VECTOR(7 downto 0);
		 sd_clk : OUT STD_LOGIC;
		 sd_do : OUT STD_LOGIC;
		 wait_o : OUT STD_LOGIC;
		 tx_start : OUT STD_LOGIC;
		 audata : OUT STD_LOGIC;
		 cd_clk : OUT STD_LOGIC;
		 do_floppy : OUT STD_LOGIC_VECTOR(15 downto 0);
		 do_user : OUT STD_LOGIC_VECTOR(7 downto 0);
		 links : OUT STD_LOGIC_VECTOR(15 downto 0);
		 rechts : OUT STD_LOGIC_VECTOR(15 downto 0);
		 sd_cs : OUT STD_LOGIC_VECTOR(7 downto 0);
		 tx_data : OUT STD_LOGIC_VECTOR(7 downto 0);
		 zdata_o : OUT STD_LOGIC_VECTOR(7 downto 0)
	);
end component;

component waitgen
	PORT(clk : IN STD_LOGIC;
		 nreset : IN STD_LOGIC;
		 mem_ce : IN STD_LOGIC;
		 memwait : IN STD_LOGIC;
		 spiwait : IN STD_LOGIC;
		 wrfull : IN STD_LOGIC;
		 addr : IN STD_LOGIC_VECTOR(15 downto 0);
		 data_in : IN STD_LOGIC_VECTOR(7 downto 0);
		 dataIO : IN STD_LOGIC_VECTOR(7 downto 0);
		 state : IN STD_LOGIC_VECTOR(1 downto 0);
		 clkena : OUT STD_LOGIC;
		 romled : OUT STD_LOGIC;
		 data_out : OUT STD_LOGIC_VECTOR(7 downto 0)
	);
end component;

signal	clkena :  STD_LOGIC;
signal	cpuclk :  STD_LOGIC;
signal	DIO :  STD_LOGIC_VECTOR(7 downto 0);
signal	fifo_in :  STD_LOGIC_VECTOR(31 downto 0);
signal	fifo_out :  STD_LOGIC_VECTOR(31 downto 0);
signal	memce :  STD_LOGIC;
signal	reset :  STD_LOGIC;
signal	spi_wait :  STD_LOGIC;
signal	state :  STD_LOGIC_VECTOR(1 downto 0);
signal	TxD :  STD_LOGIC_VECTOR(7 downto 0);
signal	TxS :  STD_LOGIC;
signal	wrfull :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(7 downto 0);
signal	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
signal	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(15 downto 0);
signal	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(7 downto 0);


BEGIN 
addr <= SYNTHESIZED_WIRE_10;
data_wr <= SYNTHESIZED_WIRE_8;
SYNTHESIZED_WIRE_0 <= '1';



b2v_inst : tfz80
PORT MAP(clk => cpuclk,
		 reset => reset,
		 interrupt => SYNTHESIZED_WIRE_0,
		 clkena_in => clkena,
		 data_in => SYNTHESIZED_WIRE_1,
		 IO_in => DIO,
		 io_wr => SYNTHESIZED_WIRE_5,
		 io_rd => SYNTHESIZED_WIRE_4,
		 mem_wr => mem_wr,
		 mem_ce => memce,
		 address => SYNTHESIZED_WIRE_10,
		 data_write => SYNTHESIZED_WIRE_8,
		 state => state);

txd_inst : txd
PORT MAP(clk => cpuclk,
		 ld => TxS,
		 data => TxD,
		 TxD => UART_TXD,
		 txbusy => SYNTHESIZED_WIRE_6);

sdfifo_inst : sdfifo
PORT MAP(wrreq => SYNTHESIZED_WIRE_2,
		 rdreq => SYNTHESIZED_WIRE_3,
		 clock => cpuclk,
		 data => fifo_in,
		 almost_full => wrfull,
		 q => fifo_out);

spi_inst : spi
PORT MAP(zclk => cpuclk,
		 ziord => SYNTHESIZED_WIRE_4,
		 ziowr => SYNTHESIZED_WIRE_5,
		 spiclk => cpuclk,
		 nreset => reset,
		 sd_di => SD_DI,
		 tx_busy => SYNTHESIZED_WIRE_6,
		 zena => clkena,
		 di_floppy => di_floppy,
		 di_user => di_user,
		 sw => sw,
		 zaddr => SYNTHESIZED_WIRE_10,
		 zdata_i => SYNTHESIZED_WIRE_8,
		 sd_clk => SD_CLK,
		 sd_do => SD_DO,
		 wait_o => spi_wait,
		 tx_start => TxS,
		 audata => SYNTHESIZED_WIRE_2,
		 cd_clk => SYNTHESIZED_WIRE_3,
		 do_floppy => do_floppy,
		 do_user => do_user,
		 links => fifo_in(15 downto 0),
		 rechts => fifo_in(31 downto 16),
		 sd_cs => SD_CS,
		 tx_data => TxD,
		 zdata_o => DIO);

waitgen_inst : waitgen
PORT MAP(clk => cpuclk,
		 nreset => reset,
		 mem_ce => memce,
		 memwait => memwait,
		 spiwait => spi_wait,
		 wrfull => wrfull,
		 addr => SYNTHESIZED_WIRE_10,
		 data_in => data_rd,
		 dataIO => DIO,
		 state => state,
		 clkena => clkena,
		 romled => romled,
		 data_out => SYNTHESIZED_WIRE_1);
cpuclk <= Host_clk;
reset <= host_reset;
enaled <= clkena;
links(15 downto 0) <= fifo_out(15 downto 0);
rechts(15 downto 0) <= fifo_out(31 downto 16);
zstate(2) <= memce;
zstate(1 downto 0) <= state;

END; 