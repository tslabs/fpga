
module hex	(
input	        	clk,
input	        	en,
input	    [3:0]	val,
input	    [1:0]	dig,
output reg	[27:0]	seg
);


always @(posedge clk)
    if (en)
    case(dig)
    2'h0: seg[ 6: 0] <= led;
    2'h1: seg[13: 7] <= led;
    2'h2: seg[20:14] <= led;
    2'h3: seg[27:21] <= led;
    endcase


reg [6:0]   led;

always @*
	case(val)
	4'h0: led = 7'b1000000;
	4'h1: led = 7'b1111001;	
	4'h2: led = 7'b0100100; 
	4'h3: led = 7'b0110000; 
	4'h4: led = 7'b0011001; 
	4'h5: led = 7'b0010010; 
	4'h6: led = 7'b0000010; 
	4'h7: led = 7'b1111000; 
	4'h8: led = 7'b0000000; 
	4'h9: led = 7'b0010000; 
	4'hA: led = 7'b0001000;
	4'hB: led = 7'b0000011;
	4'hC: led = 7'b1000110;
	4'hD: led = 7'b0100001;
	4'hE: led = 7'b0000110;
	4'hF: led = 7'b0001110;
	endcase


endmodule
