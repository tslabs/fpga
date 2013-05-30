
module ep2c5_tv80 (
	reset_n0,
	clk0,
	cen0,
	wait_n0,
	int_n0,
	nmi_n0,
	busrq_n0,
	m1_n0,
	iorq0,
	no_read0,
	write0,
	rfsh_n0,
	halt_n0,
	busak_n0,
	A0,
	dinst0,
	di0,
	dout0,
	mc0,
	ts0,
	intcycle_n0,
	IntE0,
	stop0
	
	// reset_n1,
	// clk1,
	// cen1,
	// wait_n1,
	// int_n1,
	// nmi_n1,
	// busrq_n1,
	// m1_n1,
	// iorq1,
	// no_read1,
	// write1,
	// rfsh_n1,
	// halt_n1,
	// busak_n1,
	// A1,
	// dinst1,
	// di1,
	// dout1,
	// mc1,
	// ts1,
	// intcycle_n1,
	// IntE1,
	// stop1,
	
	// reset_n2,
	// clk2,
	// cen2,
	// wait_n2,
	// int_n2,
	// nmi_n2,
	// busrq_n2,
	// m1_n2,
	// iorq2,
	// no_read2,
	// write2,
	// rfsh_n2,
	// halt_n2,
	// busak_n2,
	// A2,
	// dinst2,
	// di2,
	// dout2,
	// mc2,
	// ts2,
	// intcycle_n2,
	// IntE2,
	// stop2,
	
	// reset_n3,
	// clk3,
	// cen3,
	// wait_n3,
	// int_n3,
	// nmi_n3,
	// busrq_n3,
	// m1_n3,
	// iorq3,
	// no_read3,
	// write3,
	// rfsh_n3,
	// halt_n3,
	// busak_n3,
	// A3,
	// dinst3,
	// di3,
	// dout3,
	// mc3,
	// ts3,
	// intcycle_n3,
	// IntE3,
	// stop3
);

	input			reset_n0;
	input			clk0;
	input			cen0;
	input			wait_n0;
	input			int_n0;
	input			nmi_n0;
	input			busrq_n0;
	output			m1_n0;
	output			iorq0;
	output			no_read0;
	output			write0;
	output			rfsh_n0;
	output			halt_n0;
	output			busak_n0;
	output	[15:0]	A0;
	input	[7:0]	dinst0;
	input	[7:0]	di0;
	output	[7:0]	dout0;
	output	[6:0]	mc0;
	output	[6:0]	ts0;
	output			intcycle_n0;
	output			IntE0;
	output			stop0;
	
	// input			reset_n1;
	// input			clk1;
	// input			cen1;
	// input			wait_n1;
	// input			int_n1;
	// input			nmi_n1;
	// input			busrq_n1;
	// output			m1_n1;
	// output			iorq1;
	// output			no_read1;
	// output			write1;
	// output			rfsh_n1;
	// output			halt_n1;
	// output			busak_n1;
	// output	[15:0]	A1;
	// input	[7:0]	dinst1;
	// input	[7:0]	di1;
	// output	[7:0]	dout1;
	// output	[6:0]	mc1;
	// output	[6:0]	ts1;
	// output			intcycle_n1;
	// output			IntE1;
	// output			stop1;

	// input			reset_n2;
	// input			clk2;
	// input			cen2;
	// input			wait_n2;
	// input			int_n2;
	// input			nmi_n2;
	// input			busrq_n2;
	// output			m1_n2;
	// output			iorq2;
	// output			no_read2;
	// output			write2;
	// output			rfsh_n2;
	// output			halt_n2;
	// output			busak_n2;
	// output	[15:0]	A2;
	// input	[7:0]	dinst2;
	// input	[7:0]	di2;
	// output	[7:0]	dout2;
	// output	[6:0]	mc2;
	// output	[6:0]	ts2;
	// output			intcycle_n2;
	// output			IntE2;
	// output			stop2;

	// input			reset_n3;
	// input			clk3;
	// input			cen3;
	// input			wait_n3;
	// input			int_n3;
	// input			nmi_n3;
	// input			busrq_n3;
	// output			m1_n3;
	// output			iorq3;
	// output			no_read3;
	// output			write3;
	// output			rfsh_n3;
	// output			halt_n3;
	// output			busak_n3;
	// output	[15:0]	A3;
	// input	[7:0]	dinst3;
	// input	[7:0]	di3;
	// output	[7:0]	dout3;
	// output	[6:0]	mc3;
	// output	[6:0]	ts3;
	// output			intcycle_n3;
	// output			IntE3;
	// output			stop3;	

