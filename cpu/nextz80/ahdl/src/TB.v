`timescale 1ns / 1ps		   


module TB();

reg CLK = 0;
reg RES = 0;

always #10 CLK = ~CLK;

initial
begin
	#5
	RES = 1;
	#100
	RES = 0;
end

// NextZ80	******************************************************************************************************************************	

wire		nz80_m1, nz80_wr, nz80_mreq, nz80_iorq;
wire [15:0]	nz80_addr;
wire [7:0]	nz80_di, nz80_do;
wire [3:0]	nz80_stall;
		 
wire		ram0_wr = !nz80_addr[15] && nz80_mreq && nz80_wr;
wire [7:0]	ram0_do, rom0_do;	

assign		nz80_di = nz80_addr[15] ? ram0_do : rom0_do;


localparam
	H = 1'b1,
	L = 1'b0;

ssram ram0(
	.CLK(CLK),
	.ADDR(nz80_addr[14:0]),
	.DI(nz80_do),
	.DO(nz80_di),
	.OE(1),
	.WE(ram0_wr)
);			  


	
wire ENCLK = H;	  
wire NZ80CLK = ENCLK & CLK;
wire BLOCK;	

NextZ80	nz80 (
	.DI(nz80_di),
	.DO(nz80_do),
	.ADDR(nz80_addr),
	.WR(nz80_wr),
	.MREQ(nz80_mreq),
	.IORQ(nz80_iorq),
	.M1(nz80_m1),
	.CLK(NZ80CLK),
	.RESET(RES),
	.STALL(nz80_stall),
	
	.BLOCK(BLOCK),
	
	.INT(L), .NMI(L), .WAIT(L)
);

// T80	 ******************************************************************************************************************************

wire 		t80_m1_n, t80_mreq_n, t80_iorq_n, t80_wr_n, t80_rd_n;
wire [15:0]	t80_a;
wire [7:0]	t80_di, t80_do;

wire		ram1_wr = !(t80_a[15] | t80_wr_n | t80_mreq_n);
wire [7:0]	ram1_do, rom1_do;				

ssram ram1(
	.CLK(CLK),
	
	.ADDR(t80_a[14:0]),
	.DI(t80_do),
	.DO(t80_di),
	.OE(1),
	.WE(ram1_wr)
);

reg [4:0] delay;

always @ (posedge CLK)
	delay = {delay[3:0],RES};
	
wire T80_RES_N = ~delay[3];



T80s t80(
	.RESET_n(T80_RES_N),
	.CLK_n(CLK),
	
	.M1_n(t80_m1_n),
	.MREQ_n(t80_mreq_n),
	.IORQ_n(t80_iorq_n),
	.RD_n(t80_rd_n),
	.WR_n(t80_wr_n),
	.A(t80_a),
	.DI(t80_di),
	.DO(t80_do),
	
	.WAIT_n(H), .INT_n(H), .NMI_n(H), .BUSRQ_n(H)
);


// compare   ******************************************************************************************************************************
reg [15:0]	nz80_fa, t80_fa;					  
reg run = 1'b0;			
reg [3:0]	stop_cnt = 0;		

wire	reqStop = nz80_fa[15] == 1'bx;

always @ (negedge CLK)
begin	
	if (nz80_m1) nz80_fa = nz80_addr;
	if (!t80_m1_n && !t80_mreq_n) t80_fa = t80_a;
		
	if (!run)
	begin
		if (nz80_fa == t80_fa) 
		begin
			run = 1'b1;
			$display("*** START ***");
		end
	end			  
	else
	begin	 

		if (nz80_fa==t80_fa);
		else		
		begin		  
			if (stop_cnt == 0 && !BLOCK)
			begin
				$display("*** ÊÎÃÍÈÒÈÂÍÛÉ ÄÈÑÑÎÍÀÍÑ ***");
				$display("NEXTZ80 ADDR=%h  T80 ADDR=%h", nz80_fa, t80_fa);  
				stop_cnt = 7;
			end
		end
	end		
	
	if (stop_cnt > 0)
		stop_cnt = stop_cnt - 1;
		
	if (stop_cnt == 1)
	begin
		$display("*** STOP ***");
		$finish;
	end
end
	


endmodule
