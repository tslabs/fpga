module top
(

// Clocks
	input  wire	[1:0]	clock_24,				//	24 MHz
	input  wire	[1:0]	clock_27,				//	27 MHz
	input  wire			clock_50,				//	50 MHz
	input  wire			ext_clock,				//	External Clock
// Push Button
	input  wire	[3:0]	key,					//	Pushbutton[3:0]
// DPDT Switch
	input  wire	[9:0]	sw,						//	Toggle Switch[9:0]
// 7-SEG Display
	output wire	[6:0]	hex0,					//	Seven Segment Digit 0
	output wire	[6:0]	hex1,					//	Seven Segment Digit 1
	output wire	[6:0]	hex2,					//	Seven Segment Digit 2
	output wire	[6:0]	hex3,					//	Seven Segment Digit 3
// LED
	output wire	[7:0]	ledg,					//	LED Green[7:0]
	output wire	[9:0]	ledr,					//	LED Red[9:0]
// UART
	output wire			uart_txd,				//	UART Transmitter
	input  wire			uart_rxd,				//	UART Receiver
// SDRAM
	inout  wire	[15:0]	dram_dq,				//	SDRAM Data bus 16 Bits
	output wire	[11:0]	dram_addr,				//	SDRAM Address bus 12 Bits
	output wire			dram_ldqm,				//	SDRAM Low-byte Data Mask 
	output wire			dram_udqm,				//	SDRAM High-byte Data Mask
	output wire			dram_we_n,				//	SDRAM Write Enable
	output wire			dram_cas_n,				//	SDRAM Column Address Strobe
	output wire			dram_ras_n,				//	SDRAM Row Address Strobe
	output wire			dram_cs_n,				//	SDRAM Chip Select
	output wire			dram_ba_0,				//	SDRAM Bank Address 0
	output wire			dram_ba_1,				//	SDRAM Bank Address 0
	output wire			dram_clk,				//	SDRAM Clock
	output wire			dram_cke,				//	SDRAM Clock Enable
// Flash
	inout  wire [7:0]	fl_dq,					//	FLASH Data bus 8 Bits
	output wire [21:0]	fl_addr,				//	FLASH Address bus 22 Bits
	output wire 		fl_we_n,				//	FLASH Write Enable
	output wire 		fl_rst_n,				//	FLASH Reset
	output wire 		fl_oe_n,				//	FLASH Output Enable
	output wire 		fl_ce_n,				//	FLASH Chip Enable
// SRAM
	inout  wire [15:0]	sram_dq,				//	SRAM Data bus 16 Bits
	output wire [17:0]	sram_addr,				//	SRAM Address bus 18 Bits
	output wire 		sram_ub_n,				//	SRAM High-byte Data Mask 
	output wire 		sram_lb_n,				//	SRAM Low-byte Data Mask 
	output wire 		sram_we_n,				//	SRAM Write Enable
	output wire 		sram_ce_n,				//	SRAM Chip Enable
	output wire 		sram_oe_n,				//	SRAM Output Enable
// SD Card
	output wire		sd_cs_n,	    			//	SD Card Chip Select
	output wire		sd_clk,						//	SD Card Clock
	output wire		sd_do,						//	SD Card Data Out
	input  wire		sd_di,						//	SD Card Data In
// I2C
	inout  wire			i2c_sdat,				//	I2C Data
	output wire			i2c_sclk,				//	I2C Clock
// PS/2
	inout  wire		 	ps2_dat,				//	PS2 Data
	output wire			ps2_clk,				//	PS2 Clock
// USB JTAG
	input  wire			tdi,					// CPLD -> FPGA (data in)
	input  wire			tck,					// CPLD -> FPGA (clk)
	input  wire			tcs,					// CPLD -> FPGA (CS)
	output wire			tdo,					// FPGA -> CPLD (data out)
// VGA
	output wire			vga_hs,					//	VGA H_SYNC
	output wire			vga_vs,					//	VGA V_SYNC
	output wire	[3:0]	vga_r,   				//	VGA Red[3:0]
	output wire	[3:0]	vga_g,	 				//	VGA Green[3:0]
	output wire	[3:0]	vga_b,   				//	VGA Blue[3:0]
// Audio CODEC
	output wire			aud_adclrck,			//	Audio CODEC ADC LR Clock
	input  wire			aud_adcdat,				//	Audio CODEC ADC Data
	output wire			aud_daclrck,			//	Audio CODEC DAC LR Clock
	output wire			aud_dacdat,				//	Audio CODEC DAC Data
	output wire			aud_bclk,				//	Audio CODEC Bit-Stream Clock
	output wire			aud_xck,				//	Audio CODEC Chip Clock
// GPIO
	inout wire [35:0]	gpio_0,
	inout wire [35:0]	gpio_1
);


	// assign gpio_0 = 36'hZZZZZZZZZ;
	// assign gpio_1 = 36'hZZZZZZZZZ;
	assign ledr = {gpio_1[34], gpio_1[32], gpio_1[30], gpio_1[28], gpio_1[16], gpio_1[14], gpio_1[12], gpio_1[10], gpio_1[22], gpio_1[24]};

	
avr_port avr_port (
	.clk	   ( clk108	    ),
	.data	   ( {gpio_1[34], gpio_1[32], gpio_1[30], gpio_1[28], gpio_1[16], gpio_1[14], gpio_1[12], gpio_1[10]} ),
	.ce_n 	   ( gpio_1[22] ),
	.re_n 	   ( gpio_1[24] ),
	.we_n 	   ( gpio_1[ 4] ),
	.ae_p 	   ( gpio_1[ 6] ),
	.de_p 	   ( gpio_1[ 8] ),
	.r_n_b	   ( gpio_1[26] )
	);

	
sxga sxga  (
    .clk   ( clk108	   ),
    .clk2  ( clk108_2  ),
	.r     ( vga_r 	   ),
	.g     ( vga_g	   ),	
	.b     ( vga_b 	   ),
	.hs    ( vga_hs	   ),
	.vs    ( vga_vs	   ),
	
	.sram_dq    ( sram_dq   ),
	.sram_addr  ( sram_addr ),
	.sram_ce_n  ( sram_ce_n ),
	.sram_oe_n  ( sram_oe_n ),
	.sram_we_n  ( sram_we_n ),
	.sram_ub_n  ( sram_ub_n ),
	.sram_lb_n  ( sram_lb_n ),
	
	.sw		( sw ),
	.key	( key )
	);


	// assign ledr = sw;
	assign ledg[3:0] = key;

	wire        hex_en  = 1;
	wire [3:0]  hex_val = sw[3:0];
	wire [1:0]  hex_dig = sw[9:8];

hex hex	(
    .clk     ( clk108  ),
    .en      ( hex_en  ),
    .val     ( hex_val ),
    .dig     ( hex_dig ),
    .seg     ( {hex3, hex2, hex1, hex0} )
    );


	wire clk108;
	wire hclk;
	wire clk108_2;
	
	pll	pll (
	.inclk0 ( clock_24[0] ),
	.c0     ( clk108      ),
	.c1     ( hclk        ),
	.c2     ( clk108_2    )
	);


endmodule
