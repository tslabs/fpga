module tsxb_cpld
(
	// clock
	input wire CLK50,			// dedicated In

	// ZX-BUS connector
	input wire [15:0] ZA,
	inout wire [7:0] ZD,
	input wire ZRD_N, ZWR_N, ZMRQ_N, ZIORQ_N,
	input wire ZBUSAK_N,	// dedicated In
	input wire ZCSROM_N,
	output wire ZBUSRQ_N,
	output wire ZIORGE_N,
	output wire ZRDROM_N,

	// FCI connector
	inout wire [7:0] FCI,
	input wire [1:0] FCI_S,
	input wire FDIR,			// 1 - from CPLD to FPGA (CPU write), default state when FPGA is being configured / 0 - from FPGA to CPLD (CPU read)

	// ZX-BUS bus transmitter
	output wire DDIR,
	output wire FRD_N,
	output wire FWR_N,
	output wire FMRQ_N,
	output wire FIORQ_N,

	// FPGA configuration
	output wire MSEL0,
	output wire DCLK,
	output wire DATA0,
	inout wire NCONFIG,
	input wire NSTATUS,		// dedicated In
	input wire CONF_DONE	// dedicated In
);

	assign DDIR = 1'b0;		// legacy 16245 - to be removed

// ZXBUS handling

	/* ZXBUS */
	assign ZD = FDIR ? 8'bZZ : FCI;
	assign ZBUSRQ_N = 1;
	assign ZIORGE_N = 1;
	assign ZRDROM_N = 1'bZ;

	/* FPGA bus */
	assign FRD_N = ZRD_N;
	assign FWR_N = ZWR_N;
	assign FMRQ_N = ZMRQ_N;
	assign FIORQ_N = ZIORQ_N;

	/* FCI bus */
	assign FCI = FDIR ? fci_mux : 8'bZZ;

	localparam FCI_ZAL = 2'h0;
	localparam FCI_ZAH = 2'h1;
	localparam FCI_ZD = 2'h2;
	localparam FCI_ZC = 2'h3;

	wire [7:0] fci_mux = fci_mx[FCI_S];
	wire [7:0] fci_mx[0:3];
	assign fci_mx[FCI_ZAL] = ZA[7:0];
	assign fci_mx[FCI_ZAH] = ZA[15:8];
	assign fci_mx[FCI_ZD ] = ZD[7:0];
	assign fci_mx[FCI_ZC ] = ZD[7:0];
			
// ---------------------------------------------------------------------------------------
// PS configuration

	// Ports:
	//
	// Control / Status - #E0AF
	// Bit stream data - #00AF..7FAF
	//
	// Control:
	//	bit0: 1 - nCONFIG (1 - nCONFIG = 0 / 0 - nCONFIG = Z)
	//	bit1: MSEL0: 0 - AS mode from EPCS4 / 1 - PS mode from host
	//
	// Status:
	//	bit0: nSTATUS
	//	bit7: CONF_DONE

	/* top-level assignments */
	assign NCONFIG = config_int ? 1'b0 : 1'bZ;
	assign MSEL0 = msel0_int;
	assign DCLK = CONF_DONE ? 1'b0 : (ps_mode ? dclk_int : 1'bZ);
	assign DATA0 = CONF_DONE ? 1'b0 : (ps_mode ? bs_shift[0] : 1'bZ);

	/* ports decoding */
	wire ports_hit = !ZIORQ_N && (ZA[7:0] == 8'hAF);
	wire conf_hit = ports_hit && (ZA[15:8] == 8'hE0);
	wire data_hit = ports_hit && !ZA[15] && !ZWR_N && !CONF_DONE && ps_mode;
	wire ctrl_hit = conf_hit && !ZWR_N;
	wire stat_hit = conf_hit && !ZRD_N;

	/* control signals re-sync */
	reg data_hit_r;
	reg ctrl_hit_r;
	reg nconfig_r;
	always @(posedge CLK50)
	begin
		data_hit_r <= data_hit;
		ctrl_hit_r <= ctrl_hit;
		nconfig_r <= NCONFIG;
	end

	/* PS mode latch */
	reg ps_mode = 0;
	always @(posedge CLK50)
		if (!nconfig_r)
			ps_mode <= MSEL0;

	/* configuration control register */
	reg config_int = 0;
	reg msel0_int = 0;
	always @(posedge CLK50)
		if (ctrl_hit_r)
		begin
			config_int <= ZD[0];
			msel0_int <= ZD[1];
		end

	/* bitstream data processing */
	reg [7:0] bs_shift;
	reg [3:0] bit_cnt = 4'b1000;
	reg dclk_int = 0;
	always @(posedge CLK50)
		if (data_hit_r)
		begin
			bs_shift <= ZD;
			bit_cnt <= 4'b0;
		end

		// !data_hit_r
		else if (!dclk_int)
		begin
			if (!bit_cnt[3])
			begin
				dclk_int <= 1'b1;
				bit_cnt <= bit_cnt + 4'd1;
			end
		end

		// dclk_int
		else
		begin
			bs_shift[7:0] <= {1'b0, bs_shift[7:1]};
			dclk_int <= 1'b0;
		end

endmodule
