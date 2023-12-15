//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module decoder_8b10b_unit_test;
  import svunit_pkg::svunit_testcase;
  string name = "decoder_8b10b_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  logic [9:0] in_data;
  logic       in_disp;
  logic [7:0] out_data;
  logic       out_disp;
  logic       out_is_k;
  logic       err_code;
  logic       err_disp;


  //----------------------------------------------------------------------------
  decoder_8b10b DUT (.*);


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();

    in_data <= '0;
    in_disp <= '0;
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
