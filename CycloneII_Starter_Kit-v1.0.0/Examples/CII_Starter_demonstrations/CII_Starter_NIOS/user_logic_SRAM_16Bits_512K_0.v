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



// turn off bogus verilog processor warnings 
// altera message_off 10034 10035 10036 10037 10230 

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on
module user_logic_SRAM_16Bits_512K_0 (
                                       // inputs:
                                        iADDR,
                                        iCE_N,
                                        iDATA,
                                        iLB_N,
                                        iOE_N,
                                        iRST_N,
                                        iUB_N,
                                        iWE_N,

                                       // outputs:
                                        SRAM_ADDR,
                                        SRAM_CE_N,
                                        SRAM_DQ,
                                        SRAM_LB_N,
                                        SRAM_OE_N,
                                        SRAM_UB_N,
                                        SRAM_WE_N,
                                        oDATA
                                     )
;

  output  [ 17: 0] SRAM_ADDR;
  output           SRAM_CE_N;
  inout   [ 15: 0] SRAM_DQ;
  output           SRAM_LB_N;
  output           SRAM_OE_N;
  output           SRAM_UB_N;
  output           SRAM_WE_N;
  output  [ 15: 0] oDATA;
  input   [ 17: 0] iADDR;
  input            iCE_N;
  input   [ 15: 0] iDATA;
  input            iLB_N;
  input            iOE_N;
  input            iRST_N;
  input            iUB_N;
  input            iWE_N;

  wire    [ 17: 0] SRAM_ADDR;
  wire             SRAM_CE_N;
  wire    [ 15: 0] SRAM_DQ;
  wire             SRAM_LB_N;
  wire             SRAM_OE_N;
  wire             SRAM_UB_N;
  wire             SRAM_WE_N;
  wire    [ 15: 0] oDATA;
  SRAM_16Bit_512K the_SRAM_16Bit_512K
    (
      .SRAM_ADDR (SRAM_ADDR),
      .SRAM_CE_N (SRAM_CE_N),
      .SRAM_DQ   (SRAM_DQ),
      .SRAM_LB_N (SRAM_LB_N),
      .SRAM_OE_N (SRAM_OE_N),
      .SRAM_UB_N (SRAM_UB_N),
      .SRAM_WE_N (SRAM_WE_N),
      .iADDR     (iADDR),
      .iCE_N     (iCE_N),
      .iDATA     (iDATA),
      .iLB_N     (iLB_N),
      .iOE_N     (iOE_N),
      .iRST_N    (iRST_N),
      .iUB_N     (iUB_N),
      .iWE_N     (iWE_N),
      .oDATA     (oDATA)
    );


endmodule

