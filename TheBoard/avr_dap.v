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
	output reg			w_rq,
	output reg			r_rq,
	input  wire			rq_ack
	
);

	assign dap_data = !dap_re_n && !dap_ce_n ? addr[7:0] : 8'hZZ;
	assign d_wr = {din, din0};
	assign dap_r_n_b = 1;

	reg [ 7:0]	din;
	reg [ 7:0]	din0;
	reg [ 7:0]	dout;


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
	localparam MS_IDL = 5'd0;
	localparam MS_AW1 = 5'd1;
	localparam MS_AW2 = 5'd2;
	localparam MS_AW3 = 5'd3;
	localparam MS_AW4 = 5'd4;
	localparam MS_AW5 = 5'd5;
	localparam MS_AW6 = 5'd6;
	localparam MS_AW7 = 5'd7;
	localparam MS_AW8 = 5'd8;
	localparam MS_FRK = 5'd9;
	localparam MS_DW1 = 5'd10;
	localparam MS_DW2 = 5'd11;
	localparam MS_DW3 = 5'd12;
	localparam MS_DW4 = 5'd13;
	localparam MS_DW5 = 5'd14;
	localparam MS_DW6 = 5'd15;
	localparam MS_DR1 = 5'd16;
	localparam MS_DR2 = 5'd17;
	localparam MS_DR3 = 5'd18;
	localparam MS_DR4 = 5'd19;
	localparam MS_DR5 = 5'd20;
	localparam MS_DR6 = 5'd21;
	
	
// next state clocking
	reg [4:0]	ms;
	reg [4:0]	ms_next;
	
	always @(posedge clk)
	ms <= ms_next;
	

// states assigning

// CEn	|-----______|_________|____|_______|______|____|______|________|_____|_____|__-----
// WEn	|-----------|_________|----|-------|______|----|------|________|-----|-----|-------
// MS	|IDLE       |AW1	  |AW2 |AW3    |AW4	  |AW5 |AW6   |AW7     |AW8  |AW9  |IDLE
// ADDR	|					  | 7:0               |15:8		 		  |23:16

// CEn	  |-----______|_________|____|_______|_______|__________|______|________|____|_____|__-----
// WEn	  |-----------|_________|----|-------|_______|----------|------|________|----|-----|-------
// MS	  |IDLE       |DW1	    |DW2 |DW3    |DW4    |DW5       |DW6   |DW1     |DW2 |DW9  |IDLE
// DATA	  |	                    |7:0			     |15:8      	            |7:0
// W_RQ   |__________________________________________|----------|__________________________________        
// RQ_ACK |____________________________________________________-|-_________________________________ 
// ADDR   |ADDR                                                     |ADDR+1

// CEn	  |-----______|______|____|_______|_______|_______|______|____|_______
// REn	  |-----------|______|____|-------|_______|-------|______|____|-------
// MS	  |IDLE       |DR1   |DR2 |DR3    |DR4    |DR5    |DR1	|DR2 |DR3   
// DATA	  |	                 |7:0	      |15:8                  |7:0	     
// R_RQ   |___________|------|____________________________|------|____________      
// RQ_ACK |_________________-|-_________________________________-|-___________
// ADDR   |ADDR              |ADDR+1                                                

// On any wait state if CE is deasserted FSM returns to IDLE state

	always @*
	if (!ce)
		ms_next = MS_IDL;
	else
	case (ms)
MS_IDL:
		ms_next = we ? MS_AW1 : MS_IDL;

MS_AW1:	// wait for end of WEn
		ms_next = we ? MS_AW1 : MS_AW2;
MS_AW2:	// fetch addr[7:0]
		ms_next = MS_AW3;
MS_AW3:	// wait for start of WEn
		ms_next = we ? MS_AW4 : MS_AW3;
MS_AW4:	// wait for end of WEn
		ms_next = we ? MS_AW4 : MS_AW5;
MS_AW5:	// fetch addr[15:8]
		ms_next = MS_AW6;
MS_AW6:	// wait for start of WEn
		ms_next = we ? MS_AW7 : MS_AW6;
MS_AW7:	// wait for end of WEn
		ms_next = we ? MS_AW7 : MS_AW8;
MS_AW8:	// fetch addr[23:16]
		ms_next = MS_FRK;

MS_FRK:	// wait for REn or WEn
		if (we)
			ms_next = MS_DW1;
		else
		if (re)
			ms_next = MS_DR1;
		else
			ms_next = MS_FRK;

MS_DW1:	// wait for end of WEn
		ms_next = we ? MS_DW1 : MS_DW2;
MS_DW2:	// fetch data[7:0]
		ms_next = MS_DW3;
MS_DW3:	// wait for start of WEn
		ms_next = we ? MS_DW4 : MS_DW3;
MS_DW4:	// wait for end of WEn
		ms_next = we ? MS_DW4 : MS_DW5;
MS_DW5:	// fetch data[15:8], wait for rq_ack
		ms_next = rq_ack ? MS_DW6 : MS_DW5;
MS_DW6:	// wait for start of WEn, goto DW1
		ms_next = we ? MS_DW1 : MS_DW6;

MS_DR1:	// wait for rq_ack
		ms_next = rq_ack ? MS_DR2 : MS_DR1;
MS_DR2:	// feed data[7:0]
		ms_next = MS_DR3;
MS_DR3:	// wait for end of REn
		ms_next = re ? MS_DR3 : MS_DR4;
MS_DR4:	// wait for start of REn
		ms_next = re ? MS_DR5 : MS_DR4;
MS_DR5:	// feed data[15:8], 	wait for end of REn
		ms_next = re ? MS_DR5 : MS_DR6;
MS_DR6:	// wait for start of REn, goto DR1
		ms_next = re ? MS_DR1 : MS_DR6;

default:
		ms_next = MS_IDL;
	endcase
	
	
// states processing
	always @(posedge clk)
	case (ms)
	
MS_IDL:
		begin
			r_rq <=0;
			w_rq <=0;
		end

MS_AW2:
		addr[7:0] <= din;
MS_AW5:
		addr[15:8] <= din;
MS_AW8:
		addr[23:16] <= din;

MS_DW2:
		din0[7:0] <= din;
MS_DW5:
		w_rq <= 1;
MS_DW6:
		begin
			w_rq <= 0;
			addr <= addr + 1;
		end

MS_DR1:
		r_rq <= 1;
MS_DR2:
		begin
			r_rq <= 0;
			dout <= d_rd[7:0];
			addr <= addr + 1;
		end
MS_DR4:
		dout <= d_rd[15:8];
		
		
	endcase
	
	
endmodule
