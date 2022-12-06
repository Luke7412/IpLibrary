//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi4s_master_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "axi4s_master_ut";
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

  typedef Axi4s_Transaction #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) Transaction;

  Axi4s_Master #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) master;

  Axi4s_Intf #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) intf (aclk, aresetn);


  Transaction queue [$];
  int trottle;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin
    Transaction t;

    if (!aresetn) begin
      queue.delete();
      intf.tready <= '0;

    end else begin
      intf.tready <= $urandom_range(0, 99) < trottle;

      if (intf.tvalid && intf.tready) begin
        t = new (intf.tdata, intf.tkeep, intf.tstrb, intf.tuser, intf.tdest, 
          intf.tid, intf.tlast);
        queue.push_back(t);
      end

    end
  end


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    master = new(intf);
  endfunction


  task setup();
    svunit_ut.setup();
    master.start();

    trottle     <= 100;
    aresetn     <= '0;
    intf.tvalid <= '0;
    intf.tready <= '0;

    wait_tics(5);
    aresetn <= '1;
    wait_tics(5);
  endtask


  task teardown();
    svunit_ut.teardown();
    master.stop();

    #(5*ACLK_PERIOD);
  endtask


  //----------------------------------------------------------------------------
  task wait_tics(int tics=1);
    repeat(tics)
      @(posedge aclk);
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_single_transaction)
    master.send_beat(
      .tdata (),
      .tkeep (),
      .tstrb (),
      .tuser (),
      .tdest (),
      .tid   (),
      .tlast ()
    );

    `FAIL_IF(queue.size() != 1);
    `FAIL_IF(master.monitor.queue.size() != 1);
  `SVTEST_END


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
