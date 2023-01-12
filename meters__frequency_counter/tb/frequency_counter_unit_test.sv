//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module frequency_counter_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "frequency_counter_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import axi4lite_pkg::*;

  localparam real ACLK_PERIOD = 10ns;
  real sen_clk_period = 100ns;

  localparam int ACLK_FREQUENCY = 100000000;
  localparam int ADDR_WIDTH = 12;

  logic aclk;
  logic aresetn;
  logic sen_clk;

  typedef Axi4lite_Transaction #(ADDR_WIDTH) Transaction;
  Axi4lite_Master #(ADDR_WIDTH) master;
  Axi4lite_Intf #(ADDR_WIDTH) intf (aclk, aresetn);


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))
  `SVUNIT_CLK_GEN(sen_clk, (sen_clk_period/2))


  //----------------------------------------------------------------------------
  frequency_counter #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY)
  ) DUT (
    .ctrl_arvalid (intf.arvalid),
    .ctrl_arready (intf.arready),
    .ctrl_araddr  (intf.araddr),
    .ctrl_rvalid  (intf.rvalid),
    .ctrl_rready  (intf.rready),
    .ctrl_rdata   (intf.rdata),
    .ctrl_rresp   (intf.rresp),
    .ctrl_awvalid (intf.awvalid),
    .ctrl_awready (intf.awready),
    .ctrl_awaddr  (intf.awaddr),
    .ctrl_wvalid  (intf.wvalid),
    .ctrl_wready  (intf.wready),
    .ctrl_wdata   (intf.wdata),
    .ctrl_wstrb   (intf.wstrb),
    .ctrl_bvalid  (intf.bvalid),
    .ctrl_bready  (intf.bready),
    .ctrl_bresp   (intf.bresp),
    .*
  );


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
    aresetn <= '0;
    #(5*ACLK_PERIOD);
  endtask


  //----------------------------------------------------------------------------
  task wait_tics(int tics=1);
    repeat(tics)
      @(posedge intf.aclk);
  endtask



  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_read_module_id)
    bit [31:0] data;
    bit [1:0] resp;

    master.read(.addr('h00), .data(data), .resp(resp));
    `FAIL_IF(data != 'hDEADBEEF)
  `SVTEST_END

  `SVTEST(test_write_reg_div)
    bit [31:0] data;
    bit [1:0] resp;

    master.write(.addr('h04), .data(1), .resp(resp));
    master.read(.addr('h04), .data(data), .resp(resp));
    `FAIL_IF(data != 1)
  `SVTEST_END

  `SVTEST(test_read_freq)
    bit [31:0] data;
    bit [1:0] resp;

    #100us;
    do
      master.read(.addr('h08), .data(data), .resp(resp));
    while (data[17] != 1);

    `FAIL_IF(data[17:0] != 'h2000a)
  `SVTEST_END


  `SVTEST(test_read_freq_div)
    bit [31:0] data;
    bit [1:0] resp;

    master.write(.addr('h04), .data(1), .resp(resp));

    #100us;
    do
      master.read(.addr('h08), .data(data), .resp(resp));
    while (data[17] != 1);

    `FAIL_IF(data[17:0] != 'h200a0)
  `SVTEST_END

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
