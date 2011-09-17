/////////////////////////////////////////////////////////////////////
////                                                             ////
////  Top Level Test Bench                                       ////
////                                                             ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/cores/vga_lcd/   ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2001 Rudolf Usselmann                         ////
////                    rudi@asics.ws                            ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: test_bench_top.v,v 1.4 2002-02-07 05:38:32 rherveille Exp $
//
//  $Date: 2002-02-07 05:38:32 $
//  $Revision: 1.4 $
//  $Author: rherveille $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//
//
//
//                        

`timescale 1ns / 10ps

module test;

reg		clk;
reg		rst;
wire		clk_v;

parameter	LINE_FIFO_AWIDTH = 7;

wire		int;
wire	[31:0]	wb_addr_o;
wire	[31:0]	wb_data_i;
wire	[31:0]	wb_data_o;
wire	[3:0]	wb_sel_o;
wire		wb_we_o;
wire		wb_stb_o;
wire		wb_cyc_o;
wire		wb_ack_i;
wire		wb_err_i;
wire	[31:0]	wb_addr_i;
wire	[31:0]	wbm_data_i;
wire	[3:0]	wb_sel_i;
wire		wb_we_i;
wire		wb_stb_i;
wire		wb_cyc_i;
wire		wb_ack_o;
wire		wb_err_o;
reg		pclk;
wire		hsync;
wire		vsync;
wire		csync;
wire		blanc;
wire	[7:0]	red;
wire	[7:0]	green;
wire	[7:0]	blue;

wire vga_stb_i;
wire clut_stb_i;

reg		scen;

// Test Bench Variables
integer		wd_cnt;
integer		error_cnt;

// Misc Variables
reg	[31:0]	data;
reg	[31:0]	pattern;
reg		int_warn;

integer		n;
integer		mode;
integer delay;

reg	[7:0]	thsync, thgdel;
reg	[15:0]	thgate, thlen;
reg	[7:0]	tvsync, tvgdel;
reg	[15:0]	tvgate, tvlen;
reg		hpol;
reg		vpol;
reg		cpol;
reg		bpol;
integer		p, l;
reg	[31:0]	pn;
reg	[31:0]	pra, paa, tmp;
reg	[23:0]	pd;
reg	[1:0]	cd;
reg		pc;
reg	[31:0]	vbase;
reg	[31:0]	cbase;
reg	[31:0]	vbara;
reg	[31:0]	vbarb;
reg	[7:0]	bank;

/////////////////////////////////////////////////////////////////////
//
// Defines 
//

`define	CTRL		32'h0000_0000
`define	STAT		32'h0000_0004
`define	HTIM		32'h0000_0008
`define	VTIM		32'h0000_000c
`define	HVLEN		32'h0000_0010
`define	VBARA		32'h0000_0014
`define	VBARB		32'h0000_0018

`define USE_VC		1

parameter	PCLK_C = 15;

/////////////////////////////////////////////////////////////////////
//
// Simulation Initialization and Start up Section
//

initial
   begin
	$timeformat (-9, 1, " ns", 12);
	$display("\n\n");
	$display("******************************************************");
	$display("* WISHBONE VGA/LCD Controller Simulation started ... *");
	$display("******************************************************");
	$display("\n");
`ifdef WAVES
  	$shm_open("waves");
	$shm_probe("AS",test,"AS");
	$display("INFO: Signal dump enabled ...\n\n");
