//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi4lite_master_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "axi4lite_master_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import axi4lite_pkg::*;

  localparam real ACLK_PERIOD = 10;

  localparam int ADDR_WIDTH = 8;

  logic aclk;
  logic aresetn;

  typedef Axi4lite_Transaction #(ADDR_WIDTH) Transaction;
  Axi4lite_Master #(ADDR_WIDTH) master;
  Axi4lite_Intf #(ADDR_WIDTH) intf (aclk, aresetn);

  Transaction queue [$];


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin
    Transaction t;

    if (!aresetn) begin
      queue.delete();
      intf.rvalid <= '0;
      intf.rdata <= '0;
      intf.rresp <= '0;
      intf.bvalid <= '0;
      intf.bresp <= '0;

    end else begin

      // Read Handshake/Data
      if (intf.arvalid && intf.arready) begin
        intf.rvalid <= '1;
        t = new (.write(0), .addr(intf.araddr), .data(intf.rdata));
        queue.push_back(t);
      end else if (intf.rvalid && intf.rready) begin
        intf.rvalid <= '0;
      end

      // Write Handshake/Data
      if (intf.awvalid && intf.awready && intf.wvalid && intf.wready) begin
        intf.bvalid <= '1;
        t = new (.write(1), .addr(intf.awaddr), .data(intf.wdata), .strb(intf.wstrb));
        queue.push_back(t);

      end else if (intf.bvalid && intf.bready) begin
        intf.bvalid <= '0;
      end

    end
  end

  assign intf.arready = !intf.rvalid;
  assign intf.awready = intf.wvalid  && !intf.bvalid;
  assign intf.wready  = intf.awvalid && !intf.bvalid;


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    master = new(intf);
  endfunction


  task setup();
    svunit_ut.setup();
    master.start();

    aresetn <= '0;

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


  `SVTEST(test_single_write)
    bit [1:0] resp;

    master.write(.addr(12), .data('hDEADBEEF), .resp(resp));

  `SVTEST_END

  `SVTEST(test_single_read)
    bit [31:0] data;
    bit [1:0] resp;

    master.read(.addr(12), .data(data), .resp(resp));

  `SVTEST_END

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
