//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module dff_sync_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "dff_sync_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  localparam real DST_CLK_PERIOD = 5ns;

  localparam int DEPTH = 2;
  localparam bit RST_VAL = '0;

  logic src_data;
  logic dst_clk;
  logic dst_rst_n;
  logic dst_data;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(dst_clk, (DST_CLK_PERIOD/2))


  //----------------------------------------------------------------------------
  dff_sync #(
    .DEPTH   (DEPTH),
    .RST_VAL (RST_VAL)
  ) DUT (.*);


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();

    src_data <= '0;

    dst_rst_n <= '0;
    wait_tics(5);
    dst_rst_n <= '1;
    wait_tics(5);
  endtask


  task teardown();
    svunit_ut.teardown();

    #(5*DST_CLK_PERIOD);
    dst_rst_n <= '0;
  endtask


  //----------------------------------------------------------------------------
  task wait_tics(int tics=1);
    repeat(tics)
      @(posedge dst_clk);
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_sync_delay)
    src_data <= '1;
    wait_tics(DEPTH+1);
    `FAIL_IF(dst_data != src_data)
    
    src_data <= '0;
    wait_tics(DEPTH+1);
    `FAIL_IF(dst_data != src_data)
  `SVTEST_END


  `SVTEST(test_reset_value)
    src_data <= '1;
    wait_tics(DEPTH+1);
    `FAIL_IF(dst_data != src_data)
    
    dst_rst_n <= '0;
    wait_tics(1);
    `FAIL_IF(dst_data != RST_VAL)
  `SVTEST_END


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
