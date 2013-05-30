module main
(
	input wire clk50,
	output wire pin3,
	output wire pin7,
	output wire pin9,

	output wire [74:0] rnd_out
);

	wire [25:0] cnt0 = {cnt[25:18], cnt[17:0]};
	wire [25:0] cnt1 = {cnt[25:18] + 85, cnt[17:0]};
	wire [25:0] cnt2 = {cnt[25:18] + 170, cnt[17:0]};

	wire [7:0] duty0 = cnt0[25] ? cnt0[24:17] : ~cnt0[24:17];
	wire [7:0] duty1 = cnt1[25] ? cnt1[24:17] : ~cnt1[24:17];
	wire [7:0] duty2 = cnt2[25] ? cnt2[24:17] : ~cnt2[24:17];

	assign pin3 = cnt[7:0] > duty0;
	assign pin7 = cnt[7:0] > duty1;
	assign pin9 = cnt[7:0] > duty2;

	reg [25:0] cnt;
	always @(posedge c0)
		cnt = cnt + 1;


localparam INIT		= 2'd0;
localparam NEXT		= 2'd1;
localparam ST2		= 2'd2;
localparam ST3		= 2'd3;

	reg rnd_init;
	reg rnd_save;
	reg rnd_restore;
	reg rnd_next;

	reg [1:0] state = INIT;
	always @(posedge clk50)
		case (state)
			INIT:
				begin
					state <= NEXT;
					rnd_init <= 1;
					rnd_next <= 0;
					rnd_save <= 0;
					rnd_restore <= 0;
				end
				
			NEXT:
				begin
					rnd_init <= 0;
					rnd_next <= 1;
				end
		endcase


	wire c0;
	wire c1;
	wire c2;

	pll	pll(
		.inclk0 (clk50),
		.c0     (c0)
		// .c1     (c1),
		// .c2     (c2)
	);


	rnd_vec_gen rnd(
		.clk		(clk50),
		.init		(rnd_init),
		.save		(rnd_save),
		.restore	(rnd_restore),
		.next		(rnd_next),
		.out		(rnd_out)
	);

endmodule
