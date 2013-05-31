
module ep2c_zx
(
// clocks
	input wire clk50,

// VGA
	output wire [3:0] vga_r,
    output wire [3:0] vga_g,
    output wire [3:0] vga_b,
    output wire vga_hs,
    output wire vga_vs,

// Z80	
	output wire [7:0] zdo,
	output wire [7:0] rdata,
	output wire [15:0] zaddr,
	output wire zwr,
	output wire zmreq,
	output wire ziorq,
	output wire zhalt,
	output wire zm1
);

// Reset
	reg [9:0] res_cnt;
	always @(posedge c0)
		res_cnt <= res_cnt + 1;

// VGA controller
vga vga
(
	.clk (c2),
	
	.vga_r (vga_r),
	.vga_g (vga_g),
	.vga_b (vga_b),
	.vga_hs (vga_hs),
	.vga_vs (vga_vs)
);
		
// Z80 ROM
z80_rom z80_rom
(
	.a		(zaddr),
	.d		(rdata)
);

// Z80
// NextZ80 z80
// (
	// .CLK	(c0),
	
	// .RESET	(res_cnt[9]),
	// .INT	(0),
	// .NMI	(0),
	// .WAIT	(0),
	
	// .ADDR	(zaddr),
	// .DI		(rdata),
	// .DO	   	(zdo),
	
	// .MREQ	(zmreq),
	// .IORQ	(ziorq),
	// .WR	   	(zwr),
	// .M1	   	(zm1),
	// .HALT	(zhalt)
// );

// PLL
	wire c0;
	wire c1;
	wire c2;

pll	pll
(
	.inclk0 (clk50),	// 50Mhz
	.c0     (c0),		// 30MHz (Z80)
	.c1     (c1),		// 90MHz (SRAM access)
	.c2     (c2)		// 50MHz (VGA pixel)
);

endmodule
