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

module SEG7_LUT_8 (	oSEG0,oSEG1,oSEG2,oSEG3,oSEG4,oSEG5,oSEG6,oSEG7,
					iDIG,iWR,iCLK,iRST_N );
input	[31:0]	iDIG;
input			iWR,iCLK,iRST_N;
output	[6:0]	oSEG0,oSEG1,oSEG2,oSEG3,oSEG4,oSEG5,oSEG6,oSEG7;
reg		[31:0]	rDIG;

always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	rDIG <= 0;
	else
	begin
		if(iWR)
		rDIG <= iDIG;
	end
end

SEG7_LUT	u0	(	oSEG0,rDIG[3:0]		);
SEG7_LUT	u1	(	oSEG1,rDIG[7:4]		);
SEG7_LUT	u2	(	oSEG2,rDIG[11:8]	);
SEG7_LUT	u3	(	oSEG3,rDIG[15:12]	);
SEG7_LUT	u4	(	oSEG4,rDIG[19:16]	);
SEG7_LUT	u5	(	oSEG5,rDIG[23:20]	);
SEG7_LUT	u6	(	oSEG6,rDIG[27:24]	);
SEG7_LUT	u7	(	oSEG7,rDIG[31:28]	);

endmodule