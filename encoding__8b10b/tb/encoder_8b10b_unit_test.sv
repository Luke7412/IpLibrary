//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module encoder_8b10b_unit_test;
  import svunit_pkg::svunit_testcase;
  string name = "encoder_8b10b_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  logic [7:0]  in_data;
  logic        in_disp;
  logic        in_is_k;
  logic [7:0]  out_data;
  logic        out_disp;


  //----------------------------------------------------------------------------
  encoder_8b10b DUT(.*);


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();

    in_data <= '0;
    in_disp <= '0;
    in_is_k <= '0;
    #1;
  endtask


  task teardown();
    svunit_ut.teardown();

    #1;
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_)
    
  `SVTEST_END

 
  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
