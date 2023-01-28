//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi4lite__regbank_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "axi4lite__regbank_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import axi4lite_pkg::*;

  localparam real ACLK_PERIOD = 10;
  localparam int ADDR_WIDTH = 12;

  localparam int NOF_REGOUT = 4;
  localparam int NOF_REGIN  = 4;
 
  logic        aclk;
  logic        aresetn;
  logic [31:0] reg_out [NOF_REGOUT];
  logic [31:0] reg_in  [NOF_REGIN ];

  typedef Axi4lite_Transaction #(ADDR_WIDTH) Transaction;
  Axi4lite_Master #(ADDR_WIDTH) master;
  Axi4lite_Intf #(ADDR_WIDTH) intf (aclk, aresetn);


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  axi4lite_regbank #(
    .NOF_REGOUT (NOF_REGOUT),
    .NOF_REGIN (NOF_REGIN)
  ) DUT ( 
    .aclk (aclk),
    .aresetn (aresetn),
    .ctrl_arvalid (intf.arvalid),
    .ctrl_arready (intf.arready),
    .ctrl_araddr (intf.araddr),
    .ctrl_rvalid (intf.rvalid),
    .ctrl_rready (intf.rready),
    .ctrl_rdata (intf.rdata),
    .ctrl_rresp (intf.rresp),
    .ctrl_awvalid (intf.awvalid),
    .ctrl_awready (intf.awready),
    .ctrl_awaddr (intf.awaddr),
    .ctrl_wvalid (intf.wvalid),
    .ctrl_wready (intf.wready),
    .ctrl_wdata (intf.wdata),
    .ctrl_wstrb (intf.wstrb),
    .ctrl_bvalid (intf.bvalid),
    .ctrl_bready (intf.bready),
    .ctrl_bresp (intf.bresp),
    .reg_out (reg_out),
    .reg_in (reg_in)
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


  


  //----------------------------------------------------------------------------
  `SVTEST(test_single_read)
    bit [31:0] data;
    bit [1:0] resp;

    reg_in[0] = 'hBEEFF00D;
    master.read(.addr(0), .data(data), .resp(resp));
      `FAIL_UNLESS_LOG(reg_in[0] == data, 
      $sformatf("Exp: %d, Got: %d", reg_in[0], data)
    )
  `SVTEST_END


  `SVTEST(test_single_write)
    bit [1:0] resp;
    logic [31:0] value = 'hDEADBEEF;

    master.write(.addr(4), .data(value), .resp(resp));

    `FAIL_UNLESS_LOG(value == reg_out[0], 
      $sformatf("Exp: %d, Got: %d", value, reg_out[0])
    )
  `SVTEST_END


  `SVTEST(test_all_reg_in)
    bit [31:0] data;
    bit [1:0] resp;

    foreach(reg_in[i]) begin
      reg_in[i] = $random();

      master.read(.addr(8*i), .data(data), .resp(resp));
      `FAIL_UNLESS_LOG(reg_in[i] == data, 
        $sformatf("Exp: %d, Got: %d", reg_in[i], data)
      )
    end
  `SVTEST_END


  `SVTEST(test_all_reg_out)
    bit [31:0] data;
    bit [1:0] resp;
    logic [31:0] value;

    foreach(reg_out[i]) begin
      value = $random();
      master.write(.addr(8*i+4), .data(value), .resp(resp));

      `FAIL_UNLESS_LOG(value == reg_out[i], 
        $sformatf("Exp: %d, Got: %d", value, reg_out[i])
      )

      master.read(.addr(8*i+4), .data(data), .resp(resp));
      `FAIL_UNLESS_LOG(value == data, 
        $sformatf("Exp: %d, Got: %d", value, data)
      )
    end

  `SVTEST_END

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
