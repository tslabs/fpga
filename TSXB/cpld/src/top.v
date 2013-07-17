module tsxb_cpld
(
	// clock
	input wire clk,			// dedicated In

	// ZX-BUS connector
	inout wire [15:0] za,
	inout wire zd0, zd7,
	input wire zd1, zd2, zd3, zd4, zd5, zd6,
	inout wire zrd_n, zwr_n, zmrq_n, ziorq_n,
	output wire zbusrq_n,
	input wire zbusak_n,	// dedicated In
	output wire ziorge_n,

	// FPGA connector
	inout wire [15:0] fa,
	inout wire frd_n, fwr_n, fmrq_n, fiorq_n,
	input wire fbusrq_n,
	input wire fiorge_n_forq,	// Host Master: IORGE / Host Slave: FPGA Data Bus Output Enable, correspondent T80 signal may be used

	// ZX-BUS bus transmitter
	output wire ddir,

	// FPGA configuration
	output wire msel0,
	output wire dclk,
	output wire data0,
	inout wire nconfig,
	input wire nstatus,		// dedicated In
	input wire conf_done	// dedicated In
);

	wire [7:0] zd = {zd7, zd6, zd5, zd4, zd3, zd2, zd1, zd0};
	wire fiorge_n = fiorge_n_forq;	// just aliases
	wire forq = fiorge_n_forq;      //

// ZX-BUS handling
	wire slave_mode = fbusrq_n || zbusak_n;

	/* FPGA bus */
	assign fa = slave_mode ? za : 16'hZZZZ;
	assign frd_n = slave_mode ? zrd_n : 1'bZ;
	assign fwr_n = slave_mode ? zwr_n : 1'bZ;
	assign fmrq_n = slave_mode ? zmrq_n : 1'bZ;
	assign fiorq_n = slave_mode ? ziorq_n : 1'bZ;
	
	/* ZXBUS bus */
	assign zd0 = (slave_mode && stat_hit) ? nstatus : 1'bZ;
	assign zd7 = (slave_mode && stat_hit) ? conf_done : 1'bZ;
	assign za = slave_mode ? 16'hZZZZ : fa;
	assign zrd_n = slave_mode ? 1'bZ : frd_n;
	assign zwr_n = slave_mode ? 1'bZ : fwr_n;
	assign zmrq_n = slave_mode ? 1'bZ : fmrq_n;
	assign ziorq_n = slave_mode ? 1'bZ : fiorq_n;
	assign zbusrq_n = fbusrq_n;
	assign ziorge_n = (slave_mode ? fiorge_n : 1'b1) && !conf_hit && !data_hit;

	/* 16245 data direction */
	localparam FPGA_TO_ZXBUS = 1'b0;
	localparam ZXBUS_TO_FPGA = 1'b1;
	
	assign ddir = slave_mode ? slave_dir : master_dir;
		// in Slave mode FPGA outputs data only if own address decoded and read request from host received
	wire slave_dir = (!fiorge_n && !zrd_n) ? FPGA_TO_ZXBUS : ZXBUS_TO_FPGA;
		// in Master mode FPGA outputs data only by FORQ request
	wire master_dir = forq ? FPGA_TO_ZXBUS : ZXBUS_TO_FPGA;

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
	assign nconfig = config_int ? 1'b0 : 1'bZ;
	assign msel0 = msel0_int;
	assign dclk = conf_done ? 1'b0 : (ps_mode ? dclk_int : 1'bZ);
	assign data0 = conf_done ? 1'b0 : (ps_mode ? bs_shift[0] : 1'bZ);

	/* ports decoding */
	wire ports_hit = !ziorq_n && (za[7:0] == 8'hAF);
	wire conf_hit = ports_hit && (za[15:8] == 8'hE0);
	wire data_hit = ports_hit && !za[15] && !zwr_n && !conf_done && ps_mode;
	wire ctrl_hit = conf_hit && !zwr_n;
	wire stat_hit = conf_hit && !zrd_n;

	/* control signals re-sync */
	reg data_hit_r;
	reg ctrl_hit_r;
	reg nconfig_r;
	always @(posedge clk)
	begin
		data_hit_r <= data_hit;
		ctrl_hit_r <= ctrl_hit;
		nconfig_r <= nconfig;
	end

	/* PS mode latch */
	reg ps_mode = 0;
	always @(posedge clk)
		if (!nconfig_r)
			ps_mode <= msel0;
		
	/* configuration control register */
	reg config_int = 0;
	reg msel0_int = 0;
	always @(posedge clk)
		if (ctrl_hit_r)
		begin
			config_int <= zd0;
			msel0_int <= zd1;
		end

	/* bitstream data processing */
	reg [7:0] bs_shift;
	reg [3:0] bit_cnt = 4'b1000;
	reg dclk_int = 0;
	always @(posedge clk)
		if (data_hit_r)
		begin
			bs_shift <= zd;
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
