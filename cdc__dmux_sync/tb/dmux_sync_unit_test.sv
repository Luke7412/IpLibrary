//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module dmux_sync_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "dmux_sync_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  localparam real DST_CLK_PERIOD = 5ns;

  localparam int             DEPTH = 2;
  localparam int             WIDTH = 8;
  localparam bit [WIDTH-1:0] RST_VAL = '0;

  logic             src_toggle;
  logic [WIDTH-1:0] src_data;
  logic             dst_clk;
  logic             dst_rst_n;
  logic             dst_pulse;
  logic [WIDTH-1:0] dst_data;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(dst_clk, (DST_CLK_PERIOD/2))


  //----------------------------------------------------------------------------
  dmux_sync #(
    .DEPTH   (DEPTH),
    .WIDTH   (WIDTH),
    .RST_VAL (RST_VAL)
  ) DUT (.*);


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();

    src_toggle <= '0;
    src_data   <= '0;

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

  task send_data(logic [WIDTH-1:0] data);
    src_toggle <= !src_toggle;
    src_data   <= data;
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_sync_delay)
    send_data('h06);
    wait_tics(DEPTH+2);
    `FAIL_IF(dst_data != src_data)
  `SVTEST_END


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
