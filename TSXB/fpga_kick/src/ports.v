module 	ports
(
	input wire [15:0] addr,
	output reg [7:0] data_out,
	input wire rnw,
	output wire port_en,
	input wire port_req,
	output wire port_stb,

	input wire [7:0] epcs_data,
	
	output wire covox_stb,
	output wire sdrv_stb,
	output wire ectrl_stb,
	output wire edata_stb,
	output wire srpage_stb
);

	assign port_en = rnw ? iord_en : iowr_en;
	assign port_stb = port_req;

	wire [7:0] loa = addr[7:0];
	wire [7:0] hia = addr[15:8];

// --- devices
	localparam SRPAGE	= 8'h81;
	localparam ECTRL	= 8'hF0;
	localparam EDATA	= 8'hF1;

	wire covox_en  = (loa == 8'hFB);
	wire sdrv_en   = (loa == 8'h0F) || (loa == 8'h1F) || (loa == 8'h4F) || (loa == 8'h5F);
	wire tsxb_en   = (loa == 8'hAF);
	wire ectrl_en  = tsxb_en && (hia == ECTRL);
	wire edata_en  = tsxb_en && (hia == EDATA);
	wire srpage_en = tsxb_en && (hia == SRPAGE);

	assign covox_stb  = port_req && covox_en;
	assign sdrv_stb   = port_req && sdrv_en;
	assign ectrl_stb  = port_req && ectrl_en;
	assign edata_stb  = port_req && edata_en;
	assign srpage_stb = port_req && srpage_en;

	wire iowr_en = covox_en || sdrv_en || ectrl_en || edata_en || srpage_en;
	wire iord_en = edata_en;

	always @*
		case (hia)
			EDATA:
				data_out = epcs_data;
			default:
				data_out = 8'hFF;
		endcase

endmodule
