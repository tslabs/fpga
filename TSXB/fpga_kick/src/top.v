module fpga_kick
(
	// clock
	input wire CLK50,

	// ZX-BUS
	input wire FZF,
	input wire [7:0] FD,
	input wire [7:0] FA,
	input wire FA_SEL,
	input wire FRD,
	input wire FWR,
	input wire FMRQ,
	input wire FIORQ,
	input wire FM1,
	input wire FINT,
	input wire FBUSRQ,
	input wire FBUSAK,
	input wire FCSROM,
	input wire FIORGE_FORQ,
	input wire FRES,
	input wire FWAIT,

	// SDRAM
	output wire SD_CLK,
	output wire [11:0] SD_A,
	output wire [1:0] SD_BA,
	output wire SD_RAS,
	output wire SD_CAS,
	output wire SD_WE,
	output wire SD_LDQM,
	output wire SD_UDQM,
	inout wire [15:0] SD_D,

	// SRAM
	output wire [18:0] SR_A,
	output wire SR_OE,
	output wire SR_WE,
	output wire SR_BHE,
	output wire SR_BLE,
	inout wire [15:0] SR_D,

	// video DAC
	output wire V_CLK,
	output wire [7:0] V_B,
	output wire [7:0] V_G,
	output wire [7:0] V_R,
	output wire V_HS,
	output wire V_VS,

	// audio DAC
	output wire DAC_LRCK,
	output wire DAC_MCLK,
	output wire DAC_SDATA,

	// conf device
	// input wire ASDO,
	// input wire NCSO

	// virtual
	output reg [15:0] zaddr,
	output wire [118:0] rnd_out
);

	always @(posedge CLK50)
		if (FA_SEL)
			zaddr[15:8] <= FA;
		else
			zaddr[7:0] <= FA;

	wire c0;
	wire c1;
	wire c2;

	pll	pll (
		.inclk0 (CLK50),	// 50 MHz
		.c0     (c0),		// 200 MHz
		.c1     (c1),		// 100 MHz
		.c2     (c2)		// 50 MHz
	);

	assign V_CLK = c1;
	
	sxga sxga(
		.clk 		(c1),
		.r   		(V_R),
		.g   		(V_G),	
		.b   		(V_B),
		.hs  		(V_HS),
		.vs  		(V_VS),
		
		.sram_dq    (SR_D),
		.sram_addr  (SR_A),
		.sram_oe_n  (SR_OE),
		.sram_we_n  (SR_WE),
		.sram_ub_n  (SR_BHE),
		.sram_lb_n  (SR_BLE),
		
		.key		(4'b1110)
	);

endmodule
