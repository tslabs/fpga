
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
// output signals to SRAM are set at mclk posedge on mc[]:
//	0 - video
//	1 - CPU
//	2 - dummy
//
// SRAM read data should be clocked at mclk posedge on mc[]:
//	0 - CPU (this is just posedge of zclk, when CPU latches data in)
//	1 - dummy
//	2 - video
//
// ************************************************************************************************************
	
module sram
(
	input wire zclk, mclk,
	output reg [2:0] mc,
	
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
		if (!zclk)
			mc <= 3'b001;
		else
			mc <= {mc[1:0], 1'b0};
	
// output signals
	always @(posedge mclk)
		// video cycle
		if (mc[0])
		begin
			addr <= vaddr;
			ce_n <= 0;
			oe_n <= 0;
			we_n <= 1;
			lb_n <= 0;
			ub_n <= 0;
		end
		
		// CPU cycle (Z80 already asserted control signals and address/data)
		else if (mc[1])
		begin
			addr <= zaddr[17:1];
			ce_n <= !zrq;
			oe_n <= zwr;
			we_n <= !zwr;
			lb_n <= zaddr[0];
			ub_n <= !zaddr[0];
		end

		// dummy control shot
		else if (mc[2])
		begin
			addr <= 18'h3AA55;
			ce_n <= 0;
			oe_n <= 0;
			we_n <= 1;
			lb_n <= 0;
			ub_n <= 0;
		end

	// reg 
	// always @(posedge mclk)
	


endmodule
