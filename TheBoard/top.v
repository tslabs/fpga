module top
(

// Clocks
input	[1:0]	clock_24,				//	24 MHz
input	[1:0]	clock_27,				//	27 MHz
input			clock_50,				//	50 MHz
input			ext_clock,				//	External Clock
// Push Button
input	[3:0]	key,					//	Pushbutton[3:0]
// DPDT Switch
input	[9:0]	sw,						//	Toggle Switch[9:0]
// 7-SEG Display
output	[6:0]	hex0,					//	Seven Segment Digit 0
output	[6:0]	hex1,					//	Seven Segment Digit 1
output	[6:0]	hex2,					//	Seven Segment Digit 2
output	[6:0]	hex3,					//	Seven Segment Digit 3
// LED
output	[7:0]	ledg,					//	LED Green[7:0]
output	[9:0]	ledr,					//	LED Red[9:0]
// UART
output			uart_txd,				//	UART Transmitter
input			uart_rxd,				//	UART Receiver
// SDRAM
inout	[15:0]	dram_dq,				//	SDRAM Data bus 16 Bits
output	[11:0]	dram_addr,				//	SDRAM Address bus 12 Bits
output			dram_ldqm,				//	SDRAM Low-byte Data Mask 
output			dram_udqm,				//	SDRAM High-byte Data Mask
output			dram_we_n,				//	SDRAM Write Enable
output			dram_cas_n,				//	SDRAM Column Address Strobe
output			dram_ras_n,				//	SDRAM Row Address Strobe
output			dram_cs_n,				//	SDRAM Chip Select
output			dram_ba_0,				//	SDRAM Bank Address 0
output			dram_ba_1,				//	SDRAM Bank Address 0
output			dram_clk,				//	SDRAM Clock
output			dram_cke,				//	SDRAM Clock Enable
// Flash
inout	[7:0]	fl_dq,					//	FLASH Data bus 8 Bits
output	[21:0]	fl_addr,				//	FLASH Address bus 22 Bits
output			fl_we_n,				//	FLASH Write Enable
output			fl_rst_n,				//	FLASH Reset
output			fl_oe_n,				//	FLASH Output Enable
output			fl_ce_n,				//	FLASH Chip Enable
// SRAM
inout	[15:0]	sram_dq,				//	SRAM Data bus 16 Bits
output	[17:0]	sram_addr,				//	SRAM Address bus 18 Bits
output			sram_ub_n,				//	SRAM High-byte Data Mask 
output			sram_lb_n,				//	SRAM Low-byte Data Mask 
output			sram_we_n,				//	SRAM Write Enable
output			sram_ce_n,				//	SRAM Chip Enable
output			sram_oe_n,				//	SRAM Output Enable
// SD Card
output			sd_cs_n,	    		//	SD Card Chip Select
output			sd_clk,					//	SD Card Clock
output			sd_do,					//	SD Card Data Out
input			sd_di,					//	SD Card Data In
// I2C
inout			i2c_sdat,				//	I2C Data
output			i2c_sclk,				//	I2C Clock
// PS/2
input		 	ps2_dat,				//	PS2 Data
input			ps2_clk,				//	PS2 Clock
// USB JTAG
input  			tdi,					// CPLD -> FPGA (data in)
input  			tck,					// CPLD -> FPGA (clk)
input  			tcs,					// CPLD -> FPGA (CS)
output 			tdo,					// FPGA -> CPLD (data out)
// VGA
output			vga_hs,					//	VGA H_SYNC
output			vga_vs,					//	VGA V_SYNC
output	[3:0]	vga_r,   				//	VGA Red[3:0]
output	[3:0]	vga_g,	 				//	VGA Green[3:0]
output	[3:0]	vga_b,   				//	VGA Blue[3:0]
// Audio CODEC
output			aud_adclrck,			//	Audio CODEC ADC LR Clock
input			aud_adcdat,				//	Audio CODEC ADC Data
output			aud_daclrck,			//	Audio CODEC DAC LR Clock
output			aud_dacdat,				//	Audio CODEC DAC Data
inout			aud_bclk,				//	Audio CODEC Bit-Stream Clock
output			aud_xck,				//	Audio CODEC Chip Clock
// GPIO
inout	[35:0]	gpio_0,					//	GPIO Connection 0
inout	[35:0]	gpio_1					//	GPIO Connection 1
);


wire        hex_en  = 0;
wire [3:0]  hex_val = 0;
wire [1:0]  hex_dig = 0;

hex hex	(
    .clk     ( clk108  ),
    .en      ( hex_en  ),
    .val     ( hex_val ),
    .dig     ( hex_dig ),
    .seg     ( {hex3, hex2, hex1, hex0} )
    );


pll	pll (
	.inclk0 ( clock_24[0] ),
	.c0     ( clk108      ),
	.c1     ( clk166      )
	);


endmodule
