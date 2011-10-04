module 	sxga(

	input  wire	        	clk,
	// output wire	[3:0]		vred,
	// output wire	[3:0]		vgrn,
	// output wire	[3:0]		vblu,
	output reg				hsync,
	output reg				vsync,
	output wire [10:0]		haddr,
	output wire [10:0]		vaddr,
	output wire				vis

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
	reg			hvis;
	reg			vvis;
	
	assign		vis = hvis && vvis;
	
	wire eol = (hcnt == (HTOTAL - 1));
	wire hss = (hcnt == (HSYNC - 1));
	wire hse = (hcnt == (HBACK - 1));
	wire hvs = (hcnt == (HVISIBLE - 1));
	
	wire eof = (vcnt == (VTOTAL - 1));
	wire vss = (vcnt == (VSYNC - 1));
	wire vse = (vcnt == (VBACK - 1));
	wire vvs = (vcnt == (VVISIBLE - 1));

	assign haddr = hcnt - HVISIBLE + 2;
	assign vaddr = vcnt - VVISIBLE;

	
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

		if (hvs)
			hvis <= 1'b1;
		else if (eol)
			hvis <= 1'b0;

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

	

	// assign vred = vis ? {hcnt1[0],hcnt1[7:5]} : 4'b0;
	// assign vgrn = vis ? hcnt[9:6] : 4'b0;
	// assign vblu = vis ? vcnt[9:6] : 4'b0;
	
	
endmodule
