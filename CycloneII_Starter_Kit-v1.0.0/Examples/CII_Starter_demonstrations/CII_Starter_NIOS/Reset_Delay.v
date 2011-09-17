//Legal Notice: (C)2006 Altera Corporation. All rights reserved. Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

module	Reset_Delay(iRST,iCLK,oRESET);
input		iCLK;
input		iRST;
output reg	oRESET;
reg	[23:0]	Cont;

always@(posedge iCLK or negedge iRST)
begin
	if(!iRST)
	begin
		oRESET	<=	1'b0;
		Cont	<=	24'h0000000;
	end
	else
	begin
		if(Cont!=24'hFFFFFF)
		begin
			Cont	<=	Cont+1;
			oRESET	<=	1'b0;
		end
		else
		oRESET	<=	1'b1;
	end
end

endmodule