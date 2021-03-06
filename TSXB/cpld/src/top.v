module tsxb_cpld
(
	// clock
	input wire CLK_IN,			// 50MHz, dedicated In

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

	// ZX-BUS bus transmitter to FPGA
	output wire FRD,
	output wire FWR,
	output wire FMRQ,
	output wire FIORQ,

	// FPGA configuration
	output wire MSEL0,
	output wire DCLK,
	output wire DATA0,
	inout wire NCONFIG,
	input wire NSTATUS,		// dedicated In
	input wire CONF_DONE	// dedicated In
);

	// config
	assign NCONFIG = config_int ? 1'b0 : 1'bZ;
	assign MSEL0 = msel0_int;
	assign DCLK  = CONF_DONE ? 1'bZ : (ps_mode ? dclk_int : 1'bZ);
	assign DATA0 = CONF_DONE ? 1'bZ : (ps_mode ? bs_shift[0] : 1'bZ);

	// ZX-BUS
	assign ZD = stat_hit ? conf_status : (CONF_DONE ? (FDIR ? 8'bZZ : FCI) : 8'bZZ);
	assign ZBUSRQ_N = 1;
	assign ZIORGE_N = 1;
	assign ZRDROM_N = 1'bZ;

	// FPGA bus
	assign FCI     = CONF_DONE ? (FDIR ? fci_mux : 8'bZZ) : 8'bZZ;
	assign FRD   = CONF_DONE ? !ZRD_N   : 1'bZ;
	assign FWR   = CONF_DONE ? !ZWR_N   : 1'bZ;
	assign FMRQ  = CONF_DONE ? !ZMRQ_N  : 1'bZ;
	assign FIORQ = CONF_DONE ? !ZIORQ_N : 1'bZ;

	wire [7:0] conf_status = {CONF_DONE, 6'b0, NSTATUS};

	/* FCI bus */

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
	// Control / Status - #F8AF
	//
	// Bit stream data is written to memory into selected 16kB window
	//
	// Control (write):
	//	bit0: 1 - nCONFIG
	//		0 - nCONFIG = Z
	//		1 - nCONFIG = 0
	//	bit1: MSEL0:
	//		0 - AS mode from EPCS4
	//		1 - PS mode from host
	//	bit6,7: window address:
	//		00 - 0000..3FFF
	//		01 - 4000..7FFF
	//		10 - 8000..BFFF
	//		11 - C000..FFFF
	//
	// Status (read):
	//	bit0: nSTATUS
	//	bit7: CONF_DONE


	/* ports decoding */
	wire conf_hit = (ZA[15:0] == 16'hF8AF) && !ZIORQ_N;
	wire ctrl_hit = conf_hit && !ZWR_N;
	wire stat_hit = conf_hit && !ZRD_N;
	wire data_hit = (ZA[15:14] == conf_addr) && !ZMRQ_N && !ZWR_N && ps_mode;

	/* configuration control register */
	reg config_int = 1'b0;
	reg msel0_int = 1'b0;
	reg [1:0] conf_addr;
	reg ctrl_hit_r;

	always @(posedge CLK_IN)
	begin
		ctrl_hit_r <= ctrl_hit;		// re-sync

		if (ctrl_hit_r)
		begin
			config_int <= ZD[0];
			msel0_int <= ZD[1];
			conf_addr <= ZD[7:6];
		end
	end

	/* PS mode latch */
	reg ps_mode = 0;
	always @(posedge NCONFIG, posedge CONF_DONE)
		if (CONF_DONE)
			ps_mode <= 1'b0;
		else
			ps_mode <= msel0_int;

	/* bitstream data processing */
	reg [7:0] bs_shift;
	reg [3:0] bit_cnt = 4'b1000;
	reg dclk_int = 0;
	reg [1:0] data_hit_r;
	wire data_hit_s = data_hit_r[0] && !data_hit_r[1];

	always @(posedge CLK_IN)
	begin
		data_hit_r <= {data_hit_r[0], data_hit};		// re-sync

		if (data_hit_s)
		begin
			bs_shift <= ZD;
			bit_cnt <= 4'b0;
			dclk_int <= 1'b0;
		end

		else if (!bit_cnt[3])
		begin
			dclk_int <= ~dclk_int;

			// falling edge of DCLK
			if (dclk_int)
			begin
				bs_shift[7:0] <= {1'b0, bs_shift[7:1]};
				bit_cnt <= bit_cnt + 4'd1;
			end
		end
	end

endmodule
