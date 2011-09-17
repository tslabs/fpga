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

module LEDG_Driver(LED,iCLK,iRST_N);
output	[7:0]	LED;
input			iCLK;
input			iRST_N;

reg		[20:0]	Cont;
reg		[7:0]	mLED;
reg				DIR;

always@(posedge iCLK)	Cont	<=	Cont+1'b1;

always@(posedge Cont[20] or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		mLED	<=	8'b00000111;
		DIR		<=	0;
	end
	else
	begin
		if(!DIR)
		mLED	<=	{mLED[6:0],mLED[7]};
		else
		mLED	<=	{mLED[0],mLED[7:1]};
		if(mLED == 8'b01110000)
		DIR	<=	1;
		else if(mLED == 8'b00001110)
		DIR	<=	0;
	end
end

assign	LED	=	mLED;

endmodule
