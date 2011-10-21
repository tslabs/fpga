module mem(

// inputs
	input wire [23:0]	addr;
	input wire [15:0]	d_in;
	input wire [15:0]	d_out;

// SRAM


// 



}


// resources decoding	
	reg sram_ce;
	reg regs_ce;
	reg flsh_ce;
	reg sdrm_ce;
	
	always @*
	begin
		sdrm_ce = (addr[23:22] == 2'b00);		// SDRAM
		flsh_ce = (addr[23:22] == 2'b01);		// Flash
		sram_ce = (addr[23:22] == 2'b10);		// SRAM
		regs_ce = (addr[23:22] == 2'b11);		// Registers
	end







endmodule
