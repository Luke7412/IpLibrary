//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module dest_packetizer_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "dest_packetizer_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  localparam int ACLK_PERIOD = 5ns;

  logic       aclk;
  logic       aresetn;

  logic       rxframe_tvalid, txframe_tvalid;
  logic       rxframe_tready, txframe_tready;
  logic       rxframe_tlast , txframe_tlast;
  logic [7:0] rxframe_tdata , txframe_tdata;
   
  logic       rxpacket_tvalid, txpacket_tvalid;
  logic       rxpacket_tready, txpacket_tready;
  logic       rxpacket_tlast , txpacket_tlast;
  logic [7:0] rxpacket_tdata , txpacket_tdata;
  logic [2:0] rxpacket_tid   , txpacket_tid;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  dest_packetizer DUT (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .rxframe_tvalid   (rxframe_tvalid),
    .rxframe_tready   (rxframe_tready),
    .rxframe_tlast    (rxframe_tlast),
    .rxframe_tdata    (rxframe_tdata),
    .txframe_tvalid   (txframe_tvalid),
    .txframe_tready   (txframe_tready),
    .txframe_tlast    (txframe_tlast),
    .txframe_tdata    (txframe_tdata),
    .rxpacket_tvalid  (rxpacket_tvalid),
    .rxpacket_tready  (rxpacket_tready),
    .rxpacket_tlast   (rxpacket_tlast),
    .rxpacket_tdata   (rxpacket_tdata),
    .rxpacket_tid     (rxpacket_tid),
    .txpacket_tvalid  (txpacket_tvalid),
    .txpacket_tready  (txpacket_tready),
    .txpacket_tlast   (txpacket_tlast),
    .txpacket_tdata   (txpacket_tdata),
    .txpacket_tid     (txpacket_tid)
  );


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_)
    
  `SVTEST_END

 
  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
