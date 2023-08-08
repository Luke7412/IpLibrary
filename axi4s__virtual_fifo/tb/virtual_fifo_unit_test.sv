//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module virtual_fifo_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "virtual_fifo_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import axi4s_pkg::*;

  localparam real ACLK_PERIOD = 10ns;

  localparam int TDATA_BYTES   = 8;
  localparam int TUSER_WIDTH   = 0;
  localparam int TKEEP_WIDTH   = 1;
  localparam int TSTRB_WIDTH   = 0;
  localparam int TID_WIDTH     = 4;
  localparam int TDEST_WIDTH   = 0;
  localparam int ADDR_WIDTH    = 12;
  localparam int MAX_BURST_LEN = 256;

  logic        aclk;
  logic        aresetn;

  Axi4s_Master #(
    .TDATA_WIDTH (8*TDATA_BYTES), .TDEST_WIDTH (TDEST_WIDTH), .TID_WIDTH (TID_WIDTH)
  ) master;
  Axi4s_Slave #(
    .TDATA_WIDTH (8*TDATA_BYTES), .TDEST_WIDTH (TDEST_WIDTH), .TID_WIDTH (TID_WIDTH)
  ) slave;

  Axi4s_Intf #(
    .TDATA_WIDTH (8*TDATA_BYTES), .TDEST_WIDTH (TDEST_WIDTH), .TID_WIDTH (TID_WIDTH)
  ) in_intf (aclk, aresetn);
  Axi4s_Intf #(
      .TDATA_WIDTH (8*TDATA_BYTES), .TDEST_WIDTH (TDEST_WIDTH), .TID_WIDTH (TID_WIDTH)
  ) out_intf (aclk, aresetn);


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  virtual_fifo #(
    .TDATA_BYTES   (TDATA_BYTES),
    .TUSER_WIDTH   (TUSER_WIDTH),
    .TKEEP_WIDTH   (TKEEP_WIDTH),
    .TSTRB_WIDTH   (TSTRB_WIDTH),
    .TID_WIDTH     (TID_WIDTH),
    .TDEST_WIDTH   (TDEST_WIDTH),
    .ADDR_WIDTH    (ADDR_WIDTH),
    .MAX_BURST_LEN (MAX_BURST_LEN)
  ) DUT ( 
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (in_intf.tvalid),    
    .target_tready    (in_intf.tready),    
    .target_tdata     (in_intf.tdata),     
    .target_tuser     (in_intf.tuser),     
    .target_tkeep     (in_intf.tkeep),     
    .target_tstrb     (in_intf.tstrb),     
    .target_tid       (in_intf.tid),       
    .target_tdest     (in_intf.tdest),     
    .target_tlast     (in_intf.tlast),     
    .initiator_tvalid (out_intf.tvalid),
    .initiator_tready (out_intf.tready),
    .initiator_tdata  (out_intf.tdata),
    .initiator_tuser  (out_intf.tuser),
    .initiator_tkeep  (out_intf.tkeep),
    .initiator_tstrb  (out_intf.tstrb),
    .initiator_tid    (out_intf.tid),
    .initiator_tdest  (out_intf.tdest),
    .initiator_tlast  (out_intf.tlast),
    .mem_awvalid      (awvalid),
    .mem_awready      (awready),     
    .mem_awaddr       (awaddr),
    .mem_awlen        (awlen),
    .mem_awsize       (awsize),
    .mem_awburst      (awburst),
    .mem_awid         (awid),
    .mem_wvalid       (wvalid),
    .mem_wready       (wready),
    .mem_wdata        (wdata),
    .mem_wstrb        (wstrb),
    .mem_wlast        (wlast),
    .mem_bvalid       (bvalid),
    .mem_bready       (bready),
    .mem_bid          (bid),
    .mem_bresp        (bresp),
    .mem_arvalid      (arvalid),
    .mem_arready      (arready),
    .mem_araddr       (araddr),
    .mem_arlen        (arlen),
    .mem_arsize       (arsize),
    .mem_arburst      (arburst),
    .mem_arid         (arid),
    .mem_rvalid       (rvalid),
    .mem_rready       (rready),
    .mem_rdata        (rdata),
    .mem_rid          (rid),
    .mem_rresp        (rresp),
    .mem_rlast        (rlast)
  );


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    master = new(in_intf);
    slave = new(out_intf);
  endfunction


  task setup();
    svunit_ut.setup();
    master.start();
    slave.start();

    aresetn <= '0;
    wait_tics(5);
    aresetn <= '1;
    wait_tics(5);
  endtask


  task teardown();
    svunit_ut.teardown();
    master.stop();
    slave.stop();

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
