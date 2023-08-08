//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module cdr_data_recovery_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "cdr_data_recovery_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  localparam real ACLK_FREQUENCY = 100000000;
  localparam int ACLK_PERIOD = 1s/ACLK_FREQUENCY;


  logic        aclk;
  logic        aresetn;



  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------



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
      @(posedge axi4s_intf.aclk);
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN

  `SVTEST(test_)
    master.send_beat(.tdata('h45), .tkeep('1));
  `SVTEST_END



  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule