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

module bar_big(
input [11:0]x,
input [11:0]y,

input [11:0]org_x,
input [11:0]org_y,
input [11:0]line_x,
input [11:0]line_y,
output bar_space
);

assign bar_space=(
(x>=org_x) && (x<=(org_x+line_x)) &&
(y>=org_y) && (y<=(org_y+line_y)) 
)?1:0;


endmodule