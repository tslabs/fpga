module 	ports
(
	input wire clk,
	input wire [15:0] addr,
	input wire [7:0] data_in,
	output reg [7:0] data_out,
	input wire rnw,
	output wire port_en,
	input wire port_req,
	output wire port_stb,
	
	output wire covox_stb,
	output wire sdrv_stb,
	
	output reg [7:0] test
);
	
	localparam TESTR	= 8'h01;
	localparam TESTR2	= 8'h02;
	localparam TESTW	= 8'h80;
	localparam TESTW2	= 8'h81;
	
	assign port_en = rnw ? iord_en : iowr_en;
	assign port_stb = port_req;
	
	wire [7:0] loa = addr[7:0];
	wire [7:0] hia = addr[15:8];
	
// --- devices
	wire covox_en = (loa == 8'hFB);
	wire sdrv_en = (loa == 8'h0F) || (loa == 8'h1F) || (loa == 8'h4F) || (loa == 8'h5F);
	wire tsxb_en = (loa == 8'hAF);

	assign covox_stb = port_stb && covox_en;
	assign sdrv_stb  = port_stb && sdrv_en;
	
// --- write
	wire iowr_en = covox_en || sdrv_en || tsxb_en;
	
	always @*
		case (hia)
			TESTR:
				data_out = 8'hAA;

			TESTR2:
				data_out = 8'h55;
				
            default:
				data_out = 8'hFF;
            endcase

// --- read

	wire iord_en = tsxb_en && (
			hia == TESTR
		||	hia == TESTR2
		);
	
	always @(posedge clk)
		if (port_stb)
		begin
			if (hia == TESTW)
				test <= data_in;
		end
	
endmodule
