
module ep2c_zx
(
// clocks
	input wire clk50,

// SRAM
	output wire [17:0] sram_a,
	output wire sram_ce_n,
	output wire sram_oe_n,
	output wire sram_we_n,
	output wire sram_lb_n,
	output wire sram_ub_n,
	inout wire [15:0] sram_d,

// Flash
	output wire [21:0] flash_a,
	input wire [7:0] flash_d,
	output wire flash_ce_n,
	output wire flash_oe_n,
	output wire flash_we_n,
	output wire flash_rst_n,

// VGA
	output wire [3:0] vga_r, vga_g, vga_b,
    output wire vga_hs, vga_vs,

// KB
	input wire [3:0] key,
	input wire [9:0] sw,

// LEDs
	output wire [6:0] hex0, hex1, hex2, hex3,
	output wire [9:0] led_r,
	output wire [7:0] led_g,

// GPIO
	input wire [35:0] gpio_0, gpio_1,

// debug virtual pins
	output wire [15:0] sram_d_v,
	output wire mclk, vclk, tclk
);

	wire mcyc;
	
// debug virtual pins
	// assign sram_d_v = sram_d;

// SRAM
	assign sram_d = !sram_we_n ? {zdataout, zdataout} : 16'hZZZZ;

// Flash
	assign flash_a = {8'd0, zaddr[13:0]};
	assign flash_ce_n = !zromreq;
	assign flash_oe_n = zwr;
	assign flash_we_n = 1;
	assign flash_rst_n = 1;

	wire ramwr;

	wire [15:0] zaddr;
	wire [7:0] zdataout;
	wire zwr;
	wire zromreq;
	wire zramreq;
	wire ziorq;

z80 z80
(
	.mclk	(mclk),
	.wt_clk	(!mcyc),
	.key	(key[0]),

	.a		(zaddr),
	.dout	(zdataout),
	.ramreq	(zramreq),
	.romreq	(zromreq),
	.wr		(zwr),
	.ramwr	(zramwr),
	.iorq	(ziorq),

	.fdata	(flash_d),
	.sdata	(sram_d)
);

sram sram
(
	.mclk	(mclk),
	.mc		(mcyc),

	.zaddr	({3'd0, zaddr}),
	.zrq	(zramreq),
	.zwr	(zramwr),

	.vaddr	(vaddr),

	.addr	(sram_a),
	.ce_n	(sram_ce_n),
	.oe_n	(sram_oe_n),
	.we_n	(sram_we_n),
	.lb_n	(sram_lb_n),
	.ub_n	(sram_ub_n)
);

	wire [17:0] vaddr;
	wire vreq;

vga vga
(
	.vclk		(vclk),
	.mclk		(mclk),

	.addr		(vaddr),
	.data		(sram_d),
	.mstb		(mcyc),

	.vga_r		(vga_r),
	.vga_g		(vga_g),
	.vga_b		(vga_b),
	.vga_hs		(vga_hs),
	.vga_vs		(vga_vs)
);

// PLL
	
pll	pll
(
	.inclk0	(clk50),	// 50Mhz
	.c0		(mclk),		// 60MHz (SRAM, CPU)
	.c1		(vclk),		// 50MHz (VGA pixel)
	.c2		(tclk)		// 180MHz (TAP)
);

endmodule
