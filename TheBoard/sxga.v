module 	sxga(

	input  wire	        	clk,
	input  wire	        	clk2,
	output reg	[3:0]		r,
	output reg	[3:0]		g,
	output reg	[3:0]		b,
	output reg				hs,
	output reg				vs,
	
	input  wire [15:0]	sram_dq,	
	output reg  [17:0]	sram_addr,
	output reg  		sram_ce_n,
    output reg  		sram_oe_n,
	output reg  		sram_we_n,
	output reg  		sram_lb_n,
	output reg  		sram_ub_n,
	
	input  wire	[9:0]	sw
);


//	|...front...|...sync...|...back...|...visible...|
//	|....48.....|...112....|...248....|....1280.....|	hor
//	|.....1.....|.....3....|....38....|....1024.....|	ver

	localparam HFRONT   = 11'd0;
	localparam HSYNC    = 11'd48;
	localparam HBACK    = 11'd160;
	localparam HVISIBLE = 11'd408;
	localparam HTOTAL   = 11'd1688;

	localparam VFRONT   = 11'd0;
	localparam VSYNC    = 11'd1;
	localparam VBACK    = 11'd4;
	localparam VVISIBLE = 11'd42;
    localparam VTOTAL   = 11'd1066;

	
	reg	[10:0]	hcnt;
	reg	[10:0]	vcnt;
	reg			vvis;           // vertical pixels window
	reg			hfetch;         // window for fetching
	reg			hf1, hf2;
	
	wire eol = (hcnt == (HTOTAL - 1));
	wire hss = (hcnt == (HSYNC - 1));
	wire hse = (hcnt == (HBACK - 1));
	wire hfs = (hcnt == (HVISIBLE - 4));
	wire hfe = (hcnt == (HTOTAL - 4));
	
	wire eof = (vcnt == (VTOTAL - 1));
	wire vss = (vcnt == (VSYNC - 1));
	wire vse = (vcnt == (VBACK - 1));
	wire vvs = (vcnt == (VVISIBLE - 1));

	wire [10:0] haddr = hcnt - HVISIBLE + 3;
	wire [10:0] vaddr = vcnt - VVISIBLE;
	wire [17:0] saddr = {vaddr[8:0], haddr[8:0]};


// SRAM part
	wire 		v_req = 1'b1;
	// wire [15:0]	sram_d = v_req ? sram_dq : 16'b0;
	wire [15:0]	sram_d = sram_dq;

  	always @(posedge clk)
	begin
		if (hfetch)
		begin
			sram_addr <= saddr;
			sram_ce_n <= ~v_req;
			sram_oe_n <= ~v_req;
			sram_we_n <= 1'b1;
			sram_lb_n <= 1'b0;
			sram_ub_n <= 1'b0;
		end
		
		else
		begin
			sram_ce_n <= 1'b1;
			sram_oe_n <= 1'b1;
			sram_we_n <= 1'b1;
			sram_lb_n <= 1'b1;
			sram_ub_n <= 1'b1;
		end
	end
	
	
// VGA part	
    always @(posedge clk)
    begin
		hf1 <= hfetch;
		hf2 <= hf1;
				
        r <= hf2 && sw[9] ? sram_d[15:12] : 4'b0;
        g <= hf2 && sw[8] ? sram_d[10: 7] : 4'b0;
        b <= hf2 && sw[7] ? sram_d[ 4: 1] : 4'b0;
    end
    
	
// horizontal part
	always @(posedge clk)
	begin
	
		if (eol)
			hcnt <= 11'd0;
		else
			hcnt <= hcnt + 11'd1;
			
		if (hss)
			hs <= 1'b0;
		else if (hse)
			hs <= 1'b1;

		if (hfs && vvis)
			hfetch <= 1'b1;
		else if (hfe)
			hfetch <= 1'b0;
        
	end


// vertical part
	always @(posedge clk)
	begin
		if (eol)
		begin
		
			if (eof)
				vcnt <= 11'd0;
			else
				vcnt <= vcnt + 11'd1;
				
			if (vss)
				vs <= 1'b0;
			else if (vse)
				vs <= 1'b1;
		
			if (vvs)
				vvis <= 1'b1;
			else if (eof)
				vvis <= 1'b0;

		end
	end

	
endmodule
