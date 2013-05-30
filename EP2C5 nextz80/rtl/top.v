
module ep2c5_nextz80
(
	input	wire	[7:0]	DI,
	output	wire	[7:0]	DO,
	output	wire	[15:0]	ADDR,
	output	wire			WR,
	output	wire			MREQ,
	output	wire			IORQ,
	output	wire			HALT,
	output	wire			M1,
	input	wire			CLK,
	input	wire			RESET,
	input	wire			INT,
	input	wire			NMI,
	input	wire			WAIT
);

NextZ80 NextZ80
(
	.DI		(DI),
	.DO	   	(DO),
	.ADDR	(ADDR),
	.WR	   	(WR),
	.MREQ	(MREQ),
	.IORQ	(IORQ),
	.HALT	(HALT),
	.M1	   	(M1),
	.CLK	(CLK),
	.RESET	(RESET),
	.INT	(INT),
	.NMI	(NMI),
	.WAIT	(WAIT)
);

endmodule
