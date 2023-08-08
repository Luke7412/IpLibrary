//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module packet_chopper_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "packet_chopper_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import axi4s_pkg::*;

  localparam real ACLK_PERIOD = 10ns;

  localparam int TDATA_BYTES   = 8;
  localparam int TID_WIDTH     = 4;
  localparam int TDEST_WIDTH   = 1;
  localparam int MAX_BURST_LEN = 256;

  logic        aclk;
  logic        aresetn;

  Axi4s_Master #(
    .TDATA_WIDTH (8*TDATA_BYTES), .TDEST_WIDTH (TDEST_WIDTH), .TID_WIDTH (TID_WIDTH)
  ) master;
  Axi4s_Slave #(
    .TDATA_WIDTH (8*TDATA_BYTES), .TDEST_WIDTH (TDEST_WIDTH), .TID_WIDTH (TID_WIDTH)
  ) slave;
  Axi4s_Slave #(
    .TDATA_WIDTH (16), .TDEST_WIDTH (TDEST_WIDTH), .TID_WIDTH (TID_WIDTH)
  ) meta_slv;

  Axi4s_Intf #(
    .TDATA_WIDTH (8*TDATA_BYTES), .TDEST_WIDTH (TDEST_WIDTH), .TID_WIDTH (TID_WIDTH)
  ) in_intf (aclk, aresetn);
  Axi4s_Intf #(
      .TDATA_WIDTH (8*TDATA_BYTES), .TDEST_WIDTH (TDEST_WIDTH), .TID_WIDTH (TID_WIDTH)
  ) out_intf (aclk, aresetn);
  Axi4s_Intf #(
      .TDATA_WIDTH (16), .TDEST_WIDTH (TDEST_WIDTH), .TID_WIDTH (TID_WIDTH)
  ) meta_intf (aclk, aresetn);


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  packet_chopper #(
    .TDATA_BYTES   (TDATA_BYTES),
    .TID_WIDTH     (TID_WIDTH),
    .TDEST_WIDTH   (TDEST_WIDTH),
    .MAX_BURST_LEN (MAX_BURST_LEN)
  ) DUT (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (in_intf.tvalid),
    .target_tready    (in_intf.tready),
    .target_tdata     (in_intf.tdata),
    .target_tkeep     (in_intf.tkeep),
    .target_tid       (in_intf.tid),
    .target_tdest     (in_intf.tdest),
    .target_tlast     (in_intf.tlast),
    .initiator_tvalid (out_intf.tvalid),
    .initiator_tready (out_intf.tready),
    .initiator_tdata  (out_intf.tdata),
    .initiator_tkeep  (out_intf.tkeep),
    .initiator_tlast  (out_intf.tlast),
    .meta_tvalid      (meta_intf.tvalid),
    .meta_tready      (meta_intf.tready),
    .meta_tdata       (meta_intf.tdata),
    .meta_tid         (meta_intf.tid),
    .meta_tdest       (meta_intf.tdest)
  );


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    master = new(in_intf);
    slave = new(out_intf);
    meta_slv = new(meta_intf);
  endfunction


  task setup();
    svunit_ut.setup();
    master.start();
    slave.start();
    meta_slv.start();

    aresetn <= '0;
    wait_tics(5);
    aresetn <= '1;
    wait_tics(5);
  endtask


  task teardown();
    svunit_ut.teardown();
    master.stop();
    slave.stop();
    meta_slv.stop();

    #(5*ACLK_PERIOD);
    aresetn <= '0;
  endtask


  //----------------------------------------------------------------------------
  task wait_tics(int tics=1);
    repeat(tics)
      @(posedge in_intf.aclk);
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_read_module_hash)

  `SVTEST_END

 

    
  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
