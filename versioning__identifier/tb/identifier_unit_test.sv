//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module identifier_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "identifier_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import axi4lite_pkg::*;

  localparam real ACLK_PERIOD = 10ns;

  localparam bit [15:0][7:0] NAME          = "TEST VERSION";
  localparam bit [15:0]      MAJOR_VERSION = 1;
  localparam bit [15:0]      MINOR_VERSION = 0;

  localparam int ADDR_WIDTH = 8;

  logic        aclk;
  logic        aresetn;

  Axi4lite_Master #(ADDR_WIDTH) master;
  Axi4lite_Intf #(ADDR_WIDTH) intf (aclk, aresetn);


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  identifier_wpr #(
  .NAME          (NAME),
  .MAJOR_VERSION (1),
  .MINOR_VERSION (0)
  ) DUT (
    .aclk         (aclk),
    .aresetn      (aresetn),
    .ctrl_arvalid (intf.arvalid),
    .ctrl_arready (intf.arready),
    .ctrl_araddr  (intf.araddr),
    .ctrl_rvalid  (intf.rvalid),
    .ctrl_rready  (intf.rready),
    .ctrl_rdata   (intf.rdata),
    .ctrl_rresp   (intf.rresp)
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
  endtask


  //----------------------------------------------------------------------------
  task wait_tics(int tics=1);
    repeat(tics)
      @(posedge aclk);
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_read_module_hash)
    bit [31:0] data;
    bit [1:0] resp;

    master.read(.addr(8'h00), .data(data), .resp(resp));

    `FAIL_IF(resp != 2'h0);
    `FAIL_IF(data != 32'h958B2728);
  `SVTEST_END

 
   `SVTEST(test_read_version)
    bit [31:0] data;
    bit [1:0] resp;

    master.read(.addr(8'h14), .data(data), .resp(resp));

    `FAIL_IF(resp != 2'h0);
    `FAIL_IF(data != {MAJOR_VERSION, MINOR_VERSION});
  `SVTEST_END


   `SVTEST(test_read_name)
    bit [31:0] data;
    bit [1:0] resp;
    logic [0:3][31:0] NAME_ARR = NAME;

    for (int i=0; i<4; i++) begin
      master.read(.addr('h04 + 4*i), .data(data), .resp(resp));
      `FAIL_IF(resp != 2'h0);
      `FAIL_IF(data != NAME_ARR[i]);
      $display("%08x, %08x", NAME_ARR[i], data);

      // for (int j=0; j<4; j++)
      //   $display("%s", data[8*(j+1)-1 -: 8]);
    end
  `SVTEST_END

    
  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
