module tsxb_cpld
(
	// clock
	input wire clk,			// dedicated In
	
	// ZX-BUS connector
	inout wire [15:0] za,
	inout wire zd0,
	input wire zd1,
	input wire zd2,
	input wire zd3,
	input wire zd4,
	input wire zd5,
	input wire zd6,
	inout wire zd7,
	inout wire zrd_n,
	inout wire zwr_n,
	inout wire zmrq_n,
	inout wire ziorq_n,
	output wire zbusrq_n,
	input wire zbusak_n,	// dedicated In
	output wire ziorge_n,

	// FPGA connector
	inout wire [15:0] fa,
	inout wire frd_n,
	inout wire fwr_n,
	inout wire fmrq_n,
	inout wire fiorq_n,
	input wire fbusrq_n,
	input wire fiorge_forq,	// Host Master: IORGE / Host Slave: FPGA Data Bus Output Enable, correspondent T80 signal may be used

	// ZX-BUS bus transmitter
	output wire doe_n,
	output wire ddir,
	
	// FPGA configuration
	output wire msel0,
	output wire dclk,
	output wire data0,
	output wire nconfig,
	input wire nstatus,		// dedicated In
	input wire conf_done	// dedicated In
);

	wire [7:0] zd = {zd7, zd6, zd5, zd4, zd3, zd2, zd1, zd0};
	
// ZX-BUS handling
	wire host_master = !(!fbusrq_n && !zbusak_n);
	
	assign za = host_master ? 16'hZZZZ : fa;
	assign zd0 = (host_master && conf_stat_hit) ? nstatus : 1'bZ;
	assign zd7 = (host_master && conf_stat_hit) ? conf_done : 1'bZ;
	assign zrd_n = host_master ? 1'bZ : frd_n;
	assign zwr_n = host_master ? 1'bZ : fwr_n;
	assign zmrq_n = host_master ? 1'bZ : fmrq_n;
	assign ziorq_n = host_master ? 1'bZ : fiorq_n;
	assign zbusrq_n = fbusrq_n;
	assign ziorge_n = host_master ? !fiorge_forq : 1'b1;
	
	assign fa = host_master ? za : 16'hZZZZ;
	assign frd_n = host_master ? zrd_n : 1'bZ;
	assign fwr_n = host_master ? zwr_n : 1'bZ;
	assign fmrq_n = host_master ? zmrq_n : 1'bZ;
	assign fiorq_n = host_master ? ziorq_n : 1'bZ;
	
	// 245 direction: 0 - FPGA -> ZX-BUS / 1 - ZX-BUS - > FPGA
	assign ddir = host_master ? zrd_n : !frd_n;
	
	// data on DB must appear earlier than fwr_n asserted
	assign doe_n = !(host_master ? 1'b1 : (!frd_n || fiorge_forq));


// Configuration ports

	// Control / Status - #E0AF
	// Data while configuring - #00..7FAF
	// 
	// Control:
	//	bit0: 1 - start configuring, 0 - break
	//	bit1: MSEL0: 0 - active conf from EPCS4 / 1 - passive conf from host
	//
	// Status:
	//	bit0: nSTATUS
	//	bit7: CONF_DONE
	
	wire conf_ports_hit = !ziorq_n && (za == 16'hE0AF);
	wire conf_ctrl_hit = conf_ports_hit && !zwr_n;
	wire conf_stat_hit = conf_ports_hit && !zrd_n;
	wire conf_data_hit = conf_in_progress && !ziorq_n && !zwr_n && !za[15] && (za[7:0] == 8'hAF);
	
	// make strobes for ports decoding
	reg [2:0] conf_data_hit_r;
	reg [2:0] conf_ctrl_hit_r;
	always @(posedge clk)
	begin
		conf_data_hit_r <= {conf_data_hit_r[1:0], conf_data_hit};
		conf_ctrl_hit_r <= {conf_ctrl_hit_r[1:0], conf_ctrl_hit};
	end
	
	wire conf_data_hit_s = conf_data_hit_r[1] && !conf_data_hit_r[2];
	wire conf_ctrl_hit_s = conf_ctrl_hit_r[1] && !conf_ctrl_hit_r[2];
	
	reg conf_in_progress;




endmodule
