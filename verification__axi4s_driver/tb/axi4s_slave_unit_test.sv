//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi4s_slave_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "axi4s_slave_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import axi4s_pkg::*;

  localparam real ACLK_PERIOD = 10;

  localparam int TDATA_WIDTH = 8;
  localparam int TKEEP_WIDTH = TDATA_WIDTH/8;
  localparam int TSTRB_WIDTH = TDATA_WIDTH/8;
  localparam int TUSER_WIDTH = 1;
  localparam int TDEST_WIDTH = 1;
  localparam int TID_WIDTH   = 1;

  logic aclk;
  logic aresetn;

  typedef AXI4S_Transaction #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) Transaction;

  AXI4S_Slave #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) slave;

  AXI4S_Intf #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) intf (aclk, aresetn);


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    slave = new(intf);
  endfunction


  task setup();
    svunit_ut.setup();
    slave.start();

    aresetn <= '0;
    intf.tvalid <= '0;

    wait_tics(5);
    aresetn <= '1;
    wait_tics(5);
  endtask


  task teardown();
    svunit_ut.teardown();
    slave.stop();

    #(5*ACLK_PERIOD);
  endtask


  //----------------------------------------------------------------------------
  task wait_tics(int tics=1);
    repeat(tics)
      @(posedge aclk);
  endtask

  task transact(
    logic [TDATA_WIDTH-1:0] tdata,
    logic [TKEEP_WIDTH-1:0] tkeep,
    logic [TSTRB_WIDTH-1:0] tstrb,
    logic [TUSER_WIDTH-1:0] tuser,
    logic [TDEST_WIDTH-1:0] tdest,
    logic [TID_WIDTH-1:0]   tid,
    logic                   tlast
  );
    intf.tvalid <= '1;
    intf.tdata  <= tdata;
    intf.tkeep  <= tkeep;
    intf.tstrb  <= tstrb;
    intf.tuser  <= tuser;
    intf.tdest  <= tdest;
    intf.tid    <= tid;
    intf.tlast  <= tlast;
    do 
      wait_tics(1);
    while (!intf.tready);
    intf.tvalid <= '0;
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_single_transaction)
    transact(
      .tdata(0), .tkeep(0), .tstrb(0), .tuser(0), .tdest(0), .tid(0), .tlast(0)
    );

    wait_tics();
    `FAIL_IF(slave.monitor.queue.size() != 1);
  `SVTEST_END

  `SVTEST(test_transaction_in_reset)
    aresetn <= '0;
    wait_tics();

    transact(
      .tdata(0), .tkeep(0), .tstrb(0), .tuser(0), .tdest(0), .tid(0), .tlast(0)
    );

    wait_tics();
    `FAIL_IF(slave.monitor.queue.size() != 0);
  `SVTEST_END

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
