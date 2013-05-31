
// `define VGA_60		// 40MHz pixelclock
`define VGA_72		// 50MHz pixelclock
// `define VGA_100		// 68.18MHz pixelclock

`ifdef VGA_60
localparam HFRONT = 11'd40;
localparam HSYNC = 11'd128;
localparam HBACK = 11'd88;
localparam HVIS = 11'd800;
localparam HSS = 1'b1;		// positive

localparam VFRONT = 11'd1;
localparam VSYNC = 11'd4;
localparam VBACK = 11'd23;
localparam VVIS = 11'd600;
localparam VSS = 1'b1;		// positive
`endif

`ifdef VGA_72
localparam HFRONT = 11'd56;
localparam HSYNC = 11'd120;
localparam HBACK = 11'd64;
localparam HVIS = 11'd800;
localparam HSS = 1'b1;		// positive

localparam VFRONT = 11'd37;
localparam VSYNC = 11'd6;
localparam VBACK = 11'd23;
localparam VVIS = 11'd600;
localparam VSS = 1'b1;		// positive
`endif

`ifdef VGA_100
localparam HFRONT = 11'd48;
localparam HSYNC = 11'd88;
localparam HBACK = 11'd136;
localparam HVIS = 11'd800;
localparam HSS = 1'b0;		// negative

localparam VFRONT = 11'd1;
localparam VSYNC = 11'd3;
localparam VBACK = 11'd32;
localparam VVIS = 11'd600;
localparam VSS = 1'b1;		// positive
`endif

localparam HTOTAL = HFRONT + HSYNC + HBACK + HVIS;
localparam HS_BEG = HFRONT;
localparam HS_END = HFRONT + HSYNC;
localparam HB_BEG = 0;
localparam HB_END = HFRONT + HSYNC + HBACK;

localparam VTOTAL = VFRONT + VSYNC + VBACK + VVIS;
localparam VS_BEG = VFRONT;
localparam VS_END = VFRONT + VSYNC;
localparam VB_BEG = 0;
localparam VB_END = VFRONT + VSYNC + VBACK;
