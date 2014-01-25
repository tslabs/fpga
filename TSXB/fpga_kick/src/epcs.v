module epcs
(
	// clock
	input wire clk,			// 50MHz, dedicated In

	// ZX-BUS connector
	input wire [7:0] data_in,
	output reg [7:0] data_out,
	input wire ectrl_stb,
	input wire edata_stb,
	output wire ncso,
	output wire asdo,
	output wire dclk,
	input wire data0
);

	assign dclk = dclk_int;
	assign asdo = bitorder ? shift_out[0] : shift_out[7];
	assign ncso = ectrl[0];
	wire bitorder = ectrl[1];		// 0 - MSB first (normal), 1 - LSB first (*.rpd)

	/* bitstream data processing */
	reg [7:0] shift_out, shift_in;
	reg [3:0] bit_cnt = 4'b1000;
	reg [2:0] clk_cnt = 3'd0;
	reg dclk_int = 0;

	// clk is divided by 6 here, 18.75MHz at clk=112.5MHz
	always @(posedge clk)
	begin
		if (edata_stb)
		begin
			shift_out <= data_in;
			data_out <= shift_in;
			bit_cnt <= 4'b0;
			clk_cnt <= 3'd0;
			dclk_int <= 1'b0;
		end

		else if (!bit_cnt[3])
		begin
			clk_cnt <= clk_cnt + 1;

			if (clk_cnt == 3'd2)
			// rising edge of DLCK
			begin
				dclk_int <= 1'b1;
				shift_in <= bitorder ? {data0, shift_in[7:1]} : {shift_in[6:0], data0};
			end

			else if (clk_cnt == 3'd5)
			// falling edge of DLCK
			begin
				clk_cnt <= 3'd0;
				dclk_int <= 1'b0;
				shift_out[7:0] <= bitorder ? {1'b0, shift_out[7:1]} : {shift_out[6:0], 1'b0};
				bit_cnt <= bit_cnt + 4'd1;
			end
		end
	end
	
// ports
	reg [7:0] ectrl = 8'b00000001;
	
	always @(posedge clk)
	if (ectrl_stb)
		ectrl <= data_in;

endmodule
