module avr_dap(
	inout  wire 		clk,
	inout  wire  [7:0]	dap_data,
	inout  wire 		dap_ce_n, 
	inout  wire 		dap_re_n, 
	inout  wire 		dap_we_n, 
	inout  wire			dap_r_n_b,
	
	output reg  [23:0]	addr,
	output wire [15:0]	d_wr,
	input  wire [15:0]	d_rd,
	output wire			w_rq,
	output wire			r_rq,
	input  wire			rq_ack
	
);

	assign dap_data = !dap_re_n && !dap_ce_n ? dout : 8'hZZ;
	assign d_wr = {din, din0};
	assign dap_r_n_b = 1;

	reg [ 7:0]	din;
	reg [ 7:0]	din0;
	reg [ 7:0]	dout;
	reg [ 7:0]	dout0;


// strobing input data
	always @(posedge dap_we_n)
		if (!dap_ce_n)
			din <= dap_data;
	
	
// strobing control input signals
	reg	ce, ce0;
	reg	re, re0;
	reg	we, we0;
	
	always @(posedge clk)
	begin
		ce <= ce0;	ce0 <= ~dap_ce_n;
		re <= re0;	re0 <= ~dap_re_n;
		we <= we0;	we0 <= ~dap_we_n;
	end


// FSM
	localparam IDL = 5'd0;
	localparam AW1 = 5'd1;
	localparam AW2 = 5'd2;
	localparam AW3 = 5'd3;
	localparam AW4 = 5'd4;
	localparam AW5 = 5'd5;
	localparam ROW = 5'd6;
	localparam DW1 = 5'd7;
	localparam DW2 = 5'd8;
	localparam DW3 = 5'd9;
	localparam DR1 = 5'd10;
	localparam DR2 = 5'd11;
	localparam DR3 = 5'd12;
	
// some control signals derived from state
	assign w_rq = (ms == DW3) && !we && !rq_ack;
	assign r_rq = (ms == ROW) && re && !rq_ack;
	
	reg [4:0]	ms;
	
	always @(posedge clk)
	begin
	if (!ce)
		ms <= IDL;
	else
	case (ms)
IDL:	// wait for 1st WEn
		if (we)
			ms <= AW1;

AW1:	// if end of WEn, fetch addr[7:0]
		if (!we)
		begin
			addr[7:0] <= din;
			ms <= AW2;
		end
		
AW2:	// wait for 2nd WEn
		if (we)
			ms <= AW3;
		
AW3:	// if end of WEn, fetch addr[15:8]
		if (!we)
		begin
			addr[15:8] <= din;
			ms <= AW4;
		end
		
AW4:	// wait for 3rd WEn
		if (we)
			ms <= AW5;
		
AW5:	// if end of WEn, fetch addr[23:16]
		if (!we)
		begin
			addr[23:16] <= din;
			ms <= ROW;
		end
		
ROW:	// wait for REn or WEn
		if (we)
			ms <= DW1;
		else
		if (re && rq_ack)
		begin
			{dout0, dout} <= addr;			//DEBUG!!!
			// {dout0, dout} <= d_rd;
			addr <= addr + 1;
			ms <= DR1;
		end

DW1:	// if end of WEn, fetch data[7:0]
		if (!we)
		begin
			din0 <= din;
			ms <= DW2;
		end

DW2:	// wait for 2nd WEn
		if (we)
			ms <= DW3;
		
DW3:	// if end of WEn, write request appears, waiting for request acknowledge, repeat from ROW
		if (!we && rq_ack)
		begin
			addr <= addr + 1;
			ms <= ROW;
		end

DR1:	// wait for end of 1st REn
		if (!re)
		begin
			dout <= dout0;
			ms <= DR2;
		end

DR2:
		if (re)
			ms <= DR3;

DR3:
		if (!re)
			ms <= ROW;
		
	endcase
	end


endmodule
