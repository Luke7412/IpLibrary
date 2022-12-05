//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi4s_transaction_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "axi4s_transaction_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import axi4s_pkg::*;


  //----------------------------------------------------------------------------
  

  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_typedef_defaults)
    typedef AXI4S_Transaction T;

    T transaction = new();
    `FAIL_IF($size(transaction.tdata) != 8);
    `FAIL_IF($size(transaction.tkeep) != 1);
    `FAIL_IF($size(transaction.tstrb) != 1);
    `FAIL_IF($size(transaction.tuser) != 1);
    `FAIL_IF($size(transaction.tdest) != 1);
    `FAIL_IF($size(transaction.tid)   != 1);
  `SVTEST_END


  `SVTEST(test_typedef_full)
    typedef AXI4S_Transaction #(
    .TDATA_WIDTH(10), .TKEEP_WIDTH(11), .TSTRB_WIDTH(12), 
    .TUSER_WIDTH(13), .TDEST_WIDTH(14), .TID_WIDTH(15)
  ) T;

    T transaction = new();
    `FAIL_IF($size(transaction.tdata) != 10);
    `FAIL_IF($size(transaction.tkeep) != 11);
    `FAIL_IF($size(transaction.tstrb) != 12);
    `FAIL_IF($size(transaction.tuser) != 13);
    `FAIL_IF($size(transaction.tdest) != 14);
    `FAIL_IF($size(transaction.tid)   != 15);
  `SVTEST_END


  `SVTEST(test_typedef_calculated_tkeep_tstrb)
    typedef AXI4S_Transaction #(
    .TDATA_WIDTH (10)
  ) T;

    T transaction = new();
    `FAIL_IF($size(transaction.tdata) != 10);
    `FAIL_IF($size(transaction.tkeep) != 2);
    `FAIL_IF($size(transaction.tstrb) != 2);
    `FAIL_IF($size(transaction.tuser) != 1);
    `FAIL_IF($size(transaction.tdest) != 1);
    `FAIL_IF($size(transaction.tid)   != 1);
  `SVTEST_END


  `SVTEST(test_fields)
    typedef AXI4S_Transaction #(
    .TDATA_WIDTH(8), .TKEEP_WIDTH(8), .TSTRB_WIDTH(8),
    .TUSER_WIDTH(8), .TDEST_WIDTH(8), .TID_WIDTH(8)
  ) T;

    T transaction = new(
      .tdata(10), .tkeep(11), .tstrb(12), .tuser(13), .tdest(14), .tid(15)
    );
    `FAIL_IF(transaction.tdata != 10);
    `FAIL_IF(transaction.tkeep != 11);
    `FAIL_IF(transaction.tstrb != 12);
    `FAIL_IF(transaction.tuser != 13);
    `FAIL_IF(transaction.tdest != 14);
    `FAIL_IF(transaction.tid   != 15);

    // transaction.display();
  `SVTEST_END

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
