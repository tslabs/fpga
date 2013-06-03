
// ************************************************************************************************************
// VGA controller
// ************************************************************************************************************

module vga
(
	input wire vclk, mclk,

	output wire [17:0] addr,
	input wire [15:0] data,
	input wire mstb,

	output reg [3:0] vga_r, vga_g, vga_b,
    output reg vga_hs, vga_vs
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
	assign addr = atr_n_gfx ? aaddr : gaddr;
	wire [17:0] gaddr = {6'b000010, ycnt_in[7:6], ycnt_in[2:0], ycnt_in[5:3], xcnt[4:1]};
	wire [17:0] aaddr = {9'b000010110, ycnt_in[7:3], xcnt[4:1]};
	wire req = vpix && !pstb && !xcnt[5];
	wire dstb = mstb && req;

// 6912 renderer
	wire atr_n_gfx = xcnt[0];
	wire pstb = !pcnt[4];
	
	reg [5:0] xcnt;
	always @(posedge mclk)
		if (line_reset_s)
			xcnt <= 0;
		else if (dstb)
			xcnt <= xcnt + 1;
		
	reg [4:0] pcnt;
	always @(posedge mclk)
		if (line_reset_s)
			pcnt <= 5'h10;
		else if (dstb && xcnt[0])
			pcnt <= 0;
		else if (pstb)
			pcnt <= pcnt + 1;
	
	reg [15:0] gfx, atr;
	always @(posedge mclk)
			if (atr_n_gfx)
				atr <= data;
			else
				gfx <= data;
	
	wire flash = 0;
	wire zx_dot = gfx[{pcnt[3], ~pcnt[2:0]}];
	wire [7:0] zx_attr	= ~pcnt[3] ? atr[7:0] : atr[15:8];
	wire [3:0] zx_pix = {zx_attr[6], zx_dot ^ (flash & zx_attr[7]) ? zx_attr[2:0] : zx_attr[5:3]};
	wire [1:0] zx_r = zx_pix[1] ? (zx_pix[3] ? 2'b11 : 2'b10 ) : 2'b00;
	wire [1:0] zx_g = zx_pix[2] ? (zx_pix[3] ? 2'b11 : 2'b10 ) : 2'b00;
	wire [1:0] zx_b = zx_pix[0] ? (zx_pix[3] ? 2'b11 : 2'b10 ) : 2'b00;
	wire [11:0] pdata = {zx_r, 2'b0, zx_g, 2'b0, zx_b, 2'b0};
	
// raster in address counters (memory clock domain)
	wire [18:0] rcnt_in_next = frame_reset_s ? 0 : ((vpix && pstb) ? (rcnt_in + 1) : rcnt_in);
	wire  [9:0] xcnt_in_next =  line_reset_s ? 0 : (pstb ? (xcnt_in + 1) : xcnt_in);
	wire  [9:0] ycnt_in_next = frame_reset_s ? 0 : ((vpix && line_reset_s) ? (ycnt_in + 1) : ycnt_in);

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
	wire [3:0] noise_r = noise[150:147];
	wire [3:0] noise_g = noise[145:142];
	wire [3:0] noise_b = noise[140:137];

	reg [150:0] noise;
	always @(posedge vclk)
		noise = {noise[149:0], noise[150]} ^ hcnt + vcnt;

// VGA FIFO buffer
	wire [11:0] vga_out;

vga_fifo vga_fifo
(
	.rdclock	(vclk),
	.wrclock	(mclk),
	// .data		(data),
	.data		(pdata),
	.wraddress	(xcnt_in),
	// .wren		(stb),
	.wren		(pstb),
	.rdaddress	(xcnt_out),
	.q			(vga_out)
);

endmodule