tv80_core tv80_0
(
	.reset_n	(reset_n0),
	.clk		(clk0),
	.cen		(cen0),
	.wait_n		(wait_n0),
	.int_n		(int_n0),
	.nmi_n		(nmi_n0),
	.busrq_n	(busrq_n0),
	.m1_n		(m1_n0),
	.iorq		(iorq0),
	.no_read	(no_read0),
	.write		(write0),
	.rfsh_n		(rfsh_n0),
	.halt_n		(halt_n0),
	.busak_n	(busak_n0),
	.A			(A0),
	.dinst		(dinst0),
	.di			(di0),
	.dout		(dout0),
	.mc			(mc0),
	.ts			(ts0),
	.intcycle_n	(intcycle_n0),
	.IntE		(IntE0),
	.stop		(stop0)
);

// tv80_core tv80_1
// (
	// .reset_n	(reset_n1),
	// .clk		(clk1),
	// .cen		(cen1),
	// .wait_n		(wait_n1),
	// .int_n		(int_n1),
	// .nmi_n		(nmi_n1),
	// .busrq_n	(busrq_n1),
	// .m1_n		(m1_n1),
	// .iorq		(iorq1),
	// .no_read	(no_read1),
	// .write		(write1),
	// .rfsh_n		(rfsh_n1),
	// .halt_n		(halt_n1),
	// .busak_n	(busak_n1),
	// .A			(A1),
	// .dinst		(dinst1),
	// .di			(di1),
	// .dout		(dout1),
	// .mc			(mc1),
	// .ts			(ts1),
	// .intcycle_n	(intcycle_n1),
	// .IntE		(IntE1),
	// .stop		(stop1)
// );

// tv80_core tv80_2
// (
	// .reset_n	(reset_n2),
	// .clk		(clk2),
	// .cen		(cen2),
	// .wait_n		(wait_n2),
	// .int_n		(int_n2),
	// .nmi_n		(nmi_n2),
	// .busrq_n	(busrq_n2),
	// .m1_n		(m1_n2),
	// .iorq		(iorq2),
	// .no_read	(no_read2),
	// .write		(write2),
	// .rfsh_n		(rfsh_n2),
	// .halt_n		(halt_n2),
	// .busak_n	(busak_n2),
	// .A			(A2),
	// .dinst		(dinst2),
	// .di			(di2),
	// .dout		(dout2),
	// .mc			(mc2),
	// .ts			(ts2),
	// .intcycle_n	(intcycle_n2),
	// .IntE		(IntE2),
	// .stop		(stop2)
// );

// tv80_core tv80_3
// (
	// .reset_n	(reset_n3),
	// .clk		(clk3),
	// .cen		(cen3),
	// .wait_n		(wait_n3),
	// .int_n		(int_n3),
	// .nmi_n		(nmi_n3),
	// .busrq_n	(busrq_n3),
	// .m1_n		(m1_n3),
	// .iorq		(iorq3),
	// .no_read	(no_read3),
	// .write		(write3),
	// .rfsh_n		(rfsh_n3),
	// .halt_n		(halt_n3),
	// .busak_n	(busak_n3),
	// .A			(A3),
	// .dinst		(dinst3),
	// .di			(di3),
	// .dout		(dout3),
	// .mc			(mc3),
	// .ts			(ts3),
	// .intcycle_n	(intcycle_n3),
	// .IntE		(IntE3),
	// .stop		(stop3)
// );

endmodule
