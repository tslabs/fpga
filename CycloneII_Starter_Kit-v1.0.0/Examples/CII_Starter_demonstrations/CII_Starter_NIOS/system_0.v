//megafunction wizard: %Altera SOPC Builder%
//GENERATION: STANDARD
//VERSION: WM1.0


//Legal Notice: (C)2006 Altera Corporation. All rights reserved.  Your
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

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module KEY_s1_arbitrator (
                           // inputs:
                            KEY_s1_irq,
                            KEY_s1_readdata,
                            clk,
                            cpu_0_data_master_address_to_slave,
                            cpu_0_data_master_read,
                            cpu_0_data_master_waitrequest,
                            cpu_0_data_master_write,
                            cpu_0_data_master_writedata,
                            reset_n,

                           // outputs:
                            KEY_s1_address,
                            KEY_s1_chipselect,
                            KEY_s1_irq_from_sa,
                            KEY_s1_readdata_from_sa,
                            KEY_s1_reset_n,
                            KEY_s1_write_n,
                            KEY_s1_writedata,
                            cpu_0_data_master_granted_KEY_s1,
                            cpu_0_data_master_qualified_request_KEY_s1,
                            cpu_0_data_master_read_data_valid_KEY_s1,
                            cpu_0_data_master_requests_KEY_s1,
                            d1_KEY_s1_end_xfer
                         )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] KEY_s1_address;
  output           KEY_s1_chipselect;
  output           KEY_s1_irq_from_sa;
  output  [  3: 0] KEY_s1_readdata_from_sa;
  output           KEY_s1_reset_n;
  output           KEY_s1_write_n;
  output  [  3: 0] KEY_s1_writedata;
  output           cpu_0_data_master_granted_KEY_s1;
  output           cpu_0_data_master_qualified_request_KEY_s1;
  output           cpu_0_data_master_read_data_valid_KEY_s1;
  output           cpu_0_data_master_requests_KEY_s1;
  output           d1_KEY_s1_end_xfer;
  input            KEY_s1_irq;
  input   [  3: 0] KEY_s1_readdata;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;

  wire    [  1: 0] KEY_s1_address;
  wire             KEY_s1_allgrants;
  wire             KEY_s1_allow_new_arb_cycle;
  wire             KEY_s1_any_continuerequest;
  wire             KEY_s1_arb_counter_enable;
  reg     [  2: 0] KEY_s1_arb_share_counter;
  wire    [  2: 0] KEY_s1_arb_share_counter_next_value;
  wire    [  2: 0] KEY_s1_arb_share_set_values;
  wire             KEY_s1_beginbursttransfer_internal;
  wire             KEY_s1_begins_xfer;
  wire             KEY_s1_chipselect;
  wire             KEY_s1_end_xfer;
  wire             KEY_s1_firsttransfer;
  wire             KEY_s1_grant_vector;
  wire             KEY_s1_in_a_read_cycle;
  wire             KEY_s1_in_a_write_cycle;
  wire             KEY_s1_irq_from_sa;
  wire             KEY_s1_master_qreq_vector;
  wire             KEY_s1_non_bursting_master_requests;
  wire    [  3: 0] KEY_s1_readdata_from_sa;
  wire             KEY_s1_reset_n;
  reg              KEY_s1_slavearbiterlockenable;
  wire             KEY_s1_slavearbiterlockenable2;
  wire             KEY_s1_waits_for_read;
  wire             KEY_s1_waits_for_write;
  wire             KEY_s1_write_n;
  wire    [  3: 0] KEY_s1_writedata;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_KEY_s1;
  wire             cpu_0_data_master_qualified_request_KEY_s1;
  wire             cpu_0_data_master_read_data_valid_KEY_s1;
  wire             cpu_0_data_master_requests_KEY_s1;
  wire             cpu_0_data_master_saved_grant_KEY_s1;
  reg              d1_KEY_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             wait_for_KEY_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~KEY_s1_end_xfer;
    end


  assign KEY_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_KEY_s1));
  //assign KEY_s1_readdata_from_sa = KEY_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign KEY_s1_readdata_from_sa = KEY_s1_readdata;

  assign cpu_0_data_master_requests_KEY_s1 = ({cpu_0_data_master_address_to_slave[23 : 4] , 4'b0} == 24'h481040) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //KEY_s1_arb_share_counter set values, which is an e_mux
  assign KEY_s1_arb_share_set_values = 1;

  //KEY_s1_non_bursting_master_requests mux, which is an e_mux
  assign KEY_s1_non_bursting_master_requests = cpu_0_data_master_requests_KEY_s1;

  //KEY_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign KEY_s1_arb_share_counter_next_value = KEY_s1_firsttransfer ? (KEY_s1_arb_share_set_values - 1) : |KEY_s1_arb_share_counter ? (KEY_s1_arb_share_counter - 1) : 0;

  //KEY_s1_allgrants all slave grants, which is an e_mux
  assign KEY_s1_allgrants = |KEY_s1_grant_vector;

  //KEY_s1_end_xfer assignment, which is an e_assign
  assign KEY_s1_end_xfer = ~(KEY_s1_waits_for_read | KEY_s1_waits_for_write);

  //KEY_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign KEY_s1_arb_counter_enable = (KEY_s1_end_xfer & KEY_s1_allgrants) | (KEY_s1_end_xfer & ~KEY_s1_non_bursting_master_requests);

  //KEY_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          KEY_s1_arb_share_counter <= 0;
      else if (KEY_s1_arb_counter_enable)
          KEY_s1_arb_share_counter <= KEY_s1_arb_share_counter_next_value;
    end


  //KEY_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          KEY_s1_slavearbiterlockenable <= 0;
      else if ((|KEY_s1_master_qreq_vector & KEY_s1_end_xfer) | (KEY_s1_end_xfer & ~KEY_s1_non_bursting_master_requests))
          KEY_s1_slavearbiterlockenable <= |KEY_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master KEY/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = KEY_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //KEY_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign KEY_s1_slavearbiterlockenable2 = |KEY_s1_arb_share_counter_next_value;

  //cpu_0/data_master KEY/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = KEY_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //KEY_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign KEY_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_KEY_s1 = cpu_0_data_master_requests_KEY_s1 & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //KEY_s1_writedata mux, which is an e_mux
  assign KEY_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_KEY_s1 = cpu_0_data_master_qualified_request_KEY_s1;

  //cpu_0/data_master saved-grant KEY/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_KEY_s1 = cpu_0_data_master_requests_KEY_s1;

  //allow new arb cycle for KEY/s1, which is an e_assign
  assign KEY_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign KEY_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign KEY_s1_master_qreq_vector = 1;

  //KEY_s1_reset_n assignment, which is an e_assign
  assign KEY_s1_reset_n = reset_n;

  assign KEY_s1_chipselect = cpu_0_data_master_granted_KEY_s1;
  //KEY_s1_firsttransfer first transaction, which is an e_assign
  assign KEY_s1_firsttransfer = ~(KEY_s1_slavearbiterlockenable & KEY_s1_any_continuerequest);

  //KEY_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign KEY_s1_beginbursttransfer_internal = KEY_s1_begins_xfer & KEY_s1_firsttransfer;

  //~KEY_s1_write_n assignment, which is an e_mux
  assign KEY_s1_write_n = ~(cpu_0_data_master_granted_KEY_s1 & cpu_0_data_master_write);

  //KEY_s1_address mux, which is an e_mux
  assign KEY_s1_address = cpu_0_data_master_address_to_slave >> 2;

  //d1_KEY_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_KEY_s1_end_xfer <= 1;
      else if (1)
          d1_KEY_s1_end_xfer <= KEY_s1_end_xfer;
    end


  //KEY_s1_waits_for_read in a cycle, which is an e_mux
  assign KEY_s1_waits_for_read = KEY_s1_in_a_read_cycle & KEY_s1_begins_xfer;

  //KEY_s1_in_a_read_cycle assignment, which is an e_assign
  assign KEY_s1_in_a_read_cycle = cpu_0_data_master_granted_KEY_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = KEY_s1_in_a_read_cycle;

  //KEY_s1_waits_for_write in a cycle, which is an e_mux
  assign KEY_s1_waits_for_write = KEY_s1_in_a_write_cycle & 0;

  //KEY_s1_in_a_write_cycle assignment, which is an e_assign
  assign KEY_s1_in_a_write_cycle = cpu_0_data_master_granted_KEY_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = KEY_s1_in_a_write_cycle;

  assign wait_for_KEY_s1_counter = 0;
  //assign KEY_s1_irq_from_sa = KEY_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign KEY_s1_irq_from_sa = KEY_s1_irq;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module LEDG_s1_arbitrator (
                            // inputs:
                             clk,
                             cpu_0_data_master_address_to_slave,
                             cpu_0_data_master_byteenable,
                             cpu_0_data_master_read,
                             cpu_0_data_master_waitrequest,
                             cpu_0_data_master_write,
                             cpu_0_data_master_writedata,
                             reset_n,

                            // outputs:
                             LEDG_s1_address,
                             LEDG_s1_chipselect,
                             LEDG_s1_reset_n,
                             LEDG_s1_write_n,
                             LEDG_s1_writedata,
                             cpu_0_data_master_granted_LEDG_s1,
                             cpu_0_data_master_qualified_request_LEDG_s1,
                             cpu_0_data_master_read_data_valid_LEDG_s1,
                             cpu_0_data_master_requests_LEDG_s1,
                             d1_LEDG_s1_end_xfer
                          )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] LEDG_s1_address;
  output           LEDG_s1_chipselect;
  output           LEDG_s1_reset_n;
  output           LEDG_s1_write_n;
  output  [  7: 0] LEDG_s1_writedata;
  output           cpu_0_data_master_granted_LEDG_s1;
  output           cpu_0_data_master_qualified_request_LEDG_s1;
  output           cpu_0_data_master_read_data_valid_LEDG_s1;
  output           cpu_0_data_master_requests_LEDG_s1;
  output           d1_LEDG_s1_end_xfer;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;

  wire    [  1: 0] LEDG_s1_address;
  wire             LEDG_s1_allgrants;
  wire             LEDG_s1_allow_new_arb_cycle;
  wire             LEDG_s1_any_continuerequest;
  wire             LEDG_s1_arb_counter_enable;
  reg     [  2: 0] LEDG_s1_arb_share_counter;
  wire    [  2: 0] LEDG_s1_arb_share_counter_next_value;
  wire    [  2: 0] LEDG_s1_arb_share_set_values;
  wire             LEDG_s1_beginbursttransfer_internal;
  wire             LEDG_s1_begins_xfer;
  wire             LEDG_s1_chipselect;
  wire             LEDG_s1_end_xfer;
  wire             LEDG_s1_firsttransfer;
  wire             LEDG_s1_grant_vector;
  wire             LEDG_s1_in_a_read_cycle;
  wire             LEDG_s1_in_a_write_cycle;
  wire             LEDG_s1_master_qreq_vector;
  wire             LEDG_s1_non_bursting_master_requests;
  wire             LEDG_s1_pretend_byte_enable;
  wire             LEDG_s1_reset_n;
  reg              LEDG_s1_slavearbiterlockenable;
  wire             LEDG_s1_slavearbiterlockenable2;
  wire             LEDG_s1_waits_for_read;
  wire             LEDG_s1_waits_for_write;
  wire             LEDG_s1_write_n;
  wire    [  7: 0] LEDG_s1_writedata;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_LEDG_s1;
  wire             cpu_0_data_master_qualified_request_LEDG_s1;
  wire             cpu_0_data_master_read_data_valid_LEDG_s1;
  wire             cpu_0_data_master_requests_LEDG_s1;
  wire             cpu_0_data_master_saved_grant_LEDG_s1;
  reg              d1_LEDG_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             wait_for_LEDG_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~LEDG_s1_end_xfer;
    end


  assign LEDG_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_LEDG_s1));
  assign cpu_0_data_master_requests_LEDG_s1 = (({cpu_0_data_master_address_to_slave[23 : 4] , 4'b0} == 24'h481020) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_write;
  //LEDG_s1_arb_share_counter set values, which is an e_mux
  assign LEDG_s1_arb_share_set_values = 1;

  //LEDG_s1_non_bursting_master_requests mux, which is an e_mux
  assign LEDG_s1_non_bursting_master_requests = cpu_0_data_master_requests_LEDG_s1;

  //LEDG_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign LEDG_s1_arb_share_counter_next_value = LEDG_s1_firsttransfer ? (LEDG_s1_arb_share_set_values - 1) : |LEDG_s1_arb_share_counter ? (LEDG_s1_arb_share_counter - 1) : 0;

  //LEDG_s1_allgrants all slave grants, which is an e_mux
  assign LEDG_s1_allgrants = |LEDG_s1_grant_vector;

  //LEDG_s1_end_xfer assignment, which is an e_assign
  assign LEDG_s1_end_xfer = ~(LEDG_s1_waits_for_read | LEDG_s1_waits_for_write);

  //LEDG_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign LEDG_s1_arb_counter_enable = (LEDG_s1_end_xfer & LEDG_s1_allgrants) | (LEDG_s1_end_xfer & ~LEDG_s1_non_bursting_master_requests);

  //LEDG_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          LEDG_s1_arb_share_counter <= 0;
      else if (LEDG_s1_arb_counter_enable)
          LEDG_s1_arb_share_counter <= LEDG_s1_arb_share_counter_next_value;
    end


  //LEDG_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          LEDG_s1_slavearbiterlockenable <= 0;
      else if ((|LEDG_s1_master_qreq_vector & LEDG_s1_end_xfer) | (LEDG_s1_end_xfer & ~LEDG_s1_non_bursting_master_requests))
          LEDG_s1_slavearbiterlockenable <= |LEDG_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master LEDG/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = LEDG_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //LEDG_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign LEDG_s1_slavearbiterlockenable2 = |LEDG_s1_arb_share_counter_next_value;

  //cpu_0/data_master LEDG/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = LEDG_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //LEDG_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign LEDG_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_LEDG_s1 = cpu_0_data_master_requests_LEDG_s1 & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //LEDG_s1_writedata mux, which is an e_mux
  assign LEDG_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_LEDG_s1 = cpu_0_data_master_qualified_request_LEDG_s1;

  //cpu_0/data_master saved-grant LEDG/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_LEDG_s1 = cpu_0_data_master_requests_LEDG_s1;

  //allow new arb cycle for LEDG/s1, which is an e_assign
  assign LEDG_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign LEDG_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign LEDG_s1_master_qreq_vector = 1;

  //LEDG_s1_reset_n assignment, which is an e_assign
  assign LEDG_s1_reset_n = reset_n;

  assign LEDG_s1_chipselect = cpu_0_data_master_granted_LEDG_s1;
  //LEDG_s1_firsttransfer first transaction, which is an e_assign
  assign LEDG_s1_firsttransfer = ~(LEDG_s1_slavearbiterlockenable & LEDG_s1_any_continuerequest);

  //LEDG_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign LEDG_s1_beginbursttransfer_internal = LEDG_s1_begins_xfer & LEDG_s1_firsttransfer;

  //~LEDG_s1_write_n assignment, which is an e_mux
  assign LEDG_s1_write_n = ~(((cpu_0_data_master_granted_LEDG_s1 & cpu_0_data_master_write)) & LEDG_s1_pretend_byte_enable);

  //LEDG_s1_address mux, which is an e_mux
  assign LEDG_s1_address = cpu_0_data_master_address_to_slave >> 2;

  //d1_LEDG_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_LEDG_s1_end_xfer <= 1;
      else if (1)
          d1_LEDG_s1_end_xfer <= LEDG_s1_end_xfer;
    end


  //LEDG_s1_waits_for_read in a cycle, which is an e_mux
  assign LEDG_s1_waits_for_read = LEDG_s1_in_a_read_cycle & LEDG_s1_begins_xfer;

  //LEDG_s1_in_a_read_cycle assignment, which is an e_assign
  assign LEDG_s1_in_a_read_cycle = cpu_0_data_master_granted_LEDG_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = LEDG_s1_in_a_read_cycle;

  //LEDG_s1_waits_for_write in a cycle, which is an e_mux
  assign LEDG_s1_waits_for_write = LEDG_s1_in_a_write_cycle & 0;

  //LEDG_s1_in_a_write_cycle assignment, which is an e_assign
  assign LEDG_s1_in_a_write_cycle = cpu_0_data_master_granted_LEDG_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = LEDG_s1_in_a_write_cycle;

  assign wait_for_LEDG_s1_counter = 0;
  //LEDG_s1_pretend_byte_enable byte enable port mux, which is an e_mux
  assign LEDG_s1_pretend_byte_enable = (cpu_0_data_master_granted_LEDG_s1)? cpu_0_data_master_byteenable :
    -1;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module LEDR_s1_arbitrator (
                            // inputs:
                             clk,
                             cpu_0_data_master_address_to_slave,
                             cpu_0_data_master_read,
                             cpu_0_data_master_waitrequest,
                             cpu_0_data_master_write,
                             cpu_0_data_master_writedata,
                             reset_n,

                            // outputs:
                             LEDR_s1_address,
                             LEDR_s1_chipselect,
                             LEDR_s1_reset_n,
                             LEDR_s1_write_n,
                             LEDR_s1_writedata,
                             cpu_0_data_master_granted_LEDR_s1,
                             cpu_0_data_master_qualified_request_LEDR_s1,
                             cpu_0_data_master_read_data_valid_LEDR_s1,
                             cpu_0_data_master_requests_LEDR_s1,
                             d1_LEDR_s1_end_xfer
                          )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] LEDR_s1_address;
  output           LEDR_s1_chipselect;
  output           LEDR_s1_reset_n;
  output           LEDR_s1_write_n;
  output  [  9: 0] LEDR_s1_writedata;
  output           cpu_0_data_master_granted_LEDR_s1;
  output           cpu_0_data_master_qualified_request_LEDR_s1;
  output           cpu_0_data_master_read_data_valid_LEDR_s1;
  output           cpu_0_data_master_requests_LEDR_s1;
  output           d1_LEDR_s1_end_xfer;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;

  wire    [  1: 0] LEDR_s1_address;
  wire             LEDR_s1_allgrants;
  wire             LEDR_s1_allow_new_arb_cycle;
  wire             LEDR_s1_any_continuerequest;
  wire             LEDR_s1_arb_counter_enable;
  reg     [  2: 0] LEDR_s1_arb_share_counter;
  wire    [  2: 0] LEDR_s1_arb_share_counter_next_value;
  wire    [  2: 0] LEDR_s1_arb_share_set_values;
  wire             LEDR_s1_beginbursttransfer_internal;
  wire             LEDR_s1_begins_xfer;
  wire             LEDR_s1_chipselect;
  wire             LEDR_s1_end_xfer;
  wire             LEDR_s1_firsttransfer;
  wire             LEDR_s1_grant_vector;
  wire             LEDR_s1_in_a_read_cycle;
  wire             LEDR_s1_in_a_write_cycle;
  wire             LEDR_s1_master_qreq_vector;
  wire             LEDR_s1_non_bursting_master_requests;
  wire             LEDR_s1_reset_n;
  reg              LEDR_s1_slavearbiterlockenable;
  wire             LEDR_s1_slavearbiterlockenable2;
  wire             LEDR_s1_waits_for_read;
  wire             LEDR_s1_waits_for_write;
  wire             LEDR_s1_write_n;
  wire    [  9: 0] LEDR_s1_writedata;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_LEDR_s1;
  wire             cpu_0_data_master_qualified_request_LEDR_s1;
  wire             cpu_0_data_master_read_data_valid_LEDR_s1;
  wire             cpu_0_data_master_requests_LEDR_s1;
  wire             cpu_0_data_master_saved_grant_LEDR_s1;
  reg              d1_LEDR_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             wait_for_LEDR_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~LEDR_s1_end_xfer;
    end


  assign LEDR_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_LEDR_s1));
  assign cpu_0_data_master_requests_LEDR_s1 = (({cpu_0_data_master_address_to_slave[23 : 4] , 4'b0} == 24'h481030) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_write;
  //LEDR_s1_arb_share_counter set values, which is an e_mux
  assign LEDR_s1_arb_share_set_values = 1;

  //LEDR_s1_non_bursting_master_requests mux, which is an e_mux
  assign LEDR_s1_non_bursting_master_requests = cpu_0_data_master_requests_LEDR_s1;

  //LEDR_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign LEDR_s1_arb_share_counter_next_value = LEDR_s1_firsttransfer ? (LEDR_s1_arb_share_set_values - 1) : |LEDR_s1_arb_share_counter ? (LEDR_s1_arb_share_counter - 1) : 0;

  //LEDR_s1_allgrants all slave grants, which is an e_mux
  assign LEDR_s1_allgrants = |LEDR_s1_grant_vector;

  //LEDR_s1_end_xfer assignment, which is an e_assign
  assign LEDR_s1_end_xfer = ~(LEDR_s1_waits_for_read | LEDR_s1_waits_for_write);

  //LEDR_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign LEDR_s1_arb_counter_enable = (LEDR_s1_end_xfer & LEDR_s1_allgrants) | (LEDR_s1_end_xfer & ~LEDR_s1_non_bursting_master_requests);

  //LEDR_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          LEDR_s1_arb_share_counter <= 0;
      else if (LEDR_s1_arb_counter_enable)
          LEDR_s1_arb_share_counter <= LEDR_s1_arb_share_counter_next_value;
    end


  //LEDR_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          LEDR_s1_slavearbiterlockenable <= 0;
      else if ((|LEDR_s1_master_qreq_vector & LEDR_s1_end_xfer) | (LEDR_s1_end_xfer & ~LEDR_s1_non_bursting_master_requests))
          LEDR_s1_slavearbiterlockenable <= |LEDR_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master LEDR/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = LEDR_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //LEDR_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign LEDR_s1_slavearbiterlockenable2 = |LEDR_s1_arb_share_counter_next_value;

  //cpu_0/data_master LEDR/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = LEDR_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //LEDR_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign LEDR_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_LEDR_s1 = cpu_0_data_master_requests_LEDR_s1 & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //LEDR_s1_writedata mux, which is an e_mux
  assign LEDR_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_LEDR_s1 = cpu_0_data_master_qualified_request_LEDR_s1;

  //cpu_0/data_master saved-grant LEDR/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_LEDR_s1 = cpu_0_data_master_requests_LEDR_s1;

  //allow new arb cycle for LEDR/s1, which is an e_assign
  assign LEDR_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign LEDR_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign LEDR_s1_master_qreq_vector = 1;

  //LEDR_s1_reset_n assignment, which is an e_assign
  assign LEDR_s1_reset_n = reset_n;

  assign LEDR_s1_chipselect = cpu_0_data_master_granted_LEDR_s1;
  //LEDR_s1_firsttransfer first transaction, which is an e_assign
  assign LEDR_s1_firsttransfer = ~(LEDR_s1_slavearbiterlockenable & LEDR_s1_any_continuerequest);

  //LEDR_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign LEDR_s1_beginbursttransfer_internal = LEDR_s1_begins_xfer & LEDR_s1_firsttransfer;

  //~LEDR_s1_write_n assignment, which is an e_mux
  assign LEDR_s1_write_n = ~(cpu_0_data_master_granted_LEDR_s1 & cpu_0_data_master_write);

  //LEDR_s1_address mux, which is an e_mux
  assign LEDR_s1_address = cpu_0_data_master_address_to_slave >> 2;

  //d1_LEDR_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_LEDR_s1_end_xfer <= 1;
      else if (1)
          d1_LEDR_s1_end_xfer <= LEDR_s1_end_xfer;
    end


  //LEDR_s1_waits_for_read in a cycle, which is an e_mux
  assign LEDR_s1_waits_for_read = LEDR_s1_in_a_read_cycle & LEDR_s1_begins_xfer;

  //LEDR_s1_in_a_read_cycle assignment, which is an e_assign
  assign LEDR_s1_in_a_read_cycle = cpu_0_data_master_granted_LEDR_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = LEDR_s1_in_a_read_cycle;

  //LEDR_s1_waits_for_write in a cycle, which is an e_mux
  assign LEDR_s1_waits_for_write = LEDR_s1_in_a_write_cycle & 0;

  //LEDR_s1_in_a_write_cycle assignment, which is an e_assign
  assign LEDR_s1_in_a_write_cycle = cpu_0_data_master_granted_LEDR_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = LEDR_s1_in_a_write_cycle;

  assign wait_for_LEDR_s1_counter = 0;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module SEG7_avalonS_arbitrator (
                                 // inputs:
                                  clk,
                                  cpu_0_data_master_address_to_slave,
                                  cpu_0_data_master_read,
                                  cpu_0_data_master_waitrequest,
                                  cpu_0_data_master_write,
                                  cpu_0_data_master_writedata,
                                  reset_n,

                                 // outputs:
                                  SEG7_avalonS_reset_n,
                                  SEG7_avalonS_write,
                                  SEG7_avalonS_writedata,
                                  cpu_0_data_master_granted_SEG7_avalonS,
                                  cpu_0_data_master_qualified_request_SEG7_avalonS,
                                  cpu_0_data_master_read_data_valid_SEG7_avalonS,
                                  cpu_0_data_master_requests_SEG7_avalonS,
                                  d1_SEG7_avalonS_end_xfer
                               )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output           SEG7_avalonS_reset_n;
  output           SEG7_avalonS_write;
  output  [ 15: 0] SEG7_avalonS_writedata;
  output           cpu_0_data_master_granted_SEG7_avalonS;
  output           cpu_0_data_master_qualified_request_SEG7_avalonS;
  output           cpu_0_data_master_read_data_valid_SEG7_avalonS;
  output           cpu_0_data_master_requests_SEG7_avalonS;
  output           d1_SEG7_avalonS_end_xfer;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;

  wire             SEG7_avalonS_address_for_slave_wo_address;
  wire             SEG7_avalonS_allgrants;
  wire             SEG7_avalonS_allow_new_arb_cycle;
  wire             SEG7_avalonS_any_continuerequest;
  wire             SEG7_avalonS_arb_counter_enable;
  reg     [  2: 0] SEG7_avalonS_arb_share_counter;
  wire    [  2: 0] SEG7_avalonS_arb_share_counter_next_value;
  wire    [  2: 0] SEG7_avalonS_arb_share_set_values;
  wire             SEG7_avalonS_beginbursttransfer_internal;
  wire             SEG7_avalonS_begins_xfer;
  wire             SEG7_avalonS_end_xfer;
  wire             SEG7_avalonS_firsttransfer;
  wire             SEG7_avalonS_grant_vector;
  wire             SEG7_avalonS_in_a_read_cycle;
  wire             SEG7_avalonS_in_a_write_cycle;
  wire             SEG7_avalonS_master_qreq_vector;
  wire             SEG7_avalonS_non_bursting_master_requests;
  wire             SEG7_avalonS_reset_n;
  reg              SEG7_avalonS_slavearbiterlockenable;
  wire             SEG7_avalonS_slavearbiterlockenable2;
  wire             SEG7_avalonS_waits_for_read;
  wire             SEG7_avalonS_waits_for_write;
  wire             SEG7_avalonS_write;
  wire    [ 15: 0] SEG7_avalonS_writedata;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_SEG7_avalonS;
  wire             cpu_0_data_master_qualified_request_SEG7_avalonS;
  wire             cpu_0_data_master_read_data_valid_SEG7_avalonS;
  wire             cpu_0_data_master_requests_SEG7_avalonS;
  wire             cpu_0_data_master_saved_grant_SEG7_avalonS;
  reg              d1_SEG7_avalonS_end_xfer;
  reg              d1_reasons_to_wait;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             wait_for_SEG7_avalonS_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~SEG7_avalonS_end_xfer;
    end


  assign SEG7_avalonS_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_SEG7_avalonS));
  assign cpu_0_data_master_requests_SEG7_avalonS = (({cpu_0_data_master_address_to_slave[23 : 2] , 2'b0} == 24'h481068) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_write;
  //SEG7_avalonS_arb_share_counter set values, which is an e_mux
  assign SEG7_avalonS_arb_share_set_values = 1;

  //SEG7_avalonS_non_bursting_master_requests mux, which is an e_mux
  assign SEG7_avalonS_non_bursting_master_requests = cpu_0_data_master_requests_SEG7_avalonS;

  //SEG7_avalonS_arb_share_counter_next_value assignment, which is an e_assign
  assign SEG7_avalonS_arb_share_counter_next_value = SEG7_avalonS_firsttransfer ? (SEG7_avalonS_arb_share_set_values - 1) : |SEG7_avalonS_arb_share_counter ? (SEG7_avalonS_arb_share_counter - 1) : 0;

  //SEG7_avalonS_allgrants all slave grants, which is an e_mux
  assign SEG7_avalonS_allgrants = |SEG7_avalonS_grant_vector;

  //SEG7_avalonS_end_xfer assignment, which is an e_assign
  assign SEG7_avalonS_end_xfer = ~(SEG7_avalonS_waits_for_read | SEG7_avalonS_waits_for_write);

  //SEG7_avalonS_arb_share_counter arbitration counter enable, which is an e_assign
  assign SEG7_avalonS_arb_counter_enable = (SEG7_avalonS_end_xfer & SEG7_avalonS_allgrants) | (SEG7_avalonS_end_xfer & ~SEG7_avalonS_non_bursting_master_requests);

  //SEG7_avalonS_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          SEG7_avalonS_arb_share_counter <= 0;
      else if (SEG7_avalonS_arb_counter_enable)
          SEG7_avalonS_arb_share_counter <= SEG7_avalonS_arb_share_counter_next_value;
    end


  //SEG7_avalonS_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          SEG7_avalonS_slavearbiterlockenable <= 0;
      else if ((|SEG7_avalonS_master_qreq_vector & SEG7_avalonS_end_xfer) | (SEG7_avalonS_end_xfer & ~SEG7_avalonS_non_bursting_master_requests))
          SEG7_avalonS_slavearbiterlockenable <= |SEG7_avalonS_arb_share_counter_next_value;
    end


  //cpu_0/data_master SEG7/avalonS arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = SEG7_avalonS_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //SEG7_avalonS_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign SEG7_avalonS_slavearbiterlockenable2 = |SEG7_avalonS_arb_share_counter_next_value;

  //cpu_0/data_master SEG7/avalonS arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = SEG7_avalonS_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //SEG7_avalonS_any_continuerequest at least one master continues requesting, which is an e_assign
  assign SEG7_avalonS_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_SEG7_avalonS = cpu_0_data_master_requests_SEG7_avalonS & ~(((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //SEG7_avalonS_writedata mux, which is an e_mux
  assign SEG7_avalonS_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_SEG7_avalonS = cpu_0_data_master_qualified_request_SEG7_avalonS;

  //cpu_0/data_master saved-grant SEG7/avalonS, which is an e_assign
  assign cpu_0_data_master_saved_grant_SEG7_avalonS = cpu_0_data_master_requests_SEG7_avalonS;

  //allow new arb cycle for SEG7/avalonS, which is an e_assign
  assign SEG7_avalonS_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign SEG7_avalonS_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign SEG7_avalonS_master_qreq_vector = 1;

  //SEG7_avalonS_reset_n assignment, which is an e_assign
  assign SEG7_avalonS_reset_n = reset_n;

  //SEG7_avalonS_firsttransfer first transaction, which is an e_assign
  assign SEG7_avalonS_firsttransfer = ~(SEG7_avalonS_slavearbiterlockenable & SEG7_avalonS_any_continuerequest);

  //SEG7_avalonS_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign SEG7_avalonS_beginbursttransfer_internal = SEG7_avalonS_begins_xfer & SEG7_avalonS_firsttransfer;

  //SEG7_avalonS_write assignment, which is an e_mux
  assign SEG7_avalonS_write = cpu_0_data_master_granted_SEG7_avalonS & cpu_0_data_master_write;

  //SEG7_avalonS_address_for_slave_wo_address mux, which is an e_mux
  assign SEG7_avalonS_address_for_slave_wo_address = cpu_0_data_master_address_to_slave >> 2;

  //d1_SEG7_avalonS_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_SEG7_avalonS_end_xfer <= 1;
      else if (1)
          d1_SEG7_avalonS_end_xfer <= SEG7_avalonS_end_xfer;
    end


  //SEG7_avalonS_waits_for_read in a cycle, which is an e_mux
  assign SEG7_avalonS_waits_for_read = SEG7_avalonS_in_a_read_cycle & 0;

  //SEG7_avalonS_in_a_read_cycle assignment, which is an e_assign
  assign SEG7_avalonS_in_a_read_cycle = cpu_0_data_master_granted_SEG7_avalonS & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = SEG7_avalonS_in_a_read_cycle;

  //SEG7_avalonS_waits_for_write in a cycle, which is an e_mux
  assign SEG7_avalonS_waits_for_write = SEG7_avalonS_in_a_write_cycle & 0;

  //SEG7_avalonS_in_a_write_cycle assignment, which is an e_assign
  assign SEG7_avalonS_in_a_write_cycle = cpu_0_data_master_granted_SEG7_avalonS & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = SEG7_avalonS_in_a_write_cycle;

  assign wait_for_SEG7_avalonS_counter = 0;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module Switch_s1_arbitrator (
                              // inputs:
                               Switch_s1_readdata,
                               clk,
                               cpu_0_data_master_address_to_slave,
                               cpu_0_data_master_read,
                               cpu_0_data_master_write,
                               reset_n,

                              // outputs:
                               Switch_s1_address,
                               Switch_s1_readdata_from_sa,
                               Switch_s1_reset_n,
                               cpu_0_data_master_granted_Switch_s1,
                               cpu_0_data_master_qualified_request_Switch_s1,
                               cpu_0_data_master_read_data_valid_Switch_s1,
                               cpu_0_data_master_requests_Switch_s1,
                               d1_Switch_s1_end_xfer
                            )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] Switch_s1_address;
  output  [  9: 0] Switch_s1_readdata_from_sa;
  output           Switch_s1_reset_n;
  output           cpu_0_data_master_granted_Switch_s1;
  output           cpu_0_data_master_qualified_request_Switch_s1;
  output           cpu_0_data_master_read_data_valid_Switch_s1;
  output           cpu_0_data_master_requests_Switch_s1;
  output           d1_Switch_s1_end_xfer;
  input   [  9: 0] Switch_s1_readdata;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input            reset_n;

  wire    [  1: 0] Switch_s1_address;
  wire             Switch_s1_allgrants;
  wire             Switch_s1_allow_new_arb_cycle;
  wire             Switch_s1_any_continuerequest;
  wire             Switch_s1_arb_counter_enable;
  reg     [  2: 0] Switch_s1_arb_share_counter;
  wire    [  2: 0] Switch_s1_arb_share_counter_next_value;
  wire    [  2: 0] Switch_s1_arb_share_set_values;
  wire             Switch_s1_beginbursttransfer_internal;
  wire             Switch_s1_begins_xfer;
  wire             Switch_s1_end_xfer;
  wire             Switch_s1_firsttransfer;
  wire             Switch_s1_grant_vector;
  wire             Switch_s1_in_a_read_cycle;
  wire             Switch_s1_in_a_write_cycle;
  wire             Switch_s1_master_qreq_vector;
  wire             Switch_s1_non_bursting_master_requests;
  wire    [  9: 0] Switch_s1_readdata_from_sa;
  wire             Switch_s1_reset_n;
  reg              Switch_s1_slavearbiterlockenable;
  wire             Switch_s1_slavearbiterlockenable2;
  wire             Switch_s1_waits_for_read;
  wire             Switch_s1_waits_for_write;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_Switch_s1;
  wire             cpu_0_data_master_qualified_request_Switch_s1;
  wire             cpu_0_data_master_read_data_valid_Switch_s1;
  wire             cpu_0_data_master_requests_Switch_s1;
  wire             cpu_0_data_master_saved_grant_Switch_s1;
  reg              d1_Switch_s1_end_xfer;
  reg              d1_reasons_to_wait;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             wait_for_Switch_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~Switch_s1_end_xfer;
    end


  assign Switch_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_Switch_s1));
  //assign Switch_s1_readdata_from_sa = Switch_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign Switch_s1_readdata_from_sa = Switch_s1_readdata;

  assign cpu_0_data_master_requests_Switch_s1 = (({cpu_0_data_master_address_to_slave[23 : 4] , 4'b0} == 24'h481050) & (cpu_0_data_master_read | cpu_0_data_master_write)) & cpu_0_data_master_read;
  //Switch_s1_arb_share_counter set values, which is an e_mux
  assign Switch_s1_arb_share_set_values = 1;

  //Switch_s1_non_bursting_master_requests mux, which is an e_mux
  assign Switch_s1_non_bursting_master_requests = cpu_0_data_master_requests_Switch_s1;

  //Switch_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign Switch_s1_arb_share_counter_next_value = Switch_s1_firsttransfer ? (Switch_s1_arb_share_set_values - 1) : |Switch_s1_arb_share_counter ? (Switch_s1_arb_share_counter - 1) : 0;

  //Switch_s1_allgrants all slave grants, which is an e_mux
  assign Switch_s1_allgrants = |Switch_s1_grant_vector;

  //Switch_s1_end_xfer assignment, which is an e_assign
  assign Switch_s1_end_xfer = ~(Switch_s1_waits_for_read | Switch_s1_waits_for_write);

  //Switch_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign Switch_s1_arb_counter_enable = (Switch_s1_end_xfer & Switch_s1_allgrants) | (Switch_s1_end_xfer & ~Switch_s1_non_bursting_master_requests);

  //Switch_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          Switch_s1_arb_share_counter <= 0;
      else if (Switch_s1_arb_counter_enable)
          Switch_s1_arb_share_counter <= Switch_s1_arb_share_counter_next_value;
    end


  //Switch_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          Switch_s1_slavearbiterlockenable <= 0;
      else if ((|Switch_s1_master_qreq_vector & Switch_s1_end_xfer) | (Switch_s1_end_xfer & ~Switch_s1_non_bursting_master_requests))
          Switch_s1_slavearbiterlockenable <= |Switch_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master Switch/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = Switch_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //Switch_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign Switch_s1_slavearbiterlockenable2 = |Switch_s1_arb_share_counter_next_value;

  //cpu_0/data_master Switch/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = Switch_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //Switch_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign Switch_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_Switch_s1 = cpu_0_data_master_requests_Switch_s1;
  //master is always granted when requested
  assign cpu_0_data_master_granted_Switch_s1 = cpu_0_data_master_qualified_request_Switch_s1;

  //cpu_0/data_master saved-grant Switch/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_Switch_s1 = cpu_0_data_master_requests_Switch_s1;

  //allow new arb cycle for Switch/s1, which is an e_assign
  assign Switch_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign Switch_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign Switch_s1_master_qreq_vector = 1;

  //Switch_s1_reset_n assignment, which is an e_assign
  assign Switch_s1_reset_n = reset_n;

  //Switch_s1_firsttransfer first transaction, which is an e_assign
  assign Switch_s1_firsttransfer = ~(Switch_s1_slavearbiterlockenable & Switch_s1_any_continuerequest);

  //Switch_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign Switch_s1_beginbursttransfer_internal = Switch_s1_begins_xfer & Switch_s1_firsttransfer;

  //Switch_s1_address mux, which is an e_mux
  assign Switch_s1_address = cpu_0_data_master_address_to_slave >> 2;

  //d1_Switch_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_Switch_s1_end_xfer <= 1;
      else if (1)
          d1_Switch_s1_end_xfer <= Switch_s1_end_xfer;
    end


  //Switch_s1_waits_for_read in a cycle, which is an e_mux
  assign Switch_s1_waits_for_read = Switch_s1_in_a_read_cycle & Switch_s1_begins_xfer;

  //Switch_s1_in_a_read_cycle assignment, which is an e_assign
  assign Switch_s1_in_a_read_cycle = cpu_0_data_master_granted_Switch_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = Switch_s1_in_a_read_cycle;

  //Switch_s1_waits_for_write in a cycle, which is an e_mux
  assign Switch_s1_waits_for_write = Switch_s1_in_a_write_cycle & 0;

  //Switch_s1_in_a_write_cycle assignment, which is an e_assign
  assign Switch_s1_in_a_write_cycle = cpu_0_data_master_granted_Switch_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = Switch_s1_in_a_write_cycle;

  assign wait_for_Switch_s1_counter = 0;

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_jtag_debug_module_arbitrator (
                                            // inputs:
                                             clk,
                                             cpu_0_data_master_address_to_slave,
                                             cpu_0_data_master_byteenable,
                                             cpu_0_data_master_debugaccess,
                                             cpu_0_data_master_read,
                                             cpu_0_data_master_write,
                                             cpu_0_data_master_writedata,
                                             cpu_0_instruction_master_address_to_slave,
                                             cpu_0_instruction_master_latency_counter,
                                             cpu_0_instruction_master_read,
                                             cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                             cpu_0_jtag_debug_module_readdata,
                                             cpu_0_jtag_debug_module_resetrequest,
                                             reset_n,

                                            // outputs:
                                             cpu_0_data_master_granted_cpu_0_jtag_debug_module,
                                             cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
                                             cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
                                             cpu_0_data_master_requests_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
                                             cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
                                             cpu_0_jtag_debug_module_address,
                                             cpu_0_jtag_debug_module_begintransfer,
                                             cpu_0_jtag_debug_module_byteenable,
                                             cpu_0_jtag_debug_module_chipselect,
                                             cpu_0_jtag_debug_module_debugaccess,
                                             cpu_0_jtag_debug_module_readdata_from_sa,
                                             cpu_0_jtag_debug_module_reset,
                                             cpu_0_jtag_debug_module_reset_n,
                                             cpu_0_jtag_debug_module_resetrequest_from_sa,
                                             cpu_0_jtag_debug_module_write,
                                             cpu_0_jtag_debug_module_writedata,
                                             d1_cpu_0_jtag_debug_module_end_xfer
                                          )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output           cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  output           cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  output           cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  output           cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  output           cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  output  [  8: 0] cpu_0_jtag_debug_module_address;
  output           cpu_0_jtag_debug_module_begintransfer;
  output  [  3: 0] cpu_0_jtag_debug_module_byteenable;
  output           cpu_0_jtag_debug_module_chipselect;
  output           cpu_0_jtag_debug_module_debugaccess;
  output  [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  output           cpu_0_jtag_debug_module_reset;
  output           cpu_0_jtag_debug_module_reset_n;
  output           cpu_0_jtag_debug_module_resetrequest_from_sa;
  output           cpu_0_jtag_debug_module_write;
  output  [ 31: 0] cpu_0_jtag_debug_module_writedata;
  output           d1_cpu_0_jtag_debug_module_end_xfer;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input            cpu_0_data_master_debugaccess;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input   [ 23: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  input   [ 31: 0] cpu_0_jtag_debug_module_readdata;
  input            cpu_0_jtag_debug_module_resetrequest;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module;
  wire    [  8: 0] cpu_0_jtag_debug_module_address;
  wire             cpu_0_jtag_debug_module_allgrants;
  wire             cpu_0_jtag_debug_module_allow_new_arb_cycle;
  wire             cpu_0_jtag_debug_module_any_continuerequest;
  reg     [  1: 0] cpu_0_jtag_debug_module_arb_addend;
  wire             cpu_0_jtag_debug_module_arb_counter_enable;
  reg     [  2: 0] cpu_0_jtag_debug_module_arb_share_counter;
  wire    [  2: 0] cpu_0_jtag_debug_module_arb_share_counter_next_value;
  wire    [  2: 0] cpu_0_jtag_debug_module_arb_share_set_values;
  wire    [  1: 0] cpu_0_jtag_debug_module_arb_winner;
  wire             cpu_0_jtag_debug_module_arbitration_holdoff_internal;
  wire             cpu_0_jtag_debug_module_beginbursttransfer_internal;
  wire             cpu_0_jtag_debug_module_begins_xfer;
  wire             cpu_0_jtag_debug_module_begintransfer;
  wire    [  3: 0] cpu_0_jtag_debug_module_byteenable;
  wire             cpu_0_jtag_debug_module_chipselect;
  wire    [  3: 0] cpu_0_jtag_debug_module_chosen_master_double_vector;
  wire    [  1: 0] cpu_0_jtag_debug_module_chosen_master_rot_left;
  wire             cpu_0_jtag_debug_module_debugaccess;
  wire             cpu_0_jtag_debug_module_end_xfer;
  wire             cpu_0_jtag_debug_module_firsttransfer;
  wire    [  1: 0] cpu_0_jtag_debug_module_grant_vector;
  wire             cpu_0_jtag_debug_module_in_a_read_cycle;
  wire             cpu_0_jtag_debug_module_in_a_write_cycle;
  wire    [  1: 0] cpu_0_jtag_debug_module_master_qreq_vector;
  wire             cpu_0_jtag_debug_module_non_bursting_master_requests;
  wire    [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  wire             cpu_0_jtag_debug_module_reset;
  wire             cpu_0_jtag_debug_module_reset_n;
  wire             cpu_0_jtag_debug_module_resetrequest_from_sa;
  reg     [  1: 0] cpu_0_jtag_debug_module_saved_chosen_master_vector;
  reg              cpu_0_jtag_debug_module_slavearbiterlockenable;
  wire             cpu_0_jtag_debug_module_slavearbiterlockenable2;
  wire             cpu_0_jtag_debug_module_waits_for_read;
  wire             cpu_0_jtag_debug_module_waits_for_write;
  wire             cpu_0_jtag_debug_module_write;
  wire    [ 31: 0] cpu_0_jtag_debug_module_writedata;
  reg              d1_cpu_0_jtag_debug_module_end_xfer;
  reg              d1_reasons_to_wait;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module;
  wire             wait_for_cpu_0_jtag_debug_module_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~cpu_0_jtag_debug_module_end_xfer;
    end


  assign cpu_0_jtag_debug_module_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module));
  //assign cpu_0_jtag_debug_module_readdata_from_sa = cpu_0_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_0_jtag_debug_module_readdata_from_sa = cpu_0_jtag_debug_module_readdata;

  assign cpu_0_data_master_requests_cpu_0_jtag_debug_module = ({cpu_0_data_master_address_to_slave[23 : 11] , 11'b0} == 24'h480000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //cpu_0_jtag_debug_module_arb_share_counter set values, which is an e_mux
  assign cpu_0_jtag_debug_module_arb_share_set_values = 1;

  //cpu_0_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  assign cpu_0_jtag_debug_module_non_bursting_master_requests = cpu_0_data_master_requests_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_requests_cpu_0_jtag_debug_module |
    cpu_0_data_master_requests_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;

  //cpu_0_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_arb_share_counter_next_value = cpu_0_jtag_debug_module_firsttransfer ? (cpu_0_jtag_debug_module_arb_share_set_values - 1) : |cpu_0_jtag_debug_module_arb_share_counter ? (cpu_0_jtag_debug_module_arb_share_counter - 1) : 0;

  //cpu_0_jtag_debug_module_allgrants all slave grants, which is an e_mux
  assign cpu_0_jtag_debug_module_allgrants = |cpu_0_jtag_debug_module_grant_vector |
    |cpu_0_jtag_debug_module_grant_vector |
    |cpu_0_jtag_debug_module_grant_vector |
    |cpu_0_jtag_debug_module_grant_vector;

  //cpu_0_jtag_debug_module_end_xfer assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_end_xfer = ~(cpu_0_jtag_debug_module_waits_for_read | cpu_0_jtag_debug_module_waits_for_write);

  //cpu_0_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  assign cpu_0_jtag_debug_module_arb_counter_enable = (cpu_0_jtag_debug_module_end_xfer & cpu_0_jtag_debug_module_allgrants) | (cpu_0_jtag_debug_module_end_xfer & ~cpu_0_jtag_debug_module_non_bursting_master_requests);

  //cpu_0_jtag_debug_module_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_arb_share_counter <= 0;
      else if (cpu_0_jtag_debug_module_arb_counter_enable)
          cpu_0_jtag_debug_module_arb_share_counter <= cpu_0_jtag_debug_module_arb_share_counter_next_value;
    end


  //cpu_0_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_slavearbiterlockenable <= 0;
      else if ((|cpu_0_jtag_debug_module_master_qreq_vector & cpu_0_jtag_debug_module_end_xfer) | (cpu_0_jtag_debug_module_end_xfer & ~cpu_0_jtag_debug_module_non_bursting_master_requests))
          cpu_0_jtag_debug_module_slavearbiterlockenable <= |cpu_0_jtag_debug_module_arb_share_counter_next_value;
    end


  //cpu_0/data_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = cpu_0_jtag_debug_module_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //cpu_0_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign cpu_0_jtag_debug_module_slavearbiterlockenable2 = |cpu_0_jtag_debug_module_arb_share_counter_next_value;

  //cpu_0/data_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = cpu_0_jtag_debug_module_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = cpu_0_jtag_debug_module_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master cpu_0/jtag_debug_module arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = cpu_0_jtag_debug_module_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted cpu_0/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= 0;
      else if (1)
          last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module <= cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module ? 1 : (cpu_0_jtag_debug_module_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_cpu_0_jtag_debug_module) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = last_cycle_cpu_0_instruction_master_granted_slave_cpu_0_jtag_debug_module & cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;

  //cpu_0_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  assign cpu_0_jtag_debug_module_any_continuerequest = cpu_0_instruction_master_continuerequest |
    cpu_0_data_master_continuerequest;

  assign cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module = cpu_0_data_master_requests_cpu_0_jtag_debug_module & ~(cpu_0_instruction_master_arbiterlock);
  //cpu_0_jtag_debug_module_writedata mux, which is an e_mux
  assign cpu_0_jtag_debug_module_writedata = cpu_0_data_master_writedata;

  //mux cpu_0_jtag_debug_module_debugaccess, which is an e_mux
  assign cpu_0_jtag_debug_module_debugaccess = cpu_0_data_master_debugaccess;

  assign cpu_0_instruction_master_requests_cpu_0_jtag_debug_module = (({cpu_0_instruction_master_address_to_slave[23 : 11] , 11'b0} == 24'h480000) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted cpu_0/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= 0;
      else if (1)
          last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module <= cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module ? 1 : (cpu_0_jtag_debug_module_arbitration_holdoff_internal | ~cpu_0_data_master_requests_cpu_0_jtag_debug_module) ? 0 : last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = last_cycle_cpu_0_data_master_granted_slave_cpu_0_jtag_debug_module & cpu_0_data_master_requests_cpu_0_jtag_debug_module;

  assign cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module = cpu_0_instruction_master_requests_cpu_0_jtag_debug_module & ~((cpu_0_instruction_master_read & ((cpu_0_instruction_master_latency_counter != 0) | (|cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register))) | cpu_0_data_master_arbiterlock);
  //local readdatavalid cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module = cpu_0_instruction_master_granted_cpu_0_jtag_debug_module & cpu_0_instruction_master_read & ~cpu_0_jtag_debug_module_waits_for_read;

  //allow new arb cycle for cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_jtag_debug_module_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock;

  //cpu_0/instruction_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_jtag_debug_module_master_qreq_vector[0] = cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;

  //cpu_0/instruction_master grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_instruction_master_granted_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_grant_vector[0];

  //cpu_0/instruction_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_arb_winner[0] && cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;

  //cpu_0/data_master assignment into master qualified-requests vector for cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_jtag_debug_module_master_qreq_vector[1] = cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;

  //cpu_0/data_master grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_data_master_granted_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_grant_vector[1];

  //cpu_0/data_master saved-grant cpu_0/jtag_debug_module, which is an e_assign
  assign cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module = cpu_0_jtag_debug_module_arb_winner[1] && cpu_0_data_master_requests_cpu_0_jtag_debug_module;

  //cpu_0/jtag_debug_module chosen-master double-vector, which is an e_assign
  assign cpu_0_jtag_debug_module_chosen_master_double_vector = {cpu_0_jtag_debug_module_master_qreq_vector, cpu_0_jtag_debug_module_master_qreq_vector} & ({~cpu_0_jtag_debug_module_master_qreq_vector, ~cpu_0_jtag_debug_module_master_qreq_vector} + cpu_0_jtag_debug_module_arb_addend);

  //stable onehot encoding of arb winner
  assign cpu_0_jtag_debug_module_arb_winner = (cpu_0_jtag_debug_module_allow_new_arb_cycle & | cpu_0_jtag_debug_module_grant_vector) ? cpu_0_jtag_debug_module_grant_vector : cpu_0_jtag_debug_module_saved_chosen_master_vector;

  //saved cpu_0_jtag_debug_module_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_saved_chosen_master_vector <= 0;
      else if (cpu_0_jtag_debug_module_allow_new_arb_cycle)
          cpu_0_jtag_debug_module_saved_chosen_master_vector <= |cpu_0_jtag_debug_module_grant_vector ? cpu_0_jtag_debug_module_grant_vector : cpu_0_jtag_debug_module_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign cpu_0_jtag_debug_module_grant_vector = {(cpu_0_jtag_debug_module_chosen_master_double_vector[1] | cpu_0_jtag_debug_module_chosen_master_double_vector[3]),
    (cpu_0_jtag_debug_module_chosen_master_double_vector[0] | cpu_0_jtag_debug_module_chosen_master_double_vector[2])};

  //cpu_0/jtag_debug_module chosen master rotated left, which is an e_assign
  assign cpu_0_jtag_debug_module_chosen_master_rot_left = (cpu_0_jtag_debug_module_arb_winner << 1) ? (cpu_0_jtag_debug_module_arb_winner << 1) : 1;

  //cpu_0/jtag_debug_module's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_jtag_debug_module_arb_addend <= 1;
      else if (|cpu_0_jtag_debug_module_grant_vector)
          cpu_0_jtag_debug_module_arb_addend <= cpu_0_jtag_debug_module_end_xfer? cpu_0_jtag_debug_module_chosen_master_rot_left : cpu_0_jtag_debug_module_grant_vector;
    end


  assign cpu_0_jtag_debug_module_begintransfer = cpu_0_jtag_debug_module_begins_xfer;
  //assign lhs ~cpu_0_jtag_debug_module_reset of type reset_n to cpu_0_jtag_debug_module_reset_n, which is an e_assign
  assign cpu_0_jtag_debug_module_reset = ~cpu_0_jtag_debug_module_reset_n;

  //cpu_0_jtag_debug_module_reset_n assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_reset_n = reset_n;

  //assign cpu_0_jtag_debug_module_resetrequest_from_sa = cpu_0_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign cpu_0_jtag_debug_module_resetrequest_from_sa = cpu_0_jtag_debug_module_resetrequest;

  assign cpu_0_jtag_debug_module_chipselect = cpu_0_data_master_granted_cpu_0_jtag_debug_module | cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  //cpu_0_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  assign cpu_0_jtag_debug_module_firsttransfer = ~(cpu_0_jtag_debug_module_slavearbiterlockenable & cpu_0_jtag_debug_module_any_continuerequest);

  //cpu_0_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign cpu_0_jtag_debug_module_beginbursttransfer_internal = cpu_0_jtag_debug_module_begins_xfer & cpu_0_jtag_debug_module_firsttransfer;

  //cpu_0_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign cpu_0_jtag_debug_module_arbitration_holdoff_internal = cpu_0_jtag_debug_module_begins_xfer & cpu_0_jtag_debug_module_firsttransfer;

  //cpu_0_jtag_debug_module_write assignment, which is an e_mux
  assign cpu_0_jtag_debug_module_write = cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_write;

  //cpu_0_jtag_debug_module_address mux, which is an e_mux
  assign cpu_0_jtag_debug_module_address = (cpu_0_data_master_granted_cpu_0_jtag_debug_module)? (cpu_0_data_master_address_to_slave >> 2) :
    (cpu_0_instruction_master_address_to_slave >> 2);

  //d1_cpu_0_jtag_debug_module_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_cpu_0_jtag_debug_module_end_xfer <= 1;
      else if (1)
          d1_cpu_0_jtag_debug_module_end_xfer <= cpu_0_jtag_debug_module_end_xfer;
    end


  //cpu_0_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  assign cpu_0_jtag_debug_module_waits_for_read = cpu_0_jtag_debug_module_in_a_read_cycle & cpu_0_jtag_debug_module_begins_xfer;

  //cpu_0_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_in_a_read_cycle = (cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module & cpu_0_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cpu_0_jtag_debug_module_in_a_read_cycle;

  //cpu_0_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  assign cpu_0_jtag_debug_module_waits_for_write = cpu_0_jtag_debug_module_in_a_write_cycle & cpu_0_jtag_debug_module_begins_xfer;

  //cpu_0_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  assign cpu_0_jtag_debug_module_in_a_write_cycle = cpu_0_data_master_granted_cpu_0_jtag_debug_module & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cpu_0_jtag_debug_module_in_a_write_cycle;

  assign wait_for_cpu_0_jtag_debug_module_counter = 0;
  //cpu_0_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  assign cpu_0_jtag_debug_module_byteenable = (cpu_0_data_master_granted_cpu_0_jtag_debug_module)? cpu_0_data_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_cpu_0_jtag_debug_module + cpu_0_instruction_master_granted_cpu_0_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_cpu_0_jtag_debug_module + cpu_0_instruction_master_saved_grant_cpu_0_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_data_master_arbitrator (
                                      // inputs:
                                       KEY_s1_irq_from_sa,
                                       KEY_s1_readdata_from_sa,
                                       Switch_s1_readdata_from_sa,
                                       cfi_flash_0_s1_wait_counter_eq_0,
                                       cfi_flash_0_s1_wait_counter_eq_1,
                                       clk,
                                       cpu_0_data_master_address,
                                       cpu_0_data_master_byteenable_cfi_flash_0_s1,
                                       cpu_0_data_master_byteenable_sdram_0_s1,
                                       cpu_0_data_master_byteenable_sram_0_avalonS,
                                       cpu_0_data_master_debugaccess,
                                       cpu_0_data_master_granted_KEY_s1,
                                       cpu_0_data_master_granted_LEDG_s1,
                                       cpu_0_data_master_granted_LEDR_s1,
                                       cpu_0_data_master_granted_SEG7_avalonS,
                                       cpu_0_data_master_granted_Switch_s1,
                                       cpu_0_data_master_granted_cfi_flash_0_s1,
                                       cpu_0_data_master_granted_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_granted_epcs_controller_epcs_control_port,
                                       cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave,
                                       cpu_0_data_master_granted_sdram_0_s1,
                                       cpu_0_data_master_granted_sram_0_avalonS,
                                       cpu_0_data_master_granted_uart_0_s1,
                                       cpu_0_data_master_qualified_request_KEY_s1,
                                       cpu_0_data_master_qualified_request_LEDG_s1,
                                       cpu_0_data_master_qualified_request_LEDR_s1,
                                       cpu_0_data_master_qualified_request_SEG7_avalonS,
                                       cpu_0_data_master_qualified_request_Switch_s1,
                                       cpu_0_data_master_qualified_request_cfi_flash_0_s1,
                                       cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port,
                                       cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave,
                                       cpu_0_data_master_qualified_request_sdram_0_s1,
                                       cpu_0_data_master_qualified_request_sram_0_avalonS,
                                       cpu_0_data_master_qualified_request_uart_0_s1,
                                       cpu_0_data_master_read,
                                       cpu_0_data_master_read_data_valid_KEY_s1,
                                       cpu_0_data_master_read_data_valid_LEDG_s1,
                                       cpu_0_data_master_read_data_valid_LEDR_s1,
                                       cpu_0_data_master_read_data_valid_SEG7_avalonS,
                                       cpu_0_data_master_read_data_valid_Switch_s1,
                                       cpu_0_data_master_read_data_valid_cfi_flash_0_s1,
                                       cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_read_data_valid_epcs_controller_epcs_control_port,
                                       cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave,
                                       cpu_0_data_master_read_data_valid_sdram_0_s1,
                                       cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                       cpu_0_data_master_read_data_valid_sram_0_avalonS,
                                       cpu_0_data_master_read_data_valid_uart_0_s1,
                                       cpu_0_data_master_requests_KEY_s1,
                                       cpu_0_data_master_requests_LEDG_s1,
                                       cpu_0_data_master_requests_LEDR_s1,
                                       cpu_0_data_master_requests_SEG7_avalonS,
                                       cpu_0_data_master_requests_Switch_s1,
                                       cpu_0_data_master_requests_cfi_flash_0_s1,
                                       cpu_0_data_master_requests_cpu_0_jtag_debug_module,
                                       cpu_0_data_master_requests_epcs_controller_epcs_control_port,
                                       cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave,
                                       cpu_0_data_master_requests_sdram_0_s1,
                                       cpu_0_data_master_requests_sram_0_avalonS,
                                       cpu_0_data_master_requests_uart_0_s1,
                                       cpu_0_data_master_write,
                                       cpu_0_data_master_writedata,
                                       cpu_0_jtag_debug_module_readdata_from_sa,
                                       d1_KEY_s1_end_xfer,
                                       d1_LEDG_s1_end_xfer,
                                       d1_LEDR_s1_end_xfer,
                                       d1_SEG7_avalonS_end_xfer,
                                       d1_Switch_s1_end_xfer,
                                       d1_cpu_0_jtag_debug_module_end_xfer,
                                       d1_epcs_controller_epcs_control_port_end_xfer,
                                       d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
                                       d1_sdram_0_s1_end_xfer,
                                       d1_sram_0_avalonS_end_xfer,
                                       d1_tri_state_bridge_0_avalon_slave_end_xfer,
                                       d1_uart_0_s1_end_xfer,
                                       epcs_controller_epcs_control_port_irq_from_sa,
                                       epcs_controller_epcs_control_port_readdata_from_sa,
                                       incoming_tri_state_bridge_0_data_with_Xs_converted_to_0,
                                       jtag_uart_0_avalon_jtag_slave_irq_from_sa,
                                       jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
                                       jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
                                       registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1,
                                       reset_n,
                                       sdram_0_s1_readdata_from_sa,
                                       sdram_0_s1_waitrequest_from_sa,
                                       sram_0_avalonS_readdata_from_sa,
                                       sram_0_avalonS_wait_counter_eq_0,
                                       sram_0_avalonS_wait_counter_eq_1,
                                       uart_0_s1_irq_from_sa,
                                       uart_0_s1_readdata_from_sa,

                                      // outputs:
                                       cpu_0_data_master_address_to_slave,
                                       cpu_0_data_master_dbs_address,
                                       cpu_0_data_master_dbs_write_16,
                                       cpu_0_data_master_dbs_write_8,
                                       cpu_0_data_master_irq,
                                       cpu_0_data_master_no_byte_enables_and_last_term,
                                       cpu_0_data_master_readdata,
                                       cpu_0_data_master_waitrequest
                                    )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [ 23: 0] cpu_0_data_master_address_to_slave;
  output  [  1: 0] cpu_0_data_master_dbs_address;
  output  [ 15: 0] cpu_0_data_master_dbs_write_16;
  output  [  7: 0] cpu_0_data_master_dbs_write_8;
  output  [ 31: 0] cpu_0_data_master_irq;
  output           cpu_0_data_master_no_byte_enables_and_last_term;
  output  [ 31: 0] cpu_0_data_master_readdata;
  output           cpu_0_data_master_waitrequest;
  input            KEY_s1_irq_from_sa;
  input   [  3: 0] KEY_s1_readdata_from_sa;
  input   [  9: 0] Switch_s1_readdata_from_sa;
  input            cfi_flash_0_s1_wait_counter_eq_0;
  input            cfi_flash_0_s1_wait_counter_eq_1;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address;
  input            cpu_0_data_master_byteenable_cfi_flash_0_s1;
  input   [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1;
  input   [  1: 0] cpu_0_data_master_byteenable_sram_0_avalonS;
  input            cpu_0_data_master_debugaccess;
  input            cpu_0_data_master_granted_KEY_s1;
  input            cpu_0_data_master_granted_LEDG_s1;
  input            cpu_0_data_master_granted_LEDR_s1;
  input            cpu_0_data_master_granted_SEG7_avalonS;
  input            cpu_0_data_master_granted_Switch_s1;
  input            cpu_0_data_master_granted_cfi_flash_0_s1;
  input            cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_granted_epcs_controller_epcs_control_port;
  input            cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  input            cpu_0_data_master_granted_sdram_0_s1;
  input            cpu_0_data_master_granted_sram_0_avalonS;
  input            cpu_0_data_master_granted_uart_0_s1;
  input            cpu_0_data_master_qualified_request_KEY_s1;
  input            cpu_0_data_master_qualified_request_LEDG_s1;
  input            cpu_0_data_master_qualified_request_LEDR_s1;
  input            cpu_0_data_master_qualified_request_SEG7_avalonS;
  input            cpu_0_data_master_qualified_request_Switch_s1;
  input            cpu_0_data_master_qualified_request_cfi_flash_0_s1;
  input            cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port;
  input            cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  input            cpu_0_data_master_qualified_request_sdram_0_s1;
  input            cpu_0_data_master_qualified_request_sram_0_avalonS;
  input            cpu_0_data_master_qualified_request_uart_0_s1;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_read_data_valid_KEY_s1;
  input            cpu_0_data_master_read_data_valid_LEDG_s1;
  input            cpu_0_data_master_read_data_valid_LEDR_s1;
  input            cpu_0_data_master_read_data_valid_SEG7_avalonS;
  input            cpu_0_data_master_read_data_valid_Switch_s1;
  input            cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  input            cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_read_data_valid_epcs_controller_epcs_control_port;
  input            cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1;
  input            cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_data_master_read_data_valid_sram_0_avalonS;
  input            cpu_0_data_master_read_data_valid_uart_0_s1;
  input            cpu_0_data_master_requests_KEY_s1;
  input            cpu_0_data_master_requests_LEDG_s1;
  input            cpu_0_data_master_requests_LEDR_s1;
  input            cpu_0_data_master_requests_SEG7_avalonS;
  input            cpu_0_data_master_requests_Switch_s1;
  input            cpu_0_data_master_requests_cfi_flash_0_s1;
  input            cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  input            cpu_0_data_master_requests_epcs_controller_epcs_control_port;
  input            cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  input            cpu_0_data_master_requests_sdram_0_s1;
  input            cpu_0_data_master_requests_sram_0_avalonS;
  input            cpu_0_data_master_requests_uart_0_s1;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input   [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  input            d1_KEY_s1_end_xfer;
  input            d1_LEDG_s1_end_xfer;
  input            d1_LEDR_s1_end_xfer;
  input            d1_SEG7_avalonS_end_xfer;
  input            d1_Switch_s1_end_xfer;
  input            d1_cpu_0_jtag_debug_module_end_xfer;
  input            d1_epcs_controller_epcs_control_port_end_xfer;
  input            d1_jtag_uart_0_avalon_jtag_slave_end_xfer;
  input            d1_sdram_0_s1_end_xfer;
  input            d1_sram_0_avalonS_end_xfer;
  input            d1_tri_state_bridge_0_avalon_slave_end_xfer;
  input            d1_uart_0_s1_end_xfer;
  input            epcs_controller_epcs_control_port_irq_from_sa;
  input   [ 31: 0] epcs_controller_epcs_control_port_readdata_from_sa;
  input   [  7: 0] incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;
  input            jtag_uart_0_avalon_jtag_slave_irq_from_sa;
  input   [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  input            jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  input            registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  input            reset_n;
  input   [ 15: 0] sdram_0_s1_readdata_from_sa;
  input            sdram_0_s1_waitrequest_from_sa;
  input   [ 15: 0] sram_0_avalonS_readdata_from_sa;
  input            sram_0_avalonS_wait_counter_eq_0;
  input            sram_0_avalonS_wait_counter_eq_1;
  input            uart_0_s1_irq_from_sa;
  input   [ 15: 0] uart_0_s1_readdata_from_sa;

  wire    [ 23: 0] cpu_0_data_master_address_to_slave;
  reg     [  1: 0] cpu_0_data_master_dbs_address;
  wire    [  1: 0] cpu_0_data_master_dbs_increment;
  wire    [ 15: 0] cpu_0_data_master_dbs_write_16;
  wire    [  7: 0] cpu_0_data_master_dbs_write_8;
  wire    [ 31: 0] cpu_0_data_master_irq;
  reg              cpu_0_data_master_no_byte_enables_and_last_term;
  wire    [ 31: 0] cpu_0_data_master_readdata;
  wire             cpu_0_data_master_run;
  reg              cpu_0_data_master_waitrequest;
  reg     [ 15: 0] dbs_16_reg_segment_0;
  reg     [  7: 0] dbs_8_reg_segment_0;
  reg     [  7: 0] dbs_8_reg_segment_1;
  reg     [  7: 0] dbs_8_reg_segment_2;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  wire             last_dbs_term_and_run;
  wire    [  1: 0] next_dbs_address;
  wire    [ 15: 0] p1_dbs_16_reg_segment_0;
  wire    [  7: 0] p1_dbs_8_reg_segment_0;
  wire    [  7: 0] p1_dbs_8_reg_segment_1;
  wire    [  7: 0] p1_dbs_8_reg_segment_2;
  wire    [ 31: 0] p1_registered_cpu_0_data_master_readdata;
  wire             pre_dbs_count_enable;
  wire             r_0;
  wire             r_1;
  wire             r_2;
  reg     [ 31: 0] registered_cpu_0_data_master_readdata;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (cpu_0_data_master_qualified_request_KEY_s1 | ~cpu_0_data_master_requests_KEY_s1) & ((~cpu_0_data_master_qualified_request_KEY_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_KEY_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_LEDG_s1 | ~cpu_0_data_master_requests_LEDG_s1) & ((~cpu_0_data_master_qualified_request_LEDG_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_LEDG_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_LEDR_s1 | ~cpu_0_data_master_requests_LEDR_s1) & ((~cpu_0_data_master_qualified_request_LEDR_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_LEDR_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_SEG7_avalonS | ~cpu_0_data_master_requests_SEG7_avalonS) & ((~cpu_0_data_master_qualified_request_SEG7_avalonS | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_SEG7_avalonS | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & ((~cpu_0_data_master_qualified_request_Switch_s1 | ~cpu_0_data_master_read | (1 & 1 & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_Switch_s1 | ~cpu_0_data_master_write | (1 & cpu_0_data_master_write))) & 1;

  //cascaded wait assignment, which is an e_assign
  assign cpu_0_data_master_run = r_0 & r_1 & r_2;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = (cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_data_master_requests_cpu_0_jtag_debug_module) & (cpu_0_data_master_granted_cpu_0_jtag_debug_module | ~cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module) & ((~cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & 1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & 1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port | ~cpu_0_data_master_requests_epcs_controller_epcs_control_port) & (cpu_0_data_master_granted_epcs_controller_epcs_control_port | ~cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port) & ((~cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & 1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & 1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave | ~cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave) & ((~cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & ~jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & ~jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa & (cpu_0_data_master_read | cpu_0_data_master_write)))) & 1 & (cpu_0_data_master_qualified_request_sdram_0_s1 | (cpu_0_data_master_read_data_valid_sdram_0_s1 & cpu_0_data_master_dbs_address[1]) | (cpu_0_data_master_write & !cpu_0_data_master_byteenable_sdram_0_s1 & cpu_0_data_master_dbs_address[1]) | ~cpu_0_data_master_requests_sdram_0_s1) & (cpu_0_data_master_granted_sdram_0_s1 | ~cpu_0_data_master_qualified_request_sdram_0_s1) & ((~cpu_0_data_master_qualified_request_sdram_0_s1 | ~cpu_0_data_master_read | (cpu_0_data_master_read_data_valid_sdram_0_s1 & (cpu_0_data_master_dbs_address[1]) & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_sdram_0_s1 | ~cpu_0_data_master_write | (1 & ~sdram_0_s1_waitrequest_from_sa & (cpu_0_data_master_dbs_address[1]) & cpu_0_data_master_write))) & 1 & (cpu_0_data_master_qualified_request_sram_0_avalonS | (cpu_0_data_master_write & !cpu_0_data_master_byteenable_sram_0_avalonS & cpu_0_data_master_dbs_address[1]) | ~cpu_0_data_master_requests_sram_0_avalonS);

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = (cpu_0_data_master_granted_sram_0_avalonS | ~cpu_0_data_master_qualified_request_sram_0_avalonS) & ((~cpu_0_data_master_qualified_request_sram_0_avalonS | ~cpu_0_data_master_read | (1 & sram_0_avalonS_wait_counter_eq_1 & (cpu_0_data_master_dbs_address[1]) & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_sram_0_avalonS | ~cpu_0_data_master_write | (1 & sram_0_avalonS_wait_counter_eq_1 & (cpu_0_data_master_dbs_address[1]) & cpu_0_data_master_write))) & 1 & ((cpu_0_data_master_qualified_request_cfi_flash_0_s1 | (registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1 & cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0]) | ((cpu_0_data_master_write & !cpu_0_data_master_byteenable_cfi_flash_0_s1 & cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0])) | ~cpu_0_data_master_requests_cfi_flash_0_s1)) & (cpu_0_data_master_granted_cfi_flash_0_s1 | ~cpu_0_data_master_qualified_request_cfi_flash_0_s1) & ((~cpu_0_data_master_qualified_request_cfi_flash_0_s1 | ~cpu_0_data_master_read | (registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1 & (cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0]) & cpu_0_data_master_read))) & ((~cpu_0_data_master_qualified_request_cfi_flash_0_s1 | ~cpu_0_data_master_write | (1 & cfi_flash_0_s1_wait_counter_eq_1 & (cpu_0_data_master_dbs_address[1] & cpu_0_data_master_dbs_address[0]) & cpu_0_data_master_write))) & 1 & ((~cpu_0_data_master_qualified_request_uart_0_s1 | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & 1 & (cpu_0_data_master_read | cpu_0_data_master_write)))) & ((~cpu_0_data_master_qualified_request_uart_0_s1 | ~(cpu_0_data_master_read | cpu_0_data_master_write) | (1 & 1 & (cpu_0_data_master_read | cpu_0_data_master_write))));

  //optimize select-logic by passing only those address bits which matter.
  assign cpu_0_data_master_address_to_slave = cpu_0_data_master_address[23 : 0];

  //cpu_0/data_master readdata mux, which is an e_mux
  assign cpu_0_data_master_readdata = ({32 {~cpu_0_data_master_requests_KEY_s1}} | KEY_s1_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_Switch_s1}} | Switch_s1_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_cpu_0_jtag_debug_module}} | cpu_0_jtag_debug_module_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_epcs_controller_epcs_control_port}} | epcs_controller_epcs_control_port_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave}} | registered_cpu_0_data_master_readdata) &
    ({32 {~cpu_0_data_master_requests_sdram_0_s1}} | registered_cpu_0_data_master_readdata) &
    ({32 {~cpu_0_data_master_requests_sram_0_avalonS}} | {sram_0_avalonS_readdata_from_sa[15 : 0],
    dbs_16_reg_segment_0}) &
    ({32 {~cpu_0_data_master_requests_cfi_flash_0_s1}} | {incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[7 : 0],
    dbs_8_reg_segment_2,
    dbs_8_reg_segment_1,
    dbs_8_reg_segment_0}) &
    ({32 {~cpu_0_data_master_requests_uart_0_s1}} | uart_0_s1_readdata_from_sa);

  //actual waitrequest port, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_waitrequest <= ~0;
      else if (1)
          cpu_0_data_master_waitrequest <= ~((~(cpu_0_data_master_read | cpu_0_data_master_write))? 0: (cpu_0_data_master_run & cpu_0_data_master_waitrequest));
    end


  //irq assign, which is an e_assign
  assign cpu_0_data_master_irq = {1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    KEY_s1_irq_from_sa,
    epcs_controller_epcs_control_port_irq_from_sa,
    uart_0_s1_irq_from_sa,
    jtag_uart_0_avalon_jtag_slave_irq_from_sa};

  //unpredictable registered wait state incoming data, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          registered_cpu_0_data_master_readdata <= 0;
      else if (1)
          registered_cpu_0_data_master_readdata <= p1_registered_cpu_0_data_master_readdata;
    end


  //registered readdata mux, which is an e_mux
  assign p1_registered_cpu_0_data_master_readdata = ({32 {~cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave}} | jtag_uart_0_avalon_jtag_slave_readdata_from_sa) &
    ({32 {~cpu_0_data_master_requests_sdram_0_s1}} | {sdram_0_s1_readdata_from_sa[15 : 0],
    dbs_16_reg_segment_0});

  //no_byte_enables_and_last_term, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_no_byte_enables_and_last_term <= 0;
      else if (1)
          cpu_0_data_master_no_byte_enables_and_last_term <= last_dbs_term_and_run;
    end


  //compute the last dbs term, which is an e_mux
  assign last_dbs_term_and_run = (cpu_0_data_master_requests_sdram_0_s1)? (((cpu_0_data_master_dbs_address == 2'b10) & cpu_0_data_master_write & !cpu_0_data_master_byteenable_sdram_0_s1)) :
    (cpu_0_data_master_requests_sram_0_avalonS)? (((cpu_0_data_master_dbs_address == 2'b10) & cpu_0_data_master_write & !cpu_0_data_master_byteenable_sram_0_avalonS)) :
    (((cpu_0_data_master_dbs_address == 2'b11) & cpu_0_data_master_write & !cpu_0_data_master_byteenable_cfi_flash_0_s1));

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = (((~cpu_0_data_master_no_byte_enables_and_last_term) & cpu_0_data_master_requests_sdram_0_s1 & cpu_0_data_master_write & !cpu_0_data_master_byteenable_sdram_0_s1)) |
    cpu_0_data_master_read_data_valid_sdram_0_s1 |
    (cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_write & 1 & 1 & ~sdram_0_s1_waitrequest_from_sa) |
    (((~cpu_0_data_master_no_byte_enables_and_last_term) & cpu_0_data_master_requests_sram_0_avalonS & cpu_0_data_master_write & !cpu_0_data_master_byteenable_sram_0_avalonS)) |
    ((cpu_0_data_master_granted_sram_0_avalonS & cpu_0_data_master_read & 1 & 1 & ({sram_0_avalonS_wait_counter_eq_0 & ~d1_sram_0_avalonS_end_xfer}))) |
    ((cpu_0_data_master_granted_sram_0_avalonS & cpu_0_data_master_write & 1 & 1 & ({sram_0_avalonS_wait_counter_eq_0 & ~d1_sram_0_avalonS_end_xfer}))) |
    (((~cpu_0_data_master_no_byte_enables_and_last_term) & cpu_0_data_master_requests_cfi_flash_0_s1 & cpu_0_data_master_write & !cpu_0_data_master_byteenable_cfi_flash_0_s1)) |
    cpu_0_data_master_read_data_valid_cfi_flash_0_s1 |
    ((cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_write & 1 & 1 & ({cfi_flash_0_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_0_avalon_slave_end_xfer})));

  //input to dbs-16 stored 0, which is an e_mux
  assign p1_dbs_16_reg_segment_0 = (cpu_0_data_master_requests_sdram_0_s1)? sdram_0_s1_readdata_from_sa :
    sram_0_avalonS_readdata_from_sa;

  //dbs register for dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_16_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((cpu_0_data_master_dbs_address[1]) == 0))
          dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
    end


  //mux write dbs 1, which is an e_mux
  assign cpu_0_data_master_dbs_write_16 = (cpu_0_data_master_dbs_address[1])? cpu_0_data_master_writedata[31 : 16] :
    (~(cpu_0_data_master_dbs_address[1]))? cpu_0_data_master_writedata[15 : 0] :
    (cpu_0_data_master_dbs_address[1])? cpu_0_data_master_writedata[31 : 16] :
    cpu_0_data_master_writedata[15 : 0];

  //dbs count increment, which is an e_mux
  assign cpu_0_data_master_dbs_increment = (cpu_0_data_master_requests_sdram_0_s1)? 2 :
    (cpu_0_data_master_requests_sram_0_avalonS)? 2 :
    (cpu_0_data_master_requests_cfi_flash_0_s1)? 1 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = cpu_0_data_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = cpu_0_data_master_dbs_address + cpu_0_data_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable &
    (~(cpu_0_data_master_requests_sdram_0_s1 & ~cpu_0_data_master_waitrequest));

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_dbs_address <= 0;
      else if (dbs_count_enable)
          cpu_0_data_master_dbs_address <= next_dbs_address;
    end


  //input to dbs-8 stored 0, which is an e_mux
  assign p1_dbs_8_reg_segment_0 = incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;

  //dbs register for dbs-8 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_8_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((cpu_0_data_master_dbs_address[1 : 0]) == 0))
          dbs_8_reg_segment_0 <= p1_dbs_8_reg_segment_0;
    end


  //input to dbs-8 stored 1, which is an e_mux
  assign p1_dbs_8_reg_segment_1 = incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;

  //dbs register for dbs-8 segment 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_8_reg_segment_1 <= 0;
      else if (dbs_count_enable & ((cpu_0_data_master_dbs_address[1 : 0]) == 1))
          dbs_8_reg_segment_1 <= p1_dbs_8_reg_segment_1;
    end


  //input to dbs-8 stored 2, which is an e_mux
  assign p1_dbs_8_reg_segment_2 = incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;

  //dbs register for dbs-8 segment 2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_8_reg_segment_2 <= 0;
      else if (dbs_count_enable & ((cpu_0_data_master_dbs_address[1 : 0]) == 2))
          dbs_8_reg_segment_2 <= p1_dbs_8_reg_segment_2;
    end


  //mux write dbs 2, which is an e_mux
  assign cpu_0_data_master_dbs_write_8 = ((cpu_0_data_master_dbs_address[1 : 0] == 0))? cpu_0_data_master_writedata[7 : 0] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 1))? cpu_0_data_master_writedata[15 : 8] :
    ((cpu_0_data_master_dbs_address[1 : 0] == 2))? cpu_0_data_master_writedata[23 : 16] :
    cpu_0_data_master_writedata[31 : 24];


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cpu_0_instruction_master_arbitrator (
                                             // inputs:
                                              cfi_flash_0_s1_wait_counter_eq_0,
                                              cfi_flash_0_s1_wait_counter_eq_1,
                                              clk,
                                              cpu_0_instruction_master_address,
                                              cpu_0_instruction_master_granted_cfi_flash_0_s1,
                                              cpu_0_instruction_master_granted_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_granted_epcs_controller_epcs_control_port,
                                              cpu_0_instruction_master_granted_sdram_0_s1,
                                              cpu_0_instruction_master_granted_sram_0_avalonS,
                                              cpu_0_instruction_master_qualified_request_cfi_flash_0_s1,
                                              cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port,
                                              cpu_0_instruction_master_qualified_request_sdram_0_s1,
                                              cpu_0_instruction_master_qualified_request_sram_0_avalonS,
                                              cpu_0_instruction_master_read,
                                              cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1,
                                              cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port,
                                              cpu_0_instruction_master_read_data_valid_sdram_0_s1,
                                              cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                              cpu_0_instruction_master_read_data_valid_sram_0_avalonS,
                                              cpu_0_instruction_master_requests_cfi_flash_0_s1,
                                              cpu_0_instruction_master_requests_cpu_0_jtag_debug_module,
                                              cpu_0_instruction_master_requests_epcs_controller_epcs_control_port,
                                              cpu_0_instruction_master_requests_sdram_0_s1,
                                              cpu_0_instruction_master_requests_sram_0_avalonS,
                                              cpu_0_jtag_debug_module_readdata_from_sa,
                                              d1_cpu_0_jtag_debug_module_end_xfer,
                                              d1_epcs_controller_epcs_control_port_end_xfer,
                                              d1_sdram_0_s1_end_xfer,
                                              d1_sram_0_avalonS_end_xfer,
                                              d1_tri_state_bridge_0_avalon_slave_end_xfer,
                                              epcs_controller_epcs_control_port_readdata_from_sa,
                                              incoming_tri_state_bridge_0_data,
                                              reset_n,
                                              sdram_0_s1_readdata_from_sa,
                                              sdram_0_s1_waitrequest_from_sa,
                                              sram_0_avalonS_readdata_from_sa,
                                              sram_0_avalonS_wait_counter_eq_0,
                                              sram_0_avalonS_wait_counter_eq_1,

                                             // outputs:
                                              cpu_0_instruction_master_address_to_slave,
                                              cpu_0_instruction_master_dbs_address,
                                              cpu_0_instruction_master_latency_counter,
                                              cpu_0_instruction_master_readdata,
                                              cpu_0_instruction_master_readdatavalid,
                                              cpu_0_instruction_master_waitrequest
                                           )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [ 23: 0] cpu_0_instruction_master_address_to_slave;
  output  [  1: 0] cpu_0_instruction_master_dbs_address;
  output  [  1: 0] cpu_0_instruction_master_latency_counter;
  output  [ 31: 0] cpu_0_instruction_master_readdata;
  output           cpu_0_instruction_master_readdatavalid;
  output           cpu_0_instruction_master_waitrequest;
  input            cfi_flash_0_s1_wait_counter_eq_0;
  input            cfi_flash_0_s1_wait_counter_eq_1;
  input            clk;
  input   [ 23: 0] cpu_0_instruction_master_address;
  input            cpu_0_instruction_master_granted_cfi_flash_0_s1;
  input            cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_granted_epcs_controller_epcs_control_port;
  input            cpu_0_instruction_master_granted_sdram_0_s1;
  input            cpu_0_instruction_master_granted_sram_0_avalonS;
  input            cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;
  input            cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port;
  input            cpu_0_instruction_master_qualified_request_sdram_0_s1;
  input            cpu_0_instruction_master_qualified_request_sram_0_avalonS;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;
  input            cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  input            cpu_0_instruction_master_read_data_valid_sram_0_avalonS;
  input            cpu_0_instruction_master_requests_cfi_flash_0_s1;
  input            cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  input            cpu_0_instruction_master_requests_epcs_controller_epcs_control_port;
  input            cpu_0_instruction_master_requests_sdram_0_s1;
  input            cpu_0_instruction_master_requests_sram_0_avalonS;
  input   [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  input            d1_cpu_0_jtag_debug_module_end_xfer;
  input            d1_epcs_controller_epcs_control_port_end_xfer;
  input            d1_sdram_0_s1_end_xfer;
  input            d1_sram_0_avalonS_end_xfer;
  input            d1_tri_state_bridge_0_avalon_slave_end_xfer;
  input   [ 31: 0] epcs_controller_epcs_control_port_readdata_from_sa;
  input   [  7: 0] incoming_tri_state_bridge_0_data;
  input            reset_n;
  input   [ 15: 0] sdram_0_s1_readdata_from_sa;
  input            sdram_0_s1_waitrequest_from_sa;
  input   [ 15: 0] sram_0_avalonS_readdata_from_sa;
  input            sram_0_avalonS_wait_counter_eq_0;
  input            sram_0_avalonS_wait_counter_eq_1;

  reg              active_and_waiting_last_time;
  reg     [ 23: 0] cpu_0_instruction_master_address_last_time;
  wire    [ 23: 0] cpu_0_instruction_master_address_to_slave;
  reg     [  1: 0] cpu_0_instruction_master_dbs_address;
  wire    [  1: 0] cpu_0_instruction_master_dbs_increment;
  reg     [  1: 0] cpu_0_instruction_master_dbs_rdv_counter;
  wire    [  1: 0] cpu_0_instruction_master_dbs_rdv_counter_inc;
  wire             cpu_0_instruction_master_is_granted_some_slave;
  reg     [  1: 0] cpu_0_instruction_master_latency_counter;
  wire    [  1: 0] cpu_0_instruction_master_next_dbs_rdv_counter;
  reg              cpu_0_instruction_master_read_but_no_slave_selected;
  reg              cpu_0_instruction_master_read_last_time;
  wire    [ 31: 0] cpu_0_instruction_master_readdata;
  wire             cpu_0_instruction_master_readdatavalid;
  wire             cpu_0_instruction_master_run;
  wire             cpu_0_instruction_master_waitrequest;
  reg     [ 15: 0] dbs_16_reg_segment_0;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [ 15: 0] dbs_latent_16_reg_segment_0;
  reg     [  7: 0] dbs_latent_8_reg_segment_0;
  reg     [  7: 0] dbs_latent_8_reg_segment_1;
  reg     [  7: 0] dbs_latent_8_reg_segment_2;
  wire             dbs_rdv_count_enable;
  wire             dbs_rdv_counter_overflow;
  wire    [  1: 0] latency_load_value;
  wire    [  1: 0] next_dbs_address;
  wire    [  1: 0] p1_cpu_0_instruction_master_latency_counter;
  wire    [ 15: 0] p1_dbs_16_reg_segment_0;
  wire    [ 15: 0] p1_dbs_latent_16_reg_segment_0;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_0;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_1;
  wire    [  7: 0] p1_dbs_latent_8_reg_segment_2;
  wire             pre_dbs_count_enable;
  wire             pre_flush_cpu_0_instruction_master_readdatavalid;
  wire             r_1;
  wire             r_2;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module | ~cpu_0_instruction_master_requests_cpu_0_jtag_debug_module) & (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module | ~cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module) & ((~cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module | ~(cpu_0_instruction_master_read) | (1 & ~d1_cpu_0_jtag_debug_module_end_xfer & (cpu_0_instruction_master_read)))) & 1 & (cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port | ~cpu_0_instruction_master_requests_epcs_controller_epcs_control_port) & (cpu_0_instruction_master_granted_epcs_controller_epcs_control_port | ~cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port) & ((~cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port | ~(cpu_0_instruction_master_read) | (1 & ~d1_epcs_controller_epcs_control_port_end_xfer & (cpu_0_instruction_master_read)))) & 1 & (cpu_0_instruction_master_qualified_request_sdram_0_s1 | ~cpu_0_instruction_master_requests_sdram_0_s1) & (cpu_0_instruction_master_granted_sdram_0_s1 | ~cpu_0_instruction_master_qualified_request_sdram_0_s1) & ((~cpu_0_instruction_master_qualified_request_sdram_0_s1 | ~cpu_0_instruction_master_read | (1 & ~sdram_0_s1_waitrequest_from_sa & (cpu_0_instruction_master_dbs_address[1]) & cpu_0_instruction_master_read)));

  //cascaded wait assignment, which is an e_assign
  assign cpu_0_instruction_master_run = r_1 & r_2;

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & (cpu_0_instruction_master_qualified_request_sram_0_avalonS | ~cpu_0_instruction_master_requests_sram_0_avalonS) & (cpu_0_instruction_master_granted_sram_0_avalonS | ~cpu_0_instruction_master_qualified_request_sram_0_avalonS) & ((~cpu_0_instruction_master_qualified_request_sram_0_avalonS | ~cpu_0_instruction_master_read | (1 & ((sram_0_avalonS_wait_counter_eq_0 & ~d1_sram_0_avalonS_end_xfer)) & (cpu_0_instruction_master_dbs_address[1]) & cpu_0_instruction_master_read))) & 1 & (cpu_0_instruction_master_qualified_request_cfi_flash_0_s1 | ~cpu_0_instruction_master_requests_cfi_flash_0_s1) & (cpu_0_instruction_master_granted_cfi_flash_0_s1 | ~cpu_0_instruction_master_qualified_request_cfi_flash_0_s1) & ((~cpu_0_instruction_master_qualified_request_cfi_flash_0_s1 | ~cpu_0_instruction_master_read | (1 & ((cfi_flash_0_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_0_avalon_slave_end_xfer)) & (cpu_0_instruction_master_dbs_address[1] & cpu_0_instruction_master_dbs_address[0]) & cpu_0_instruction_master_read)));

  //optimize select-logic by passing only those address bits which matter.
  assign cpu_0_instruction_master_address_to_slave = cpu_0_instruction_master_address[23 : 0];

  //cpu_0_instruction_master_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_read_but_no_slave_selected <= 0;
      else if (1)
          cpu_0_instruction_master_read_but_no_slave_selected <= cpu_0_instruction_master_read & cpu_0_instruction_master_run & ~cpu_0_instruction_master_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign cpu_0_instruction_master_is_granted_some_slave = cpu_0_instruction_master_granted_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_granted_epcs_controller_epcs_control_port |
    cpu_0_instruction_master_granted_sdram_0_s1 |
    cpu_0_instruction_master_granted_sram_0_avalonS |
    cpu_0_instruction_master_granted_cfi_flash_0_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_cpu_0_instruction_master_readdatavalid = (cpu_0_instruction_master_read_data_valid_sdram_0_s1 & dbs_rdv_counter_overflow) |
    (cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1 & dbs_rdv_counter_overflow);

  //latent slave read data valid which is not flushed, which is an e_mux
  assign cpu_0_instruction_master_readdatavalid = cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid |
    cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module |
    cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid |
    cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port |
    cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid |
    cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid |
    (cpu_0_instruction_master_read_data_valid_sram_0_avalonS & dbs_counter_overflow) |
    cpu_0_instruction_master_read_but_no_slave_selected |
    pre_flush_cpu_0_instruction_master_readdatavalid;

  //cpu_0/instruction_master readdata mux, which is an e_mux
  assign cpu_0_instruction_master_readdata = ({32 {~cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module}} | cpu_0_jtag_debug_module_readdata_from_sa) &
    ({32 {~cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port}} | epcs_controller_epcs_control_port_readdata_from_sa) &
    ({32 {~cpu_0_instruction_master_read_data_valid_sdram_0_s1}} | {sdram_0_s1_readdata_from_sa[15 : 0],
    dbs_latent_16_reg_segment_0}) &
    ({32 {~cpu_0_instruction_master_qualified_request_sram_0_avalonS}} | {sram_0_avalonS_readdata_from_sa[15 : 0],
    dbs_16_reg_segment_0}) &
    ({32 {~cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1}} | {incoming_tri_state_bridge_0_data[7 : 0],
    dbs_latent_8_reg_segment_2,
    dbs_latent_8_reg_segment_1,
    dbs_latent_8_reg_segment_0});

  //actual waitrequest port, which is an e_assign
  assign cpu_0_instruction_master_waitrequest = ~cpu_0_instruction_master_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_latency_counter <= 0;
      else if (1)
          cpu_0_instruction_master_latency_counter <= p1_cpu_0_instruction_master_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_cpu_0_instruction_master_latency_counter = ((cpu_0_instruction_master_run & cpu_0_instruction_master_read))? latency_load_value :
    (cpu_0_instruction_master_latency_counter)? cpu_0_instruction_master_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = {2 {cpu_0_instruction_master_requests_cfi_flash_0_s1}} & 2;

  //input to latent dbs-16 stored 0, which is an e_mux
  assign p1_dbs_latent_16_reg_segment_0 = sdram_0_s1_readdata_from_sa;

  //dbs register for latent dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_16_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_instruction_master_dbs_rdv_counter[1]) == 0))
          dbs_latent_16_reg_segment_0 <= p1_dbs_latent_16_reg_segment_0;
    end


  //dbs count increment, which is an e_mux
  assign cpu_0_instruction_master_dbs_increment = (cpu_0_instruction_master_requests_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_requests_sram_0_avalonS)? 2 :
    (cpu_0_instruction_master_requests_cfi_flash_0_s1)? 1 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = cpu_0_instruction_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = cpu_0_instruction_master_dbs_address + cpu_0_instruction_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_dbs_address <= 0;
      else if (dbs_count_enable)
          cpu_0_instruction_master_dbs_address <= next_dbs_address;
    end


  //p1 dbs rdv counter, which is an e_assign
  assign cpu_0_instruction_master_next_dbs_rdv_counter = cpu_0_instruction_master_dbs_rdv_counter + cpu_0_instruction_master_dbs_rdv_counter_inc;

  //cpu_0_instruction_master_rdv_inc_mux, which is an e_mux
  assign cpu_0_instruction_master_dbs_rdv_counter_inc = (cpu_0_instruction_master_read_data_valid_sdram_0_s1)? 2 :
    1;

  //master any slave rdv, which is an e_mux
  assign dbs_rdv_count_enable = cpu_0_instruction_master_read_data_valid_sdram_0_s1 |
    cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;

  //dbs rdv counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_dbs_rdv_counter <= 0;
      else if (dbs_rdv_count_enable)
          cpu_0_instruction_master_dbs_rdv_counter <= cpu_0_instruction_master_next_dbs_rdv_counter;
    end


  //dbs rdv counter overflow, which is an e_assign
  assign dbs_rdv_counter_overflow = cpu_0_instruction_master_dbs_rdv_counter[1] & ~cpu_0_instruction_master_next_dbs_rdv_counter[1];

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = (cpu_0_instruction_master_granted_sdram_0_s1 & cpu_0_instruction_master_read & 1 & 1 & ~sdram_0_s1_waitrequest_from_sa) |
    ((cpu_0_instruction_master_granted_sram_0_avalonS & cpu_0_instruction_master_read & 1 & 1 & ({sram_0_avalonS_wait_counter_eq_0 & ~d1_sram_0_avalonS_end_xfer}))) |
    ((cpu_0_instruction_master_granted_cfi_flash_0_s1 & cpu_0_instruction_master_read & 1 & 1 & ({cfi_flash_0_s1_wait_counter_eq_0 & ~d1_tri_state_bridge_0_avalon_slave_end_xfer})));

  //input to dbs-16 stored 0, which is an e_mux
  assign p1_dbs_16_reg_segment_0 = sram_0_avalonS_readdata_from_sa;

  //dbs register for dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_16_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((cpu_0_instruction_master_dbs_address[1]) == 0))
          dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
    end


  //input to latent dbs-8 stored 0, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_0 = incoming_tri_state_bridge_0_data;

  //dbs register for latent dbs-8 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_instruction_master_dbs_rdv_counter[1 : 0]) == 0))
          dbs_latent_8_reg_segment_0 <= p1_dbs_latent_8_reg_segment_0;
    end


  //input to latent dbs-8 stored 1, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_1 = incoming_tri_state_bridge_0_data;

  //dbs register for latent dbs-8 segment 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_1 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_instruction_master_dbs_rdv_counter[1 : 0]) == 1))
          dbs_latent_8_reg_segment_1 <= p1_dbs_latent_8_reg_segment_1;
    end


  //input to latent dbs-8 stored 2, which is an e_mux
  assign p1_dbs_latent_8_reg_segment_2 = incoming_tri_state_bridge_0_data;

  //dbs register for latent dbs-8 segment 2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_8_reg_segment_2 <= 0;
      else if (dbs_rdv_count_enable & ((cpu_0_instruction_master_dbs_rdv_counter[1 : 0]) == 2))
          dbs_latent_8_reg_segment_2 <= p1_dbs_latent_8_reg_segment_2;
    end



//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //cpu_0_instruction_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_address_last_time <= 0;
      else if (1)
          cpu_0_instruction_master_address_last_time <= cpu_0_instruction_master_address;
    end


  //cpu_0/instruction_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else if (1)
          active_and_waiting_last_time <= cpu_0_instruction_master_waitrequest & (cpu_0_instruction_master_read);
    end


  //cpu_0_instruction_master_address matches last port_name, which is an e_process
  always @(active_and_waiting_last_time or cpu_0_instruction_master_address or cpu_0_instruction_master_address_last_time)
    begin
      if (active_and_waiting_last_time & (cpu_0_instruction_master_address != cpu_0_instruction_master_address_last_time))
        begin
          $write("%0d ns: cpu_0_instruction_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //cpu_0_instruction_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_read_last_time <= 0;
      else if (1)
          cpu_0_instruction_master_read_last_time <= cpu_0_instruction_master_read;
    end


  //cpu_0_instruction_master_read matches last port_name, which is an e_process
  always @(active_and_waiting_last_time or cpu_0_instruction_master_read or cpu_0_instruction_master_read_last_time)
    begin
      if (active_and_waiting_last_time & (cpu_0_instruction_master_read != cpu_0_instruction_master_read_last_time))
        begin
          $write("%0d ns: cpu_0_instruction_master_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module epcs_controller_epcs_control_port_arbitrator (
                                                      // inputs:
                                                       clk,
                                                       cpu_0_data_master_address_to_slave,
                                                       cpu_0_data_master_read,
                                                       cpu_0_data_master_write,
                                                       cpu_0_data_master_writedata,
                                                       cpu_0_instruction_master_address_to_slave,
                                                       cpu_0_instruction_master_latency_counter,
                                                       cpu_0_instruction_master_read,
                                                       cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                                       epcs_controller_epcs_control_port_dataavailable,
                                                       epcs_controller_epcs_control_port_endofpacket,
                                                       epcs_controller_epcs_control_port_irq,
                                                       epcs_controller_epcs_control_port_readdata,
                                                       epcs_controller_epcs_control_port_readyfordata,
                                                       reset_n,

                                                      // outputs:
                                                       cpu_0_data_master_granted_epcs_controller_epcs_control_port,
                                                       cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port,
                                                       cpu_0_data_master_read_data_valid_epcs_controller_epcs_control_port,
                                                       cpu_0_data_master_requests_epcs_controller_epcs_control_port,
                                                       cpu_0_instruction_master_granted_epcs_controller_epcs_control_port,
                                                       cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port,
                                                       cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port,
                                                       cpu_0_instruction_master_requests_epcs_controller_epcs_control_port,
                                                       d1_epcs_controller_epcs_control_port_end_xfer,
                                                       epcs_controller_epcs_control_port_address,
                                                       epcs_controller_epcs_control_port_chipselect,
                                                       epcs_controller_epcs_control_port_dataavailable_from_sa,
                                                       epcs_controller_epcs_control_port_endofpacket_from_sa,
                                                       epcs_controller_epcs_control_port_irq_from_sa,
                                                       epcs_controller_epcs_control_port_read_n,
                                                       epcs_controller_epcs_control_port_readdata_from_sa,
                                                       epcs_controller_epcs_control_port_readyfordata_from_sa,
                                                       epcs_controller_epcs_control_port_reset_n,
                                                       epcs_controller_epcs_control_port_write_n,
                                                       epcs_controller_epcs_control_port_writedata
                                                    )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output           cpu_0_data_master_granted_epcs_controller_epcs_control_port;
  output           cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port;
  output           cpu_0_data_master_read_data_valid_epcs_controller_epcs_control_port;
  output           cpu_0_data_master_requests_epcs_controller_epcs_control_port;
  output           cpu_0_instruction_master_granted_epcs_controller_epcs_control_port;
  output           cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port;
  output           cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port;
  output           cpu_0_instruction_master_requests_epcs_controller_epcs_control_port;
  output           d1_epcs_controller_epcs_control_port_end_xfer;
  output  [  8: 0] epcs_controller_epcs_control_port_address;
  output           epcs_controller_epcs_control_port_chipselect;
  output           epcs_controller_epcs_control_port_dataavailable_from_sa;
  output           epcs_controller_epcs_control_port_endofpacket_from_sa;
  output           epcs_controller_epcs_control_port_irq_from_sa;
  output           epcs_controller_epcs_control_port_read_n;
  output  [ 31: 0] epcs_controller_epcs_control_port_readdata_from_sa;
  output           epcs_controller_epcs_control_port_readyfordata_from_sa;
  output           epcs_controller_epcs_control_port_reset_n;
  output           epcs_controller_epcs_control_port_write_n;
  output  [ 31: 0] epcs_controller_epcs_control_port_writedata;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input   [ 23: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  input            epcs_controller_epcs_control_port_dataavailable;
  input            epcs_controller_epcs_control_port_endofpacket;
  input            epcs_controller_epcs_control_port_irq;
  input   [ 31: 0] epcs_controller_epcs_control_port_readdata;
  input            epcs_controller_epcs_control_port_readyfordata;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_epcs_controller_epcs_control_port;
  wire             cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port;
  wire             cpu_0_data_master_read_data_valid_epcs_controller_epcs_control_port;
  wire             cpu_0_data_master_requests_epcs_controller_epcs_control_port;
  wire             cpu_0_data_master_saved_grant_epcs_controller_epcs_control_port;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_epcs_controller_epcs_control_port;
  wire             cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port;
  wire             cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port;
  wire             cpu_0_instruction_master_requests_epcs_controller_epcs_control_port;
  wire             cpu_0_instruction_master_saved_grant_epcs_controller_epcs_control_port;
  reg              d1_epcs_controller_epcs_control_port_end_xfer;
  reg              d1_reasons_to_wait;
  wire    [  8: 0] epcs_controller_epcs_control_port_address;
  wire             epcs_controller_epcs_control_port_allgrants;
  wire             epcs_controller_epcs_control_port_allow_new_arb_cycle;
  wire             epcs_controller_epcs_control_port_any_continuerequest;
  reg     [  1: 0] epcs_controller_epcs_control_port_arb_addend;
  wire             epcs_controller_epcs_control_port_arb_counter_enable;
  reg     [  2: 0] epcs_controller_epcs_control_port_arb_share_counter;
  wire    [  2: 0] epcs_controller_epcs_control_port_arb_share_counter_next_value;
  wire    [  2: 0] epcs_controller_epcs_control_port_arb_share_set_values;
  wire    [  1: 0] epcs_controller_epcs_control_port_arb_winner;
  wire             epcs_controller_epcs_control_port_arbitration_holdoff_internal;
  wire             epcs_controller_epcs_control_port_beginbursttransfer_internal;
  wire             epcs_controller_epcs_control_port_begins_xfer;
  wire             epcs_controller_epcs_control_port_chipselect;
  wire    [  3: 0] epcs_controller_epcs_control_port_chosen_master_double_vector;
  wire    [  1: 0] epcs_controller_epcs_control_port_chosen_master_rot_left;
  wire             epcs_controller_epcs_control_port_dataavailable_from_sa;
  wire             epcs_controller_epcs_control_port_end_xfer;
  wire             epcs_controller_epcs_control_port_endofpacket_from_sa;
  wire             epcs_controller_epcs_control_port_firsttransfer;
  wire    [  1: 0] epcs_controller_epcs_control_port_grant_vector;
  wire             epcs_controller_epcs_control_port_in_a_read_cycle;
  wire             epcs_controller_epcs_control_port_in_a_write_cycle;
  wire             epcs_controller_epcs_control_port_irq_from_sa;
  wire    [  1: 0] epcs_controller_epcs_control_port_master_qreq_vector;
  wire             epcs_controller_epcs_control_port_non_bursting_master_requests;
  wire             epcs_controller_epcs_control_port_read_n;
  wire    [ 31: 0] epcs_controller_epcs_control_port_readdata_from_sa;
  wire             epcs_controller_epcs_control_port_readyfordata_from_sa;
  wire             epcs_controller_epcs_control_port_reset_n;
  reg     [  1: 0] epcs_controller_epcs_control_port_saved_chosen_master_vector;
  reg              epcs_controller_epcs_control_port_slavearbiterlockenable;
  wire             epcs_controller_epcs_control_port_slavearbiterlockenable2;
  wire             epcs_controller_epcs_control_port_waits_for_read;
  wire             epcs_controller_epcs_control_port_waits_for_write;
  wire             epcs_controller_epcs_control_port_write_n;
  wire    [ 31: 0] epcs_controller_epcs_control_port_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_0_data_master_granted_slave_epcs_controller_epcs_control_port;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_epcs_controller_epcs_control_port;
  wire             wait_for_epcs_controller_epcs_control_port_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~epcs_controller_epcs_control_port_end_xfer;
    end


  assign epcs_controller_epcs_control_port_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port | cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port));
  //assign epcs_controller_epcs_control_port_readdata_from_sa = epcs_controller_epcs_control_port_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_controller_epcs_control_port_readdata_from_sa = epcs_controller_epcs_control_port_readdata;

  assign cpu_0_data_master_requests_epcs_controller_epcs_control_port = ({cpu_0_data_master_address_to_slave[23 : 11] , 11'b0} == 24'h480800) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign epcs_controller_epcs_control_port_dataavailable_from_sa = epcs_controller_epcs_control_port_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_controller_epcs_control_port_dataavailable_from_sa = epcs_controller_epcs_control_port_dataavailable;

  //assign epcs_controller_epcs_control_port_readyfordata_from_sa = epcs_controller_epcs_control_port_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_controller_epcs_control_port_readyfordata_from_sa = epcs_controller_epcs_control_port_readyfordata;

  //epcs_controller_epcs_control_port_arb_share_counter set values, which is an e_mux
  assign epcs_controller_epcs_control_port_arb_share_set_values = 1;

  //epcs_controller_epcs_control_port_non_bursting_master_requests mux, which is an e_mux
  assign epcs_controller_epcs_control_port_non_bursting_master_requests = cpu_0_data_master_requests_epcs_controller_epcs_control_port |
    cpu_0_instruction_master_requests_epcs_controller_epcs_control_port |
    cpu_0_data_master_requests_epcs_controller_epcs_control_port |
    cpu_0_instruction_master_requests_epcs_controller_epcs_control_port;

  //epcs_controller_epcs_control_port_arb_share_counter_next_value assignment, which is an e_assign
  assign epcs_controller_epcs_control_port_arb_share_counter_next_value = epcs_controller_epcs_control_port_firsttransfer ? (epcs_controller_epcs_control_port_arb_share_set_values - 1) : |epcs_controller_epcs_control_port_arb_share_counter ? (epcs_controller_epcs_control_port_arb_share_counter - 1) : 0;

  //epcs_controller_epcs_control_port_allgrants all slave grants, which is an e_mux
  assign epcs_controller_epcs_control_port_allgrants = |epcs_controller_epcs_control_port_grant_vector |
    |epcs_controller_epcs_control_port_grant_vector |
    |epcs_controller_epcs_control_port_grant_vector |
    |epcs_controller_epcs_control_port_grant_vector;

  //epcs_controller_epcs_control_port_end_xfer assignment, which is an e_assign
  assign epcs_controller_epcs_control_port_end_xfer = ~(epcs_controller_epcs_control_port_waits_for_read | epcs_controller_epcs_control_port_waits_for_write);

  //epcs_controller_epcs_control_port_arb_share_counter arbitration counter enable, which is an e_assign
  assign epcs_controller_epcs_control_port_arb_counter_enable = (epcs_controller_epcs_control_port_end_xfer & epcs_controller_epcs_control_port_allgrants) | (epcs_controller_epcs_control_port_end_xfer & ~epcs_controller_epcs_control_port_non_bursting_master_requests);

  //epcs_controller_epcs_control_port_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_controller_epcs_control_port_arb_share_counter <= 0;
      else if (epcs_controller_epcs_control_port_arb_counter_enable)
          epcs_controller_epcs_control_port_arb_share_counter <= epcs_controller_epcs_control_port_arb_share_counter_next_value;
    end


  //epcs_controller_epcs_control_port_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_controller_epcs_control_port_slavearbiterlockenable <= 0;
      else if ((|epcs_controller_epcs_control_port_master_qreq_vector & epcs_controller_epcs_control_port_end_xfer) | (epcs_controller_epcs_control_port_end_xfer & ~epcs_controller_epcs_control_port_non_bursting_master_requests))
          epcs_controller_epcs_control_port_slavearbiterlockenable <= |epcs_controller_epcs_control_port_arb_share_counter_next_value;
    end


  //cpu_0/data_master epcs_controller/epcs_control_port arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = epcs_controller_epcs_control_port_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //epcs_controller_epcs_control_port_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign epcs_controller_epcs_control_port_slavearbiterlockenable2 = |epcs_controller_epcs_control_port_arb_share_counter_next_value;

  //cpu_0/data_master epcs_controller/epcs_control_port arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = epcs_controller_epcs_control_port_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master epcs_controller/epcs_control_port arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = epcs_controller_epcs_control_port_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master epcs_controller/epcs_control_port arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = epcs_controller_epcs_control_port_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted epcs_controller/epcs_control_port last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_epcs_controller_epcs_control_port <= 0;
      else if (1)
          last_cycle_cpu_0_instruction_master_granted_slave_epcs_controller_epcs_control_port <= cpu_0_instruction_master_saved_grant_epcs_controller_epcs_control_port ? 1 : (epcs_controller_epcs_control_port_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_epcs_controller_epcs_control_port) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_epcs_controller_epcs_control_port;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = last_cycle_cpu_0_instruction_master_granted_slave_epcs_controller_epcs_control_port & cpu_0_instruction_master_requests_epcs_controller_epcs_control_port;

  //epcs_controller_epcs_control_port_any_continuerequest at least one master continues requesting, which is an e_mux
  assign epcs_controller_epcs_control_port_any_continuerequest = cpu_0_instruction_master_continuerequest |
    cpu_0_data_master_continuerequest;

  assign cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port = cpu_0_data_master_requests_epcs_controller_epcs_control_port & ~(cpu_0_instruction_master_arbiterlock);
  //epcs_controller_epcs_control_port_writedata mux, which is an e_mux
  assign epcs_controller_epcs_control_port_writedata = cpu_0_data_master_writedata;

  //assign epcs_controller_epcs_control_port_endofpacket_from_sa = epcs_controller_epcs_control_port_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_controller_epcs_control_port_endofpacket_from_sa = epcs_controller_epcs_control_port_endofpacket;

  assign cpu_0_instruction_master_requests_epcs_controller_epcs_control_port = (({cpu_0_instruction_master_address_to_slave[23 : 11] , 11'b0} == 24'h480800) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted epcs_controller/epcs_control_port last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_epcs_controller_epcs_control_port <= 0;
      else if (1)
          last_cycle_cpu_0_data_master_granted_slave_epcs_controller_epcs_control_port <= cpu_0_data_master_saved_grant_epcs_controller_epcs_control_port ? 1 : (epcs_controller_epcs_control_port_arbitration_holdoff_internal | ~cpu_0_data_master_requests_epcs_controller_epcs_control_port) ? 0 : last_cycle_cpu_0_data_master_granted_slave_epcs_controller_epcs_control_port;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = last_cycle_cpu_0_data_master_granted_slave_epcs_controller_epcs_control_port & cpu_0_data_master_requests_epcs_controller_epcs_control_port;

  assign cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port = cpu_0_instruction_master_requests_epcs_controller_epcs_control_port & ~((cpu_0_instruction_master_read & ((cpu_0_instruction_master_latency_counter != 0) | (|cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register))) | cpu_0_data_master_arbiterlock);
  //local readdatavalid cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port = cpu_0_instruction_master_granted_epcs_controller_epcs_control_port & cpu_0_instruction_master_read & ~epcs_controller_epcs_control_port_waits_for_read;

  //allow new arb cycle for epcs_controller/epcs_control_port, which is an e_assign
  assign epcs_controller_epcs_control_port_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock;

  //cpu_0/instruction_master assignment into master qualified-requests vector for epcs_controller/epcs_control_port, which is an e_assign
  assign epcs_controller_epcs_control_port_master_qreq_vector[0] = cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port;

  //cpu_0/instruction_master grant epcs_controller/epcs_control_port, which is an e_assign
  assign cpu_0_instruction_master_granted_epcs_controller_epcs_control_port = epcs_controller_epcs_control_port_grant_vector[0];

  //cpu_0/instruction_master saved-grant epcs_controller/epcs_control_port, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_epcs_controller_epcs_control_port = epcs_controller_epcs_control_port_arb_winner[0] && cpu_0_instruction_master_requests_epcs_controller_epcs_control_port;

  //cpu_0/data_master assignment into master qualified-requests vector for epcs_controller/epcs_control_port, which is an e_assign
  assign epcs_controller_epcs_control_port_master_qreq_vector[1] = cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port;

  //cpu_0/data_master grant epcs_controller/epcs_control_port, which is an e_assign
  assign cpu_0_data_master_granted_epcs_controller_epcs_control_port = epcs_controller_epcs_control_port_grant_vector[1];

  //cpu_0/data_master saved-grant epcs_controller/epcs_control_port, which is an e_assign
  assign cpu_0_data_master_saved_grant_epcs_controller_epcs_control_port = epcs_controller_epcs_control_port_arb_winner[1] && cpu_0_data_master_requests_epcs_controller_epcs_control_port;

  //epcs_controller/epcs_control_port chosen-master double-vector, which is an e_assign
  assign epcs_controller_epcs_control_port_chosen_master_double_vector = {epcs_controller_epcs_control_port_master_qreq_vector, epcs_controller_epcs_control_port_master_qreq_vector} & ({~epcs_controller_epcs_control_port_master_qreq_vector, ~epcs_controller_epcs_control_port_master_qreq_vector} + epcs_controller_epcs_control_port_arb_addend);

  //stable onehot encoding of arb winner
  assign epcs_controller_epcs_control_port_arb_winner = (epcs_controller_epcs_control_port_allow_new_arb_cycle & | epcs_controller_epcs_control_port_grant_vector) ? epcs_controller_epcs_control_port_grant_vector : epcs_controller_epcs_control_port_saved_chosen_master_vector;

  //saved epcs_controller_epcs_control_port_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_controller_epcs_control_port_saved_chosen_master_vector <= 0;
      else if (epcs_controller_epcs_control_port_allow_new_arb_cycle)
          epcs_controller_epcs_control_port_saved_chosen_master_vector <= |epcs_controller_epcs_control_port_grant_vector ? epcs_controller_epcs_control_port_grant_vector : epcs_controller_epcs_control_port_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign epcs_controller_epcs_control_port_grant_vector = {(epcs_controller_epcs_control_port_chosen_master_double_vector[1] | epcs_controller_epcs_control_port_chosen_master_double_vector[3]),
    (epcs_controller_epcs_control_port_chosen_master_double_vector[0] | epcs_controller_epcs_control_port_chosen_master_double_vector[2])};

  //epcs_controller/epcs_control_port chosen master rotated left, which is an e_assign
  assign epcs_controller_epcs_control_port_chosen_master_rot_left = (epcs_controller_epcs_control_port_arb_winner << 1) ? (epcs_controller_epcs_control_port_arb_winner << 1) : 1;

  //epcs_controller/epcs_control_port's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_controller_epcs_control_port_arb_addend <= 1;
      else if (|epcs_controller_epcs_control_port_grant_vector)
          epcs_controller_epcs_control_port_arb_addend <= epcs_controller_epcs_control_port_end_xfer? epcs_controller_epcs_control_port_chosen_master_rot_left : epcs_controller_epcs_control_port_grant_vector;
    end


  //epcs_controller_epcs_control_port_reset_n assignment, which is an e_assign
  assign epcs_controller_epcs_control_port_reset_n = reset_n;

  assign epcs_controller_epcs_control_port_chipselect = cpu_0_data_master_granted_epcs_controller_epcs_control_port | cpu_0_instruction_master_granted_epcs_controller_epcs_control_port;
  //epcs_controller_epcs_control_port_firsttransfer first transaction, which is an e_assign
  assign epcs_controller_epcs_control_port_firsttransfer = ~(epcs_controller_epcs_control_port_slavearbiterlockenable & epcs_controller_epcs_control_port_any_continuerequest);

  //epcs_controller_epcs_control_port_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign epcs_controller_epcs_control_port_beginbursttransfer_internal = epcs_controller_epcs_control_port_begins_xfer & epcs_controller_epcs_control_port_firsttransfer;

  //epcs_controller_epcs_control_port_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign epcs_controller_epcs_control_port_arbitration_holdoff_internal = epcs_controller_epcs_control_port_begins_xfer & epcs_controller_epcs_control_port_firsttransfer;

  //~epcs_controller_epcs_control_port_read_n assignment, which is an e_mux
  assign epcs_controller_epcs_control_port_read_n = ~((cpu_0_data_master_granted_epcs_controller_epcs_control_port & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_epcs_controller_epcs_control_port & cpu_0_instruction_master_read));

  //~epcs_controller_epcs_control_port_write_n assignment, which is an e_mux
  assign epcs_controller_epcs_control_port_write_n = ~(cpu_0_data_master_granted_epcs_controller_epcs_control_port & cpu_0_data_master_write);

  //epcs_controller_epcs_control_port_address mux, which is an e_mux
  assign epcs_controller_epcs_control_port_address = (cpu_0_data_master_granted_epcs_controller_epcs_control_port)? (cpu_0_data_master_address_to_slave >> 2) :
    (cpu_0_instruction_master_address_to_slave >> 2);

  //d1_epcs_controller_epcs_control_port_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_epcs_controller_epcs_control_port_end_xfer <= 1;
      else if (1)
          d1_epcs_controller_epcs_control_port_end_xfer <= epcs_controller_epcs_control_port_end_xfer;
    end


  //epcs_controller_epcs_control_port_waits_for_read in a cycle, which is an e_mux
  assign epcs_controller_epcs_control_port_waits_for_read = epcs_controller_epcs_control_port_in_a_read_cycle & epcs_controller_epcs_control_port_begins_xfer;

  //epcs_controller_epcs_control_port_in_a_read_cycle assignment, which is an e_assign
  assign epcs_controller_epcs_control_port_in_a_read_cycle = (cpu_0_data_master_granted_epcs_controller_epcs_control_port & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_epcs_controller_epcs_control_port & cpu_0_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = epcs_controller_epcs_control_port_in_a_read_cycle;

  //epcs_controller_epcs_control_port_waits_for_write in a cycle, which is an e_mux
  assign epcs_controller_epcs_control_port_waits_for_write = epcs_controller_epcs_control_port_in_a_write_cycle & epcs_controller_epcs_control_port_begins_xfer;

  //epcs_controller_epcs_control_port_in_a_write_cycle assignment, which is an e_assign
  assign epcs_controller_epcs_control_port_in_a_write_cycle = cpu_0_data_master_granted_epcs_controller_epcs_control_port & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = epcs_controller_epcs_control_port_in_a_write_cycle;

  assign wait_for_epcs_controller_epcs_control_port_counter = 0;
  //assign epcs_controller_epcs_control_port_irq_from_sa = epcs_controller_epcs_control_port_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_controller_epcs_control_port_irq_from_sa = epcs_controller_epcs_control_port_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_epcs_controller_epcs_control_port + cpu_0_instruction_master_granted_epcs_controller_epcs_control_port > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_epcs_controller_epcs_control_port + cpu_0_instruction_master_saved_grant_epcs_controller_epcs_control_port > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module jtag_uart_0_avalon_jtag_slave_arbitrator (
                                                  // inputs:
                                                   clk,
                                                   cpu_0_data_master_address_to_slave,
                                                   cpu_0_data_master_read,
                                                   cpu_0_data_master_waitrequest,
                                                   cpu_0_data_master_write,
                                                   cpu_0_data_master_writedata,
                                                   jtag_uart_0_avalon_jtag_slave_dataavailable,
                                                   jtag_uart_0_avalon_jtag_slave_irq,
                                                   jtag_uart_0_avalon_jtag_slave_readdata,
                                                   jtag_uart_0_avalon_jtag_slave_readyfordata,
                                                   jtag_uart_0_avalon_jtag_slave_waitrequest,
                                                   reset_n,

                                                  // outputs:
                                                   cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave,
                                                   cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave,
                                                   cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave,
                                                   cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave,
                                                   d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
                                                   jtag_uart_0_avalon_jtag_slave_address,
                                                   jtag_uart_0_avalon_jtag_slave_chipselect,
                                                   jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_irq_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_read_n,
                                                   jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_reset_n,
                                                   jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
                                                   jtag_uart_0_avalon_jtag_slave_write_n,
                                                   jtag_uart_0_avalon_jtag_slave_writedata
                                                )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output           cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  output           cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  output           cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave;
  output           cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  output           d1_jtag_uart_0_avalon_jtag_slave_end_xfer;
  output           jtag_uart_0_avalon_jtag_slave_address;
  output           jtag_uart_0_avalon_jtag_slave_chipselect;
  output           jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_irq_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_read_n;
  output  [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_reset_n;
  output           jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  output           jtag_uart_0_avalon_jtag_slave_write_n;
  output  [ 31: 0] jtag_uart_0_avalon_jtag_slave_writedata;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            jtag_uart_0_avalon_jtag_slave_dataavailable;
  input            jtag_uart_0_avalon_jtag_slave_irq;
  input   [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata;
  input            jtag_uart_0_avalon_jtag_slave_readyfordata;
  input            jtag_uart_0_avalon_jtag_slave_waitrequest;
  input            reset_n;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_saved_grant_jtag_uart_0_avalon_jtag_slave;
  reg              d1_jtag_uart_0_avalon_jtag_slave_end_xfer;
  reg              d1_reasons_to_wait;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             jtag_uart_0_avalon_jtag_slave_address;
  wire             jtag_uart_0_avalon_jtag_slave_allgrants;
  wire             jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle;
  wire             jtag_uart_0_avalon_jtag_slave_any_continuerequest;
  wire             jtag_uart_0_avalon_jtag_slave_arb_counter_enable;
  reg     [  2: 0] jtag_uart_0_avalon_jtag_slave_arb_share_counter;
  wire    [  2: 0] jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
  wire    [  2: 0] jtag_uart_0_avalon_jtag_slave_arb_share_set_values;
  wire             jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal;
  wire             jtag_uart_0_avalon_jtag_slave_begins_xfer;
  wire             jtag_uart_0_avalon_jtag_slave_chipselect;
  wire             jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_end_xfer;
  wire             jtag_uart_0_avalon_jtag_slave_firsttransfer;
  wire             jtag_uart_0_avalon_jtag_slave_grant_vector;
  wire             jtag_uart_0_avalon_jtag_slave_in_a_read_cycle;
  wire             jtag_uart_0_avalon_jtag_slave_in_a_write_cycle;
  wire             jtag_uart_0_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_master_qreq_vector;
  wire             jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests;
  wire             jtag_uart_0_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_reset_n;
  reg              jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable;
  wire             jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2;
  wire             jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_waits_for_read;
  wire             jtag_uart_0_avalon_jtag_slave_waits_for_write;
  wire             jtag_uart_0_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_writedata;
  wire             wait_for_jtag_uart_0_avalon_jtag_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~jtag_uart_0_avalon_jtag_slave_end_xfer;
    end


  assign jtag_uart_0_avalon_jtag_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave));
  //assign jtag_uart_0_avalon_jtag_slave_readdata_from_sa = jtag_uart_0_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_readdata_from_sa = jtag_uart_0_avalon_jtag_slave_readdata;

  assign cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave = ({cpu_0_data_master_address_to_slave[23 : 3] , 3'b0} == 24'h481060) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_0_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_0_avalon_jtag_slave_dataavailable;

  //assign jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_0_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_0_avalon_jtag_slave_readyfordata;

  //assign jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_0_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_0_avalon_jtag_slave_waitrequest;

  //jtag_uart_0_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_arb_share_set_values = 1;

  //jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests = cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;

  //jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value = jtag_uart_0_avalon_jtag_slave_firsttransfer ? (jtag_uart_0_avalon_jtag_slave_arb_share_set_values - 1) : |jtag_uart_0_avalon_jtag_slave_arb_share_counter ? (jtag_uart_0_avalon_jtag_slave_arb_share_counter - 1) : 0;

  //jtag_uart_0_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_allgrants = |jtag_uart_0_avalon_jtag_slave_grant_vector;

  //jtag_uart_0_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_end_xfer = ~(jtag_uart_0_avalon_jtag_slave_waits_for_read | jtag_uart_0_avalon_jtag_slave_waits_for_write);

  //jtag_uart_0_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_arb_counter_enable = (jtag_uart_0_avalon_jtag_slave_end_xfer & jtag_uart_0_avalon_jtag_slave_allgrants) | (jtag_uart_0_avalon_jtag_slave_end_xfer & ~jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests);

  //jtag_uart_0_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_0_avalon_jtag_slave_arb_share_counter <= 0;
      else if (jtag_uart_0_avalon_jtag_slave_arb_counter_enable)
          jtag_uart_0_avalon_jtag_slave_arb_share_counter <= jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= 0;
      else if ((|jtag_uart_0_avalon_jtag_slave_master_qreq_vector & jtag_uart_0_avalon_jtag_slave_end_xfer) | (jtag_uart_0_avalon_jtag_slave_end_xfer & ~jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests))
          jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= |jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master jtag_uart_0/avalon_jtag_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 = |jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;

  //cpu_0/data_master jtag_uart_0/avalon_jtag_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //jtag_uart_0_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave = cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave & ~((cpu_0_data_master_read & (~cpu_0_data_master_waitrequest)) | ((~cpu_0_data_master_waitrequest) & cpu_0_data_master_write));
  //jtag_uart_0_avalon_jtag_slave_writedata mux, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave = cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;

  //cpu_0/data_master saved-grant jtag_uart_0/avalon_jtag_slave, which is an e_assign
  assign cpu_0_data_master_saved_grant_jtag_uart_0_avalon_jtag_slave = cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;

  //allow new arb cycle for jtag_uart_0/avalon_jtag_slave, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign jtag_uart_0_avalon_jtag_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign jtag_uart_0_avalon_jtag_slave_master_qreq_vector = 1;

  //jtag_uart_0_avalon_jtag_slave_reset_n assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_reset_n = reset_n;

  assign jtag_uart_0_avalon_jtag_slave_chipselect = cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  //jtag_uart_0_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_firsttransfer = ~(jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable & jtag_uart_0_avalon_jtag_slave_any_continuerequest);

  //jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal = jtag_uart_0_avalon_jtag_slave_begins_xfer & jtag_uart_0_avalon_jtag_slave_firsttransfer;

  //~jtag_uart_0_avalon_jtag_slave_read_n assignment, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_read_n = ~(cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_read);

  //~jtag_uart_0_avalon_jtag_slave_write_n assignment, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_write_n = ~(cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_write);

  //jtag_uart_0_avalon_jtag_slave_address mux, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_address = cpu_0_data_master_address_to_slave >> 2;

  //d1_jtag_uart_0_avalon_jtag_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= 1;
      else if (1)
          d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= jtag_uart_0_avalon_jtag_slave_end_xfer;
    end


  //jtag_uart_0_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_waits_for_read = jtag_uart_0_avalon_jtag_slave_in_a_read_cycle & jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_0_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_in_a_read_cycle = cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = jtag_uart_0_avalon_jtag_slave_in_a_read_cycle;

  //jtag_uart_0_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  assign jtag_uart_0_avalon_jtag_slave_waits_for_write = jtag_uart_0_avalon_jtag_slave_in_a_write_cycle & jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_0_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_in_a_write_cycle = cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = jtag_uart_0_avalon_jtag_slave_in_a_write_cycle;

  assign wait_for_jtag_uart_0_avalon_jtag_slave_counter = 0;
  //assign jtag_uart_0_avalon_jtag_slave_irq_from_sa = jtag_uart_0_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_0_avalon_jtag_slave_irq_from_sa = jtag_uart_0_avalon_jtag_slave_irq;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module (
                                                             // inputs:
                                                              clear_fifo,
                                                              clk,
                                                              data_in,
                                                              read,
                                                              reset_n,
                                                              sync_reset,
                                                              write,

                                                             // outputs:
                                                              data_out,
                                                              empty,
                                                              fifo_contains_ones_n,
                                                              full
                                                           )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module (
                                                                    // inputs:
                                                                     clear_fifo,
                                                                     clk,
                                                                     data_in,
                                                                     read,
                                                                     reset_n,
                                                                     sync_reset,
                                                                     write,

                                                                    // outputs:
                                                                     data_out,
                                                                     empty,
                                                                     fifo_contains_ones_n,
                                                                     full
                                                                  )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk)
    begin
      if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sdram_0_s1_arbitrator (
                               // inputs:
                                clk,
                                cpu_0_data_master_address_to_slave,
                                cpu_0_data_master_byteenable,
                                cpu_0_data_master_dbs_address,
                                cpu_0_data_master_dbs_write_16,
                                cpu_0_data_master_no_byte_enables_and_last_term,
                                cpu_0_data_master_read,
                                cpu_0_data_master_waitrequest,
                                cpu_0_data_master_write,
                                cpu_0_instruction_master_address_to_slave,
                                cpu_0_instruction_master_dbs_address,
                                cpu_0_instruction_master_latency_counter,
                                cpu_0_instruction_master_read,
                                reset_n,
                                sdram_0_s1_readdata,
                                sdram_0_s1_readdatavalid,
                                sdram_0_s1_waitrequest,

                               // outputs:
                                cpu_0_data_master_byteenable_sdram_0_s1,
                                cpu_0_data_master_granted_sdram_0_s1,
                                cpu_0_data_master_qualified_request_sdram_0_s1,
                                cpu_0_data_master_read_data_valid_sdram_0_s1,
                                cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register,
                                cpu_0_data_master_requests_sdram_0_s1,
                                cpu_0_instruction_master_granted_sdram_0_s1,
                                cpu_0_instruction_master_qualified_request_sdram_0_s1,
                                cpu_0_instruction_master_read_data_valid_sdram_0_s1,
                                cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                cpu_0_instruction_master_requests_sdram_0_s1,
                                d1_sdram_0_s1_end_xfer,
                                sdram_0_s1_address,
                                sdram_0_s1_byteenable_n,
                                sdram_0_s1_chipselect,
                                sdram_0_s1_read_n,
                                sdram_0_s1_readdata_from_sa,
                                sdram_0_s1_reset_n,
                                sdram_0_s1_waitrequest_from_sa,
                                sdram_0_s1_write_n,
                                sdram_0_s1_writedata
                             )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1;
  output           cpu_0_data_master_granted_sdram_0_s1;
  output           cpu_0_data_master_qualified_request_sdram_0_s1;
  output           cpu_0_data_master_read_data_valid_sdram_0_s1;
  output           cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  output           cpu_0_data_master_requests_sdram_0_s1;
  output           cpu_0_instruction_master_granted_sdram_0_s1;
  output           cpu_0_instruction_master_qualified_request_sdram_0_s1;
  output           cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  output           cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  output           cpu_0_instruction_master_requests_sdram_0_s1;
  output           d1_sdram_0_s1_end_xfer;
  output  [ 21: 0] sdram_0_s1_address;
  output  [  1: 0] sdram_0_s1_byteenable_n;
  output           sdram_0_s1_chipselect;
  output           sdram_0_s1_read_n;
  output  [ 15: 0] sdram_0_s1_readdata_from_sa;
  output           sdram_0_s1_reset_n;
  output           sdram_0_s1_waitrequest_from_sa;
  output           sdram_0_s1_write_n;
  output  [ 15: 0] sdram_0_s1_writedata;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_dbs_address;
  input   [ 15: 0] cpu_0_data_master_dbs_write_16;
  input            cpu_0_data_master_no_byte_enables_and_last_term;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_waitrequest;
  input            cpu_0_data_master_write;
  input   [ 23: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_dbs_address;
  input   [  1: 0] cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input            reset_n;
  input   [ 15: 0] sdram_0_s1_readdata;
  input            sdram_0_s1_readdatavalid;
  input            sdram_0_s1_waitrequest;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire    [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1;
  wire    [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1_segment_0;
  wire    [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1_segment_1;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_sdram_0_s1;
  wire             cpu_0_data_master_qualified_request_sdram_0_s1;
  wire             cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;
  wire             cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1;
  wire             cpu_0_data_master_read_data_valid_sdram_0_s1;
  wire             cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  wire             cpu_0_data_master_requests_sdram_0_s1;
  wire             cpu_0_data_master_saved_grant_sdram_0_s1;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_sdram_0_s1;
  wire             cpu_0_instruction_master_qualified_request_sdram_0_s1;
  wire             cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;
  wire             cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  wire             cpu_0_instruction_master_requests_sdram_0_s1;
  wire             cpu_0_instruction_master_saved_grant_sdram_0_s1;
  reg              d1_reasons_to_wait;
  reg              d1_sdram_0_s1_end_xfer;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1;
  wire    [ 21: 0] sdram_0_s1_address;
  wire             sdram_0_s1_allgrants;
  wire             sdram_0_s1_allow_new_arb_cycle;
  wire             sdram_0_s1_any_continuerequest;
  reg     [  1: 0] sdram_0_s1_arb_addend;
  wire             sdram_0_s1_arb_counter_enable;
  reg     [  2: 0] sdram_0_s1_arb_share_counter;
  wire    [  2: 0] sdram_0_s1_arb_share_counter_next_value;
  wire    [  2: 0] sdram_0_s1_arb_share_set_values;
  wire    [  1: 0] sdram_0_s1_arb_winner;
  wire             sdram_0_s1_arbitration_holdoff_internal;
  wire             sdram_0_s1_beginbursttransfer_internal;
  wire             sdram_0_s1_begins_xfer;
  wire    [  1: 0] sdram_0_s1_byteenable_n;
  wire             sdram_0_s1_chipselect;
  wire    [  3: 0] sdram_0_s1_chosen_master_double_vector;
  wire    [  1: 0] sdram_0_s1_chosen_master_rot_left;
  wire             sdram_0_s1_end_xfer;
  wire             sdram_0_s1_firsttransfer;
  wire    [  1: 0] sdram_0_s1_grant_vector;
  wire             sdram_0_s1_in_a_read_cycle;
  wire             sdram_0_s1_in_a_write_cycle;
  wire    [  1: 0] sdram_0_s1_master_qreq_vector;
  wire             sdram_0_s1_move_on_to_next_transaction;
  wire             sdram_0_s1_non_bursting_master_requests;
  wire             sdram_0_s1_read_n;
  wire    [ 15: 0] sdram_0_s1_readdata_from_sa;
  wire             sdram_0_s1_readdatavalid_from_sa;
  wire             sdram_0_s1_reset_n;
  reg     [  1: 0] sdram_0_s1_saved_chosen_master_vector;
  reg              sdram_0_s1_slavearbiterlockenable;
  wire             sdram_0_s1_slavearbiterlockenable2;
  wire             sdram_0_s1_waitrequest_from_sa;
  wire             sdram_0_s1_waits_for_read;
  wire             sdram_0_s1_waits_for_write;
  wire             sdram_0_s1_write_n;
  wire    [ 15: 0] sdram_0_s1_writedata;
  wire             wait_for_sdram_0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~sdram_0_s1_end_xfer;
    end


  assign sdram_0_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_sdram_0_s1 | cpu_0_instruction_master_qualified_request_sdram_0_s1));
  //assign sdram_0_s1_readdatavalid_from_sa = sdram_0_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_0_s1_readdatavalid_from_sa = sdram_0_s1_readdatavalid;

  //assign sdram_0_s1_readdata_from_sa = sdram_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_0_s1_readdata_from_sa = sdram_0_s1_readdata;

  assign cpu_0_data_master_requests_sdram_0_s1 = ({cpu_0_data_master_address_to_slave[23] , 23'b0} == 24'h800000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign sdram_0_s1_waitrequest_from_sa = sdram_0_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_0_s1_waitrequest_from_sa = sdram_0_s1_waitrequest;

  //sdram_0_s1_arb_share_counter set values, which is an e_mux
  assign sdram_0_s1_arb_share_set_values = (cpu_0_data_master_granted_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_granted_sdram_0_s1)? 2 :
    (cpu_0_data_master_granted_sdram_0_s1)? 2 :
    (cpu_0_instruction_master_granted_sdram_0_s1)? 2 :
    1;

  //sdram_0_s1_non_bursting_master_requests mux, which is an e_mux
  assign sdram_0_s1_non_bursting_master_requests = cpu_0_data_master_requests_sdram_0_s1 |
    cpu_0_instruction_master_requests_sdram_0_s1 |
    cpu_0_data_master_requests_sdram_0_s1 |
    cpu_0_instruction_master_requests_sdram_0_s1;

  //sdram_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sdram_0_s1_arb_share_counter_next_value = sdram_0_s1_firsttransfer ? (sdram_0_s1_arb_share_set_values - 1) : |sdram_0_s1_arb_share_counter ? (sdram_0_s1_arb_share_counter - 1) : 0;

  //sdram_0_s1_allgrants all slave grants, which is an e_mux
  assign sdram_0_s1_allgrants = |sdram_0_s1_grant_vector |
    |sdram_0_s1_grant_vector |
    |sdram_0_s1_grant_vector |
    |sdram_0_s1_grant_vector;

  //sdram_0_s1_end_xfer assignment, which is an e_assign
  assign sdram_0_s1_end_xfer = ~(sdram_0_s1_waits_for_read | sdram_0_s1_waits_for_write);

  //sdram_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sdram_0_s1_arb_counter_enable = (sdram_0_s1_end_xfer & sdram_0_s1_allgrants) | (sdram_0_s1_end_xfer & ~sdram_0_s1_non_bursting_master_requests);

  //sdram_0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_arb_share_counter <= 0;
      else if (sdram_0_s1_arb_counter_enable)
          sdram_0_s1_arb_share_counter <= sdram_0_s1_arb_share_counter_next_value;
    end


  //sdram_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_slavearbiterlockenable <= 0;
      else if ((|sdram_0_s1_master_qreq_vector & sdram_0_s1_end_xfer) | (sdram_0_s1_end_xfer & ~sdram_0_s1_non_bursting_master_requests))
          sdram_0_s1_slavearbiterlockenable <= |sdram_0_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master sdram_0/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = sdram_0_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //sdram_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sdram_0_s1_slavearbiterlockenable2 = |sdram_0_s1_arb_share_counter_next_value;

  //cpu_0/data_master sdram_0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = sdram_0_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master sdram_0/s1 arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = sdram_0_s1_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master sdram_0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = sdram_0_s1_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted sdram_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 <= 0;
      else if (1)
          last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 <= cpu_0_instruction_master_saved_grant_sdram_0_s1 ? 1 : (sdram_0_s1_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_sdram_0_s1) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = last_cycle_cpu_0_instruction_master_granted_slave_sdram_0_s1 & cpu_0_instruction_master_requests_sdram_0_s1;

  //sdram_0_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  assign sdram_0_s1_any_continuerequest = cpu_0_instruction_master_continuerequest |
    cpu_0_data_master_continuerequest;

  assign cpu_0_data_master_qualified_request_sdram_0_s1 = cpu_0_data_master_requests_sdram_0_s1 & ~((cpu_0_data_master_read & (~cpu_0_data_master_waitrequest | (|cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register))) | ((~cpu_0_data_master_waitrequest | cpu_0_data_master_no_byte_enables_and_last_term | !cpu_0_data_master_byteenable_sdram_0_s1) & cpu_0_data_master_write) | cpu_0_instruction_master_arbiterlock);
  //unique name for sdram_0_s1_move_on_to_next_transaction, which is an e_assign
  assign sdram_0_s1_move_on_to_next_transaction = sdram_0_s1_readdatavalid_from_sa;

  //rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1_module rdv_fifo_for_cpu_0_data_master_to_sdram_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (cpu_0_data_master_granted_sdram_0_s1),
      .data_out             (cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1),
      .empty                (),
      .fifo_contains_ones_n (cpu_0_data_master_rdv_fifo_empty_sdram_0_s1),
      .full                 (),
      .read                 (sdram_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_0_s1_waits_for_read)
    );

  assign cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register = ~cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;
  //local readdatavalid cpu_0_data_master_read_data_valid_sdram_0_s1, which is an e_mux
  assign cpu_0_data_master_read_data_valid_sdram_0_s1 = (sdram_0_s1_readdatavalid_from_sa & cpu_0_data_master_rdv_fifo_output_from_sdram_0_s1) & ~ cpu_0_data_master_rdv_fifo_empty_sdram_0_s1;

  //sdram_0_s1_writedata mux, which is an e_mux
  assign sdram_0_s1_writedata = cpu_0_data_master_dbs_write_16;

  assign cpu_0_instruction_master_requests_sdram_0_s1 = (({cpu_0_instruction_master_address_to_slave[23] , 23'b0} == 24'h800000) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted sdram_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 <= 0;
      else if (1)
          last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 <= cpu_0_data_master_saved_grant_sdram_0_s1 ? 1 : (sdram_0_s1_arbitration_holdoff_internal | ~cpu_0_data_master_requests_sdram_0_s1) ? 0 : last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = last_cycle_cpu_0_data_master_granted_slave_sdram_0_s1 & cpu_0_data_master_requests_sdram_0_s1;

  assign cpu_0_instruction_master_qualified_request_sdram_0_s1 = cpu_0_instruction_master_requests_sdram_0_s1 & ~((cpu_0_instruction_master_read & ((cpu_0_instruction_master_latency_counter != 0) | (1 < cpu_0_instruction_master_latency_counter))) | cpu_0_data_master_arbiterlock);
  //rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1_module rdv_fifo_for_cpu_0_instruction_master_to_sdram_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (cpu_0_instruction_master_granted_sdram_0_s1),
      .data_out             (cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1),
      .empty                (),
      .fifo_contains_ones_n (cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1),
      .full                 (),
      .read                 (sdram_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_0_s1_waits_for_read)
    );

  assign cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register = ~cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;
  //local readdatavalid cpu_0_instruction_master_read_data_valid_sdram_0_s1, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_sdram_0_s1 = (sdram_0_s1_readdatavalid_from_sa & cpu_0_instruction_master_rdv_fifo_output_from_sdram_0_s1) & ~ cpu_0_instruction_master_rdv_fifo_empty_sdram_0_s1;

  //allow new arb cycle for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock;

  //cpu_0/instruction_master assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_master_qreq_vector[0] = cpu_0_instruction_master_qualified_request_sdram_0_s1;

  //cpu_0/instruction_master grant sdram_0/s1, which is an e_assign
  assign cpu_0_instruction_master_granted_sdram_0_s1 = sdram_0_s1_grant_vector[0];

  //cpu_0/instruction_master saved-grant sdram_0/s1, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_sdram_0_s1 = sdram_0_s1_arb_winner[0] && cpu_0_instruction_master_requests_sdram_0_s1;

  //cpu_0/data_master assignment into master qualified-requests vector for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_master_qreq_vector[1] = cpu_0_data_master_qualified_request_sdram_0_s1;

  //cpu_0/data_master grant sdram_0/s1, which is an e_assign
  assign cpu_0_data_master_granted_sdram_0_s1 = sdram_0_s1_grant_vector[1];

  //cpu_0/data_master saved-grant sdram_0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_sdram_0_s1 = sdram_0_s1_arb_winner[1] && cpu_0_data_master_requests_sdram_0_s1;

  //sdram_0/s1 chosen-master double-vector, which is an e_assign
  assign sdram_0_s1_chosen_master_double_vector = {sdram_0_s1_master_qreq_vector, sdram_0_s1_master_qreq_vector} & ({~sdram_0_s1_master_qreq_vector, ~sdram_0_s1_master_qreq_vector} + sdram_0_s1_arb_addend);

  //stable onehot encoding of arb winner
  assign sdram_0_s1_arb_winner = (sdram_0_s1_allow_new_arb_cycle & | sdram_0_s1_grant_vector) ? sdram_0_s1_grant_vector : sdram_0_s1_saved_chosen_master_vector;

  //saved sdram_0_s1_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_saved_chosen_master_vector <= 0;
      else if (sdram_0_s1_allow_new_arb_cycle)
          sdram_0_s1_saved_chosen_master_vector <= |sdram_0_s1_grant_vector ? sdram_0_s1_grant_vector : sdram_0_s1_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign sdram_0_s1_grant_vector = {(sdram_0_s1_chosen_master_double_vector[1] | sdram_0_s1_chosen_master_double_vector[3]),
    (sdram_0_s1_chosen_master_double_vector[0] | sdram_0_s1_chosen_master_double_vector[2])};

  //sdram_0/s1 chosen master rotated left, which is an e_assign
  assign sdram_0_s1_chosen_master_rot_left = (sdram_0_s1_arb_winner << 1) ? (sdram_0_s1_arb_winner << 1) : 1;

  //sdram_0/s1's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_arb_addend <= 1;
      else if (|sdram_0_s1_grant_vector)
          sdram_0_s1_arb_addend <= sdram_0_s1_end_xfer? sdram_0_s1_chosen_master_rot_left : sdram_0_s1_grant_vector;
    end


  //sdram_0_s1_reset_n assignment, which is an e_assign
  assign sdram_0_s1_reset_n = reset_n;

  assign sdram_0_s1_chipselect = cpu_0_data_master_granted_sdram_0_s1 | cpu_0_instruction_master_granted_sdram_0_s1;
  //sdram_0_s1_firsttransfer first transaction, which is an e_assign
  assign sdram_0_s1_firsttransfer = ~(sdram_0_s1_slavearbiterlockenable & sdram_0_s1_any_continuerequest);

  //sdram_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sdram_0_s1_beginbursttransfer_internal = sdram_0_s1_begins_xfer & sdram_0_s1_firsttransfer;

  //sdram_0_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign sdram_0_s1_arbitration_holdoff_internal = sdram_0_s1_begins_xfer & sdram_0_s1_firsttransfer;

  //~sdram_0_s1_read_n assignment, which is an e_mux
  assign sdram_0_s1_read_n = ~((cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_sdram_0_s1 & cpu_0_instruction_master_read));

  //~sdram_0_s1_write_n assignment, which is an e_mux
  assign sdram_0_s1_write_n = ~(cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_write);

  //sdram_0_s1_address mux, which is an e_mux
  assign sdram_0_s1_address = (cpu_0_data_master_granted_sdram_0_s1)? ({cpu_0_data_master_address_to_slave >> 2,
    cpu_0_data_master_dbs_address[1]}) :
    ({cpu_0_instruction_master_address_to_slave >> 2,
    cpu_0_instruction_master_dbs_address[1]});

  //d1_sdram_0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sdram_0_s1_end_xfer <= 1;
      else if (1)
          d1_sdram_0_s1_end_xfer <= sdram_0_s1_end_xfer;
    end


  //sdram_0_s1_waits_for_read in a cycle, which is an e_mux
  assign sdram_0_s1_waits_for_read = sdram_0_s1_in_a_read_cycle & sdram_0_s1_waitrequest_from_sa;

  //sdram_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign sdram_0_s1_in_a_read_cycle = (cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_sdram_0_s1 & cpu_0_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sdram_0_s1_in_a_read_cycle;

  //sdram_0_s1_waits_for_write in a cycle, which is an e_mux
  assign sdram_0_s1_waits_for_write = sdram_0_s1_in_a_write_cycle & sdram_0_s1_waitrequest_from_sa;

  //sdram_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign sdram_0_s1_in_a_write_cycle = cpu_0_data_master_granted_sdram_0_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sdram_0_s1_in_a_write_cycle;

  assign wait_for_sdram_0_s1_counter = 0;
  //~sdram_0_s1_byteenable_n byte enable port mux, which is an e_mux
  assign sdram_0_s1_byteenable_n = ~((cpu_0_data_master_granted_sdram_0_s1)? cpu_0_data_master_byteenable_sdram_0_s1 :
    -1);

  assign {cpu_0_data_master_byteenable_sdram_0_s1_segment_1,
cpu_0_data_master_byteenable_sdram_0_s1_segment_0} = cpu_0_data_master_byteenable;
  assign cpu_0_data_master_byteenable_sdram_0_s1 = ((cpu_0_data_master_dbs_address[1] == 0))? cpu_0_data_master_byteenable_sdram_0_s1_segment_0 :
    cpu_0_data_master_byteenable_sdram_0_s1_segment_1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_sdram_0_s1 + cpu_0_instruction_master_granted_sdram_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_sdram_0_s1 + cpu_0_instruction_master_saved_grant_sdram_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sram_0_avalonS_arbitrator (
                                   // inputs:
                                    clk,
                                    cpu_0_data_master_address_to_slave,
                                    cpu_0_data_master_byteenable,
                                    cpu_0_data_master_dbs_address,
                                    cpu_0_data_master_dbs_write_16,
                                    cpu_0_data_master_no_byte_enables_and_last_term,
                                    cpu_0_data_master_read,
                                    cpu_0_data_master_write,
                                    cpu_0_instruction_master_address_to_slave,
                                    cpu_0_instruction_master_dbs_address,
                                    cpu_0_instruction_master_latency_counter,
                                    cpu_0_instruction_master_read,
                                    cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                    reset_n,
                                    sram_0_avalonS_readdata,

                                   // outputs:
                                    cpu_0_data_master_byteenable_sram_0_avalonS,
                                    cpu_0_data_master_granted_sram_0_avalonS,
                                    cpu_0_data_master_qualified_request_sram_0_avalonS,
                                    cpu_0_data_master_read_data_valid_sram_0_avalonS,
                                    cpu_0_data_master_requests_sram_0_avalonS,
                                    cpu_0_instruction_master_granted_sram_0_avalonS,
                                    cpu_0_instruction_master_qualified_request_sram_0_avalonS,
                                    cpu_0_instruction_master_read_data_valid_sram_0_avalonS,
                                    cpu_0_instruction_master_requests_sram_0_avalonS,
                                    d1_sram_0_avalonS_end_xfer,
                                    sram_0_avalonS_address,
                                    sram_0_avalonS_byteenable_n,
                                    sram_0_avalonS_chipselect_n,
                                    sram_0_avalonS_outputenable_n,
                                    sram_0_avalonS_readdata_from_sa,
                                    sram_0_avalonS_reset_n,
                                    sram_0_avalonS_wait_counter_eq_0,
                                    sram_0_avalonS_wait_counter_eq_1,
                                    sram_0_avalonS_write_n,
                                    sram_0_avalonS_writedata
                                 )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output  [  1: 0] cpu_0_data_master_byteenable_sram_0_avalonS;
  output           cpu_0_data_master_granted_sram_0_avalonS;
  output           cpu_0_data_master_qualified_request_sram_0_avalonS;
  output           cpu_0_data_master_read_data_valid_sram_0_avalonS;
  output           cpu_0_data_master_requests_sram_0_avalonS;
  output           cpu_0_instruction_master_granted_sram_0_avalonS;
  output           cpu_0_instruction_master_qualified_request_sram_0_avalonS;
  output           cpu_0_instruction_master_read_data_valid_sram_0_avalonS;
  output           cpu_0_instruction_master_requests_sram_0_avalonS;
  output           d1_sram_0_avalonS_end_xfer;
  output  [ 17: 0] sram_0_avalonS_address;
  output  [  1: 0] sram_0_avalonS_byteenable_n;
  output           sram_0_avalonS_chipselect_n;
  output           sram_0_avalonS_outputenable_n;
  output  [ 15: 0] sram_0_avalonS_readdata_from_sa;
  output           sram_0_avalonS_reset_n;
  output           sram_0_avalonS_wait_counter_eq_0;
  output           sram_0_avalonS_wait_counter_eq_1;
  output           sram_0_avalonS_write_n;
  output  [ 15: 0] sram_0_avalonS_writedata;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_dbs_address;
  input   [ 15: 0] cpu_0_data_master_dbs_write_16;
  input            cpu_0_data_master_no_byte_enables_and_last_term;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input   [ 23: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_dbs_address;
  input   [  1: 0] cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  input            reset_n;
  input   [ 15: 0] sram_0_avalonS_readdata;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire    [  1: 0] cpu_0_data_master_byteenable_sram_0_avalonS;
  wire    [  1: 0] cpu_0_data_master_byteenable_sram_0_avalonS_segment_0;
  wire    [  1: 0] cpu_0_data_master_byteenable_sram_0_avalonS_segment_1;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_sram_0_avalonS;
  wire             cpu_0_data_master_qualified_request_sram_0_avalonS;
  wire             cpu_0_data_master_read_data_valid_sram_0_avalonS;
  wire             cpu_0_data_master_requests_sram_0_avalonS;
  wire             cpu_0_data_master_saved_grant_sram_0_avalonS;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_sram_0_avalonS;
  wire             cpu_0_instruction_master_qualified_request_sram_0_avalonS;
  wire             cpu_0_instruction_master_read_data_valid_sram_0_avalonS;
  wire             cpu_0_instruction_master_requests_sram_0_avalonS;
  wire             cpu_0_instruction_master_saved_grant_sram_0_avalonS;
  reg              d1_reasons_to_wait;
  reg              d1_sram_0_avalonS_end_xfer;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_cpu_0_data_master_granted_slave_sram_0_avalonS;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_sram_0_avalonS;
  wire    [ 17: 0] sram_0_avalonS_address;
  wire             sram_0_avalonS_allgrants;
  wire             sram_0_avalonS_allow_new_arb_cycle;
  wire             sram_0_avalonS_any_continuerequest;
  reg     [  1: 0] sram_0_avalonS_arb_addend;
  wire             sram_0_avalonS_arb_counter_enable;
  reg     [  2: 0] sram_0_avalonS_arb_share_counter;
  wire    [  2: 0] sram_0_avalonS_arb_share_counter_next_value;
  wire    [  2: 0] sram_0_avalonS_arb_share_set_values;
  wire    [  1: 0] sram_0_avalonS_arb_winner;
  wire             sram_0_avalonS_arbitration_holdoff_internal;
  wire             sram_0_avalonS_beginbursttransfer_internal;
  wire             sram_0_avalonS_begins_xfer;
  wire    [  1: 0] sram_0_avalonS_byteenable_n;
  wire             sram_0_avalonS_chipselect_n;
  wire    [  3: 0] sram_0_avalonS_chosen_master_double_vector;
  wire    [  1: 0] sram_0_avalonS_chosen_master_rot_left;
  wire    [  2: 0] sram_0_avalonS_counter_load_value;
  wire             sram_0_avalonS_end_xfer;
  wire             sram_0_avalonS_firsttransfer;
  wire    [  1: 0] sram_0_avalonS_grant_vector;
  wire             sram_0_avalonS_in_a_read_cycle;
  wire             sram_0_avalonS_in_a_write_cycle;
  wire    [  1: 0] sram_0_avalonS_master_qreq_vector;
  wire             sram_0_avalonS_non_bursting_master_requests;
  wire             sram_0_avalonS_outputenable_n;
  wire    [ 15: 0] sram_0_avalonS_readdata_from_sa;
  wire             sram_0_avalonS_reset_n;
  reg     [  1: 0] sram_0_avalonS_saved_chosen_master_vector;
  reg              sram_0_avalonS_slavearbiterlockenable;
  wire             sram_0_avalonS_slavearbiterlockenable2;
  reg     [  2: 0] sram_0_avalonS_wait_counter;
  wire             sram_0_avalonS_wait_counter_eq_0;
  wire             sram_0_avalonS_wait_counter_eq_1;
  wire             sram_0_avalonS_waits_for_read;
  wire             sram_0_avalonS_waits_for_write;
  wire             sram_0_avalonS_write_n;
  wire    [ 15: 0] sram_0_avalonS_writedata;
  wire             wait_for_sram_0_avalonS_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~sram_0_avalonS_end_xfer;
    end


  assign sram_0_avalonS_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_sram_0_avalonS | cpu_0_instruction_master_qualified_request_sram_0_avalonS));
  //assign sram_0_avalonS_readdata_from_sa = sram_0_avalonS_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sram_0_avalonS_readdata_from_sa = sram_0_avalonS_readdata;

  assign cpu_0_data_master_requests_sram_0_avalonS = ({cpu_0_data_master_address_to_slave[23 : 19] , 19'b0} == 24'h400000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //sram_0_avalonS_arb_share_counter set values, which is an e_mux
  assign sram_0_avalonS_arb_share_set_values = (cpu_0_data_master_granted_sram_0_avalonS)? 2 :
    (cpu_0_instruction_master_granted_sram_0_avalonS)? 2 :
    (cpu_0_data_master_granted_sram_0_avalonS)? 2 :
    (cpu_0_instruction_master_granted_sram_0_avalonS)? 2 :
    1;

  //sram_0_avalonS_non_bursting_master_requests mux, which is an e_mux
  assign sram_0_avalonS_non_bursting_master_requests = cpu_0_data_master_requests_sram_0_avalonS |
    cpu_0_instruction_master_requests_sram_0_avalonS |
    cpu_0_data_master_requests_sram_0_avalonS |
    cpu_0_instruction_master_requests_sram_0_avalonS;

  //sram_0_avalonS_arb_share_counter_next_value assignment, which is an e_assign
  assign sram_0_avalonS_arb_share_counter_next_value = sram_0_avalonS_firsttransfer ? (sram_0_avalonS_arb_share_set_values - 1) : |sram_0_avalonS_arb_share_counter ? (sram_0_avalonS_arb_share_counter - 1) : 0;

  //sram_0_avalonS_allgrants all slave grants, which is an e_mux
  assign sram_0_avalonS_allgrants = |sram_0_avalonS_grant_vector |
    |sram_0_avalonS_grant_vector |
    |sram_0_avalonS_grant_vector |
    |sram_0_avalonS_grant_vector;

  //sram_0_avalonS_end_xfer assignment, which is an e_assign
  assign sram_0_avalonS_end_xfer = ~(sram_0_avalonS_waits_for_read | sram_0_avalonS_waits_for_write);

  //sram_0_avalonS_arb_share_counter arbitration counter enable, which is an e_assign
  assign sram_0_avalonS_arb_counter_enable = (sram_0_avalonS_end_xfer & sram_0_avalonS_allgrants) | (sram_0_avalonS_end_xfer & ~sram_0_avalonS_non_bursting_master_requests);

  //sram_0_avalonS_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_0_avalonS_arb_share_counter <= 0;
      else if (sram_0_avalonS_arb_counter_enable)
          sram_0_avalonS_arb_share_counter <= sram_0_avalonS_arb_share_counter_next_value;
    end


  //sram_0_avalonS_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_0_avalonS_slavearbiterlockenable <= 0;
      else if ((|sram_0_avalonS_master_qreq_vector & sram_0_avalonS_end_xfer) | (sram_0_avalonS_end_xfer & ~sram_0_avalonS_non_bursting_master_requests))
          sram_0_avalonS_slavearbiterlockenable <= |sram_0_avalonS_arb_share_counter_next_value;
    end


  //cpu_0/data_master sram_0/avalonS arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = sram_0_avalonS_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //sram_0_avalonS_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sram_0_avalonS_slavearbiterlockenable2 = |sram_0_avalonS_arb_share_counter_next_value;

  //cpu_0/data_master sram_0/avalonS arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = sram_0_avalonS_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master sram_0/avalonS arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = sram_0_avalonS_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master sram_0/avalonS arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = sram_0_avalonS_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted sram_0/avalonS last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_sram_0_avalonS <= 0;
      else if (1)
          last_cycle_cpu_0_instruction_master_granted_slave_sram_0_avalonS <= cpu_0_instruction_master_saved_grant_sram_0_avalonS ? 1 : (sram_0_avalonS_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_sram_0_avalonS) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_sram_0_avalonS;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = last_cycle_cpu_0_instruction_master_granted_slave_sram_0_avalonS & cpu_0_instruction_master_requests_sram_0_avalonS;

  //sram_0_avalonS_any_continuerequest at least one master continues requesting, which is an e_mux
  assign sram_0_avalonS_any_continuerequest = cpu_0_instruction_master_continuerequest |
    cpu_0_data_master_continuerequest;

  assign cpu_0_data_master_qualified_request_sram_0_avalonS = cpu_0_data_master_requests_sram_0_avalonS & ~(((cpu_0_data_master_no_byte_enables_and_last_term | !cpu_0_data_master_byteenable_sram_0_avalonS) & cpu_0_data_master_write) | cpu_0_instruction_master_arbiterlock);
  //sram_0_avalonS_writedata mux, which is an e_mux
  assign sram_0_avalonS_writedata = cpu_0_data_master_dbs_write_16;

  assign cpu_0_instruction_master_requests_sram_0_avalonS = (({cpu_0_instruction_master_address_to_slave[23 : 19] , 19'b0} == 24'h400000) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted sram_0/avalonS last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_sram_0_avalonS <= 0;
      else if (1)
          last_cycle_cpu_0_data_master_granted_slave_sram_0_avalonS <= cpu_0_data_master_saved_grant_sram_0_avalonS ? 1 : (sram_0_avalonS_arbitration_holdoff_internal | ~cpu_0_data_master_requests_sram_0_avalonS) ? 0 : last_cycle_cpu_0_data_master_granted_slave_sram_0_avalonS;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = last_cycle_cpu_0_data_master_granted_slave_sram_0_avalonS & cpu_0_data_master_requests_sram_0_avalonS;

  assign cpu_0_instruction_master_qualified_request_sram_0_avalonS = cpu_0_instruction_master_requests_sram_0_avalonS & ~((cpu_0_instruction_master_read & ((cpu_0_instruction_master_latency_counter != 0) | (|cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register))) | cpu_0_data_master_arbiterlock);
  //local readdatavalid cpu_0_instruction_master_read_data_valid_sram_0_avalonS, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_sram_0_avalonS = cpu_0_instruction_master_granted_sram_0_avalonS & cpu_0_instruction_master_read & ~sram_0_avalonS_waits_for_read;

  //allow new arb cycle for sram_0/avalonS, which is an e_assign
  assign sram_0_avalonS_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock;

  //cpu_0/instruction_master assignment into master qualified-requests vector for sram_0/avalonS, which is an e_assign
  assign sram_0_avalonS_master_qreq_vector[0] = cpu_0_instruction_master_qualified_request_sram_0_avalonS;

  //cpu_0/instruction_master grant sram_0/avalonS, which is an e_assign
  assign cpu_0_instruction_master_granted_sram_0_avalonS = sram_0_avalonS_grant_vector[0];

  //cpu_0/instruction_master saved-grant sram_0/avalonS, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_sram_0_avalonS = sram_0_avalonS_arb_winner[0] && cpu_0_instruction_master_requests_sram_0_avalonS;

  //cpu_0/data_master assignment into master qualified-requests vector for sram_0/avalonS, which is an e_assign
  assign sram_0_avalonS_master_qreq_vector[1] = cpu_0_data_master_qualified_request_sram_0_avalonS;

  //cpu_0/data_master grant sram_0/avalonS, which is an e_assign
  assign cpu_0_data_master_granted_sram_0_avalonS = sram_0_avalonS_grant_vector[1];

  //cpu_0/data_master saved-grant sram_0/avalonS, which is an e_assign
  assign cpu_0_data_master_saved_grant_sram_0_avalonS = sram_0_avalonS_arb_winner[1] && cpu_0_data_master_requests_sram_0_avalonS;

  //sram_0/avalonS chosen-master double-vector, which is an e_assign
  assign sram_0_avalonS_chosen_master_double_vector = {sram_0_avalonS_master_qreq_vector, sram_0_avalonS_master_qreq_vector} & ({~sram_0_avalonS_master_qreq_vector, ~sram_0_avalonS_master_qreq_vector} + sram_0_avalonS_arb_addend);

  //stable onehot encoding of arb winner
  assign sram_0_avalonS_arb_winner = (sram_0_avalonS_allow_new_arb_cycle & | sram_0_avalonS_grant_vector) ? sram_0_avalonS_grant_vector : sram_0_avalonS_saved_chosen_master_vector;

  //saved sram_0_avalonS_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_0_avalonS_saved_chosen_master_vector <= 0;
      else if (sram_0_avalonS_allow_new_arb_cycle)
          sram_0_avalonS_saved_chosen_master_vector <= |sram_0_avalonS_grant_vector ? sram_0_avalonS_grant_vector : sram_0_avalonS_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign sram_0_avalonS_grant_vector = {(sram_0_avalonS_chosen_master_double_vector[1] | sram_0_avalonS_chosen_master_double_vector[3]),
    (sram_0_avalonS_chosen_master_double_vector[0] | sram_0_avalonS_chosen_master_double_vector[2])};

  //sram_0/avalonS chosen master rotated left, which is an e_assign
  assign sram_0_avalonS_chosen_master_rot_left = (sram_0_avalonS_arb_winner << 1) ? (sram_0_avalonS_arb_winner << 1) : 1;

  //sram_0/avalonS's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_0_avalonS_arb_addend <= 1;
      else if (|sram_0_avalonS_grant_vector)
          sram_0_avalonS_arb_addend <= sram_0_avalonS_end_xfer? sram_0_avalonS_chosen_master_rot_left : sram_0_avalonS_grant_vector;
    end


  //~sram_0_avalonS_outputenable_n assignment, which is an e_mux
  assign sram_0_avalonS_outputenable_n = ~sram_0_avalonS_in_a_read_cycle;

  //sram_0_avalonS_reset_n assignment, which is an e_assign
  assign sram_0_avalonS_reset_n = reset_n;

  assign sram_0_avalonS_chipselect_n = ~(cpu_0_data_master_granted_sram_0_avalonS | cpu_0_instruction_master_granted_sram_0_avalonS);
  //sram_0_avalonS_firsttransfer first transaction, which is an e_assign
  assign sram_0_avalonS_firsttransfer = ~(sram_0_avalonS_slavearbiterlockenable & sram_0_avalonS_any_continuerequest);

  //sram_0_avalonS_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sram_0_avalonS_beginbursttransfer_internal = sram_0_avalonS_begins_xfer & sram_0_avalonS_firsttransfer;

  //sram_0_avalonS_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign sram_0_avalonS_arbitration_holdoff_internal = sram_0_avalonS_begins_xfer & sram_0_avalonS_firsttransfer;

  //~sram_0_avalonS_write_n assignment, which is an e_mux
  assign sram_0_avalonS_write_n = ~(((cpu_0_data_master_granted_sram_0_avalonS & cpu_0_data_master_write)) & ~sram_0_avalonS_begins_xfer & (sram_0_avalonS_wait_counter >= 2) & (sram_0_avalonS_wait_counter < 4));

  //sram_0_avalonS_address mux, which is an e_mux
  assign sram_0_avalonS_address = (cpu_0_data_master_granted_sram_0_avalonS)? ({cpu_0_data_master_address_to_slave >> 2,
    cpu_0_data_master_dbs_address[1]}) :
    ({cpu_0_instruction_master_address_to_slave >> 2,
    cpu_0_instruction_master_dbs_address[1]});

  //d1_sram_0_avalonS_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sram_0_avalonS_end_xfer <= 1;
      else if (1)
          d1_sram_0_avalonS_end_xfer <= sram_0_avalonS_end_xfer;
    end


  //sram_0_avalonS_wait_counter_eq_1 assignment, which is an e_assign
  assign sram_0_avalonS_wait_counter_eq_1 = sram_0_avalonS_wait_counter == 1;

  //sram_0_avalonS_waits_for_read in a cycle, which is an e_mux
  assign sram_0_avalonS_waits_for_read = sram_0_avalonS_in_a_read_cycle & wait_for_sram_0_avalonS_counter;

  //sram_0_avalonS_in_a_read_cycle assignment, which is an e_assign
  assign sram_0_avalonS_in_a_read_cycle = (cpu_0_data_master_granted_sram_0_avalonS & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_sram_0_avalonS & cpu_0_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sram_0_avalonS_in_a_read_cycle;

  //sram_0_avalonS_waits_for_write in a cycle, which is an e_mux
  assign sram_0_avalonS_waits_for_write = sram_0_avalonS_in_a_write_cycle & wait_for_sram_0_avalonS_counter;

  //sram_0_avalonS_in_a_write_cycle assignment, which is an e_assign
  assign sram_0_avalonS_in_a_write_cycle = cpu_0_data_master_granted_sram_0_avalonS & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sram_0_avalonS_in_a_write_cycle;

  assign sram_0_avalonS_wait_counter_eq_0 = sram_0_avalonS_wait_counter == 0;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sram_0_avalonS_wait_counter <= 0;
      else if (1)
          sram_0_avalonS_wait_counter <= sram_0_avalonS_counter_load_value;
    end


  assign sram_0_avalonS_counter_load_value = ((sram_0_avalonS_in_a_write_cycle & sram_0_avalonS_begins_xfer))? 4 :
    ((sram_0_avalonS_in_a_read_cycle & sram_0_avalonS_begins_xfer))? 2 :
    (~sram_0_avalonS_wait_counter_eq_0)? sram_0_avalonS_wait_counter - 1 :
    0;

  assign wait_for_sram_0_avalonS_counter = sram_0_avalonS_begins_xfer | ~sram_0_avalonS_wait_counter_eq_0;
  //~sram_0_avalonS_byteenable_n byte enable port mux, which is an e_mux
  assign sram_0_avalonS_byteenable_n = ~((cpu_0_data_master_granted_sram_0_avalonS)? cpu_0_data_master_byteenable_sram_0_avalonS :
    -1);

  assign {cpu_0_data_master_byteenable_sram_0_avalonS_segment_1,
cpu_0_data_master_byteenable_sram_0_avalonS_segment_0} = cpu_0_data_master_byteenable;
  assign cpu_0_data_master_byteenable_sram_0_avalonS = ((cpu_0_data_master_dbs_address[1] == 0))? cpu_0_data_master_byteenable_sram_0_avalonS_segment_0 :
    cpu_0_data_master_byteenable_sram_0_avalonS_segment_1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_sram_0_avalonS + cpu_0_instruction_master_granted_sram_0_avalonS > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_sram_0_avalonS + cpu_0_instruction_master_saved_grant_sram_0_avalonS > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tri_state_bridge_0_avalon_slave_arbitrator (
                                                    // inputs:
                                                     clk,
                                                     cpu_0_data_master_address_to_slave,
                                                     cpu_0_data_master_byteenable,
                                                     cpu_0_data_master_dbs_address,
                                                     cpu_0_data_master_dbs_write_8,
                                                     cpu_0_data_master_no_byte_enables_and_last_term,
                                                     cpu_0_data_master_read,
                                                     cpu_0_data_master_write,
                                                     cpu_0_instruction_master_address_to_slave,
                                                     cpu_0_instruction_master_dbs_address,
                                                     cpu_0_instruction_master_latency_counter,
                                                     cpu_0_instruction_master_read,
                                                     cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register,
                                                     reset_n,

                                                    // outputs:
                                                     cfi_flash_0_s1_wait_counter_eq_0,
                                                     cfi_flash_0_s1_wait_counter_eq_1,
                                                     cpu_0_data_master_byteenable_cfi_flash_0_s1,
                                                     cpu_0_data_master_granted_cfi_flash_0_s1,
                                                     cpu_0_data_master_qualified_request_cfi_flash_0_s1,
                                                     cpu_0_data_master_read_data_valid_cfi_flash_0_s1,
                                                     cpu_0_data_master_requests_cfi_flash_0_s1,
                                                     cpu_0_instruction_master_granted_cfi_flash_0_s1,
                                                     cpu_0_instruction_master_qualified_request_cfi_flash_0_s1,
                                                     cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1,
                                                     cpu_0_instruction_master_requests_cfi_flash_0_s1,
                                                     d1_tri_state_bridge_0_avalon_slave_end_xfer,
                                                     incoming_tri_state_bridge_0_data,
                                                     incoming_tri_state_bridge_0_data_with_Xs_converted_to_0,
                                                     registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1,
                                                     select_n_to_the_cfi_flash_0,
                                                     tri_state_bridge_0_address,
                                                     tri_state_bridge_0_data,
                                                     tri_state_bridge_0_readn,
                                                     write_n_to_the_cfi_flash_0
                                                  )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output           cfi_flash_0_s1_wait_counter_eq_0;
  output           cfi_flash_0_s1_wait_counter_eq_1;
  output           cpu_0_data_master_byteenable_cfi_flash_0_s1;
  output           cpu_0_data_master_granted_cfi_flash_0_s1;
  output           cpu_0_data_master_qualified_request_cfi_flash_0_s1;
  output           cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  output           cpu_0_data_master_requests_cfi_flash_0_s1;
  output           cpu_0_instruction_master_granted_cfi_flash_0_s1;
  output           cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;
  output           cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;
  output           cpu_0_instruction_master_requests_cfi_flash_0_s1;
  output           d1_tri_state_bridge_0_avalon_slave_end_xfer;
  output  [  7: 0] incoming_tri_state_bridge_0_data;
  output  [  7: 0] incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;
  output           registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  output           select_n_to_the_cfi_flash_0;
  output  [ 21: 0] tri_state_bridge_0_address;
  inout   [  7: 0] tri_state_bridge_0_data;
  output           tri_state_bridge_0_readn;
  output           write_n_to_the_cfi_flash_0;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address_to_slave;
  input   [  3: 0] cpu_0_data_master_byteenable;
  input   [  1: 0] cpu_0_data_master_dbs_address;
  input   [  7: 0] cpu_0_data_master_dbs_write_8;
  input            cpu_0_data_master_no_byte_enables_and_last_term;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input   [ 23: 0] cpu_0_instruction_master_address_to_slave;
  input   [  1: 0] cpu_0_instruction_master_dbs_address;
  input   [  1: 0] cpu_0_instruction_master_latency_counter;
  input            cpu_0_instruction_master_read;
  input            cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  input            reset_n;

  wire    [  4: 0] cfi_flash_0_s1_counter_load_value;
  wire             cfi_flash_0_s1_in_a_read_cycle;
  wire             cfi_flash_0_s1_in_a_write_cycle;
  wire             cfi_flash_0_s1_pretend_byte_enable;
  reg     [  4: 0] cfi_flash_0_s1_wait_counter;
  wire             cfi_flash_0_s1_wait_counter_eq_0;
  wire             cfi_flash_0_s1_wait_counter_eq_1;
  wire             cfi_flash_0_s1_waits_for_read;
  wire             cfi_flash_0_s1_waits_for_write;
  wire             cfi_flash_0_s1_with_write_latency;
  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_0;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_1;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_2;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_3;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_cfi_flash_0_s1;
  wire             cpu_0_data_master_qualified_request_cfi_flash_0_s1;
  wire             cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  reg     [  1: 0] cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register;
  wire             cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register_in;
  wire             cpu_0_data_master_requests_cfi_flash_0_s1;
  wire             cpu_0_data_master_saved_grant_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_arbiterlock;
  wire             cpu_0_instruction_master_arbiterlock2;
  wire             cpu_0_instruction_master_continuerequest;
  wire             cpu_0_instruction_master_granted_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;
  reg     [  1: 0] cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register;
  wire             cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register_in;
  wire             cpu_0_instruction_master_requests_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_saved_grant_cfi_flash_0_s1;
  reg              d1_in_a_write_cycle /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_ENABLE_REGISTER=ON"  */;
  reg     [  7: 0] d1_outgoing_tri_state_bridge_0_data /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  reg              d1_reasons_to_wait;
  reg              d1_tri_state_bridge_0_avalon_slave_end_xfer;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg     [  7: 0] incoming_tri_state_bridge_0_data /* synthesis ALTERA_ATTRIBUTE = "FAST_INPUT_REGISTER=ON"  */;
  wire             incoming_tri_state_bridge_0_data_bit_0_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_1_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_2_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_3_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_4_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_5_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_6_is_x;
  wire             incoming_tri_state_bridge_0_data_bit_7_is_x;
  wire    [  7: 0] incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;
  reg              last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1;
  reg              last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1;
  wire    [  7: 0] outgoing_tri_state_bridge_0_data;
  wire    [  1: 0] p1_cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register;
  wire    [  1: 0] p1_cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register;
  wire             p1_select_n_to_the_cfi_flash_0;
  wire    [ 21: 0] p1_tri_state_bridge_0_address;
  wire             p1_tri_state_bridge_0_readn;
  wire             p1_write_n_to_the_cfi_flash_0;
  wire             registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  reg              select_n_to_the_cfi_flash_0 /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire             time_to_write;
  reg     [ 21: 0] tri_state_bridge_0_address /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire             tri_state_bridge_0_avalon_slave_allgrants;
  wire             tri_state_bridge_0_avalon_slave_allow_new_arb_cycle;
  wire             tri_state_bridge_0_avalon_slave_any_continuerequest;
  reg     [  1: 0] tri_state_bridge_0_avalon_slave_arb_addend;
  wire             tri_state_bridge_0_avalon_slave_arb_counter_enable;
  reg     [  2: 0] tri_state_bridge_0_avalon_slave_arb_share_counter;
  wire    [  2: 0] tri_state_bridge_0_avalon_slave_arb_share_counter_next_value;
  wire    [  2: 0] tri_state_bridge_0_avalon_slave_arb_share_set_values;
  wire    [  1: 0] tri_state_bridge_0_avalon_slave_arb_winner;
  wire             tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal;
  wire             tri_state_bridge_0_avalon_slave_beginbursttransfer_internal;
  wire             tri_state_bridge_0_avalon_slave_begins_xfer;
  wire    [  3: 0] tri_state_bridge_0_avalon_slave_chosen_master_double_vector;
  wire    [  1: 0] tri_state_bridge_0_avalon_slave_chosen_master_rot_left;
  wire             tri_state_bridge_0_avalon_slave_end_xfer;
  wire             tri_state_bridge_0_avalon_slave_firsttransfer;
  wire    [  1: 0] tri_state_bridge_0_avalon_slave_grant_vector;
  wire    [  1: 0] tri_state_bridge_0_avalon_slave_master_qreq_vector;
  wire             tri_state_bridge_0_avalon_slave_non_bursting_master_requests;
  wire             tri_state_bridge_0_avalon_slave_read_pending;
  reg     [  1: 0] tri_state_bridge_0_avalon_slave_saved_chosen_master_vector;
  reg              tri_state_bridge_0_avalon_slave_slavearbiterlockenable;
  wire             tri_state_bridge_0_avalon_slave_slavearbiterlockenable2;
  wire             tri_state_bridge_0_avalon_slave_write_pending;
  wire    [  7: 0] tri_state_bridge_0_data;
  reg              tri_state_bridge_0_readn /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  wire             wait_for_cfi_flash_0_s1_counter;
  reg              write_n_to_the_cfi_flash_0 /* synthesis ALTERA_ATTRIBUTE = "FAST_OUTPUT_REGISTER=ON"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~tri_state_bridge_0_avalon_slave_end_xfer;
    end


  assign tri_state_bridge_0_avalon_slave_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_cfi_flash_0_s1 | cpu_0_instruction_master_qualified_request_cfi_flash_0_s1));
  assign cpu_0_data_master_requests_cfi_flash_0_s1 = ({cpu_0_data_master_address_to_slave[23 : 22] , 22'b0} == 24'h0) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //~select_n_to_the_cfi_flash_0 of type chipselect to ~p1_select_n_to_the_cfi_flash_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          select_n_to_the_cfi_flash_0 <= ~0;
      else if (1)
          select_n_to_the_cfi_flash_0 <= p1_select_n_to_the_cfi_flash_0;
    end


  assign tri_state_bridge_0_avalon_slave_write_pending = 0;
  //tri_state_bridge_0/avalon_slave read pending calc, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_read_pending = 0;

  //registered rdv signal_name registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1 assignment, which is an e_assign
  assign registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1 = cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register[0];

  //tri_state_bridge_0_avalon_slave_arb_share_counter set values, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_arb_share_set_values = (cpu_0_data_master_granted_cfi_flash_0_s1)? 4 :
    (cpu_0_instruction_master_granted_cfi_flash_0_s1)? 4 :
    (cpu_0_data_master_granted_cfi_flash_0_s1)? 4 :
    (cpu_0_instruction_master_granted_cfi_flash_0_s1)? 4 :
    1;

  //tri_state_bridge_0_avalon_slave_non_bursting_master_requests mux, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_non_bursting_master_requests = cpu_0_data_master_requests_cfi_flash_0_s1 |
    cpu_0_instruction_master_requests_cfi_flash_0_s1 |
    cpu_0_data_master_requests_cfi_flash_0_s1 |
    cpu_0_instruction_master_requests_cfi_flash_0_s1;

  //tri_state_bridge_0_avalon_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_arb_share_counter_next_value = tri_state_bridge_0_avalon_slave_firsttransfer ? (tri_state_bridge_0_avalon_slave_arb_share_set_values - 1) : |tri_state_bridge_0_avalon_slave_arb_share_counter ? (tri_state_bridge_0_avalon_slave_arb_share_counter - 1) : 0;

  //tri_state_bridge_0_avalon_slave_allgrants all slave grants, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_allgrants = |tri_state_bridge_0_avalon_slave_grant_vector |
    |tri_state_bridge_0_avalon_slave_grant_vector |
    |tri_state_bridge_0_avalon_slave_grant_vector |
    |tri_state_bridge_0_avalon_slave_grant_vector;

  //tri_state_bridge_0_avalon_slave_end_xfer assignment, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_end_xfer = ~(cfi_flash_0_s1_waits_for_read | cfi_flash_0_s1_waits_for_write);

  //tri_state_bridge_0_avalon_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_arb_counter_enable = (tri_state_bridge_0_avalon_slave_end_xfer & tri_state_bridge_0_avalon_slave_allgrants) | (tri_state_bridge_0_avalon_slave_end_xfer & ~tri_state_bridge_0_avalon_slave_non_bursting_master_requests);

  //tri_state_bridge_0_avalon_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_arb_share_counter <= 0;
      else if (tri_state_bridge_0_avalon_slave_arb_counter_enable)
          tri_state_bridge_0_avalon_slave_arb_share_counter <= tri_state_bridge_0_avalon_slave_arb_share_counter_next_value;
    end


  //tri_state_bridge_0_avalon_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_slavearbiterlockenable <= 0;
      else if ((|tri_state_bridge_0_avalon_slave_master_qreq_vector & tri_state_bridge_0_avalon_slave_end_xfer) | (tri_state_bridge_0_avalon_slave_end_xfer & ~tri_state_bridge_0_avalon_slave_non_bursting_master_requests))
          tri_state_bridge_0_avalon_slave_slavearbiterlockenable <= |tri_state_bridge_0_avalon_slave_arb_share_counter_next_value;
    end


  //cpu_0/data_master tri_state_bridge_0/avalon_slave arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = tri_state_bridge_0_avalon_slave_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //tri_state_bridge_0_avalon_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_slavearbiterlockenable2 = |tri_state_bridge_0_avalon_slave_arb_share_counter_next_value;

  //cpu_0/data_master tri_state_bridge_0/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = tri_state_bridge_0_avalon_slave_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //cpu_0/instruction_master tri_state_bridge_0/avalon_slave arbiterlock, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock = tri_state_bridge_0_avalon_slave_slavearbiterlockenable & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master tri_state_bridge_0/avalon_slave arbiterlock2, which is an e_assign
  assign cpu_0_instruction_master_arbiterlock2 = tri_state_bridge_0_avalon_slave_slavearbiterlockenable2 & cpu_0_instruction_master_continuerequest;

  //cpu_0/instruction_master granted cfi_flash_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1 <= 0;
      else if (1)
          last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1 <= cpu_0_instruction_master_saved_grant_cfi_flash_0_s1 ? 1 : (tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal | ~cpu_0_instruction_master_requests_cfi_flash_0_s1) ? 0 : last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1;
    end


  //cpu_0_instruction_master_continuerequest continued request, which is an e_mux
  assign cpu_0_instruction_master_continuerequest = last_cycle_cpu_0_instruction_master_granted_slave_cfi_flash_0_s1 & cpu_0_instruction_master_requests_cfi_flash_0_s1;

  //tri_state_bridge_0_avalon_slave_any_continuerequest at least one master continues requesting, which is an e_mux
  assign tri_state_bridge_0_avalon_slave_any_continuerequest = cpu_0_instruction_master_continuerequest |
    cpu_0_data_master_continuerequest;

  assign cpu_0_data_master_qualified_request_cfi_flash_0_s1 = cpu_0_data_master_requests_cfi_flash_0_s1 & ~((cpu_0_data_master_read & (tri_state_bridge_0_avalon_slave_write_pending | (tri_state_bridge_0_avalon_slave_read_pending) | (|cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register))) | ((tri_state_bridge_0_avalon_slave_read_pending | cpu_0_data_master_no_byte_enables_and_last_term | !cpu_0_data_master_byteenable_cfi_flash_0_s1) & cpu_0_data_master_write) | cpu_0_instruction_master_arbiterlock);
  //cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register_in = cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_read & ~cfi_flash_0_s1_waits_for_read & ~(|cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register);

  //shift register p1 cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register = {cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register, cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register_in};

  //cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register <= 0;
      else if (1)
          cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register <= p1_cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register;
    end


  //local readdatavalid cpu_0_data_master_read_data_valid_cfi_flash_0_s1, which is an e_mux
  assign cpu_0_data_master_read_data_valid_cfi_flash_0_s1 = cpu_0_data_master_read_data_valid_cfi_flash_0_s1_shift_register[1];

  //tri_state_bridge_0_data register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          incoming_tri_state_bridge_0_data <= 0;
      else if (1)
          incoming_tri_state_bridge_0_data <= tri_state_bridge_0_data;
    end


  //cfi_flash_0_s1_with_write_latency assignment, which is an e_assign
  assign cfi_flash_0_s1_with_write_latency = in_a_write_cycle & (cpu_0_data_master_qualified_request_cfi_flash_0_s1 | cpu_0_instruction_master_qualified_request_cfi_flash_0_s1);

  //time to write the data, which is an e_mux
  assign time_to_write = (cfi_flash_0_s1_with_write_latency)? 1 :
    0;

  //d1_outgoing_tri_state_bridge_0_data register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_outgoing_tri_state_bridge_0_data <= 0;
      else if (1)
          d1_outgoing_tri_state_bridge_0_data <= outgoing_tri_state_bridge_0_data;
    end


  //write cycle delayed by 1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_in_a_write_cycle <= 0;
      else if (1)
          d1_in_a_write_cycle <= time_to_write;
    end


  //d1_outgoing_tri_state_bridge_0_data tristate driver, which is an e_assign
  assign tri_state_bridge_0_data = (d1_in_a_write_cycle)? d1_outgoing_tri_state_bridge_0_data:{8{1'bz}};

  //outgoing_tri_state_bridge_0_data mux, which is an e_mux
  assign outgoing_tri_state_bridge_0_data = cpu_0_data_master_dbs_write_8;

  assign cpu_0_instruction_master_requests_cfi_flash_0_s1 = (({cpu_0_instruction_master_address_to_slave[23 : 22] , 22'b0} == 24'h0) & (cpu_0_instruction_master_read)) & cpu_0_instruction_master_read;
  //cpu_0/data_master granted cfi_flash_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1 <= 0;
      else if (1)
          last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1 <= cpu_0_data_master_saved_grant_cfi_flash_0_s1 ? 1 : (tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal | ~cpu_0_data_master_requests_cfi_flash_0_s1) ? 0 : last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1;
    end


  //cpu_0_data_master_continuerequest continued request, which is an e_mux
  assign cpu_0_data_master_continuerequest = last_cycle_cpu_0_data_master_granted_slave_cfi_flash_0_s1 & cpu_0_data_master_requests_cfi_flash_0_s1;

  assign cpu_0_instruction_master_qualified_request_cfi_flash_0_s1 = cpu_0_instruction_master_requests_cfi_flash_0_s1 & ~((cpu_0_instruction_master_read & (tri_state_bridge_0_avalon_slave_write_pending | (tri_state_bridge_0_avalon_slave_read_pending) | (2 < cpu_0_instruction_master_latency_counter) | (|cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register))) | cpu_0_data_master_arbiterlock);
  //cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register_in = cpu_0_instruction_master_granted_cfi_flash_0_s1 & cpu_0_instruction_master_read & ~cfi_flash_0_s1_waits_for_read;

  //shift register p1 cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  assign p1_cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register = {cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register, cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register_in};

  //cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register <= 0;
      else if (1)
          cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register <= p1_cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register;
    end


  //local readdatavalid cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1, which is an e_mux
  assign cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1 = cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1_shift_register[1];

  //allow new arb cycle for tri_state_bridge_0/avalon_slave, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_allow_new_arb_cycle = ~cpu_0_data_master_arbiterlock & ~cpu_0_instruction_master_arbiterlock;

  //cpu_0/instruction_master assignment into master qualified-requests vector for cfi_flash_0/s1, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_master_qreq_vector[0] = cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;

  //cpu_0/instruction_master grant cfi_flash_0/s1, which is an e_assign
  assign cpu_0_instruction_master_granted_cfi_flash_0_s1 = tri_state_bridge_0_avalon_slave_grant_vector[0];

  //cpu_0/instruction_master saved-grant cfi_flash_0/s1, which is an e_assign
  assign cpu_0_instruction_master_saved_grant_cfi_flash_0_s1 = tri_state_bridge_0_avalon_slave_arb_winner[0] && cpu_0_instruction_master_requests_cfi_flash_0_s1;

  //cpu_0/data_master assignment into master qualified-requests vector for cfi_flash_0/s1, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_master_qreq_vector[1] = cpu_0_data_master_qualified_request_cfi_flash_0_s1;

  //cpu_0/data_master grant cfi_flash_0/s1, which is an e_assign
  assign cpu_0_data_master_granted_cfi_flash_0_s1 = tri_state_bridge_0_avalon_slave_grant_vector[1];

  //cpu_0/data_master saved-grant cfi_flash_0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_cfi_flash_0_s1 = tri_state_bridge_0_avalon_slave_arb_winner[1] && cpu_0_data_master_requests_cfi_flash_0_s1;

  //tri_state_bridge_0/avalon_slave chosen-master double-vector, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_chosen_master_double_vector = {tri_state_bridge_0_avalon_slave_master_qreq_vector, tri_state_bridge_0_avalon_slave_master_qreq_vector} & ({~tri_state_bridge_0_avalon_slave_master_qreq_vector, ~tri_state_bridge_0_avalon_slave_master_qreq_vector} + tri_state_bridge_0_avalon_slave_arb_addend);

  //stable onehot encoding of arb winner
  assign tri_state_bridge_0_avalon_slave_arb_winner = (tri_state_bridge_0_avalon_slave_allow_new_arb_cycle & | tri_state_bridge_0_avalon_slave_grant_vector) ? tri_state_bridge_0_avalon_slave_grant_vector : tri_state_bridge_0_avalon_slave_saved_chosen_master_vector;

  //saved tri_state_bridge_0_avalon_slave_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_saved_chosen_master_vector <= 0;
      else if (tri_state_bridge_0_avalon_slave_allow_new_arb_cycle)
          tri_state_bridge_0_avalon_slave_saved_chosen_master_vector <= |tri_state_bridge_0_avalon_slave_grant_vector ? tri_state_bridge_0_avalon_slave_grant_vector : tri_state_bridge_0_avalon_slave_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign tri_state_bridge_0_avalon_slave_grant_vector = {(tri_state_bridge_0_avalon_slave_chosen_master_double_vector[1] | tri_state_bridge_0_avalon_slave_chosen_master_double_vector[3]),
    (tri_state_bridge_0_avalon_slave_chosen_master_double_vector[0] | tri_state_bridge_0_avalon_slave_chosen_master_double_vector[2])};

  //tri_state_bridge_0/avalon_slave chosen master rotated left, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_chosen_master_rot_left = (tri_state_bridge_0_avalon_slave_arb_winner << 1) ? (tri_state_bridge_0_avalon_slave_arb_winner << 1) : 1;

  //tri_state_bridge_0/avalon_slave's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_avalon_slave_arb_addend <= 1;
      else if (|tri_state_bridge_0_avalon_slave_grant_vector)
          tri_state_bridge_0_avalon_slave_arb_addend <= tri_state_bridge_0_avalon_slave_end_xfer? tri_state_bridge_0_avalon_slave_chosen_master_rot_left : tri_state_bridge_0_avalon_slave_grant_vector;
    end


  assign p1_select_n_to_the_cfi_flash_0 = ~(cpu_0_data_master_granted_cfi_flash_0_s1 | cpu_0_instruction_master_granted_cfi_flash_0_s1);
  //tri_state_bridge_0_avalon_slave_firsttransfer first transaction, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_firsttransfer = ~(tri_state_bridge_0_avalon_slave_slavearbiterlockenable & tri_state_bridge_0_avalon_slave_any_continuerequest);

  //tri_state_bridge_0_avalon_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_beginbursttransfer_internal = tri_state_bridge_0_avalon_slave_begins_xfer & tri_state_bridge_0_avalon_slave_firsttransfer;

  //tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign tri_state_bridge_0_avalon_slave_arbitration_holdoff_internal = tri_state_bridge_0_avalon_slave_begins_xfer & tri_state_bridge_0_avalon_slave_firsttransfer;

  //~tri_state_bridge_0_readn of type read to ~p1_tri_state_bridge_0_readn, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_readn <= ~0;
      else if (1)
          tri_state_bridge_0_readn <= p1_tri_state_bridge_0_readn;
    end


  //~write_n_to_the_cfi_flash_0 of type write to ~p1_write_n_to_the_cfi_flash_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          write_n_to_the_cfi_flash_0 <= ~0;
      else if (1)
          write_n_to_the_cfi_flash_0 <= p1_write_n_to_the_cfi_flash_0;
    end


  //~p1_tri_state_bridge_0_readn assignment, which is an e_mux
  assign p1_tri_state_bridge_0_readn = ~(((cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_cfi_flash_0_s1 & cpu_0_instruction_master_read))& ~tri_state_bridge_0_avalon_slave_begins_xfer & (cfi_flash_0_s1_wait_counter < 16));

  //~p1_write_n_to_the_cfi_flash_0 assignment, which is an e_mux
  assign p1_write_n_to_the_cfi_flash_0 = ~(((cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_write)) & ~tri_state_bridge_0_avalon_slave_begins_xfer & (cfi_flash_0_s1_wait_counter >= 4) & (cfi_flash_0_s1_wait_counter < 20) & cfi_flash_0_s1_pretend_byte_enable);

  //tri_state_bridge_0_address of type address to p1_tri_state_bridge_0_address, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          tri_state_bridge_0_address <= 0;
      else if (1)
          tri_state_bridge_0_address <= p1_tri_state_bridge_0_address;
    end


  //p1_tri_state_bridge_0_address mux, which is an e_mux
  assign p1_tri_state_bridge_0_address = (cpu_0_data_master_granted_cfi_flash_0_s1)? ({cpu_0_data_master_address_to_slave >> 2,
    cpu_0_data_master_dbs_address[1 : 0]}) :
    ({cpu_0_instruction_master_address_to_slave >> 2,
    cpu_0_instruction_master_dbs_address[1 : 0]});

  //d1_tri_state_bridge_0_avalon_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_tri_state_bridge_0_avalon_slave_end_xfer <= 1;
      else if (1)
          d1_tri_state_bridge_0_avalon_slave_end_xfer <= tri_state_bridge_0_avalon_slave_end_xfer;
    end


  //cfi_flash_0_s1_wait_counter_eq_1 assignment, which is an e_assign
  assign cfi_flash_0_s1_wait_counter_eq_1 = cfi_flash_0_s1_wait_counter == 1;

  //cfi_flash_0_s1_waits_for_read in a cycle, which is an e_mux
  assign cfi_flash_0_s1_waits_for_read = cfi_flash_0_s1_in_a_read_cycle & wait_for_cfi_flash_0_s1_counter;

  //cfi_flash_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign cfi_flash_0_s1_in_a_read_cycle = (cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_read) | (cpu_0_instruction_master_granted_cfi_flash_0_s1 & cpu_0_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = cfi_flash_0_s1_in_a_read_cycle;

  //cfi_flash_0_s1_waits_for_write in a cycle, which is an e_mux
  assign cfi_flash_0_s1_waits_for_write = cfi_flash_0_s1_in_a_write_cycle & wait_for_cfi_flash_0_s1_counter;

  //cfi_flash_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign cfi_flash_0_s1_in_a_write_cycle = cpu_0_data_master_granted_cfi_flash_0_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = cfi_flash_0_s1_in_a_write_cycle;

  assign cfi_flash_0_s1_wait_counter_eq_0 = cfi_flash_0_s1_wait_counter == 0;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          cfi_flash_0_s1_wait_counter <= 0;
      else if (1)
          cfi_flash_0_s1_wait_counter <= cfi_flash_0_s1_counter_load_value;
    end


  assign cfi_flash_0_s1_counter_load_value = ((cfi_flash_0_s1_in_a_read_cycle & tri_state_bridge_0_avalon_slave_begins_xfer))? 18 :
    ((cfi_flash_0_s1_in_a_write_cycle & tri_state_bridge_0_avalon_slave_begins_xfer))? 22 :
    (~cfi_flash_0_s1_wait_counter_eq_0)? cfi_flash_0_s1_wait_counter - 1 :
    0;

  assign wait_for_cfi_flash_0_s1_counter = tri_state_bridge_0_avalon_slave_begins_xfer | ~cfi_flash_0_s1_wait_counter_eq_0;
  //cfi_flash_0_s1_pretend_byte_enable byte enable port mux, which is an e_mux
  assign cfi_flash_0_s1_pretend_byte_enable = (cpu_0_data_master_granted_cfi_flash_0_s1)? cpu_0_data_master_byteenable_cfi_flash_0_s1 :
    -1;

  assign {cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_3,
cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_2,
cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_1,
cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_0} = cpu_0_data_master_byteenable;
  assign cpu_0_data_master_byteenable_cfi_flash_0_s1 = ((cpu_0_data_master_dbs_address[1 : 0] == 0))? cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_0 :
    ((cpu_0_data_master_dbs_address[1 : 0] == 1))? cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_1 :
    ((cpu_0_data_master_dbs_address[1 : 0] == 2))? cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_2 :
    cpu_0_data_master_byteenable_cfi_flash_0_s1_segment_3;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //incoming_tri_state_bridge_0_data_bit_0_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_0_is_x = ^(incoming_tri_state_bridge_0_data[0]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[0] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[0] = incoming_tri_state_bridge_0_data_bit_0_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[0];

  //incoming_tri_state_bridge_0_data_bit_1_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_1_is_x = ^(incoming_tri_state_bridge_0_data[1]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[1] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[1] = incoming_tri_state_bridge_0_data_bit_1_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[1];

  //incoming_tri_state_bridge_0_data_bit_2_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_2_is_x = ^(incoming_tri_state_bridge_0_data[2]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[2] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[2] = incoming_tri_state_bridge_0_data_bit_2_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[2];

  //incoming_tri_state_bridge_0_data_bit_3_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_3_is_x = ^(incoming_tri_state_bridge_0_data[3]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[3] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[3] = incoming_tri_state_bridge_0_data_bit_3_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[3];

  //incoming_tri_state_bridge_0_data_bit_4_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_4_is_x = ^(incoming_tri_state_bridge_0_data[4]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[4] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[4] = incoming_tri_state_bridge_0_data_bit_4_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[4];

  //incoming_tri_state_bridge_0_data_bit_5_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_5_is_x = ^(incoming_tri_state_bridge_0_data[5]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[5] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[5] = incoming_tri_state_bridge_0_data_bit_5_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[5];

  //incoming_tri_state_bridge_0_data_bit_6_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_6_is_x = ^(incoming_tri_state_bridge_0_data[6]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[6] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[6] = incoming_tri_state_bridge_0_data_bit_6_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[6];

  //incoming_tri_state_bridge_0_data_bit_7_is_x x check, which is an e_assign_is_x
  assign incoming_tri_state_bridge_0_data_bit_7_is_x = ^(incoming_tri_state_bridge_0_data[7]) === 1'bx;

  //Crush incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[7] Xs to 0, which is an e_assign
  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0[7] = incoming_tri_state_bridge_0_data_bit_7_is_x ? 1'b0 : incoming_tri_state_bridge_0_data[7];

  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_granted_cfi_flash_0_s1 + cpu_0_instruction_master_granted_cfi_flash_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (cpu_0_data_master_saved_grant_cfi_flash_0_s1 + cpu_0_instruction_master_saved_grant_cfi_flash_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  
//  assign incoming_tri_state_bridge_0_data_with_Xs_converted_to_0 = incoming_tri_state_bridge_0_data;
//
//synthesis read_comments_as_HDL off

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module tri_state_bridge_0_bridge_arbitrator 
;



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module uart_0_s1_arbitrator (
                              // inputs:
                               clk,
                               cpu_0_data_master_address_to_slave,
                               cpu_0_data_master_read,
                               cpu_0_data_master_write,
                               cpu_0_data_master_writedata,
                               reset_n,
                               uart_0_s1_dataavailable,
                               uart_0_s1_irq,
                               uart_0_s1_readdata,
                               uart_0_s1_readyfordata,

                              // outputs:
                               cpu_0_data_master_granted_uart_0_s1,
                               cpu_0_data_master_qualified_request_uart_0_s1,
                               cpu_0_data_master_read_data_valid_uart_0_s1,
                               cpu_0_data_master_requests_uart_0_s1,
                               d1_uart_0_s1_end_xfer,
                               uart_0_s1_address,
                               uart_0_s1_begintransfer,
                               uart_0_s1_chipselect,
                               uart_0_s1_dataavailable_from_sa,
                               uart_0_s1_irq_from_sa,
                               uart_0_s1_read_n,
                               uart_0_s1_readdata_from_sa,
                               uart_0_s1_readyfordata_from_sa,
                               uart_0_s1_reset_n,
                               uart_0_s1_write_n,
                               uart_0_s1_writedata
                            )
  /* synthesis auto_dissolve = "FALSE" */ ;

  output           cpu_0_data_master_granted_uart_0_s1;
  output           cpu_0_data_master_qualified_request_uart_0_s1;
  output           cpu_0_data_master_read_data_valid_uart_0_s1;
  output           cpu_0_data_master_requests_uart_0_s1;
  output           d1_uart_0_s1_end_xfer;
  output  [  2: 0] uart_0_s1_address;
  output           uart_0_s1_begintransfer;
  output           uart_0_s1_chipselect;
  output           uart_0_s1_dataavailable_from_sa;
  output           uart_0_s1_irq_from_sa;
  output           uart_0_s1_read_n;
  output  [ 15: 0] uart_0_s1_readdata_from_sa;
  output           uart_0_s1_readyfordata_from_sa;
  output           uart_0_s1_reset_n;
  output           uart_0_s1_write_n;
  output  [ 15: 0] uart_0_s1_writedata;
  input            clk;
  input   [ 23: 0] cpu_0_data_master_address_to_slave;
  input            cpu_0_data_master_read;
  input            cpu_0_data_master_write;
  input   [ 31: 0] cpu_0_data_master_writedata;
  input            reset_n;
  input            uart_0_s1_dataavailable;
  input            uart_0_s1_irq;
  input   [ 15: 0] uart_0_s1_readdata;
  input            uart_0_s1_readyfordata;

  wire             cpu_0_data_master_arbiterlock;
  wire             cpu_0_data_master_arbiterlock2;
  wire             cpu_0_data_master_continuerequest;
  wire             cpu_0_data_master_granted_uart_0_s1;
  wire             cpu_0_data_master_qualified_request_uart_0_s1;
  wire             cpu_0_data_master_read_data_valid_uart_0_s1;
  wire             cpu_0_data_master_requests_uart_0_s1;
  wire             cpu_0_data_master_saved_grant_uart_0_s1;
  reg              d1_reasons_to_wait;
  reg              d1_uart_0_s1_end_xfer;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  2: 0] uart_0_s1_address;
  wire             uart_0_s1_allgrants;
  wire             uart_0_s1_allow_new_arb_cycle;
  wire             uart_0_s1_any_continuerequest;
  wire             uart_0_s1_arb_counter_enable;
  reg     [  2: 0] uart_0_s1_arb_share_counter;
  wire    [  2: 0] uart_0_s1_arb_share_counter_next_value;
  wire    [  2: 0] uart_0_s1_arb_share_set_values;
  wire             uart_0_s1_beginbursttransfer_internal;
  wire             uart_0_s1_begins_xfer;
  wire             uart_0_s1_begintransfer;
  wire             uart_0_s1_chipselect;
  wire             uart_0_s1_dataavailable_from_sa;
  wire             uart_0_s1_end_xfer;
  wire             uart_0_s1_firsttransfer;
  wire             uart_0_s1_grant_vector;
  wire             uart_0_s1_in_a_read_cycle;
  wire             uart_0_s1_in_a_write_cycle;
  wire             uart_0_s1_irq_from_sa;
  wire             uart_0_s1_master_qreq_vector;
  wire             uart_0_s1_non_bursting_master_requests;
  wire             uart_0_s1_read_n;
  wire    [ 15: 0] uart_0_s1_readdata_from_sa;
  wire             uart_0_s1_readyfordata_from_sa;
  wire             uart_0_s1_reset_n;
  reg              uart_0_s1_slavearbiterlockenable;
  wire             uart_0_s1_slavearbiterlockenable2;
  wire             uart_0_s1_waits_for_read;
  wire             uart_0_s1_waits_for_write;
  wire             uart_0_s1_write_n;
  wire    [ 15: 0] uart_0_s1_writedata;
  wire             wait_for_uart_0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~uart_0_s1_end_xfer;
    end


  assign uart_0_s1_begins_xfer = ~d1_reasons_to_wait & ((cpu_0_data_master_qualified_request_uart_0_s1));
  //assign uart_0_s1_readdata_from_sa = uart_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign uart_0_s1_readdata_from_sa = uart_0_s1_readdata;

  assign cpu_0_data_master_requests_uart_0_s1 = ({cpu_0_data_master_address_to_slave[23 : 5] , 5'b0} == 24'h481000) & (cpu_0_data_master_read | cpu_0_data_master_write);
  //assign uart_0_s1_dataavailable_from_sa = uart_0_s1_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign uart_0_s1_dataavailable_from_sa = uart_0_s1_dataavailable;

  //assign uart_0_s1_readyfordata_from_sa = uart_0_s1_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign uart_0_s1_readyfordata_from_sa = uart_0_s1_readyfordata;

  //uart_0_s1_arb_share_counter set values, which is an e_mux
  assign uart_0_s1_arb_share_set_values = 1;

  //uart_0_s1_non_bursting_master_requests mux, which is an e_mux
  assign uart_0_s1_non_bursting_master_requests = cpu_0_data_master_requests_uart_0_s1;

  //uart_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign uart_0_s1_arb_share_counter_next_value = uart_0_s1_firsttransfer ? (uart_0_s1_arb_share_set_values - 1) : |uart_0_s1_arb_share_counter ? (uart_0_s1_arb_share_counter - 1) : 0;

  //uart_0_s1_allgrants all slave grants, which is an e_mux
  assign uart_0_s1_allgrants = |uart_0_s1_grant_vector;

  //uart_0_s1_end_xfer assignment, which is an e_assign
  assign uart_0_s1_end_xfer = ~(uart_0_s1_waits_for_read | uart_0_s1_waits_for_write);

  //uart_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign uart_0_s1_arb_counter_enable = (uart_0_s1_end_xfer & uart_0_s1_allgrants) | (uart_0_s1_end_xfer & ~uart_0_s1_non_bursting_master_requests);

  //uart_0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          uart_0_s1_arb_share_counter <= 0;
      else if (uart_0_s1_arb_counter_enable)
          uart_0_s1_arb_share_counter <= uart_0_s1_arb_share_counter_next_value;
    end


  //uart_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          uart_0_s1_slavearbiterlockenable <= 0;
      else if ((|uart_0_s1_master_qreq_vector & uart_0_s1_end_xfer) | (uart_0_s1_end_xfer & ~uart_0_s1_non_bursting_master_requests))
          uart_0_s1_slavearbiterlockenable <= |uart_0_s1_arb_share_counter_next_value;
    end


  //cpu_0/data_master uart_0/s1 arbiterlock, which is an e_assign
  assign cpu_0_data_master_arbiterlock = uart_0_s1_slavearbiterlockenable & cpu_0_data_master_continuerequest;

  //uart_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign uart_0_s1_slavearbiterlockenable2 = |uart_0_s1_arb_share_counter_next_value;

  //cpu_0/data_master uart_0/s1 arbiterlock2, which is an e_assign
  assign cpu_0_data_master_arbiterlock2 = uart_0_s1_slavearbiterlockenable2 & cpu_0_data_master_continuerequest;

  //uart_0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign uart_0_s1_any_continuerequest = 1;

  //cpu_0_data_master_continuerequest continued request, which is an e_assign
  assign cpu_0_data_master_continuerequest = 1;

  assign cpu_0_data_master_qualified_request_uart_0_s1 = cpu_0_data_master_requests_uart_0_s1;
  //uart_0_s1_writedata mux, which is an e_mux
  assign uart_0_s1_writedata = cpu_0_data_master_writedata;

  //master is always granted when requested
  assign cpu_0_data_master_granted_uart_0_s1 = cpu_0_data_master_qualified_request_uart_0_s1;

  //cpu_0/data_master saved-grant uart_0/s1, which is an e_assign
  assign cpu_0_data_master_saved_grant_uart_0_s1 = cpu_0_data_master_requests_uart_0_s1;

  //allow new arb cycle for uart_0/s1, which is an e_assign
  assign uart_0_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign uart_0_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign uart_0_s1_master_qreq_vector = 1;

  assign uart_0_s1_begintransfer = uart_0_s1_begins_xfer;
  //uart_0_s1_reset_n assignment, which is an e_assign
  assign uart_0_s1_reset_n = reset_n;

  assign uart_0_s1_chipselect = cpu_0_data_master_granted_uart_0_s1;
  //uart_0_s1_firsttransfer first transaction, which is an e_assign
  assign uart_0_s1_firsttransfer = ~(uart_0_s1_slavearbiterlockenable & uart_0_s1_any_continuerequest);

  //uart_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign uart_0_s1_beginbursttransfer_internal = uart_0_s1_begins_xfer & uart_0_s1_firsttransfer;

  //~uart_0_s1_read_n assignment, which is an e_mux
  assign uart_0_s1_read_n = ~(cpu_0_data_master_granted_uart_0_s1 & cpu_0_data_master_read);

  //~uart_0_s1_write_n assignment, which is an e_mux
  assign uart_0_s1_write_n = ~(cpu_0_data_master_granted_uart_0_s1 & cpu_0_data_master_write);

  //uart_0_s1_address mux, which is an e_mux
  assign uart_0_s1_address = cpu_0_data_master_address_to_slave >> 2;

  //d1_uart_0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_uart_0_s1_end_xfer <= 1;
      else if (1)
          d1_uart_0_s1_end_xfer <= uart_0_s1_end_xfer;
    end


  //uart_0_s1_waits_for_read in a cycle, which is an e_mux
  assign uart_0_s1_waits_for_read = uart_0_s1_in_a_read_cycle & uart_0_s1_begins_xfer;

  //uart_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign uart_0_s1_in_a_read_cycle = cpu_0_data_master_granted_uart_0_s1 & cpu_0_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = uart_0_s1_in_a_read_cycle;

  //uart_0_s1_waits_for_write in a cycle, which is an e_mux
  assign uart_0_s1_waits_for_write = uart_0_s1_in_a_write_cycle & uart_0_s1_begins_xfer;

  //uart_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign uart_0_s1_in_a_write_cycle = cpu_0_data_master_granted_uart_0_s1 & cpu_0_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = uart_0_s1_in_a_write_cycle;

  assign wait_for_uart_0_s1_counter = 0;
  //assign uart_0_s1_irq_from_sa = uart_0_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign uart_0_s1_irq_from_sa = uart_0_s1_irq;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module system_0_reset_clk_domain_synch_module (
                                                // inputs:
                                                 clk,
                                                 data_in,
                                                 reset_n,

                                                // outputs:
                                                 data_out
                                              )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "MAX_DELAY=\"100ns\" ; PRESERVE_REGISTER=ON"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else if (1)
          data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else if (1)
          data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module system_0 (
                  // 1) global signals:
                   clk,
                   reset_n,

                  // the_KEY
                   in_port_to_the_KEY,

                  // the_LEDG
                   out_port_from_the_LEDG,

                  // the_LEDR
                   out_port_from_the_LEDR,

                  // the_SEG7
                   oSEG0_from_the_SEG7,
                   oSEG1_from_the_SEG7,
                   oSEG2_from_the_SEG7,
                   oSEG3_from_the_SEG7,

                  // the_Switch
                   in_port_to_the_Switch,

                  // the_sdram_0
                   zs_addr_from_the_sdram_0,
                   zs_ba_from_the_sdram_0,
                   zs_cas_n_from_the_sdram_0,
                   zs_cke_from_the_sdram_0,
                   zs_cs_n_from_the_sdram_0,
                   zs_dq_to_and_from_the_sdram_0,
                   zs_dqm_from_the_sdram_0,
                   zs_ras_n_from_the_sdram_0,
                   zs_we_n_from_the_sdram_0,

                  // the_sram_0
                   SRAM_ADDR_from_the_sram_0,
                   SRAM_CE_N_from_the_sram_0,
                   SRAM_DQ_to_and_from_the_sram_0,
                   SRAM_LB_N_from_the_sram_0,
                   SRAM_OE_N_from_the_sram_0,
                   SRAM_UB_N_from_the_sram_0,
                   SRAM_WE_N_from_the_sram_0,

                  // the_tri_state_bridge_0_avalon_slave
                   select_n_to_the_cfi_flash_0,
                   tri_state_bridge_0_address,
                   tri_state_bridge_0_data,
                   tri_state_bridge_0_readn,
                   write_n_to_the_cfi_flash_0,

                  // the_uart_0
                   rxd_to_the_uart_0,
                   txd_from_the_uart_0
                )
;

  output  [ 17: 0] SRAM_ADDR_from_the_sram_0;
  output           SRAM_CE_N_from_the_sram_0;
  inout   [ 15: 0] SRAM_DQ_to_and_from_the_sram_0;
  output           SRAM_LB_N_from_the_sram_0;
  output           SRAM_OE_N_from_the_sram_0;
  output           SRAM_UB_N_from_the_sram_0;
  output           SRAM_WE_N_from_the_sram_0;
  output  [  6: 0] oSEG0_from_the_SEG7;
  output  [  6: 0] oSEG1_from_the_SEG7;
  output  [  6: 0] oSEG2_from_the_SEG7;
  output  [  6: 0] oSEG3_from_the_SEG7;
  output  [  7: 0] out_port_from_the_LEDG;
  output  [  9: 0] out_port_from_the_LEDR;
  output           select_n_to_the_cfi_flash_0;
  output  [ 21: 0] tri_state_bridge_0_address;
  inout   [  7: 0] tri_state_bridge_0_data;
  output           tri_state_bridge_0_readn;
  output           txd_from_the_uart_0;
  output           write_n_to_the_cfi_flash_0;
  output  [ 11: 0] zs_addr_from_the_sdram_0;
  output  [  1: 0] zs_ba_from_the_sdram_0;
  output           zs_cas_n_from_the_sdram_0;
  output           zs_cke_from_the_sdram_0;
  output           zs_cs_n_from_the_sdram_0;
  inout   [ 15: 0] zs_dq_to_and_from_the_sdram_0;
  output  [  1: 0] zs_dqm_from_the_sdram_0;
  output           zs_ras_n_from_the_sdram_0;
  output           zs_we_n_from_the_sdram_0;
  input            clk;
  input   [  3: 0] in_port_to_the_KEY;
  input   [  9: 0] in_port_to_the_Switch;
  input            reset_n;
  input            rxd_to_the_uart_0;

  wire    [  1: 0] KEY_s1_address;
  wire             KEY_s1_chipselect;
  wire             KEY_s1_irq;
  wire             KEY_s1_irq_from_sa;
  wire    [  3: 0] KEY_s1_readdata;
  wire    [  3: 0] KEY_s1_readdata_from_sa;
  wire             KEY_s1_reset_n;
  wire             KEY_s1_write_n;
  wire    [  3: 0] KEY_s1_writedata;
  wire    [  1: 0] LEDG_s1_address;
  wire             LEDG_s1_chipselect;
  wire             LEDG_s1_reset_n;
  wire             LEDG_s1_write_n;
  wire    [  7: 0] LEDG_s1_writedata;
  wire    [  1: 0] LEDR_s1_address;
  wire             LEDR_s1_chipselect;
  wire             LEDR_s1_reset_n;
  wire             LEDR_s1_write_n;
  wire    [  9: 0] LEDR_s1_writedata;
  wire             SEG7_avalonS_reset_n;
  wire             SEG7_avalonS_write;
  wire    [ 15: 0] SEG7_avalonS_writedata;
  wire    [ 17: 0] SRAM_ADDR_from_the_sram_0;
  wire             SRAM_CE_N_from_the_sram_0;
  wire    [ 15: 0] SRAM_DQ_to_and_from_the_sram_0;
  wire             SRAM_LB_N_from_the_sram_0;
  wire             SRAM_OE_N_from_the_sram_0;
  wire             SRAM_UB_N_from_the_sram_0;
  wire             SRAM_WE_N_from_the_sram_0;
  wire    [  1: 0] Switch_s1_address;
  wire    [  9: 0] Switch_s1_readdata;
  wire    [  9: 0] Switch_s1_readdata_from_sa;
  wire             Switch_s1_reset_n;
  wire             cfi_flash_0_s1_wait_counter_eq_0;
  wire             cfi_flash_0_s1_wait_counter_eq_1;
  wire             clk_reset_n;
  wire    [ 23: 0] cpu_0_data_master_address;
  wire    [ 23: 0] cpu_0_data_master_address_to_slave;
  wire    [  3: 0] cpu_0_data_master_byteenable;
  wire             cpu_0_data_master_byteenable_cfi_flash_0_s1;
  wire    [  1: 0] cpu_0_data_master_byteenable_sdram_0_s1;
  wire    [  1: 0] cpu_0_data_master_byteenable_sram_0_avalonS;
  wire    [  1: 0] cpu_0_data_master_dbs_address;
  wire    [ 15: 0] cpu_0_data_master_dbs_write_16;
  wire    [  7: 0] cpu_0_data_master_dbs_write_8;
  wire             cpu_0_data_master_debugaccess;
  wire             cpu_0_data_master_granted_KEY_s1;
  wire             cpu_0_data_master_granted_LEDG_s1;
  wire             cpu_0_data_master_granted_LEDR_s1;
  wire             cpu_0_data_master_granted_SEG7_avalonS;
  wire             cpu_0_data_master_granted_Switch_s1;
  wire             cpu_0_data_master_granted_cfi_flash_0_s1;
  wire             cpu_0_data_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_granted_epcs_controller_epcs_control_port;
  wire             cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_granted_sdram_0_s1;
  wire             cpu_0_data_master_granted_sram_0_avalonS;
  wire             cpu_0_data_master_granted_uart_0_s1;
  wire    [ 31: 0] cpu_0_data_master_irq;
  wire             cpu_0_data_master_no_byte_enables_and_last_term;
  wire             cpu_0_data_master_qualified_request_KEY_s1;
  wire             cpu_0_data_master_qualified_request_LEDG_s1;
  wire             cpu_0_data_master_qualified_request_LEDR_s1;
  wire             cpu_0_data_master_qualified_request_SEG7_avalonS;
  wire             cpu_0_data_master_qualified_request_Switch_s1;
  wire             cpu_0_data_master_qualified_request_cfi_flash_0_s1;
  wire             cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port;
  wire             cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_qualified_request_sdram_0_s1;
  wire             cpu_0_data_master_qualified_request_sram_0_avalonS;
  wire             cpu_0_data_master_qualified_request_uart_0_s1;
  wire             cpu_0_data_master_read;
  wire             cpu_0_data_master_read_data_valid_KEY_s1;
  wire             cpu_0_data_master_read_data_valid_LEDG_s1;
  wire             cpu_0_data_master_read_data_valid_LEDR_s1;
  wire             cpu_0_data_master_read_data_valid_SEG7_avalonS;
  wire             cpu_0_data_master_read_data_valid_Switch_s1;
  wire             cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  wire             cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_read_data_valid_epcs_controller_epcs_control_port;
  wire             cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_read_data_valid_sdram_0_s1;
  wire             cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register;
  wire             cpu_0_data_master_read_data_valid_sram_0_avalonS;
  wire             cpu_0_data_master_read_data_valid_uart_0_s1;
  wire    [ 31: 0] cpu_0_data_master_readdata;
  wire             cpu_0_data_master_requests_KEY_s1;
  wire             cpu_0_data_master_requests_LEDG_s1;
  wire             cpu_0_data_master_requests_LEDR_s1;
  wire             cpu_0_data_master_requests_SEG7_avalonS;
  wire             cpu_0_data_master_requests_Switch_s1;
  wire             cpu_0_data_master_requests_cfi_flash_0_s1;
  wire             cpu_0_data_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_data_master_requests_epcs_controller_epcs_control_port;
  wire             cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave;
  wire             cpu_0_data_master_requests_sdram_0_s1;
  wire             cpu_0_data_master_requests_sram_0_avalonS;
  wire             cpu_0_data_master_requests_uart_0_s1;
  wire             cpu_0_data_master_waitrequest;
  wire             cpu_0_data_master_write;
  wire    [ 31: 0] cpu_0_data_master_writedata;
  wire    [ 23: 0] cpu_0_instruction_master_address;
  wire    [ 23: 0] cpu_0_instruction_master_address_to_slave;
  wire    [  1: 0] cpu_0_instruction_master_dbs_address;
  wire             cpu_0_instruction_master_granted_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_granted_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_granted_epcs_controller_epcs_control_port;
  wire             cpu_0_instruction_master_granted_sdram_0_s1;
  wire             cpu_0_instruction_master_granted_sram_0_avalonS;
  wire    [  1: 0] cpu_0_instruction_master_latency_counter;
  wire             cpu_0_instruction_master_qualified_request_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port;
  wire             cpu_0_instruction_master_qualified_request_sdram_0_s1;
  wire             cpu_0_instruction_master_qualified_request_sram_0_avalonS;
  wire             cpu_0_instruction_master_read;
  wire             cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port;
  wire             cpu_0_instruction_master_read_data_valid_sdram_0_s1;
  wire             cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register;
  wire             cpu_0_instruction_master_read_data_valid_sram_0_avalonS;
  wire    [ 31: 0] cpu_0_instruction_master_readdata;
  wire             cpu_0_instruction_master_readdatavalid;
  wire             cpu_0_instruction_master_requests_cfi_flash_0_s1;
  wire             cpu_0_instruction_master_requests_cpu_0_jtag_debug_module;
  wire             cpu_0_instruction_master_requests_epcs_controller_epcs_control_port;
  wire             cpu_0_instruction_master_requests_sdram_0_s1;
  wire             cpu_0_instruction_master_requests_sram_0_avalonS;
  wire             cpu_0_instruction_master_waitrequest;
  wire    [  8: 0] cpu_0_jtag_debug_module_address;
  wire             cpu_0_jtag_debug_module_begintransfer;
  wire    [  3: 0] cpu_0_jtag_debug_module_byteenable;
  wire             cpu_0_jtag_debug_module_chipselect;
  wire             cpu_0_jtag_debug_module_debugaccess;
  wire    [ 31: 0] cpu_0_jtag_debug_module_readdata;
  wire    [ 31: 0] cpu_0_jtag_debug_module_readdata_from_sa;
  wire             cpu_0_jtag_debug_module_reset;
  wire             cpu_0_jtag_debug_module_reset_n;
  wire             cpu_0_jtag_debug_module_resetrequest;
  wire             cpu_0_jtag_debug_module_resetrequest_from_sa;
  wire             cpu_0_jtag_debug_module_write;
  wire    [ 31: 0] cpu_0_jtag_debug_module_writedata;
  wire             d1_KEY_s1_end_xfer;
  wire             d1_LEDG_s1_end_xfer;
  wire             d1_LEDR_s1_end_xfer;
  wire             d1_SEG7_avalonS_end_xfer;
  wire             d1_Switch_s1_end_xfer;
  wire             d1_cpu_0_jtag_debug_module_end_xfer;
  wire             d1_epcs_controller_epcs_control_port_end_xfer;
  wire             d1_jtag_uart_0_avalon_jtag_slave_end_xfer;
  wire             d1_sdram_0_s1_end_xfer;
  wire             d1_sram_0_avalonS_end_xfer;
  wire             d1_tri_state_bridge_0_avalon_slave_end_xfer;
  wire             d1_uart_0_s1_end_xfer;
  wire    [  8: 0] epcs_controller_epcs_control_port_address;
  wire             epcs_controller_epcs_control_port_chipselect;
  wire             epcs_controller_epcs_control_port_dataavailable;
  wire             epcs_controller_epcs_control_port_dataavailable_from_sa;
  wire             epcs_controller_epcs_control_port_endofpacket;
  wire             epcs_controller_epcs_control_port_endofpacket_from_sa;
  wire             epcs_controller_epcs_control_port_irq;
  wire             epcs_controller_epcs_control_port_irq_from_sa;
  wire             epcs_controller_epcs_control_port_read_n;
  wire    [ 31: 0] epcs_controller_epcs_control_port_readdata;
  wire    [ 31: 0] epcs_controller_epcs_control_port_readdata_from_sa;
  wire             epcs_controller_epcs_control_port_readyfordata;
  wire             epcs_controller_epcs_control_port_readyfordata_from_sa;
  wire             epcs_controller_epcs_control_port_reset_n;
  wire             epcs_controller_epcs_control_port_write_n;
  wire    [ 31: 0] epcs_controller_epcs_control_port_writedata;
  wire    [  7: 0] incoming_tri_state_bridge_0_data;
  wire    [  7: 0] incoming_tri_state_bridge_0_data_with_Xs_converted_to_0;
  wire             jtag_uart_0_avalon_jtag_slave_address;
  wire             jtag_uart_0_avalon_jtag_slave_chipselect;
  wire             jtag_uart_0_avalon_jtag_slave_dataavailable;
  wire             jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_irq;
  wire             jtag_uart_0_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_readyfordata;
  wire             jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_reset_n;
  wire             jtag_uart_0_avalon_jtag_slave_waitrequest;
  wire             jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_0_avalon_jtag_slave_writedata;
  wire    [  6: 0] oSEG0_from_the_SEG7;
  wire    [  6: 0] oSEG1_from_the_SEG7;
  wire    [  6: 0] oSEG2_from_the_SEG7;
  wire    [  6: 0] oSEG3_from_the_SEG7;
  wire    [  7: 0] out_port_from_the_LEDG;
  wire    [  9: 0] out_port_from_the_LEDR;
  wire             registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1;
  wire             reset_n_sources;
  wire    [ 21: 0] sdram_0_s1_address;
  wire    [  1: 0] sdram_0_s1_byteenable_n;
  wire             sdram_0_s1_chipselect;
  wire             sdram_0_s1_read_n;
  wire    [ 15: 0] sdram_0_s1_readdata;
  wire    [ 15: 0] sdram_0_s1_readdata_from_sa;
  wire             sdram_0_s1_readdatavalid;
  wire             sdram_0_s1_reset_n;
  wire             sdram_0_s1_waitrequest;
  wire             sdram_0_s1_waitrequest_from_sa;
  wire             sdram_0_s1_write_n;
  wire    [ 15: 0] sdram_0_s1_writedata;
  wire             select_n_to_the_cfi_flash_0;
  wire    [ 17: 0] sram_0_avalonS_address;
  wire    [  1: 0] sram_0_avalonS_byteenable_n;
  wire             sram_0_avalonS_chipselect_n;
  wire             sram_0_avalonS_outputenable_n;
  wire    [ 15: 0] sram_0_avalonS_readdata;
  wire    [ 15: 0] sram_0_avalonS_readdata_from_sa;
  wire             sram_0_avalonS_reset_n;
  wire             sram_0_avalonS_wait_counter_eq_0;
  wire             sram_0_avalonS_wait_counter_eq_1;
  wire             sram_0_avalonS_write_n;
  wire    [ 15: 0] sram_0_avalonS_writedata;
  wire    [ 21: 0] tri_state_bridge_0_address;
  wire    [  7: 0] tri_state_bridge_0_data;
  wire             tri_state_bridge_0_readn;
  wire             txd_from_the_uart_0;
  wire    [  2: 0] uart_0_s1_address;
  wire             uart_0_s1_begintransfer;
  wire             uart_0_s1_chipselect;
  wire             uart_0_s1_dataavailable;
  wire             uart_0_s1_dataavailable_from_sa;
  wire             uart_0_s1_irq;
  wire             uart_0_s1_irq_from_sa;
  wire             uart_0_s1_read_n;
  wire    [ 15: 0] uart_0_s1_readdata;
  wire    [ 15: 0] uart_0_s1_readdata_from_sa;
  wire             uart_0_s1_readyfordata;
  wire             uart_0_s1_readyfordata_from_sa;
  wire             uart_0_s1_reset_n;
  wire             uart_0_s1_write_n;
  wire    [ 15: 0] uart_0_s1_writedata;
  wire             write_n_to_the_cfi_flash_0;
  wire    [ 11: 0] zs_addr_from_the_sdram_0;
  wire    [  1: 0] zs_ba_from_the_sdram_0;
  wire             zs_cas_n_from_the_sdram_0;
  wire             zs_cke_from_the_sdram_0;
  wire             zs_cs_n_from_the_sdram_0;
  wire    [ 15: 0] zs_dq_to_and_from_the_sdram_0;
  wire    [  1: 0] zs_dqm_from_the_sdram_0;
  wire             zs_ras_n_from_the_sdram_0;
  wire             zs_we_n_from_the_sdram_0;
  KEY_s1_arbitrator the_KEY_s1
    (
      .KEY_s1_address                             (KEY_s1_address),
      .KEY_s1_chipselect                          (KEY_s1_chipselect),
      .KEY_s1_irq                                 (KEY_s1_irq),
      .KEY_s1_irq_from_sa                         (KEY_s1_irq_from_sa),
      .KEY_s1_readdata                            (KEY_s1_readdata),
      .KEY_s1_readdata_from_sa                    (KEY_s1_readdata_from_sa),
      .KEY_s1_reset_n                             (KEY_s1_reset_n),
      .KEY_s1_write_n                             (KEY_s1_write_n),
      .KEY_s1_writedata                           (KEY_s1_writedata),
      .clk                                        (clk),
      .cpu_0_data_master_address_to_slave         (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_KEY_s1           (cpu_0_data_master_granted_KEY_s1),
      .cpu_0_data_master_qualified_request_KEY_s1 (cpu_0_data_master_qualified_request_KEY_s1),
      .cpu_0_data_master_read                     (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_KEY_s1   (cpu_0_data_master_read_data_valid_KEY_s1),
      .cpu_0_data_master_requests_KEY_s1          (cpu_0_data_master_requests_KEY_s1),
      .cpu_0_data_master_waitrequest              (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                    (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                (cpu_0_data_master_writedata),
      .d1_KEY_s1_end_xfer                         (d1_KEY_s1_end_xfer),
      .reset_n                                    (clk_reset_n)
    );

  KEY the_KEY
    (
      .address    (KEY_s1_address),
      .chipselect (KEY_s1_chipselect),
      .clk        (clk),
      .in_port    (in_port_to_the_KEY),
      .irq        (KEY_s1_irq),
      .readdata   (KEY_s1_readdata),
      .reset_n    (KEY_s1_reset_n),
      .write_n    (KEY_s1_write_n),
      .writedata  (KEY_s1_writedata)
    );

  LEDG_s1_arbitrator the_LEDG_s1
    (
      .LEDG_s1_address                             (LEDG_s1_address),
      .LEDG_s1_chipselect                          (LEDG_s1_chipselect),
      .LEDG_s1_reset_n                             (LEDG_s1_reset_n),
      .LEDG_s1_write_n                             (LEDG_s1_write_n),
      .LEDG_s1_writedata                           (LEDG_s1_writedata),
      .clk                                         (clk),
      .cpu_0_data_master_address_to_slave          (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                (cpu_0_data_master_byteenable),
      .cpu_0_data_master_granted_LEDG_s1           (cpu_0_data_master_granted_LEDG_s1),
      .cpu_0_data_master_qualified_request_LEDG_s1 (cpu_0_data_master_qualified_request_LEDG_s1),
      .cpu_0_data_master_read                      (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_LEDG_s1   (cpu_0_data_master_read_data_valid_LEDG_s1),
      .cpu_0_data_master_requests_LEDG_s1          (cpu_0_data_master_requests_LEDG_s1),
      .cpu_0_data_master_waitrequest               (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                     (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                 (cpu_0_data_master_writedata),
      .d1_LEDG_s1_end_xfer                         (d1_LEDG_s1_end_xfer),
      .reset_n                                     (clk_reset_n)
    );

  LEDG the_LEDG
    (
      .address    (LEDG_s1_address),
      .chipselect (LEDG_s1_chipselect),
      .clk        (clk),
      .out_port   (out_port_from_the_LEDG),
      .reset_n    (LEDG_s1_reset_n),
      .write_n    (LEDG_s1_write_n),
      .writedata  (LEDG_s1_writedata)
    );

  LEDR_s1_arbitrator the_LEDR_s1
    (
      .LEDR_s1_address                             (LEDR_s1_address),
      .LEDR_s1_chipselect                          (LEDR_s1_chipselect),
      .LEDR_s1_reset_n                             (LEDR_s1_reset_n),
      .LEDR_s1_write_n                             (LEDR_s1_write_n),
      .LEDR_s1_writedata                           (LEDR_s1_writedata),
      .clk                                         (clk),
      .cpu_0_data_master_address_to_slave          (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_LEDR_s1           (cpu_0_data_master_granted_LEDR_s1),
      .cpu_0_data_master_qualified_request_LEDR_s1 (cpu_0_data_master_qualified_request_LEDR_s1),
      .cpu_0_data_master_read                      (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_LEDR_s1   (cpu_0_data_master_read_data_valid_LEDR_s1),
      .cpu_0_data_master_requests_LEDR_s1          (cpu_0_data_master_requests_LEDR_s1),
      .cpu_0_data_master_waitrequest               (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                     (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                 (cpu_0_data_master_writedata),
      .d1_LEDR_s1_end_xfer                         (d1_LEDR_s1_end_xfer),
      .reset_n                                     (clk_reset_n)
    );

  LEDR the_LEDR
    (
      .address    (LEDR_s1_address),
      .chipselect (LEDR_s1_chipselect),
      .clk        (clk),
      .out_port   (out_port_from_the_LEDR),
      .reset_n    (LEDR_s1_reset_n),
      .write_n    (LEDR_s1_write_n),
      .writedata  (LEDR_s1_writedata)
    );

  SEG7_avalonS_arbitrator the_SEG7_avalonS
    (
      .SEG7_avalonS_reset_n                             (SEG7_avalonS_reset_n),
      .SEG7_avalonS_write                               (SEG7_avalonS_write),
      .SEG7_avalonS_writedata                           (SEG7_avalonS_writedata),
      .clk                                              (clk),
      .cpu_0_data_master_address_to_slave               (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_SEG7_avalonS           (cpu_0_data_master_granted_SEG7_avalonS),
      .cpu_0_data_master_qualified_request_SEG7_avalonS (cpu_0_data_master_qualified_request_SEG7_avalonS),
      .cpu_0_data_master_read                           (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_SEG7_avalonS   (cpu_0_data_master_read_data_valid_SEG7_avalonS),
      .cpu_0_data_master_requests_SEG7_avalonS          (cpu_0_data_master_requests_SEG7_avalonS),
      .cpu_0_data_master_waitrequest                    (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                          (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                      (cpu_0_data_master_writedata),
      .d1_SEG7_avalonS_end_xfer                         (d1_SEG7_avalonS_end_xfer),
      .reset_n                                          (clk_reset_n)
    );

  SEG7 the_SEG7
    (
      .iCLK   (clk),
      .iDIG   (SEG7_avalonS_writedata),
      .iRST_N (SEG7_avalonS_reset_n),
      .iWR    (SEG7_avalonS_write),
      .oSEG0  (oSEG0_from_the_SEG7),
      .oSEG1  (oSEG1_from_the_SEG7),
      .oSEG2  (oSEG2_from_the_SEG7),
      .oSEG3  (oSEG3_from_the_SEG7)
    );

  Switch_s1_arbitrator the_Switch_s1
    (
      .Switch_s1_address                             (Switch_s1_address),
      .Switch_s1_readdata                            (Switch_s1_readdata),
      .Switch_s1_readdata_from_sa                    (Switch_s1_readdata_from_sa),
      .Switch_s1_reset_n                             (Switch_s1_reset_n),
      .clk                                           (clk),
      .cpu_0_data_master_address_to_slave            (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_Switch_s1           (cpu_0_data_master_granted_Switch_s1),
      .cpu_0_data_master_qualified_request_Switch_s1 (cpu_0_data_master_qualified_request_Switch_s1),
      .cpu_0_data_master_read                        (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_Switch_s1   (cpu_0_data_master_read_data_valid_Switch_s1),
      .cpu_0_data_master_requests_Switch_s1          (cpu_0_data_master_requests_Switch_s1),
      .cpu_0_data_master_write                       (cpu_0_data_master_write),
      .d1_Switch_s1_end_xfer                         (d1_Switch_s1_end_xfer),
      .reset_n                                       (clk_reset_n)
    );

  Switch the_Switch
    (
      .address  (Switch_s1_address),
      .clk      (clk),
      .in_port  (in_port_to_the_Switch),
      .readdata (Switch_s1_readdata),
      .reset_n  (Switch_s1_reset_n)
    );

  cpu_0_jtag_debug_module_arbitrator the_cpu_0_jtag_debug_module
    (
      .clk                                                                (clk),
      .cpu_0_data_master_address_to_slave                                 (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                       (cpu_0_data_master_byteenable),
      .cpu_0_data_master_debugaccess                                      (cpu_0_data_master_debugaccess),
      .cpu_0_data_master_granted_cpu_0_jtag_debug_module                  (cpu_0_data_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module        (cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_data_master_read                                             (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module          (cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_data_master_requests_cpu_0_jtag_debug_module                 (cpu_0_data_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_data_master_write                                            (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                        (cpu_0_data_master_writedata),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_granted_cpu_0_jtag_debug_module           (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module (cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module   (cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_requests_cpu_0_jtag_debug_module          (cpu_0_instruction_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_jtag_debug_module_address                                    (cpu_0_jtag_debug_module_address),
      .cpu_0_jtag_debug_module_begintransfer                              (cpu_0_jtag_debug_module_begintransfer),
      .cpu_0_jtag_debug_module_byteenable                                 (cpu_0_jtag_debug_module_byteenable),
      .cpu_0_jtag_debug_module_chipselect                                 (cpu_0_jtag_debug_module_chipselect),
      .cpu_0_jtag_debug_module_debugaccess                                (cpu_0_jtag_debug_module_debugaccess),
      .cpu_0_jtag_debug_module_readdata                                   (cpu_0_jtag_debug_module_readdata),
      .cpu_0_jtag_debug_module_readdata_from_sa                           (cpu_0_jtag_debug_module_readdata_from_sa),
      .cpu_0_jtag_debug_module_reset                                      (cpu_0_jtag_debug_module_reset),
      .cpu_0_jtag_debug_module_reset_n                                    (cpu_0_jtag_debug_module_reset_n),
      .cpu_0_jtag_debug_module_resetrequest                               (cpu_0_jtag_debug_module_resetrequest),
      .cpu_0_jtag_debug_module_resetrequest_from_sa                       (cpu_0_jtag_debug_module_resetrequest_from_sa),
      .cpu_0_jtag_debug_module_write                                      (cpu_0_jtag_debug_module_write),
      .cpu_0_jtag_debug_module_writedata                                  (cpu_0_jtag_debug_module_writedata),
      .d1_cpu_0_jtag_debug_module_end_xfer                                (d1_cpu_0_jtag_debug_module_end_xfer),
      .reset_n                                                            (clk_reset_n)
    );

  cpu_0_data_master_arbitrator the_cpu_0_data_master
    (
      .KEY_s1_irq_from_sa                                                    (KEY_s1_irq_from_sa),
      .KEY_s1_readdata_from_sa                                               (KEY_s1_readdata_from_sa),
      .Switch_s1_readdata_from_sa                                            (Switch_s1_readdata_from_sa),
      .cfi_flash_0_s1_wait_counter_eq_0                                      (cfi_flash_0_s1_wait_counter_eq_0),
      .cfi_flash_0_s1_wait_counter_eq_1                                      (cfi_flash_0_s1_wait_counter_eq_1),
      .clk                                                                   (clk),
      .cpu_0_data_master_address                                             (cpu_0_data_master_address),
      .cpu_0_data_master_address_to_slave                                    (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable_cfi_flash_0_s1                           (cpu_0_data_master_byteenable_cfi_flash_0_s1),
      .cpu_0_data_master_byteenable_sdram_0_s1                               (cpu_0_data_master_byteenable_sdram_0_s1),
      .cpu_0_data_master_byteenable_sram_0_avalonS                           (cpu_0_data_master_byteenable_sram_0_avalonS),
      .cpu_0_data_master_dbs_address                                         (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_16                                        (cpu_0_data_master_dbs_write_16),
      .cpu_0_data_master_dbs_write_8                                         (cpu_0_data_master_dbs_write_8),
      .cpu_0_data_master_debugaccess                                         (cpu_0_data_master_debugaccess),
      .cpu_0_data_master_granted_KEY_s1                                      (cpu_0_data_master_granted_KEY_s1),
      .cpu_0_data_master_granted_LEDG_s1                                     (cpu_0_data_master_granted_LEDG_s1),
      .cpu_0_data_master_granted_LEDR_s1                                     (cpu_0_data_master_granted_LEDR_s1),
      .cpu_0_data_master_granted_SEG7_avalonS                                (cpu_0_data_master_granted_SEG7_avalonS),
      .cpu_0_data_master_granted_Switch_s1                                   (cpu_0_data_master_granted_Switch_s1),
      .cpu_0_data_master_granted_cfi_flash_0_s1                              (cpu_0_data_master_granted_cfi_flash_0_s1),
      .cpu_0_data_master_granted_cpu_0_jtag_debug_module                     (cpu_0_data_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_data_master_granted_epcs_controller_epcs_control_port           (cpu_0_data_master_granted_epcs_controller_epcs_control_port),
      .cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave               (cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_granted_sdram_0_s1                                  (cpu_0_data_master_granted_sdram_0_s1),
      .cpu_0_data_master_granted_sram_0_avalonS                              (cpu_0_data_master_granted_sram_0_avalonS),
      .cpu_0_data_master_granted_uart_0_s1                                   (cpu_0_data_master_granted_uart_0_s1),
      .cpu_0_data_master_irq                                                 (cpu_0_data_master_irq),
      .cpu_0_data_master_no_byte_enables_and_last_term                       (cpu_0_data_master_no_byte_enables_and_last_term),
      .cpu_0_data_master_qualified_request_KEY_s1                            (cpu_0_data_master_qualified_request_KEY_s1),
      .cpu_0_data_master_qualified_request_LEDG_s1                           (cpu_0_data_master_qualified_request_LEDG_s1),
      .cpu_0_data_master_qualified_request_LEDR_s1                           (cpu_0_data_master_qualified_request_LEDR_s1),
      .cpu_0_data_master_qualified_request_SEG7_avalonS                      (cpu_0_data_master_qualified_request_SEG7_avalonS),
      .cpu_0_data_master_qualified_request_Switch_s1                         (cpu_0_data_master_qualified_request_Switch_s1),
      .cpu_0_data_master_qualified_request_cfi_flash_0_s1                    (cpu_0_data_master_qualified_request_cfi_flash_0_s1),
      .cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module           (cpu_0_data_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port (cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port),
      .cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave     (cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_qualified_request_sdram_0_s1                        (cpu_0_data_master_qualified_request_sdram_0_s1),
      .cpu_0_data_master_qualified_request_sram_0_avalonS                    (cpu_0_data_master_qualified_request_sram_0_avalonS),
      .cpu_0_data_master_qualified_request_uart_0_s1                         (cpu_0_data_master_qualified_request_uart_0_s1),
      .cpu_0_data_master_read                                                (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_KEY_s1                              (cpu_0_data_master_read_data_valid_KEY_s1),
      .cpu_0_data_master_read_data_valid_LEDG_s1                             (cpu_0_data_master_read_data_valid_LEDG_s1),
      .cpu_0_data_master_read_data_valid_LEDR_s1                             (cpu_0_data_master_read_data_valid_LEDR_s1),
      .cpu_0_data_master_read_data_valid_SEG7_avalonS                        (cpu_0_data_master_read_data_valid_SEG7_avalonS),
      .cpu_0_data_master_read_data_valid_Switch_s1                           (cpu_0_data_master_read_data_valid_Switch_s1),
      .cpu_0_data_master_read_data_valid_cfi_flash_0_s1                      (cpu_0_data_master_read_data_valid_cfi_flash_0_s1),
      .cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module             (cpu_0_data_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_data_master_read_data_valid_epcs_controller_epcs_control_port   (cpu_0_data_master_read_data_valid_epcs_controller_epcs_control_port),
      .cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave       (cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_read_data_valid_sdram_0_s1                          (cpu_0_data_master_read_data_valid_sdram_0_s1),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register           (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_read_data_valid_sram_0_avalonS                      (cpu_0_data_master_read_data_valid_sram_0_avalonS),
      .cpu_0_data_master_read_data_valid_uart_0_s1                           (cpu_0_data_master_read_data_valid_uart_0_s1),
      .cpu_0_data_master_readdata                                            (cpu_0_data_master_readdata),
      .cpu_0_data_master_requests_KEY_s1                                     (cpu_0_data_master_requests_KEY_s1),
      .cpu_0_data_master_requests_LEDG_s1                                    (cpu_0_data_master_requests_LEDG_s1),
      .cpu_0_data_master_requests_LEDR_s1                                    (cpu_0_data_master_requests_LEDR_s1),
      .cpu_0_data_master_requests_SEG7_avalonS                               (cpu_0_data_master_requests_SEG7_avalonS),
      .cpu_0_data_master_requests_Switch_s1                                  (cpu_0_data_master_requests_Switch_s1),
      .cpu_0_data_master_requests_cfi_flash_0_s1                             (cpu_0_data_master_requests_cfi_flash_0_s1),
      .cpu_0_data_master_requests_cpu_0_jtag_debug_module                    (cpu_0_data_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_data_master_requests_epcs_controller_epcs_control_port          (cpu_0_data_master_requests_epcs_controller_epcs_control_port),
      .cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave              (cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_requests_sdram_0_s1                                 (cpu_0_data_master_requests_sdram_0_s1),
      .cpu_0_data_master_requests_sram_0_avalonS                             (cpu_0_data_master_requests_sram_0_avalonS),
      .cpu_0_data_master_requests_uart_0_s1                                  (cpu_0_data_master_requests_uart_0_s1),
      .cpu_0_data_master_waitrequest                                         (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                                               (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                           (cpu_0_data_master_writedata),
      .cpu_0_jtag_debug_module_readdata_from_sa                              (cpu_0_jtag_debug_module_readdata_from_sa),
      .d1_KEY_s1_end_xfer                                                    (d1_KEY_s1_end_xfer),
      .d1_LEDG_s1_end_xfer                                                   (d1_LEDG_s1_end_xfer),
      .d1_LEDR_s1_end_xfer                                                   (d1_LEDR_s1_end_xfer),
      .d1_SEG7_avalonS_end_xfer                                              (d1_SEG7_avalonS_end_xfer),
      .d1_Switch_s1_end_xfer                                                 (d1_Switch_s1_end_xfer),
      .d1_cpu_0_jtag_debug_module_end_xfer                                   (d1_cpu_0_jtag_debug_module_end_xfer),
      .d1_epcs_controller_epcs_control_port_end_xfer                         (d1_epcs_controller_epcs_control_port_end_xfer),
      .d1_jtag_uart_0_avalon_jtag_slave_end_xfer                             (d1_jtag_uart_0_avalon_jtag_slave_end_xfer),
      .d1_sdram_0_s1_end_xfer                                                (d1_sdram_0_s1_end_xfer),
      .d1_sram_0_avalonS_end_xfer                                            (d1_sram_0_avalonS_end_xfer),
      .d1_tri_state_bridge_0_avalon_slave_end_xfer                           (d1_tri_state_bridge_0_avalon_slave_end_xfer),
      .d1_uart_0_s1_end_xfer                                                 (d1_uart_0_s1_end_xfer),
      .epcs_controller_epcs_control_port_irq_from_sa                         (epcs_controller_epcs_control_port_irq_from_sa),
      .epcs_controller_epcs_control_port_readdata_from_sa                    (epcs_controller_epcs_control_port_readdata_from_sa),
      .incoming_tri_state_bridge_0_data_with_Xs_converted_to_0               (incoming_tri_state_bridge_0_data_with_Xs_converted_to_0),
      .jtag_uart_0_avalon_jtag_slave_irq_from_sa                             (jtag_uart_0_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_0_avalon_jtag_slave_readdata_from_sa                        (jtag_uart_0_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa                     (jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa),
      .registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1           (registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1),
      .reset_n                                                               (clk_reset_n),
      .sdram_0_s1_readdata_from_sa                                           (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_waitrequest_from_sa                                        (sdram_0_s1_waitrequest_from_sa),
      .sram_0_avalonS_readdata_from_sa                                       (sram_0_avalonS_readdata_from_sa),
      .sram_0_avalonS_wait_counter_eq_0                                      (sram_0_avalonS_wait_counter_eq_0),
      .sram_0_avalonS_wait_counter_eq_1                                      (sram_0_avalonS_wait_counter_eq_1),
      .uart_0_s1_irq_from_sa                                                 (uart_0_s1_irq_from_sa),
      .uart_0_s1_readdata_from_sa                                            (uart_0_s1_readdata_from_sa)
    );

  cpu_0_instruction_master_arbitrator the_cpu_0_instruction_master
    (
      .cfi_flash_0_s1_wait_counter_eq_0                                             (cfi_flash_0_s1_wait_counter_eq_0),
      .cfi_flash_0_s1_wait_counter_eq_1                                             (cfi_flash_0_s1_wait_counter_eq_1),
      .clk                                                                          (clk),
      .cpu_0_instruction_master_address                                             (cpu_0_instruction_master_address),
      .cpu_0_instruction_master_address_to_slave                                    (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_dbs_address                                         (cpu_0_instruction_master_dbs_address),
      .cpu_0_instruction_master_granted_cfi_flash_0_s1                              (cpu_0_instruction_master_granted_cfi_flash_0_s1),
      .cpu_0_instruction_master_granted_cpu_0_jtag_debug_module                     (cpu_0_instruction_master_granted_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_granted_epcs_controller_epcs_control_port           (cpu_0_instruction_master_granted_epcs_controller_epcs_control_port),
      .cpu_0_instruction_master_granted_sdram_0_s1                                  (cpu_0_instruction_master_granted_sdram_0_s1),
      .cpu_0_instruction_master_granted_sram_0_avalonS                              (cpu_0_instruction_master_granted_sram_0_avalonS),
      .cpu_0_instruction_master_latency_counter                                     (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_cfi_flash_0_s1                    (cpu_0_instruction_master_qualified_request_cfi_flash_0_s1),
      .cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module           (cpu_0_instruction_master_qualified_request_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port (cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port),
      .cpu_0_instruction_master_qualified_request_sdram_0_s1                        (cpu_0_instruction_master_qualified_request_sdram_0_s1),
      .cpu_0_instruction_master_qualified_request_sram_0_avalonS                    (cpu_0_instruction_master_qualified_request_sram_0_avalonS),
      .cpu_0_instruction_master_read                                                (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1                      (cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1),
      .cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module             (cpu_0_instruction_master_read_data_valid_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port   (cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1                          (cpu_0_instruction_master_read_data_valid_sdram_0_s1),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register           (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_read_data_valid_sram_0_avalonS                      (cpu_0_instruction_master_read_data_valid_sram_0_avalonS),
      .cpu_0_instruction_master_readdata                                            (cpu_0_instruction_master_readdata),
      .cpu_0_instruction_master_readdatavalid                                       (cpu_0_instruction_master_readdatavalid),
      .cpu_0_instruction_master_requests_cfi_flash_0_s1                             (cpu_0_instruction_master_requests_cfi_flash_0_s1),
      .cpu_0_instruction_master_requests_cpu_0_jtag_debug_module                    (cpu_0_instruction_master_requests_cpu_0_jtag_debug_module),
      .cpu_0_instruction_master_requests_epcs_controller_epcs_control_port          (cpu_0_instruction_master_requests_epcs_controller_epcs_control_port),
      .cpu_0_instruction_master_requests_sdram_0_s1                                 (cpu_0_instruction_master_requests_sdram_0_s1),
      .cpu_0_instruction_master_requests_sram_0_avalonS                             (cpu_0_instruction_master_requests_sram_0_avalonS),
      .cpu_0_instruction_master_waitrequest                                         (cpu_0_instruction_master_waitrequest),
      .cpu_0_jtag_debug_module_readdata_from_sa                                     (cpu_0_jtag_debug_module_readdata_from_sa),
      .d1_cpu_0_jtag_debug_module_end_xfer                                          (d1_cpu_0_jtag_debug_module_end_xfer),
      .d1_epcs_controller_epcs_control_port_end_xfer                                (d1_epcs_controller_epcs_control_port_end_xfer),
      .d1_sdram_0_s1_end_xfer                                                       (d1_sdram_0_s1_end_xfer),
      .d1_sram_0_avalonS_end_xfer                                                   (d1_sram_0_avalonS_end_xfer),
      .d1_tri_state_bridge_0_avalon_slave_end_xfer                                  (d1_tri_state_bridge_0_avalon_slave_end_xfer),
      .epcs_controller_epcs_control_port_readdata_from_sa                           (epcs_controller_epcs_control_port_readdata_from_sa),
      .incoming_tri_state_bridge_0_data                                             (incoming_tri_state_bridge_0_data),
      .reset_n                                                                      (clk_reset_n),
      .sdram_0_s1_readdata_from_sa                                                  (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_waitrequest_from_sa                                               (sdram_0_s1_waitrequest_from_sa),
      .sram_0_avalonS_readdata_from_sa                                              (sram_0_avalonS_readdata_from_sa),
      .sram_0_avalonS_wait_counter_eq_0                                             (sram_0_avalonS_wait_counter_eq_0),
      .sram_0_avalonS_wait_counter_eq_1                                             (sram_0_avalonS_wait_counter_eq_1)
    );

  cpu_0 the_cpu_0
    (
      .clk                                   (clk),
      .d_address                             (cpu_0_data_master_address),
      .d_byteenable                          (cpu_0_data_master_byteenable),
      .d_irq                                 (cpu_0_data_master_irq),
      .d_read                                (cpu_0_data_master_read),
      .d_readdata                            (cpu_0_data_master_readdata),
      .d_waitrequest                         (cpu_0_data_master_waitrequest),
      .d_write                               (cpu_0_data_master_write),
      .d_writedata                           (cpu_0_data_master_writedata),
      .i_address                             (cpu_0_instruction_master_address),
      .i_read                                (cpu_0_instruction_master_read),
      .i_readdata                            (cpu_0_instruction_master_readdata),
      .i_readdatavalid                       (cpu_0_instruction_master_readdatavalid),
      .i_waitrequest                         (cpu_0_instruction_master_waitrequest),
      .jtag_debug_module_address             (cpu_0_jtag_debug_module_address),
      .jtag_debug_module_begintransfer       (cpu_0_jtag_debug_module_begintransfer),
      .jtag_debug_module_byteenable          (cpu_0_jtag_debug_module_byteenable),
      .jtag_debug_module_clk                 (clk),
      .jtag_debug_module_debugaccess         (cpu_0_jtag_debug_module_debugaccess),
      .jtag_debug_module_debugaccess_to_roms (cpu_0_data_master_debugaccess),
      .jtag_debug_module_readdata            (cpu_0_jtag_debug_module_readdata),
      .jtag_debug_module_reset               (cpu_0_jtag_debug_module_reset),
      .jtag_debug_module_resetrequest        (cpu_0_jtag_debug_module_resetrequest),
      .jtag_debug_module_select              (cpu_0_jtag_debug_module_chipselect),
      .jtag_debug_module_write               (cpu_0_jtag_debug_module_write),
      .jtag_debug_module_writedata           (cpu_0_jtag_debug_module_writedata),
      .reset_n                               (cpu_0_jtag_debug_module_reset_n)
    );

  epcs_controller_epcs_control_port_arbitrator the_epcs_controller_epcs_control_port
    (
      .clk                                                                          (clk),
      .cpu_0_data_master_address_to_slave                                           (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_epcs_controller_epcs_control_port                  (cpu_0_data_master_granted_epcs_controller_epcs_control_port),
      .cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port        (cpu_0_data_master_qualified_request_epcs_controller_epcs_control_port),
      .cpu_0_data_master_read                                                       (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_epcs_controller_epcs_control_port          (cpu_0_data_master_read_data_valid_epcs_controller_epcs_control_port),
      .cpu_0_data_master_requests_epcs_controller_epcs_control_port                 (cpu_0_data_master_requests_epcs_controller_epcs_control_port),
      .cpu_0_data_master_write                                                      (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                                  (cpu_0_data_master_writedata),
      .cpu_0_instruction_master_address_to_slave                                    (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_granted_epcs_controller_epcs_control_port           (cpu_0_instruction_master_granted_epcs_controller_epcs_control_port),
      .cpu_0_instruction_master_latency_counter                                     (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port (cpu_0_instruction_master_qualified_request_epcs_controller_epcs_control_port),
      .cpu_0_instruction_master_read                                                (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port   (cpu_0_instruction_master_read_data_valid_epcs_controller_epcs_control_port),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register           (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_requests_epcs_controller_epcs_control_port          (cpu_0_instruction_master_requests_epcs_controller_epcs_control_port),
      .d1_epcs_controller_epcs_control_port_end_xfer                                (d1_epcs_controller_epcs_control_port_end_xfer),
      .epcs_controller_epcs_control_port_address                                    (epcs_controller_epcs_control_port_address),
      .epcs_controller_epcs_control_port_chipselect                                 (epcs_controller_epcs_control_port_chipselect),
      .epcs_controller_epcs_control_port_dataavailable                              (epcs_controller_epcs_control_port_dataavailable),
      .epcs_controller_epcs_control_port_dataavailable_from_sa                      (epcs_controller_epcs_control_port_dataavailable_from_sa),
      .epcs_controller_epcs_control_port_endofpacket                                (epcs_controller_epcs_control_port_endofpacket),
      .epcs_controller_epcs_control_port_endofpacket_from_sa                        (epcs_controller_epcs_control_port_endofpacket_from_sa),
      .epcs_controller_epcs_control_port_irq                                        (epcs_controller_epcs_control_port_irq),
      .epcs_controller_epcs_control_port_irq_from_sa                                (epcs_controller_epcs_control_port_irq_from_sa),
      .epcs_controller_epcs_control_port_read_n                                     (epcs_controller_epcs_control_port_read_n),
      .epcs_controller_epcs_control_port_readdata                                   (epcs_controller_epcs_control_port_readdata),
      .epcs_controller_epcs_control_port_readdata_from_sa                           (epcs_controller_epcs_control_port_readdata_from_sa),
      .epcs_controller_epcs_control_port_readyfordata                               (epcs_controller_epcs_control_port_readyfordata),
      .epcs_controller_epcs_control_port_readyfordata_from_sa                       (epcs_controller_epcs_control_port_readyfordata_from_sa),
      .epcs_controller_epcs_control_port_reset_n                                    (epcs_controller_epcs_control_port_reset_n),
      .epcs_controller_epcs_control_port_write_n                                    (epcs_controller_epcs_control_port_write_n),
      .epcs_controller_epcs_control_port_writedata                                  (epcs_controller_epcs_control_port_writedata),
      .reset_n                                                                      (clk_reset_n)
    );

  epcs_controller the_epcs_controller
    (
      .address       (epcs_controller_epcs_control_port_address),
      .chipselect    (epcs_controller_epcs_control_port_chipselect),
      .clk           (clk),
      .dataavailable (epcs_controller_epcs_control_port_dataavailable),
      .endofpacket   (epcs_controller_epcs_control_port_endofpacket),
      .irq           (epcs_controller_epcs_control_port_irq),
      .read_n        (epcs_controller_epcs_control_port_read_n),
      .readdata      (epcs_controller_epcs_control_port_readdata),
      .readyfordata  (epcs_controller_epcs_control_port_readyfordata),
      .reset_n       (epcs_controller_epcs_control_port_reset_n),
      .write_n       (epcs_controller_epcs_control_port_write_n),
      .writedata     (epcs_controller_epcs_control_port_writedata)
    );

  jtag_uart_0_avalon_jtag_slave_arbitrator the_jtag_uart_0_avalon_jtag_slave
    (
      .clk                                                               (clk),
      .cpu_0_data_master_address_to_slave                                (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave           (cpu_0_data_master_granted_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave (cpu_0_data_master_qualified_request_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_read                                            (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave   (cpu_0_data_master_read_data_valid_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave          (cpu_0_data_master_requests_jtag_uart_0_avalon_jtag_slave),
      .cpu_0_data_master_waitrequest                                     (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                                           (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                                       (cpu_0_data_master_writedata),
      .d1_jtag_uart_0_avalon_jtag_slave_end_xfer                         (d1_jtag_uart_0_avalon_jtag_slave_end_xfer),
      .jtag_uart_0_avalon_jtag_slave_address                             (jtag_uart_0_avalon_jtag_slave_address),
      .jtag_uart_0_avalon_jtag_slave_chipselect                          (jtag_uart_0_avalon_jtag_slave_chipselect),
      .jtag_uart_0_avalon_jtag_slave_dataavailable                       (jtag_uart_0_avalon_jtag_slave_dataavailable),
      .jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa               (jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa),
      .jtag_uart_0_avalon_jtag_slave_irq                                 (jtag_uart_0_avalon_jtag_slave_irq),
      .jtag_uart_0_avalon_jtag_slave_irq_from_sa                         (jtag_uart_0_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_0_avalon_jtag_slave_read_n                              (jtag_uart_0_avalon_jtag_slave_read_n),
      .jtag_uart_0_avalon_jtag_slave_readdata                            (jtag_uart_0_avalon_jtag_slave_readdata),
      .jtag_uart_0_avalon_jtag_slave_readdata_from_sa                    (jtag_uart_0_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_0_avalon_jtag_slave_readyfordata                        (jtag_uart_0_avalon_jtag_slave_readyfordata),
      .jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa                (jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa),
      .jtag_uart_0_avalon_jtag_slave_reset_n                             (jtag_uart_0_avalon_jtag_slave_reset_n),
      .jtag_uart_0_avalon_jtag_slave_waitrequest                         (jtag_uart_0_avalon_jtag_slave_waitrequest),
      .jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa                 (jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa),
      .jtag_uart_0_avalon_jtag_slave_write_n                             (jtag_uart_0_avalon_jtag_slave_write_n),
      .jtag_uart_0_avalon_jtag_slave_writedata                           (jtag_uart_0_avalon_jtag_slave_writedata),
      .reset_n                                                           (clk_reset_n)
    );

  jtag_uart_0 the_jtag_uart_0
    (
      .av_address     (jtag_uart_0_avalon_jtag_slave_address),
      .av_chipselect  (jtag_uart_0_avalon_jtag_slave_chipselect),
      .av_irq         (jtag_uart_0_avalon_jtag_slave_irq),
      .av_read_n      (jtag_uart_0_avalon_jtag_slave_read_n),
      .av_readdata    (jtag_uart_0_avalon_jtag_slave_readdata),
      .av_waitrequest (jtag_uart_0_avalon_jtag_slave_waitrequest),
      .av_write_n     (jtag_uart_0_avalon_jtag_slave_write_n),
      .av_writedata   (jtag_uart_0_avalon_jtag_slave_writedata),
      .clk            (clk),
      .dataavailable  (jtag_uart_0_avalon_jtag_slave_dataavailable),
      .readyfordata   (jtag_uart_0_avalon_jtag_slave_readyfordata),
      .rst_n          (jtag_uart_0_avalon_jtag_slave_reset_n)
    );

  sdram_0_s1_arbitrator the_sdram_0_s1
    (
      .clk                                                                (clk),
      .cpu_0_data_master_address_to_slave                                 (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                       (cpu_0_data_master_byteenable),
      .cpu_0_data_master_byteenable_sdram_0_s1                            (cpu_0_data_master_byteenable_sdram_0_s1),
      .cpu_0_data_master_dbs_address                                      (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_16                                     (cpu_0_data_master_dbs_write_16),
      .cpu_0_data_master_granted_sdram_0_s1                               (cpu_0_data_master_granted_sdram_0_s1),
      .cpu_0_data_master_no_byte_enables_and_last_term                    (cpu_0_data_master_no_byte_enables_and_last_term),
      .cpu_0_data_master_qualified_request_sdram_0_s1                     (cpu_0_data_master_qualified_request_sdram_0_s1),
      .cpu_0_data_master_read                                             (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_sdram_0_s1                       (cpu_0_data_master_read_data_valid_sdram_0_s1),
      .cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register        (cpu_0_data_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_data_master_requests_sdram_0_s1                              (cpu_0_data_master_requests_sdram_0_s1),
      .cpu_0_data_master_waitrequest                                      (cpu_0_data_master_waitrequest),
      .cpu_0_data_master_write                                            (cpu_0_data_master_write),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_dbs_address                               (cpu_0_instruction_master_dbs_address),
      .cpu_0_instruction_master_granted_sdram_0_s1                        (cpu_0_instruction_master_granted_sdram_0_s1),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_sdram_0_s1              (cpu_0_instruction_master_qualified_request_sdram_0_s1),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1                (cpu_0_instruction_master_read_data_valid_sdram_0_s1),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_requests_sdram_0_s1                       (cpu_0_instruction_master_requests_sdram_0_s1),
      .d1_sdram_0_s1_end_xfer                                             (d1_sdram_0_s1_end_xfer),
      .reset_n                                                            (clk_reset_n),
      .sdram_0_s1_address                                                 (sdram_0_s1_address),
      .sdram_0_s1_byteenable_n                                            (sdram_0_s1_byteenable_n),
      .sdram_0_s1_chipselect                                              (sdram_0_s1_chipselect),
      .sdram_0_s1_read_n                                                  (sdram_0_s1_read_n),
      .sdram_0_s1_readdata                                                (sdram_0_s1_readdata),
      .sdram_0_s1_readdata_from_sa                                        (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_readdatavalid                                           (sdram_0_s1_readdatavalid),
      .sdram_0_s1_reset_n                                                 (sdram_0_s1_reset_n),
      .sdram_0_s1_waitrequest                                             (sdram_0_s1_waitrequest),
      .sdram_0_s1_waitrequest_from_sa                                     (sdram_0_s1_waitrequest_from_sa),
      .sdram_0_s1_write_n                                                 (sdram_0_s1_write_n),
      .sdram_0_s1_writedata                                               (sdram_0_s1_writedata)
    );

  sdram_0 the_sdram_0
    (
      .az_addr        (sdram_0_s1_address),
      .az_be_n        (sdram_0_s1_byteenable_n),
      .az_cs          (sdram_0_s1_chipselect),
      .az_data        (sdram_0_s1_writedata),
      .az_rd_n        (sdram_0_s1_read_n),
      .az_wr_n        (sdram_0_s1_write_n),
      .clk            (clk),
      .reset_n        (sdram_0_s1_reset_n),
      .za_data        (sdram_0_s1_readdata),
      .za_valid       (sdram_0_s1_readdatavalid),
      .za_waitrequest (sdram_0_s1_waitrequest),
      .zs_addr        (zs_addr_from_the_sdram_0),
      .zs_ba          (zs_ba_from_the_sdram_0),
      .zs_cas_n       (zs_cas_n_from_the_sdram_0),
      .zs_cke         (zs_cke_from_the_sdram_0),
      .zs_cs_n        (zs_cs_n_from_the_sdram_0),
      .zs_dq          (zs_dq_to_and_from_the_sdram_0),
      .zs_dqm         (zs_dqm_from_the_sdram_0),
      .zs_ras_n       (zs_ras_n_from_the_sdram_0),
      .zs_we_n        (zs_we_n_from_the_sdram_0)
    );

  sram_0_avalonS_arbitrator the_sram_0_avalonS
    (
      .clk                                                                (clk),
      .cpu_0_data_master_address_to_slave                                 (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                       (cpu_0_data_master_byteenable),
      .cpu_0_data_master_byteenable_sram_0_avalonS                        (cpu_0_data_master_byteenable_sram_0_avalonS),
      .cpu_0_data_master_dbs_address                                      (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_16                                     (cpu_0_data_master_dbs_write_16),
      .cpu_0_data_master_granted_sram_0_avalonS                           (cpu_0_data_master_granted_sram_0_avalonS),
      .cpu_0_data_master_no_byte_enables_and_last_term                    (cpu_0_data_master_no_byte_enables_and_last_term),
      .cpu_0_data_master_qualified_request_sram_0_avalonS                 (cpu_0_data_master_qualified_request_sram_0_avalonS),
      .cpu_0_data_master_read                                             (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_sram_0_avalonS                   (cpu_0_data_master_read_data_valid_sram_0_avalonS),
      .cpu_0_data_master_requests_sram_0_avalonS                          (cpu_0_data_master_requests_sram_0_avalonS),
      .cpu_0_data_master_write                                            (cpu_0_data_master_write),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_dbs_address                               (cpu_0_instruction_master_dbs_address),
      .cpu_0_instruction_master_granted_sram_0_avalonS                    (cpu_0_instruction_master_granted_sram_0_avalonS),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_sram_0_avalonS          (cpu_0_instruction_master_qualified_request_sram_0_avalonS),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_read_data_valid_sram_0_avalonS            (cpu_0_instruction_master_read_data_valid_sram_0_avalonS),
      .cpu_0_instruction_master_requests_sram_0_avalonS                   (cpu_0_instruction_master_requests_sram_0_avalonS),
      .d1_sram_0_avalonS_end_xfer                                         (d1_sram_0_avalonS_end_xfer),
      .reset_n                                                            (clk_reset_n),
      .sram_0_avalonS_address                                             (sram_0_avalonS_address),
      .sram_0_avalonS_byteenable_n                                        (sram_0_avalonS_byteenable_n),
      .sram_0_avalonS_chipselect_n                                        (sram_0_avalonS_chipselect_n),
      .sram_0_avalonS_outputenable_n                                      (sram_0_avalonS_outputenable_n),
      .sram_0_avalonS_readdata                                            (sram_0_avalonS_readdata),
      .sram_0_avalonS_readdata_from_sa                                    (sram_0_avalonS_readdata_from_sa),
      .sram_0_avalonS_reset_n                                             (sram_0_avalonS_reset_n),
      .sram_0_avalonS_wait_counter_eq_0                                   (sram_0_avalonS_wait_counter_eq_0),
      .sram_0_avalonS_wait_counter_eq_1                                   (sram_0_avalonS_wait_counter_eq_1),
      .sram_0_avalonS_write_n                                             (sram_0_avalonS_write_n),
      .sram_0_avalonS_writedata                                           (sram_0_avalonS_writedata)
    );

  sram_0 the_sram_0
    (
      .SRAM_ADDR (SRAM_ADDR_from_the_sram_0),
      .SRAM_CE_N (SRAM_CE_N_from_the_sram_0),
      .SRAM_DQ   (SRAM_DQ_to_and_from_the_sram_0),
      .SRAM_LB_N (SRAM_LB_N_from_the_sram_0),
      .SRAM_OE_N (SRAM_OE_N_from_the_sram_0),
      .SRAM_UB_N (SRAM_UB_N_from_the_sram_0),
      .SRAM_WE_N (SRAM_WE_N_from_the_sram_0),
      .iADDR     (sram_0_avalonS_address),
      .iCE_N     (sram_0_avalonS_chipselect_n),
      .iDATA     (sram_0_avalonS_writedata),
      .iLB_N     (sram_0_avalonS_byteenable_n),
      .iOE_N     (sram_0_avalonS_outputenable_n),
      .iRST_N    (sram_0_avalonS_reset_n),
      .iUB_N     (sram_0_avalonS_byteenable_n),
      .iWE_N     (sram_0_avalonS_write_n),
      .oDATA     (sram_0_avalonS_readdata)
    );

  tri_state_bridge_0_avalon_slave_arbitrator the_tri_state_bridge_0_avalon_slave
    (
      .cfi_flash_0_s1_wait_counter_eq_0                                   (cfi_flash_0_s1_wait_counter_eq_0),
      .cfi_flash_0_s1_wait_counter_eq_1                                   (cfi_flash_0_s1_wait_counter_eq_1),
      .clk                                                                (clk),
      .cpu_0_data_master_address_to_slave                                 (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_byteenable                                       (cpu_0_data_master_byteenable),
      .cpu_0_data_master_byteenable_cfi_flash_0_s1                        (cpu_0_data_master_byteenable_cfi_flash_0_s1),
      .cpu_0_data_master_dbs_address                                      (cpu_0_data_master_dbs_address),
      .cpu_0_data_master_dbs_write_8                                      (cpu_0_data_master_dbs_write_8),
      .cpu_0_data_master_granted_cfi_flash_0_s1                           (cpu_0_data_master_granted_cfi_flash_0_s1),
      .cpu_0_data_master_no_byte_enables_and_last_term                    (cpu_0_data_master_no_byte_enables_and_last_term),
      .cpu_0_data_master_qualified_request_cfi_flash_0_s1                 (cpu_0_data_master_qualified_request_cfi_flash_0_s1),
      .cpu_0_data_master_read                                             (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_cfi_flash_0_s1                   (cpu_0_data_master_read_data_valid_cfi_flash_0_s1),
      .cpu_0_data_master_requests_cfi_flash_0_s1                          (cpu_0_data_master_requests_cfi_flash_0_s1),
      .cpu_0_data_master_write                                            (cpu_0_data_master_write),
      .cpu_0_instruction_master_address_to_slave                          (cpu_0_instruction_master_address_to_slave),
      .cpu_0_instruction_master_dbs_address                               (cpu_0_instruction_master_dbs_address),
      .cpu_0_instruction_master_granted_cfi_flash_0_s1                    (cpu_0_instruction_master_granted_cfi_flash_0_s1),
      .cpu_0_instruction_master_latency_counter                           (cpu_0_instruction_master_latency_counter),
      .cpu_0_instruction_master_qualified_request_cfi_flash_0_s1          (cpu_0_instruction_master_qualified_request_cfi_flash_0_s1),
      .cpu_0_instruction_master_read                                      (cpu_0_instruction_master_read),
      .cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1            (cpu_0_instruction_master_read_data_valid_cfi_flash_0_s1),
      .cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register (cpu_0_instruction_master_read_data_valid_sdram_0_s1_shift_register),
      .cpu_0_instruction_master_requests_cfi_flash_0_s1                   (cpu_0_instruction_master_requests_cfi_flash_0_s1),
      .d1_tri_state_bridge_0_avalon_slave_end_xfer                        (d1_tri_state_bridge_0_avalon_slave_end_xfer),
      .incoming_tri_state_bridge_0_data                                   (incoming_tri_state_bridge_0_data),
      .incoming_tri_state_bridge_0_data_with_Xs_converted_to_0            (incoming_tri_state_bridge_0_data_with_Xs_converted_to_0),
      .registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1        (registered_cpu_0_data_master_read_data_valid_cfi_flash_0_s1),
      .reset_n                                                            (clk_reset_n),
      .select_n_to_the_cfi_flash_0                                        (select_n_to_the_cfi_flash_0),
      .tri_state_bridge_0_address                                         (tri_state_bridge_0_address),
      .tri_state_bridge_0_data                                            (tri_state_bridge_0_data),
      .tri_state_bridge_0_readn                                           (tri_state_bridge_0_readn),
      .write_n_to_the_cfi_flash_0                                         (write_n_to_the_cfi_flash_0)
    );

  uart_0_s1_arbitrator the_uart_0_s1
    (
      .clk                                           (clk),
      .cpu_0_data_master_address_to_slave            (cpu_0_data_master_address_to_slave),
      .cpu_0_data_master_granted_uart_0_s1           (cpu_0_data_master_granted_uart_0_s1),
      .cpu_0_data_master_qualified_request_uart_0_s1 (cpu_0_data_master_qualified_request_uart_0_s1),
      .cpu_0_data_master_read                        (cpu_0_data_master_read),
      .cpu_0_data_master_read_data_valid_uart_0_s1   (cpu_0_data_master_read_data_valid_uart_0_s1),
      .cpu_0_data_master_requests_uart_0_s1          (cpu_0_data_master_requests_uart_0_s1),
      .cpu_0_data_master_write                       (cpu_0_data_master_write),
      .cpu_0_data_master_writedata                   (cpu_0_data_master_writedata),
      .d1_uart_0_s1_end_xfer                         (d1_uart_0_s1_end_xfer),
      .reset_n                                       (clk_reset_n),
      .uart_0_s1_address                             (uart_0_s1_address),
      .uart_0_s1_begintransfer                       (uart_0_s1_begintransfer),
      .uart_0_s1_chipselect                          (uart_0_s1_chipselect),
      .uart_0_s1_dataavailable                       (uart_0_s1_dataavailable),
      .uart_0_s1_dataavailable_from_sa               (uart_0_s1_dataavailable_from_sa),
      .uart_0_s1_irq                                 (uart_0_s1_irq),
      .uart_0_s1_irq_from_sa                         (uart_0_s1_irq_from_sa),
      .uart_0_s1_read_n                              (uart_0_s1_read_n),
      .uart_0_s1_readdata                            (uart_0_s1_readdata),
      .uart_0_s1_readdata_from_sa                    (uart_0_s1_readdata_from_sa),
      .uart_0_s1_readyfordata                        (uart_0_s1_readyfordata),
      .uart_0_s1_readyfordata_from_sa                (uart_0_s1_readyfordata_from_sa),
      .uart_0_s1_reset_n                             (uart_0_s1_reset_n),
      .uart_0_s1_write_n                             (uart_0_s1_write_n),
      .uart_0_s1_writedata                           (uart_0_s1_writedata)
    );

  uart_0 the_uart_0
    (
      .address       (uart_0_s1_address),
      .begintransfer (uart_0_s1_begintransfer),
      .chipselect    (uart_0_s1_chipselect),
      .clk           (clk),
      .dataavailable (uart_0_s1_dataavailable),
      .irq           (uart_0_s1_irq),
      .read_n        (uart_0_s1_read_n),
      .readdata      (uart_0_s1_readdata),
      .readyfordata  (uart_0_s1_readyfordata),
      .reset_n       (uart_0_s1_reset_n),
      .rxd           (rxd_to_the_uart_0),
      .txd           (txd_from_the_uart_0),
      .write_n       (uart_0_s1_write_n),
      .writedata     (uart_0_s1_writedata)
    );

  //reset is asserted asynchronously and deasserted synchronously
  system_0_reset_clk_domain_synch_module system_0_reset_clk_domain_synch
    (
      .clk      (clk),
      .data_in  (1'b1),
      .data_out (clk_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset sources mux, which is an e_mux
  assign reset_n_sources = ~(~reset_n |
    0 |
    cpu_0_jtag_debug_module_resetrequest_from_sa |
    cpu_0_jtag_debug_module_resetrequest_from_sa);


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cfi_flash_0_lane0_module (
                                  // inputs:
                                   data,
                                   rdaddress,
                                   rdclken,
                                   wraddress,
                                   wrclock,
                                   wren,

                                  // outputs:
                                   q
                                )
;

  output  [  7: 0] q;
  input   [  7: 0] data;
  input   [ 21: 0] rdaddress;
  input            rdclken;
  input   [ 21: 0] wraddress;
  input            wrclock;
  input            wren;

  reg     [  7: 0] mem_array [4194303: 0];
  wire    [  7: 0] q;
  reg     [ 21: 0] read_address;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  always @(rdaddress)
    begin
      if (1)
          read_address <= rdaddress;
    end


  // Data read is asynchronous.
  assign q = mem_array[read_address];

initial
    $readmemh("cfi_flash_0.dat", mem_array);
  always @(posedge wrclock)
    begin
      // Write data
      if (wren)
          mem_array[wraddress] <= data;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  always @(rdaddress)
//    begin
//      if (1)
//          read_address <= rdaddress;
//    end
//
//
//  lpm_ram_dp lpm_ram_dp_component
//    (
//      .data (data),
//      .q (q),
//      .rdaddress (read_address),
//      .rdclken (rdclken),
//      .wraddress (wraddress),
//      .wrclock (wrclock),
//      .wren (wren)
//    );
//
//  defparam lpm_ram_dp_component.lpm_file = "cfi_flash_0.mif",
//           lpm_ram_dp_component.lpm_hint = "USE_EAB=ON",
//           lpm_ram_dp_component.lpm_indata = "REGISTERED",
//           lpm_ram_dp_component.lpm_outdata = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_rdaddress_control = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_width = 8,
//           lpm_ram_dp_component.lpm_widthad = 22,
//           lpm_ram_dp_component.lpm_wraddress_control = "REGISTERED",
//           lpm_ram_dp_component.suppress_memory_conversion_warnings = "ON";
//
//synthesis read_comments_as_HDL off

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module cfi_flash_0 (
                     // inputs:
                      address,
                      read_n,
                      select_n,
                      write_n,

                     // outputs:
                      data
                   )
;

  inout   [  7: 0] data;
  input   [ 21: 0] address;
  input            read_n;
  input            select_n;
  input            write_n;

  wire    [  7: 0] data;
  wire    [  7: 0] data_0;
  wire    [  7: 0] logic_vector_gasket;
  wire    [  7: 0] q_0;
  //s1, which is an e_ptf_slave

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  assign logic_vector_gasket = data;
  assign data_0 = logic_vector_gasket[7 : 0];
  //cfi_flash_0_lane0, which is an e_ram
  cfi_flash_0_lane0_module cfi_flash_0_lane0
    (
      .data      (data_0),
      .q         (q_0),
      .rdaddress (address),
      .rdclken   (1'b1),
      .wraddress (address),
      .wrclock   (write_n),
      .wren      (~select_n)
    );

  assign data = (~select_n & ~read_n)? q_0: {8{1'bz}};

//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


//synthesis translate_off



// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE

// AND HERE WILL BE PRESERVED </ALTERA_NOTE>


// If user logic components use Altsync_Ram with convert_hex2ver.dll,
// set USE_convert_hex2ver in the user comments section above

`ifdef USE_convert_hex2ver
`else
`define NO_PLI 1
`endif

`include "c:/altera/quartus60/eda/sim_lib/altera_mf.v"
`include "c:/altera/quartus60/eda/sim_lib/220model.v"
`include "c:/altera/quartus60/eda/sim_lib/sgate.v"
`include "LEDR.v"
`include "sdram_0.v"
`include "sdram_0_test_component.v"
`include "epcs_controller.v"
`include "Switch.v"
`include "LEDG.v"
`include "SRAM_16Bit_512K.v"
`include "sram_0.v"
`include "uart_0.v"
`include "jtag_uart_0.v"
`include "SEG7_LUT.v"
`include "SEG7_LUT_4.v"
`include "SEG7.v"
`include "cpu_0_test_bench.v"
`include "cpu_0_mult_cell.v"
`include "cpu_0_jtag_debug_module.v"
`include "cpu_0_jtag_debug_module_wrapper.v"
`include "cpu_0.vo"
`include "KEY.v"

`timescale 1ns / 1ps

module test_bench 
;


  wire    [ 17: 0] SRAM_ADDR_from_the_sram_0;
  wire             SRAM_CE_N_from_the_sram_0;
  wire    [ 15: 0] SRAM_DQ_to_and_from_the_sram_0;
  wire             SRAM_LB_N_from_the_sram_0;
  wire             SRAM_OE_N_from_the_sram_0;
  wire             SRAM_UB_N_from_the_sram_0;
  wire             SRAM_WE_N_from_the_sram_0;
  reg              clk;
  wire             epcs_controller_epcs_control_port_dataavailable_from_sa;
  wire             epcs_controller_epcs_control_port_endofpacket_from_sa;
  wire             epcs_controller_epcs_control_port_readyfordata_from_sa;
  wire    [  3: 0] in_port_to_the_KEY;
  wire    [  9: 0] in_port_to_the_Switch;
  wire             jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa;
  wire    [  6: 0] oSEG0_from_the_SEG7;
  wire    [  6: 0] oSEG1_from_the_SEG7;
  wire    [  6: 0] oSEG2_from_the_SEG7;
  wire    [  6: 0] oSEG3_from_the_SEG7;
  wire    [  7: 0] out_port_from_the_LEDG;
  wire    [  9: 0] out_port_from_the_LEDR;
  reg              reset_n;
  wire             rxd_to_the_uart_0;
  wire             select_n_to_the_cfi_flash_0;
  wire    [ 21: 0] tri_state_bridge_0_address;
  wire    [  7: 0] tri_state_bridge_0_data;
  wire             tri_state_bridge_0_readn;
  wire             txd_from_the_uart_0;
  wire             uart_0_s1_dataavailable_from_sa;
  wire             uart_0_s1_readyfordata_from_sa;
  wire             write_n_to_the_cfi_flash_0;
  wire    [ 11: 0] zs_addr_from_the_sdram_0;
  wire    [  1: 0] zs_ba_from_the_sdram_0;
  wire             zs_cas_n_from_the_sdram_0;
  wire             zs_cke_from_the_sdram_0;
  wire             zs_cs_n_from_the_sdram_0;
  wire    [ 15: 0] zs_dq_to_and_from_the_sdram_0;
  wire    [  1: 0] zs_dqm_from_the_sdram_0;
  wire             zs_ras_n_from_the_sdram_0;
  wire             zs_we_n_from_the_sdram_0;


// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
//  add your signals and additional architecture here
// AND HERE WILL BE PRESERVED </ALTERA_NOTE>

  //Set us up the Dut
  system_0 DUT
    (
      .SRAM_ADDR_from_the_sram_0      (SRAM_ADDR_from_the_sram_0),
      .SRAM_CE_N_from_the_sram_0      (SRAM_CE_N_from_the_sram_0),
      .SRAM_DQ_to_and_from_the_sram_0 (SRAM_DQ_to_and_from_the_sram_0),
      .SRAM_LB_N_from_the_sram_0      (SRAM_LB_N_from_the_sram_0),
      .SRAM_OE_N_from_the_sram_0      (SRAM_OE_N_from_the_sram_0),
      .SRAM_UB_N_from_the_sram_0      (SRAM_UB_N_from_the_sram_0),
      .SRAM_WE_N_from_the_sram_0      (SRAM_WE_N_from_the_sram_0),
      .clk                            (clk),
      .in_port_to_the_KEY             (in_port_to_the_KEY),
      .in_port_to_the_Switch          (in_port_to_the_Switch),
      .oSEG0_from_the_SEG7            (oSEG0_from_the_SEG7),
      .oSEG1_from_the_SEG7            (oSEG1_from_the_SEG7),
      .oSEG2_from_the_SEG7            (oSEG2_from_the_SEG7),
      .oSEG3_from_the_SEG7            (oSEG3_from_the_SEG7),
      .out_port_from_the_LEDG         (out_port_from_the_LEDG),
      .out_port_from_the_LEDR         (out_port_from_the_LEDR),
      .reset_n                        (reset_n),
      .rxd_to_the_uart_0              (rxd_to_the_uart_0),
      .select_n_to_the_cfi_flash_0    (select_n_to_the_cfi_flash_0),
      .tri_state_bridge_0_address     (tri_state_bridge_0_address),
      .tri_state_bridge_0_data        (tri_state_bridge_0_data),
      .tri_state_bridge_0_readn       (tri_state_bridge_0_readn),
      .txd_from_the_uart_0            (txd_from_the_uart_0),
      .write_n_to_the_cfi_flash_0     (write_n_to_the_cfi_flash_0),
      .zs_addr_from_the_sdram_0       (zs_addr_from_the_sdram_0),
      .zs_ba_from_the_sdram_0         (zs_ba_from_the_sdram_0),
      .zs_cas_n_from_the_sdram_0      (zs_cas_n_from_the_sdram_0),
      .zs_cke_from_the_sdram_0        (zs_cke_from_the_sdram_0),
      .zs_cs_n_from_the_sdram_0       (zs_cs_n_from_the_sdram_0),
      .zs_dq_to_and_from_the_sdram_0  (zs_dq_to_and_from_the_sdram_0),
      .zs_dqm_from_the_sdram_0        (zs_dqm_from_the_sdram_0),
      .zs_ras_n_from_the_sdram_0      (zs_ras_n_from_the_sdram_0),
      .zs_we_n_from_the_sdram_0       (zs_we_n_from_the_sdram_0)
    );

  cfi_flash_0 the_cfi_flash_0
    (
      .address  (tri_state_bridge_0_address),
      .data     (tri_state_bridge_0_data),
      .read_n   (tri_state_bridge_0_readn),
      .select_n (select_n_to_the_cfi_flash_0),
      .write_n  (write_n_to_the_cfi_flash_0)
    );

  sdram_0_test_component the_sdram_0_test_component
    (
      .clk      (clk),
      .zs_addr  (zs_addr_from_the_sdram_0),
      .zs_ba    (zs_ba_from_the_sdram_0),
      .zs_cas_n (zs_cas_n_from_the_sdram_0),
      .zs_cke   (zs_cke_from_the_sdram_0),
      .zs_cs_n  (zs_cs_n_from_the_sdram_0),
      .zs_dq    (zs_dq_to_and_from_the_sdram_0),
      .zs_dqm   (zs_dqm_from_the_sdram_0),
      .zs_ras_n (zs_ras_n_from_the_sdram_0),
      .zs_we_n  (zs_we_n_from_the_sdram_0)
    );

  initial
    clk = 1'b0;
  always
    #5 clk <= ~clk;
  
  initial 
    begin
      reset_n <= 0;
      #100 reset_n <= 1;
    end

endmodule


//synthesis translate_on