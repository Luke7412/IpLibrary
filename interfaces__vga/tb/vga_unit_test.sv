//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module vga_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "vga_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import vga_pkg::*;

  localparam real ACLK_PERIOD = 25;

  logic aclk;
  logic aresetn;
  logic        ctrl_arvalid;
  logic        ctrl_arready;
  logic [11:0] ctrl_araddr;
  logic        ctrl_rvalid;
  logic        ctrl_rready;
  logic [31:0] ctrl_rdata;
  logic [1:0]  ctrl_rresp;
  logic        ctrl_awvalid;
  logic        ctrl_awready;
  logic [11:0] ctrl_awaddr;
  logic        ctrl_wvalid;
  logic        ctrl_wready;
  logic [31:0] ctrl_wdata;
  logic [3:0]  ctrl_wstrb;
  logic        ctrl_bvalid;
  logic        ctrl_bready;
  logic [1:0]  ctrl_bresp;
  logic            pix_tvalid;
  logic            pix_tready;
  logic [3*8-1:0]  pix_tdata;
  logic            pix_tlast;
  logic            pix_tuser;
  logic       vga_vsync;
  logic       vga_hsync;
  logic [3:0] vga_red;
  logic [3:0] vga_green;
  logic [3:0] vga_blue;

  logic sof;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  vga DUT (.*);


  //----------------------------------------------------------------------------
  frame_gen i_frame_gen( 
    .aclk       (aclk),
    .aresetn    (aresetn),
    .H_RES      (800),
    .V_RES      (600),
    .sof        (sof),
    .pix_tvalid (pix_tvalid),
    .pix_tready (pix_tready),
    .pix_tdata  (pix_tdata),
    .pix_tlast  (pix_tlast),
    .pix_tuser  (pix_tuser)
  );


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();

    aresetn <= '0;
    pix_tvalid <= '0;
    sof <= '0;

    wait_tics(5);
    aresetn <= '1;
    wait_tics(5);
  endtask


  task teardown();
    svunit_ut.teardown();

    #(5*ACLK_PERIOD);
    aresetn <= '0;
  endtask


  //----------------------------------------------------------------------------
  task wait_tics(int tics=1);
    repeat(tics)
      @(posedge aclk);
  endtask;

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  //----------------------------------------------------------------------------
  `SVTEST(test)
    #1ms;
    sof <= '1;
    #100000us;
  `SVTEST_END

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
