module main
(
	input wire clk50,
	output wire pin3
	//output wire pin4,
	//output wire pin7,
	//output wire pin8,
	//input wire pin9
);
	
	assign pin3 = out;
	// assign pin4 = c0;
	// assign pin7 = c1;
	// assign pin8 = c2;
	
	wire [7:0] duty = cnt[25] ? cnt[24:17] : ~cnt[24:17];
	wire out = cnt[7:0] > duty;
	
	reg [3:0] div;
	always @(posedge c0)
		div = div + 1;
	
	reg [25:0] cnt;
	always @(posedge c0) if (&div)
		cnt = cnt + 1;

	
	wire c0;
	wire c1;
	wire c2;
	pll	pll(
	.inclk0 (clk50),
	.c0     (c0)
	// .c1     (c1),
	// .c2     (c2)
	);

endmodule