`endif
	scen = 0;
	error_cnt = 0;
   	clk = 0;
	pclk = 0;
   	rst = 0;
	int_warn=1;

   	repeat(20)	@(posedge clk);
   	rst = 1;
   	repeat(20)	@(posedge clk);

	// HERE IS WHERE THE TEST CASES GO ...

if(0)	// Full Regression Run
   begin

   end
else
if(1)	// Quick Regression Run
   begin
	//reg_test;
	//tim_test;

	delay = 2;
	for(delay = 0; delay < 3; delay = delay +1)
	begin
		$display("Setting wishbone slave delay to %d", delay);
		s0.delay = delay;
		//pd1_test;
		pd2_test;
	end

	//ur_test;
   end
else
   begin

	//
	// TEST DEVELOPMENT AREA
	//
$display("\n\n");
$display("*****************************************************");
$display("*** XXX Test                                 ***");
$display("*****************************************************\n");

	s0.fill_mem(1);

   	repeat(10)	@(posedge clk);

	vbara = 32'h0000_0000;
	vbarb = 32'h0001_0000;

	m0.wb_wr1( `VBARA, 4'hf, vbara );
	m0.wb_wr1( `VBARB, 4'hf, vbarb );

	thsync = 0;
	thgdel = 0;
	thgate = 340;
	thlen = 345;

	tvsync = 0;
	tvgdel = 0;
	tvgate = 240;
	tvlen = 245;

/*
	thsync = 0;
	thgdel = 0;
	thgate = 63;
	thlen = 70;

	tvsync = 0;
	tvgdel = 0;
	tvgate = 32;
	tvlen = 36;
*/

	hpol = 0;
	vpol = 0;
	cpol = 0;
	bpol = 0;

	m0.wb_wr1( `HTIM,  4'hf, {thsync, thgdel, thgate} );
	m0.wb_wr1( `VTIM,  4'hf, {tvsync, tvgdel, tvgate} );
	m0.wb_wr1( `HVLEN, 4'hf, {thlen, tvlen} );

mode = 2;

//for(mode=0;mode<1;mode=mode+1)
for(bank=0;bank<3;bank=bank + 1)
   begin
	case(mode)
	   0:
	     begin
		cd = 2'h2;
		pc = 1'b0;
	     end
	   1:
	     begin
		cd = 2'h0;
		pc = 1'b0;
	     end
	   2:
	     begin
		cd = 2'h0;
		pc = 1'b1;
	     end
	   3:
	     begin
		cd = 2'h1;
		pc = 1'b0;
	     end
	endcase

	m0.wb_wr1( `CTRL,  4'hf, {
				16'h0,	// Reserved
				bpol, cpol,
				vpol, hpol,
				pc,	// 1'b0,	// PC
				cd,	// 2'h2,	// CD
				2'h0,	// VBL
				1'b0,	// Reserved
				1'b1,	// CBSWE
				1'b1,	// VBSWE
				1'b0,	// BSIE
				1'b0,	// HIE
				1'b0,	// VIE
				1'b1	// Video Enable
				});

	$display("Mode: %0d Screen: %0d", mode, bank);
	//repeat(2) @(posedge vsync);
	@(posedge vsync);

	// For Each Line
	for(l=0;l<tvgate+1;l=l+1)
	// For each Pixel
	for(p=0;p<thgate+1;p=p+1)
	   begin
		while(blanc)	@(posedge pclk);  // wait for viewable data

		//$display("pixel=%0d, line=%0d, (%0t)",p,l,$time);

		if(bank[0])	vbase = vbarb[31:2];
		else		vbase = vbara[31:2];
		if(bank[0])	cbase = 32'h0000_0c00;
		else		cbase = 32'h0000_0800;

		// Depending on Mode, determine pixel data
		// pixel number = line * (thgate + 1) + p
		pn = l * (thgate + 1) + p;

		case(mode)
		   0:	// 24 bit/pixel mode
		   begin
			pra = pn[31:2] * 3;	// Pixel relative Address
			paa = pra + vbase;		// Pixel Absolute Address

			// Pixel Data
			case(pn[1:0])
			   0:
			     begin
				tmp = s0.mem[paa];
				pd = tmp[31:8];
			     end
			   1:
			     begin
				tmp = s0.mem[paa];
				pd[23:16] = tmp[7:0];
				tmp = s0.mem[paa+1];
				pd[15:0] = tmp[31:16];
			     end
			   2:
			     begin
				tmp = s0.mem[paa+1];
				pd[23:8] = tmp[15:0];
				tmp = s0.mem[paa+2];
				pd[7:0] = tmp[31:24];
			     end
			   3:
			     begin
				tmp = s0.mem[paa+2];
				pd = tmp[23:0];
			     end
			endcase
		   end

		   1:	// 8 bit/pixel grayscale mode
		   begin
			pra = pn[31:2];		// Pixel relative Address
			paa = pra + vbase;	// Pixel Absolute Address
			case(pn[1:0])
			   0:
			     begin
				tmp = s0.mem[paa];
				pd = { tmp[31:24], tmp[31:24], tmp[31:24] };
			     end
			   1:
			     begin
				tmp = s0.mem[paa];
				pd = { tmp[23:16], tmp[23:16], tmp[23:16] };
			     end
			   2:
			     begin
				tmp = s0.mem[paa];
				pd = { tmp[15:8], tmp[15:8], tmp[15:8] };
			     end
			   3:
			     begin
				tmp = s0.mem[paa];
				pd = { tmp[7:0], tmp[7:0], tmp[7:0] };
			     end
			endcase
		   end

		   2:	// 8 bit/pixel Pseudo Color mode
		   begin
			pra = pn[31:2];		// Pixel relative Address
			paa = pra + vbase;	// Pixel Absolute Address
			case(pn[1:0])
			   0:
			     begin
				tmp = s0.mem[paa];
				tmp = s0.mem[cbase[31:2] + tmp[31:24]];
				pd = tmp[23:0];
			     end
			   1:
			     begin
				tmp = s0.mem[paa];
				tmp = s0.mem[cbase[31:2] + tmp[23:16]];
				pd = tmp[23:0];
			     end
			   2:
			     begin
				tmp = s0.mem[paa];
				tmp = s0.mem[cbase[31:2] + tmp[15:8]];
				pd = tmp[23:0];
			     end
			   3:
			     begin
				tmp = s0.mem[paa];
				tmp = s0.mem[cbase[31:2] + tmp[7:0]];
				pd = tmp[23:0];
			     end
			endcase
		   end

		   3:	// 16 bit/pixel mode
		   begin
			pra = pn[31:1];		// Pixel relative Address
			paa = pra + vbase;	// Pixel Absolute Address
			case(pn[0])
			   0:
			     begin
				tmp = s0.mem[paa];
				tmp[15:0] = tmp[31:16];
				pd = {tmp[15:11], 3'h0, tmp[10:5], 2'h0, tmp[4:0], 3'h0};
			     end
			   1:
			     begin
				tmp = s0.mem[paa];
				pd = {tmp[15:11], 3'h0, tmp[10:5], 2'h0, tmp[4:0], 3'h0};
			     end
			endcase
		   end

		endcase

		if(pd !== {red, green, blue} )
		   begin
			$display("ERROR: Pixel Data Mismatch: Expected: %h, Got: %h %h %h",
				pd, red, green, blue);
			$display("       pixel=%0d, line=%0d, (%0t)",p,l,$time);
			error_cnt = error_cnt + 1;
		   end

		@(posedge pclk);

	   end	
   end

show_errors;
$display("*****************************************************");
$display("*** Test DONE ...                                 ***");
$display("*****************************************************\n\n");


   end

   	repeat(10)	@(posedge clk);
   	$finish;
   end

/////////////////////////////////////////////////////////////////////
//
// Sync Monitor
//

sync_check #(PCLK_C) uceck(
		.pclk(		pclk		),
		.rst(		rst		),
		.enable(	scen		),
		.hsync(		hsync		),
		.vsync(		vsync		),
		.csync(		csync		),
		.blanc(		blanc		),
		.hpol(		hpol		),
		.vpol(		vpol		),
		.cpol(		cpol		),
		.bpol(		bpol		),
		.thsync(	thsync		),
		.thgdel(	thgdel		),
		.thgate(	thgate		),
		.thlen(		thlen		),
		.tvsync(	tvsync		),
		.tvgdel(	tvgdel		),
		.tvgate(	tvgate		),
		.tvlen(		tvlen		) );

/////////////////////////////////////////////////////////////////////
//
// Video Data Monitor
//

/////////////////////////////////////////////////////////////////////
//
// Watchdog Counter
//

always @(posedge clk)
	if(wb_cyc_i | wb_cyc_o | wb_ack_i | wb_ack_o | hsync)	wd_cnt <= #1 0;
	else						wd_cnt <= #1 wd_cnt + 1;


always @(wd_cnt)
	if(wd_cnt>9000)
	   begin
		$display("\n\n*************************************\n");
		$display("ERROR: Watch Dog Counter Expired\n");
		$display("*************************************\n\n\n");
		$finish;
	   end


always @(posedge int)
  if(int_warn)
   begin
	$display("\n\n*************************************\n");
	$display("WARNING: Recieved Interrupt (%0t)", $time);
	$display("*************************************\n\n\n");
   end

always #2.5		clk = ~clk;
always #(PCLK_C/2)	pclk = ~pclk;

assign clk_v = clk;

/////////////////////////////////////////////////////////////////////
//
// WISHBONE DMA IP Core
//


// Module Prototype

`ifdef USE_VC
vga_enh_top #(1'b0, LINE_FIFO_AWIDTH) u0 (
		.wb_clk_i(		clk		),
		.wb_rst_i(		1'b0 ),
		.rst_i(		rst		),
		.wb_inta_o(		int		),

		//-- slave signals
		.wbs_adr_i(		wb_addr_i[11:0]	),
		.wbs_dat_i(		wb_data_i	),
		.wbs_dat_o(		wb_data_o	),
		.wbs_sel_i(		wb_sel_i	),
		.wbs_we_i(		wb_we_i		),
		.wbs_stb_i(		wb_stb_i	),
		.wbs_cyc_i(		wb_cyc_i	),
		.wbs_ack_o(		wb_ack_o	),
		.wbs_err_o(		wb_err_o	),

		//-- master signals
		.wbm_adr_o(		wb_addr_o[31:0]	),
		.wbm_dat_i(		wbm_data_i	),
		.wbm_sel_o(		wb_sel_o	),
		.wbm_we_o(		wb_we_o		),
		.wbm_stb_o(		wb_stb_o	),
		.wbm_cyc_o(		wb_cyc_o	),
		.wbm_cab_o(				),
		.wbm_ack_i(		wb_ack_i	),
		.wbm_err_i(		wb_err_i	),

		//-- VGA signals
		.clk_p_i(		pclk		),
		.hsync_pad_o(	hsync		),
		.vsync_pad_o(	vsync		),
		.csync_pad_o(	csync		),
		.blank_pad_o(	blanc		),
		.r_pad_o(		red		),
		.g_pad_o(		green		),
		.b_pad_o(		blue		)
	);

`else

VGA u0 (	.CLK_I(	clk_v		),
		.RST_I(		~rst		),
		.NRESET(	rst		),
		.INTA_O(	int		),

		//-- slave signals
		.ADR_I(		wb_addr_i[4:2]	),
		.SDAT_I(	wb_data_i	),
		.SDAT_O(	wb_data_o	),
		.SEL_I(		wb_sel_i	),
		.WE_I(		wb_we_i		),
		.STB_I(		wb_stb_i	),
		.CYC_I(		wb_cyc_i	),
		.ACK_O(		wb_ack_o	),
		.ERR_O(		wb_err_o	),

		//-- master signals
		.ADR_O(		wb_addr_o[31:2]	),
		.MDAT_I(	wbm_data_i	),
		.SEL_O(		wb_sel_o	),
		.WE_O(		wb_we_o		),
		.STB_O(		wb_stb_o	),
		.CYC_O(		wb_cyc_o	),
		.CAB_O(				),
		.ACK_I(		wb_ack_i	),
		.ERR_I(		wb_err_i	),

		//-- VGA signals
		.PCLK(		pclk		),
		.HSYNC(		hsync		),
		.VSYNC(		vsync		),
		.CSYNC(		csync		),
		.BLANK(		blanc		),
		.R(		red		),
		.G(		green		),
		.B(		blue		)
	);

`endif

wb_mast	m0(	.clk(		clk		),
		.rst(		rst		),
		.adr(		wb_addr_i	),
		.din(		wb_data_o	),
		.dout(		wb_data_i	),
		.cyc(		wb_cyc_i	),
		.stb(		wb_stb_i	),
		.sel(		wb_sel_i	),
		.we(		wb_we_i		),
		.ack(		wb_ack_o	),
		.err(		wb_err_o	),
		.rty(		1'b0		)
		);

wb_slv #(24) s0(.clk(		clk		),
		.rst(		rst		),
		.adr(		{1'b0, wb_addr_o[30:0]}	),
		.din(		32'h0		),
		.dout(		wbm_data_i	),
		.cyc(		wb_cyc_o	),
		.stb(		wb_stb_o	),
		.sel(		wb_sel_o	),
		.we(		wb_we_o		),
		.ack(		wb_ack_i	),
		.err(		wb_err_i	),
		.rty(				)
		);

`include "tests.v"

endmodule

/*
module vdata_mon(clk, rst, hsync, vsync, blank, pixel, line);
input		clk, rst;
input		hsync, vsync, blank;
output	[31:0]	pixel, line;

reg	[31:0]	pixel, line;

always @(negedge blank)
	line = line + 1;

always @(posedge vsync or negedge rst)
	line = -1;

always @(posedge clk)
	if(!blank)	pixel = pixel + 1;
	else		pixel = 0;

endmodule
*/
































































