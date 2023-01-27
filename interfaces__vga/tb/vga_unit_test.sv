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
  localparam real ACLK_PERIOD = 20;

  localparam int H_RES          = 20;
  localparam int V_RES          = 20;
  localparam int H_FRONT_PORCH  = 4;
  localparam int H_BACK_PORCH   = 4;
  localparam int V_FRONT_PORCH  = 3;
  localparam int V_BACK_PORCH   = 3;
  localparam int H_BLANKING     = 10;
  localparam int V_BLANKING     = 10;
  localparam int H_ACT_BLANKING = H_BLANKING - H_FRONT_PORCH - H_BACK_PORCH;
  localparam int V_ACT_BLANKING = V_BLANKING - V_FRONT_PORCH - V_BACK_PORCH;

  logic aclk;
  logic aresetn;
  logic            pix_tvalid;
  logic            pix_tready;
  logic [3*4-1:0]  pix_tdata;
  logic            pix_tlast;
  logic            pix_tuser;
  logic vsync;
  logic hsync;
  logic [3:0] r;
  logic [3:0] g;
  logic [3:0] b;
  logic sof;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  vga #(
    .H_RES         (H_RES),
    .V_RES         (V_RES),
    .H_FRONT_PORCH (H_FRONT_PORCH),
    .H_BACK_PORCH  (H_BACK_PORCH),
    .V_FRONT_PORCH (V_FRONT_PORCH),
    .V_BACK_PORCH  (V_BACK_PORCH),
    .H_BLANKING    (H_BLANKING),
    .V_BLANKING    (V_BLANKING)
  ) DUT (.*);


  //----------------------------------------------------------------------------
  frame_gen #(
    .H_RES         (H_RES),
    .V_RES         (V_RES)
  ) i_frame_gen (.*);

  
  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();

    aresetn <= '0;
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
  `SVTEST(test_dummy)
    #50us;
  `SVTEST_END

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
