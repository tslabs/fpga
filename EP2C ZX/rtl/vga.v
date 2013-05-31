
module vga
(
	input wire clk,
	
	output reg [3:0] vga_r,
    output reg [3:0] vga_g,
    output reg [3:0] vga_b,
    output reg vga_hs,
    output reg vga_vs
);

`include "vga_params.v"

// colors
	wire [3:0] vr = pcnt[3:0];
	wire [3:0] vg = pcnt[7:4];
	wire [3:0] vb = pcnt[11:8];
	
	reg [11:0] pcnt;
	always @(posedge clk)
		pcnt = {pcnt[10:0], pcnt[11]} ^ hcnt ^ vcnt;

// beam counters
	reg [10:0] hcnt;
	reg [10:0] vcnt;

	wire line_end = hcnt == (HTOTAL - 1);
	wire frame_end = vcnt == (VTOTAL - 1);
	wire [10:0] hcnt_next = line_end ? 0 : (hcnt + 1);
	wire [10:0] vcnt_next = line_end ? (frame_end ? 0 : (vcnt + 1)) : vcnt;
	
	wire hs_next = ((hcnt_next >= HS_BEG) && (hcnt_next < HS_END)) ? HSS : !HSS;
	wire vs_next = ((vcnt_next >= VS_BEG) && (vcnt_next < VS_END)) ? VSS : !VSS;
	wire hb_next = (hcnt_next >= HB_BEG) && (hcnt_next < HB_END);
	wire vb_next = (vcnt_next >= VB_BEG) && (vcnt_next < VB_END);
	wire blank_next = hb_next || vb_next;
	
// outputs	
	always @(posedge clk)
	begin
		hcnt <= hcnt_next;
		vcnt <= vcnt_next;
		vga_r <= blank_next ? 0 : vr;
		vga_g <= blank_next ? 0 : vg;
		vga_b <= blank_next ? 0 : vb;
		vga_hs <= hs_next;
		vga_vs <= vs_next;
	end

endmodule
