
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
	output wire [7:0] zdataout,
	output wire [7:0] rdata,
	output wire [15:0] zaddr,
	output wire zwr,
	output wire zromreq,
	output wire zramreq,
	output wire ziorq,
	output wire zhalt,
	output wire zm1,
	output wire zreset,
	
	output wire [2:0] mcyc,
	output wire zclk, mclk, vclk,
	output wire [15:0] sram_d_v
);

// debug virtual pins
	assign sram_d_v = sram_d;

// SRAM
	assign sram_d = !sram_we_n ? {zdataout, zdataout} : 16'hZZZZ;

// Flash
	assign flash_a = {8'd0, zaddr[13:0]};
	assign flash_ce_n = !zromreq;
	assign flash_oe_n = zwr;
	assign flash_we_n = 1;
	assign flash_rst_n = 1;

	wire ramwr;
	
z80 z80
(
	.zclk	(zclk),
	
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
	.zclk	(zclk),
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
	// .vclk		(vclk),
	.vclk		(clk50),
	.mclk		(zclk),

	.vga_r		(vga_r),
	.vga_g		(vga_g),
	.vga_b		(vga_b),
	.vga_hs		(vga_hs),
	.vga_vs		(vga_vs),

	.vaddr		(vaddr),
	.v_req_en	(!zramreq),
	.v_req		(vreq),
	.v_data		(sram_d)
);

// PLL
	// wire zclk;
	// wire mclk;
	// wire vclk;

pll	pll
(
	.inclk0	(clk50),	// 50Mhz
	.c0		(zclk),		// 30MHz (Z80)
	.c1		(mclk),		// 90MHz (SRAM access)
	.c2		(vclk)		// 50MHz (VGA pixel)
);

endmodule
