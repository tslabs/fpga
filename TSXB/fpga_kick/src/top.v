module fpga_kick
(
	// clock
	input wire CLK_IN,		// 50MHz

	// ZX-BUS
	input wire FRD,
	input wire FWR,
	input wire FMRQ,
	input wire FIORQ,
	input wire FCSROM_N,
	input wire FM1_N,
	input wire FZF,
	input wire FRES_N,
	input wire FWAIT_N,
	input wire FINT_N,
	input wire FBUSAK_N,

	// FCI connector
	inout wire [7:0] FCI,
	output wire [1:0] FCI_S,
	output wire FDIR,			// 1 - from CPLD to FPGA (CPU write), default state when FPGA is being configured / 0 - from FPGA to CPLD (CPU read)

	// SDRAM
	output wire SD_CLK,
	output wire [11:0] SD_A,
	output wire [1:0] SD_BA,
	output wire SD_RAS_N,
	output wire SD_CAS_N,
	output wire SD_WE_N,
	output wire SD_LDQM,
	output wire SD_UDQM,
	inout wire [15:0] SD_D,

	// SRAM
	output wire [18:0] SR_A,
	output wire SR_OE_N,
	output wire SR_WE_N,
	output wire SR_BHE_N,
	output wire SR_BLE_N,
	inout wire [15:0] SR_D,

	// video DAC
	output wire V_CLK,
	output wire [7:0] V_B,
	output wire [7:0] V_G,
	output wire [7:0] V_R,
	output wire V_HS,
	output wire V_VS,

	// audio DAC
	output wire DAC_LRCK,
	output wire DAC_MCLK,
	output wire DAC_SDATA,

	// conf device
	inout wire NCSO,
	inout wire ASDO,
	output wire DCLK,
	input wire DATA0
);
	
	// assign NCSO  = 1'b0;
	// assign ASDO  = 1'b0;
	
	assign V_CLK = clk1;

	assign FCI = FDIR ? 8'hZZ : (zxb_mni ? memdata_out : portdata_out);
	assign FDIR = fci_dir || !FRD;		// to release CPU data bus as soon as it de-asserts !RD signal

	assign DAC_LRCK = soundbit_l;
	assign DAC_MCLK = soundbit_r;

	assign SR_D = SR_WE_N ? 16'hZZZZ : {zxbdata_in, zxbdata_in};

	wire zxb_en = zxb_mni ? mem_en : port_en;

	wire mem_en  = zxb_rnw ? mrd_en : mwr_en;
	wire mrd_en = 1'b0;
	wire mwr_en = sxgamem_en;
	
	wire sxgamem_en;

	wire clk0;
	wire clk1;
	wire clk2;

	wire [7:0] memdata_out;
	wire [7:0] portdata_out;
	wire [7:0] epcs_data_out;

	wire [15:0] zxbaddr;
	wire [7:0] zxbdata_in;
	wire fci_dir;
	wire zxb_rnw;
	wire zxb_mni;

	wire zxbmem_req;
	wire zxbport_req;
	wire mem_stb = 1'b1;

	wire port_stb;
	wire port_en;
	wire covox_stb;
	wire sdrv_stb;
	wire ectrl_stb;
	wire edata_stb;
	wire srpage_stb;
	
	wire soundbit_l;
	wire soundbit_r;

	wire [7:0] test;

	zxbus zxbus
	(
		.clk		(clk1),
		.rd			(FRD),
		.wr			(FWR),
		.mrq		(FMRQ),
		.iorq		(FIORQ),
		.reset		(!FRES_N),
		.fci_in		(FCI),
		.fci_sel	(FCI_S),
		.fci_dir	(fci_dir),
		.zaddr		(zxbaddr),
		.zdata_in	(zxbdata_in),
		.zxb_rnw	(zxb_rnw),
		.zxb_mni	(zxb_mni),
		.zxb_en		(zxb_en),
		.mem_req	(zxbmem_req),
		.port_req	(zxbport_req),
		.mem_stb	(mem_stb),
		.port_stb	(port_stb)
	);

	ports ports
	(
		.addr		(zxbaddr),
		.data_out	(portdata_out),
		.rnw		(zxb_rnw),
		.port_en	(port_en),
		.port_req	(zxbport_req),
		.port_stb	(port_stb),
		.epcs_data  (epcs_data_out),
		.covox_stb	(covox_stb),
		.sdrv_stb	(sdrv_stb),
		.ectrl_stb	(ectrl_stb),
		.edata_stb	(edata_stb),
		.srpage_stb	(srpage_stb)
	);

	epcs epcs
	(
		.clk		(clk1),
		.data_in	(zxbdata_in),
		.data_out	(epcs_data_out),
		.ectrl_stb	(ectrl_stb),
		.edata_stb	(edata_stb),
		.ncso		(NCSO),
		.asdo		(ASDO),
		.dclk		(DCLK),
		.data0		(DATA0)
	);

	sound sound
	(
		.data_in	(zxbdata_in),
		.clk		(clk1),
		.sclk		(clk2),
		.covox_wr	(covox_stb),
		.sdrv_wr	(sdrv_stb),
		.addr		(zxbaddr),
		.soundbit_l	(soundbit_l),
		.soundbit_r	(soundbit_r)
	);

	sxga sxga
	(
		.clk 		(V_CLK),
		.r   		(V_R),
		.g   		(V_G),
		.b   		(V_B),
		.hs  		(V_HS),
		.vs  		(V_VS),
		.data_in	(zxbdata_in),
		.zxbaddr	(zxbaddr),
		.sxgamem_en	(sxgamem_en),
		.srpage_stb	(srpage_stb),
        .wstb       (zxbmem_req && !zxb_rnw),
		.sram_dq    (SR_D),
		.sram_addr  (SR_A),
		.sram_oe_n  (SR_OE_N),
		.sram_we_n  (SR_WE_N),
		.sram_ub_n  (SR_BHE_N),
		.sram_lb_n  (SR_BLE_N),
		.key		(~test[3:0])
	);

	pll	pll
	(
		.inclk0 (CLK_IN),	// 50 MHz
		.c0     (clk0),		// 225 MHz
		.c1     (clk1),		// 112.5 MHz
		.c2     (clk2)		// 56.25 MHz
	);
	
endmodule
