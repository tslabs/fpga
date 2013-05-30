
module ep2c5_tv80 (
	// Outputs
	m1_n, iorq, no_read, write, rfsh_n, halt_n, busak_n, A, dout, mc,
	ts, intcycle_n, IntE, stop,
	// Inputs
	reset_n, clk, cen, wait_n, int_n, nmi_n, busrq_n, dinst, di
);

	input			reset_n;
	input			clk;
	input			cen;
	input			wait_n;
	input			int_n;
	input			nmi_n;
	input			busrq_n;
	output			m1_n;
	output			iorq;
	output			no_read;
	output			write;
	output			rfsh_n;
	output			halt_n;
	output			busak_n;
	output	[15:0]	A;
	input	[7:0]	dinst;
	input	[7:0]	di;
	output	[7:0]	dout;
	output	[6:0]	mc;
	output	[6:0]	ts;
	output			intcycle_n;
	output			IntE;
	output			stop;

tv80_core tv80
(
	.reset_n	(reset_n),
	.clk		(clk),
	.cen		(cen),
	.wait_n		(wait_n),
	.int_n		(int_n),
	.nmi_n		(nmi_n),
	.busrq_n	(busrq_n),
	.m1_n		(m1_n),
	.iorq		(iorq),
	.no_read	(no_read),
	.write		(write),
	.rfsh_n		(rfsh_n),
	.halt_n		(halt_n),
	.busak_n	(busak_n),
	.A			(A),
	.dinst		(dinst),
	.di			(di),
	.dout		(dout),
	.mc			(mc),
	.ts			(ts),
	.intcycle_n	(intcycle_n),
	.IntE		(IntE),
	.stop		(stop)
);

endmodule
