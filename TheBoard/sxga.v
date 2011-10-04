module 	sxga(

	input  wire	        	clk,
	output reg	[3:0]		r,
	output reg	[3:0]		g,
	output reg	[3:0]		b,
	output reg				hsync,
	output reg				vsync,

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
	
	wire eol = (hcnt == (HTOTAL - 1));
	wire hss = (hcnt == (HSYNC - 1));
	wire hse = (hcnt == (HBACK - 1));
	wire hfs = (hcnt == (HVISIBLE - 2));
	wire hfe = (hcnt == (HTOTAL - 2));
	
	wire eof = (vcnt == (VTOTAL - 1));
	wire vss = (vcnt == (VSYNC - 1));
	wire vse = (vcnt == (VBACK - 1));
	wire vvs = (vcnt == (VVISIBLE - 1));

	wire [10:0] haddr = hcnt - HVISIBLE + 1;
	wire [10:0] vaddr = vcnt - VVISIBLE;


// SRAM part
  	assign sram_addr = {vaddr[8:0], haddr[8:0]};
	assign sram_ce_n = hfetch;
	assign sram_oe_n = hfetch;
	assign sram_lb_n = 1'b0;
	assign sram_ub_n = 1'b0;
	assign sram_we_n = 1'b1;
	
    always @(posedge clk)
    begin
        r <= hfetch && sw[9] ? sram_dq[15:12] : 4'b0;
        g <= hfetch && sw[8] ? sram_dq[10: 7] : 4'b0;
        b <= hfetch && sw[7] ? sram_dq[ 4: 1] : 4'b0;
    end
    
	
// horizontal part
	always @(posedge clk)
	begin
	
		if (eol)
			hcnt <= 11'd0;
		else
			hcnt <= hcnt + 11'd1;
			
		if (hss)
			hsync <= 1'b0;
		else if (hse)
			hsync <= 1'b1;

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
				vsync <= 1'b0;
			else if (vse)
				vsync <= 1'b1;
		
			if (vvs)
				vvis <= 1'b1;
			else if (eof)
				vvis <= 1'b0;

		end
	end

	
endmodule
