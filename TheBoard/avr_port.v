module avr_port(
	inout wire 			clk,
	inout wire  [7:0]	data,
	inout wire 			ce_n, 
	inout wire 			re_n, 
	inout wire 			we_n, 
	inout wire 			ae_p,	
	inout wire 			de_p,	
	inout wire			r_n_b
);


	reg	[1:0]	ce;
	reg	[1:0]	re;
	reg	[1:0]	we;
	reg	[1:0]	ae;
	reg	[1:0]	de;
	
// strobing input signals
	always @(posedge clk)
	begin
		ce[1] <= ce[0];	ce[0] <= ~ce_n;
		re[1] <= re[0];	re[0] <= ~re_n;
		we[1] <= we[0];	we[0] <= ~we_n;
		ae[1] <= ae[0];	ae[0] <= ae_p;
		de[1] <= de[0];	de[0] <= de_p;
	end
	
	
	reg [23:0]	addr;
	reg [ 7:0]	dout;
	reg [ 7:0]	din;
	reg			a_n_d;
	
	assign data = re[1] ? dout : 8'hZZ;


// FSM
	reg [ 4:0]	ms;
	reg [ 4:0]	ms_next;
	
	localparam MS_IDLE = 4'd0;
	localparam MS_AWR1 = 4'd1;
	localparam MS_AWR2 = 4'd2;
	localparam MS_AWR3 = 4'd3;
	localparam MS_AWR4 = 4'd4;
	localparam MS_AWR5 = 4'd5;
	localparam MS_AWR6 = 4'd6;
	localparam MS_AWR7 = 4'd7;
	localparam MS_AWR8 = 4'd8;
	localparam MS_DWR1 = 4'd9;
	localparam MS_DWR2 = 4'd10;
	localparam MS_DWR3 = 4'd11;
	localparam MS_DRD1 = 4'd12;
	localparam MS_DRD2 = 4'd13;
	localparam MS_DRD3 = 4'd14;
	
	wire awe = ae[1] && we[1];
	wire dwe = de[1] && we[1];
	wire dre = de[1] && re[1];

	
// next state clocking
	always @(posedge clk)
	ms <= ms_next;
	

// states assigning
	always @*
	if (!ce[1])
		ms_next = MS_IDLE;
	else
	case (ms)
MS_IDLE:
		if (ae[1] && we[1])		// address write cycle
			ms_next = MS_AWR1;
		else
		if (de[1] && we[1])		// data write cycle
			ms_next = MS_DWR1;
		else
		if (de[1] && re[1])		// data read cycle
			ms_next = MS_DRD1;
		else
			ms_next = MS_IDLE;	// smoking cigarettes cycle

MS_AWR1:
		ms_next = ae[1] ? MS_AWR2 : MS_IDLE;
MS_AWR2:
		ms_next = ae[1] ? (we[1] ? MS_AWR2 : MS_AWR3) : MS_IDLE;
MS_AWR3:
		ms_next = ae[1] ? (we[1] ? MS_AWR4 : MS_AWR3) : MS_IDLE;
MS_AWR4:
		ms_next = ae[1] ? MS_AWR5 : MS_IDLE;
MS_AWR5:
		ms_next = ae[1] ? (we[1] ? MS_AWR5 : MS_AWR6) : MS_IDLE;
MS_AWR6:
		ms_next = ae[1] ? (we[1] ? MS_AWR7 : MS_AWR6) : MS_IDLE;
MS_AWR7:
		ms_next = ae[1] ? MS_AWR8 : MS_IDLE;
MS_AWR8:
		ms_next = ae[1] ? MS_AWR8 : MS_IDLE;

MS_DWR1:
		ms_next = MS_DWR2;
MS_DWR2:
		ms_next = MS_IDLE;
MS_DRD1:
		ms_next = MS_DRD2;
MS_DRD2:
		ms_next = MS_IDLE;
default:
		ms_next = MS_IDLE;
	endcase
	
	
// states processing
	always @(posedge clk)
	case (ms)
	
MS_AWR1:
		addr[7:0] <= data;
MS_AWR4:
		addr[15:8] <= data;
MS_AWR7:
		addr[23:16] <= data;

	endcase
	
	
	
	

endmodule
