module tap (
	input wire clk,
	output wire clk_pll0,
	output wire clk_pll1,
	output wire clk_pll2,
	input wire scl,
	input wire sda,
	input wire rdy,
	output reg tick_1khz,
	output reg [23:0] div
);

	always @(posedge clk)
		div <= div + 1;
	

// output for 1kHz strobe
localparam MAX = 16'd50000;
localparam DUTY = 16'd100;

	reg [15:0] cnt = 0;
	always @(posedge clk)
		if (cnt == (MAX - 1))
			cnt <= 0;
		else 
			cnt <= cnt + 1;
		
	always @(posedge clk)
		if (~|cnt)
			tick_1khz <= 1'b1;
		else if (cnt == DUTY)
			tick_1khz <= 1'b0;

// PLL
	pll	pll(
		.inclk0 (clk),
		.c0     (clk_pll0),
		.c1     (clk_pll1),
		.c2     (clk_pll2)
	);
	
endmodule
