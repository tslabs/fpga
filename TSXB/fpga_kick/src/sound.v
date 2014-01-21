module sound
(
	input  wire	clk,
	input  wire	sclk,
	input  wire [7:0] data_in,
	input  wire [15:0] addr,
	input  wire	covox_wr,
	input  wire	sdrv_wr,
	output reg soundbit_l,
	output reg soundbit_r
);

	wire [8:0] val_l = sd0 + sd1;
	wire [8:0] val_r = sd2 + sd3;

	reg [7:0] sd0, sd1, sd2, sd3;
	wire [1:0] sdsel = {addr[6], addr[4]};

// port writes
	always @(posedge clk)
		if (covox_wr)
		begin
			sd0 <= data_in;
			sd1 <= data_in;
			sd2 <= data_in;
			sd3 <= data_in;
		end

		else if (sdrv_wr)
			case (sdsel)
				2'h0:
					sd0 <= data_in;
				2'h1:
					sd1 <= data_in;
				2'h2:
					sd2 <= data_in;
				2'h3:
					sd3 <= data_in;
			endcase

// SD modulator

	// reg [8:0] ctr_l, ctr_r;

	// wire gte_l = val_l >= ctr_l;
	// wire gte_r = val_r >= ctr_r;

	// always @(posedge sclk)
	// begin
		// soundbit_l <= gte_l;
		// soundbit_r <= gte_r;

		// ctr_l <= {9{gte_l}} - val_l + ctr_l;
		// ctr_r <= {9{gte_r}} - val_r + ctr_r;
	// end

// PWM generator
	reg [9:0] ctr;

	wire phase = ctr[9];
	wire [8:0] saw = ctr[8:0];

	always @(posedge sclk)
	begin
		soundbit_l <= ((phase ? saw : ~saw) < val_l);
		soundbit_r <= ((phase ? saw : ~saw) < val_r);
		ctr <= ctr + 1;
	end

endmodule

