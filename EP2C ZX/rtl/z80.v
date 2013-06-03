
// ************************************************************************************************************
// Z80 controller
// ************************************************************************************************************

module z80
(
	input wire mclk,
	input wire wt_clk,
	input wire key,
	
	output wire romreq, ramreq,
	output wire [15:0] a,
	output wire [7:0] dout,
	output wire wr, ramwr,
	output wire iorq,
	
	input wire [7:0] fdata,
	input wire [15:0] sdata
);

// Z80 signaling
	wire [7:0] din = romreq ? fdata : (a[0] ? sdata[15:8] : sdata[7:0]);
	
	assign romreq = vrom ? 0 : (mreq && !wr && ~|a[15:14]);
	assign ramreq = mreq && (wr || (vrom ? 1 : |a[15:14]));
	assign ramwr = wr && (vrom ? |a[15:14] : 1);
	
// wait generation on Flash access
	wire wt = !reset && (romreq && !wt_r[1]);
	
	reg [1:0] wt_r;
	always @(posedge mclk) if (!wt_clk)
		if (reset)
			wt_r <= 0;
		else if (romreq)
			wt_r <= {wt_r[0], ~|wt_r};
	
// ROM to SRAM substitution
	reg vrom;
	always @(posedge mclk) if (!wt_clk)
		if (reset)
			vrom <= 0;
		else if (iorq)
			vrom <= 1;
	
// reset generation
	assign reset = !key;
	// assign reset = &res_cnt;
	reg [20:0] res_cnt;
	always @(posedge mclk) if (!wt_clk)
		res_cnt <= res_cnt + 1;
		
// Z80 core
NextZ80 nextz80
(
	.CLK	(mclk),
	
	.RESET	(reset),
	.INT	(0),
	.NMI	(0),
	.WAIT	(wt || wt_clk),
	
	.ADDR	(a),
	.DI		(din),
	.DO	   	(dout),
	
	.MREQ	(mreq),
	.IORQ	(iorq),
	.WR	   	(wr),
	.M1	   	(m1),
	.HALT	(halt)
);

// Z80 ROM (unused now)
z80_rom z80_rom
(
	.a		(a),
	.d		(rdata)
);

endmodule
