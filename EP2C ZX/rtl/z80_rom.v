
module z80_rom
(
	input wire [15:0] a,
	output reg [7:0] d
);

// ROM
	always @*
		case (a)
			16'h0000:	d = 8'hF3;
			16'h0001:	d = 8'h01;
			16'h0002:	d = 8'hAA;
			16'h0003:	d = 8'h55;
			16'h0004:	d = 8'h3E;
			16'h0005:	d = 8'h0F;
			16'h0006:	d = 8'hED;
			16'h0007:	d = 8'h79;
			16'h0008:	d = 8'h21;
			16'h0009:	d = 8'h00;
			16'h000A:	d = 8'h00;
			16'h000B:	d = 8'h11;
			16'h000C:	d = 8'h80;
			16'h000D:	d = 8'h00;
			16'h000E:	d = 8'h01;
			16'h000F:	d = 8'h10;
			16'h0010:	d = 8'h00;
			16'h0011:	d = 8'hED;
			16'h0012:	d = 8'hB0;
			16'h0013:	d = 8'h06;
			16'h0014:	d = 8'h10;
			16'h0015:	d = 8'hD3;
			16'h0016:	d = 8'hFE;
			16'h0017:	d = 8'h3C;
			16'h0018:	d = 8'h10;
			16'h0019:	d = 8'hFB;
			16'h001A:	d = 8'h00;
			16'h001B:	d = 8'h00;
			16'h001C:	d = 8'h00;
			16'h001D:	d = 8'h00;
			16'h001E:	d = 8'h18;
			16'h001F:	d = 8'hFE;
			default:	d = 8'hFF;
		endcase

endmodule
