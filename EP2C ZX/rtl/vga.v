
// ************************************************************************************************************
// VGA controller
// ************************************************************************************************************

module vga
(
	input wire vclk, mclk,

	output reg [3:0] vga_r, vga_g, vga_b,
    output reg vga_hs, vga_vs,

	output wire [17:0] vaddr,
	input wire v_req_en,
	output wire v_req,
	input wire [15:0] v_data
);

`include "vga_params.v"
`include "vga_modes.v"

localparam M_ZX = 2'd0;

	wire [1:0] mode = M_ZX;

// color mixer
	wire [3:0] vr = pix ? vga_out[11:8] : {4{vcnt[1] ^ hcnt[1]}};
	wire [3:0] vg = pix ? vga_out [7:4] : {4{vcnt[1] ^ hcnt[1]}};
	wire [3:0] vb = pix ? vga_out [3:0] : {4{vcnt[1] ^ hcnt[1]}};

// SRAM request
	assign vaddr = rcnt_in;
	assign v_req = vpix && !v_line_done;

	reg fetch_stb;
	always @(posedge mclk)
		fetch_stb <= v_req;

// raster in address counters (memory clock domain)
	wire  v_line_done = (xcnt_in >= 256);
	wire v_frame_done = (ycnt_in >= 192);
	wire v_done = v_line_done || v_frame_done;

	wire [18:0] rcnt_in_next = frame_reset_s ? 0 : (fetch_stb ? (rcnt_in + 1) : rcnt_in);
	wire  [9:0] xcnt_in_next =  line_reset_s ? 0 : (fetch_stb ? (xcnt_in + 1) : xcnt_in);
	wire  [9:0] ycnt_in_next = frame_reset_s ? 0 : (line_reset_s ? (ycnt_in + 1) : ycnt_in);

	reg [18:0] rcnt_in;
	reg  [9:0] xcnt_in;
	reg  [9:0] ycnt_in;
	always @(posedge mclk)
	begin
		rcnt_in <= rcnt_in_next;
	    xcnt_in <= xcnt_in_next;
	    ycnt_in <= ycnt_in_next;
	end

// raster in address counters reset strobes resync to memory clock
	// reg [1:0] frame_reset_r;
	// reg [1:0]  line_reset_r;
	// always @(posedge vclk)
	// begin
		// frame_reset_r <= {frame_reset_r[0], frame_end};
	     // line_reset_r <= { line_reset_r[0],  hcnt_end};
	// end
	
	wire frame_reset_s = frame_end && !frame_reset_rs;
	wire  line_reset_s =  hcnt_end && !line_reset_rs;
	
	reg frame_reset_rs;
	reg line_reset_rs;
	always @(posedge mclk)
	begin
		frame_reset_rs <= frame_end;
		 line_reset_rs <= hcnt_end;
	end
	
// raster out address counters (video clock domain)
	wire [18:0] rcnt_out_next = frame_end ? 0 : (pix  ? (rcnt_out + 1) : rcnt_out);
	wire  [9:0] xcnt_out_next  = hcnt_end ? 0 : (hpix ? (xcnt_out + 1) : xcnt_out);
	wire  [9:0] ycnt_out_next  = vcnt_end ? 0 : (vpix ? (ycnt_out + 1) : ycnt_out);

	reg [18:0] rcnt_out;
	reg  [9:0] xcnt_out;
	reg  [9:0] ycnt_out;

	always @(posedge vclk)
	begin
		rcnt_out <= rcnt_out_next;
	    xcnt_out <= xcnt_out_next;
	    ycnt_out <= ycnt_out_next;
	end

// beam counters
	reg [10:0] hcnt;
	reg [10:0] vcnt;

	wire hcnt_end = hcnt == (HTOTAL - 1);
	wire vcnt_end = vcnt == (VTOTAL - 1);
	wire frame_end = hcnt_end && vcnt_end;
	wire [10:0] hcnt_next = hcnt_end ? 0 : (hcnt + 1);
	wire [10:0] vcnt_next = hcnt_end ? (vcnt_end ? 0 : (vcnt + 1)) : vcnt;

	wire hs_next = ((hcnt_next >= HS_BEG) && (hcnt_next < HS_END)) ? HSS : !HSS;
	wire vs_next = ((vcnt_next >= VS_BEG) && (vcnt_next < VS_END)) ? VSS : !VSS;
	wire hb_next = (hcnt_next >= HB_BEG) && (hcnt_next < HB_END);
	wire vb_next = (vcnt_next >= VB_BEG) && (vcnt_next < VB_END);
	wire blank_next = hb_next || vb_next;

	wire hpix = (hcnt >= HPIX_BEG) && (hcnt < HPIX_END);
	wire vpix = (vcnt >= VPIX_BEG) && (vcnt < VPIX_END);
	wire pix = hpix && vpix;

// outputs
	always @(posedge vclk)
	begin
		hcnt <= hcnt_next;
		vcnt <= vcnt_next;
		vga_r <= blank_next ? 0 : vr;
		vga_g <= blank_next ? 0 : vg;
		vga_b <= blank_next ? 0 : vb;
		vga_hs <= hs_next;
		vga_vs <= vs_next;
	end

// noise generator
	wire [3:0] noise_r = pcnt[150:147];
	wire [3:0] noise_g = pcnt[145:142];
	wire [3:0] noise_b = pcnt[140:137];

	reg [150:0] pcnt;
	always @(posedge vclk)
		pcnt = {pcnt[149:0], pcnt[150]} ^ hcnt + vcnt;

// VGA FIFO buffer
	wire [11:0] vga_out;

vga_fifo vga_fifo
(
	.rdclock	(vclk),
	.wrclock	(mclk),
	.data		(v_data),
	// .data		(pcnt[150:133]),
	.wraddress	(xcnt_in),
	.wren		(fetch_stb),
	.rdaddress	(xcnt_out),
	.q			(vga_out)
);

endmodule
