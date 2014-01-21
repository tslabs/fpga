module 	sxga
(

	input  wire	        clk,
	output reg	[7:0]	r,
	output reg	[7:0]	g,
	output reg	[7:0]	b,
	output reg			hs,
	output reg			vs,
	
	input  wire [15:0]	sram_dq,	
	output reg  [17:0]	sram_addr,
    output reg  		sram_oe_n,
	output reg  		sram_we_n,
	output reg  		sram_lb_n,
	output reg  		sram_ub_n,
	
	input  wire	[3:0]	key
);

//	|...front...|...sync...|...back...|...visible...|
//	|....48.....|...112....|...248....|....1280.....|	hor
//	|.....1.....|.....3....|....38....|....1024.....|	ver

	// SXGA 1280x1024
	localparam HSYNC    = 11'd48;		// start of Horizontal Sync
	localparam HBACK    = 11'd160;		// start of Horizontal Back Porch
	localparam HVISIBLE = 11'd408;		// start of Horizontal Pixels
	localparam HTOTAL   = 11'd1688;		// total number of tacts per line
		
	localparam VSYNC    = 11'd1;		// start of Vertical Sync
	localparam VBACK    = 11'd4;		// start of Vertical Back Porch
	localparam VVISIBLE = 11'd42;		// start of Vertical Pixels
    localparam VTOTAL   = 11'd1066;		// total number of line per frame

	// VGA 768x576
	// localparam HSYNC    = 11'd32;		// start of Horizontal Sync
	// localparam HBACK    = 11'd112;		// start of Horizontal Back Porch
	// localparam HVISIBLE = 11'd224;		// start of Horizontal Pixels
	// localparam HTOTAL   = 11'd992;		// total number of tacts per line
		
	// localparam VSYNC    = 11'd1;		// start of Vertical Sync
	// localparam VBACK    = 11'd4;		// start of Vertical Back Porch
	// localparam VVISIBLE = 11'd25;		// start of Vertical Pixels
    // localparam VTOTAL   = 11'd601;		// total number of line per frame
	
	wire hss = (hcnt == (HSYNC - 1));            	// hsync start trigger
	wire hse = (hcnt == (HBACK - 1));            	// hsync end trigger
	wire hfs = (hcnt == (HVISIBLE - 4)) && vvis; 	// fetch start trigger
	wire hfe = (hcnt == (HTOTAL - 4));           	// fetch end trigger
	wire eol = (hcnt == (HTOTAL - 1));           	// end of line trigger
	                                              
	wire vss = (vcnt == (VSYNC - 1));             	// vsync start trigger
	wire vse = (vcnt == (VBACK - 1));             	// vsync end trigger
	wire vvs = (vcnt == (VVISIBLE - 1));          	// vertical pixels area start trigger
	wire eof = (vcnt == (VTOTAL - 1));            	// end of frame trigger
	
// horizontal part
	reg	[10:0]	hcnt;
	reg			hfetch;         // window for fetching
	
	always @(posedge clk)
	begin
	
		if (eol)
			hcnt <= 0;
		else
			hcnt <= hcnt + 1;
			
		if (hss)
			hs <= 0;
		else if (hse)
			hs <= 1;

		if (hfs)
			hfetch <= 1;
		else if (hfe)
			hfetch <= 0;
        
	end

// vertical part
	reg	[10:0]	vcnt;
	reg			vvis;           // vertical pixels window
	
	always @(posedge clk)
	begin
		if (eol)
		begin
		
			if (eof)
				vcnt <= 0;
			else
				vcnt <= vcnt + 1;
				
			if (vss)
				vs <= 0;
			else if (vse)
				vs <= 1;
		
			if (vvs)
				vvis <= 1;
			else if (eof)
				vvis <= 0;

		end
	end

// Bitmap walking
	reg  [20:0]	bitmap_x;							// These are 9.12 (= 512x512 with 12 bits for fractal part)
	reg  [20:0]	bitmap_y;
	reg  [20:0]	bm_x_temp;
	reg  [20:0]	bm_y_temp;
	reg  [15:0]	step_x = 16'b0001000000000000;		// These are 4.12 (4 bits for integer and 12 bits for fractal part)
	reg  [15:0]	step_y = 16'b0000000000000000;
	wire [20:0] step_x_ext = {{6{step_x[15]}}, step_x[14:0]};
	wire [20:0] step_y_ext = {{6{step_y[15]}}, step_y[14:0]};
	
	always @(posedge clk)
	begin
		
		if (hfe && eof)								// at the last tact of frame
		begin
			bm_x_temp <= 0;							// initiate start X and Y for bitmap
			bm_y_temp <= 0;
		end
		
		else
		if (hfs)									// at the start of visible line
		begin
			bitmap_x <= bm_x_temp;					// get new X and Y for bitmap
			bitmap_y <= bm_y_temp;

			bm_x_temp <= bm_x_temp - step_y_ext;		// move to next line of bitmap
			bm_y_temp <= bm_y_temp + step_x_ext;
		end
		
		else
		if (hfetch)									// at the visible area of line
		begin
			bitmap_x <= bitmap_x + step_x_ext;			// move to the next pixel of bitmap
			bitmap_y <= bitmap_y + step_y_ext;
		end
		
	end
	
// SRAM part
	wire [15:0]	sram_d = sram_dq;
	wire [17:0] saddr = {bitmap_y[20:12], bitmap_x[20:12]};
	wire 		v_req = hfetch;
	wire		r_req = v_req;
	wire		w_req = 0;
	wire [ 1:0] b_req = 2'b11;

  	always @(posedge clk)
	begin
		sram_addr <= saddr;
		sram_oe_n <= ~r_req;
		sram_we_n <= ~w_req;
		sram_lb_n <= ~b_req[0];
		sram_ub_n <= ~b_req[1];
	end
	
// VGA-out part	
	reg	[1:0] hf_delayed;

    always @(posedge clk)
    begin
		hf_delayed[0] <= hfetch;
		hf_delayed[1] <= hf_delayed[0];
    end
	
	wire [2:0] cmask = vcnt[8:6];
	wire cmask_en = vcnt[10:9] == 2'b00;
    
	wire en = hf_delayed[1];
	
	wire [7:0] luma = hcnt[9:2] - 128;
	// wire [7:0] luma = hcnt[7:0];

	
	always @(negedge clk)
		if (cmask_en)
		begin
			r <= (en && (cmask[1] || !cmask_en)) ? luma : 0;
			g <= (en && (cmask[2] || !cmask_en)) ? luma : 0;
			b <= (en && (cmask[0] || !cmask_en)) ? luma : 0;
		end
		
		else
		begin
			r[7:3] <= en ? sram_d[14:10] : 0;
			g[7:3] <= en ? sram_d[9:5] : 0;
			b[7:3] <= en ? sram_d[4:0] : 0;
		end
    
// Zooming and Rotating control
	always @(posedge clk)
	begin
		if (eol && eof)
		begin
	
			if (!key[0])
			begin
				step_x <= step_x - 1;
			end
	
			else
			if (!key[1])
			begin
				step_x <= step_x + 1;
			end
			
			if (!key[2])
			begin
				step_y <= step_y - 1;
			end
	
			else
			if (!key[3])
			begin
				step_y <= step_y + 1;
			end
			
		end
	end

endmodule
