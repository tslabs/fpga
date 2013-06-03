
// ************************************************************************************************************
// SRAM controller
// ************************************************************************************************************
//
//	mclk - 90MHz clock, used for SRAM controller
//	zclk - 30MHz clock, used for CPU
//
//	They should be outputs from the same PLL with 0 deg phase shift
//
// ************************************************************************************************************
//
// output signals to SRAM are set at posedge of mclk on mc:
//	0 - video
//	1 - CPU (Z80 already asserted control signals and address/data)
//
// SRAM read data should be clocked at posedge of mclk on mc:
//	0 - CPU (this is just posedge of zclk, when CPU latches data in)
//	1 - video
//
// SRAM write data and we_n should be set at NEGEDGE of mclk on mc:
//	0 - video
//	1 - CPU
//
// ************************************************************************************************************
	
module sram
(
	input wire mclk,
	output reg mc,
	
	input wire [17:0] zaddr,
	input wire zrq,
	input wire zwr,
	
	input wire [17:0] vaddr,
	
	output reg [17:0] addr,
	output reg ce_n,
	output reg oe_n,
	output reg we_n,
	output reg lb_n,
	output reg ub_n
);
	
// memory cycles
	always @(posedge mclk)
		mc <= !mc;
	
// output signals
	always @(posedge mclk)
		// video cycle
		if (!mc)
			we_n <= 1;
		
		// CPU cycle
		else
			we_n <= !zwr;

	always @(posedge mclk)
		// video cycle
		if (!mc)
		begin
			addr <= vaddr;
			ce_n <= 0;
			oe_n <= 0;
			lb_n <= 0;
			ub_n <= 0;
		end
		
		// CPU cycle
		else
		begin
			addr <= zaddr[17:1];
			ce_n <= !zrq;
			oe_n <= zwr;
			lb_n <= zaddr[0];
			ub_n <= !zaddr[0];
		end

endmodule
