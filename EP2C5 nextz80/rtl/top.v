
module ep2c5_nextz80
(
	input	wire			clk50,
	
	output	wire	[7:0]	zdo,
	output	reg		[7:0]	rdata,
	output	wire	[15:0]	zaddr,
	output	wire			zwr,
	output	wire			zmreq,
	output	wire			ziorq,
	output	wire			zhalt,
	output	wire			zm1
);

	// wire zwait = 0;
	// wire znmi = 0;
	// wire zint = 0;
	// wire zclk = c0;
	// wire zreset = res_cnt[7];
	// wire [7:0] zdi = rdata;
	
	
// ROM
	always @*
		case (zaddr)
			16'h0000:	rdata = 8'hF3;
			16'h0001:	rdata = 8'h01;
			16'h0002:	rdata = 8'hAA;
			16'h0003:	rdata = 8'h55;
			16'h0004:	rdata = 8'h3E;
			16'h0005:	rdata = 8'h0F;
			16'h0006:	rdata = 8'hED;
			16'h0007:	rdata = 8'h79;
			16'h0008:	rdata = 8'h21;
			16'h0009:	rdata = 8'h00;
			16'h000A:	rdata = 8'h00;
			16'h000B:	rdata = 8'h11;
			16'h000C:	rdata = 8'h80;
			16'h000D:	rdata = 8'h00;
			16'h000E:	rdata = 8'h01;
			16'h000F:	rdata = 8'h10;
			16'h0010:	rdata = 8'h00;
			16'h0011:	rdata = 8'hED;
			16'h0012:	rdata = 8'hB0;
			16'h0013:	rdata = 8'h06;
			16'h0014:	rdata = 8'h10;
			16'h0015:	rdata = 8'hD3;
			16'h0016:	rdata = 8'hFE;
			16'h0017:	rdata = 8'h3C;
			16'h0018:	rdata = 8'h10;
			16'h0019:	rdata = 8'hFB;
			16'h001A:	rdata = 8'h00;
			16'h001B:	rdata = 8'h00;
			16'h001C:	rdata = 8'h00;
			16'h001D:	rdata = 8'h00;
			16'h001E:	rdata = 8'h18;
			16'h001F:	rdata = 8'hFE;
			default:	rdata = 8'hFF;
		endcase

// Reset
	reg [9:0] res_cnt;
	always @(posedge c0)
		res_cnt <= res_cnt + 1;

// PLL
	wire c0;
	wire c1;
	wire c2;

	pll	pll(
		.inclk0 (clk50),
		.c0     (c0)
		// .c1     (c1),
		// .c2     (c2)
	);

// Z80
NextZ80 NextZ80
(
	.CLK	(c0),
	// .RESET	(res_cnt[7]),
	.RESET	(res_cnt[9]),
	.ADDR	(zaddr),
	.DI		(rdata),
	.DO	   	(zdo),
	.WR	   	(zwr),
	.MREQ	(zmreq),
	.IORQ	(ziorq),
	.HALT	(zhalt),
	.M1	   	(zm1),
	.INT	(0),
	.NMI	(0),
	.WAIT	(0)
);

endmodule
