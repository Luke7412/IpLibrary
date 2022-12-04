//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi_uart_driver_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "axi_uart_driver_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import axi_uart_pkg::*;

  localparam real     BAUD_RATE   = 1000000;
  localparam bit[7:0] START_BYTE  = 'h7D;
  localparam bit[7:0] STOP_BYTE   = 'h7E;
  localparam bit[7:0] ESCAPE_BYTE = 'h7F;

  typedef bit[7:0] t_pkt [$];
  typedef t_pkt t_pkts [$];
  
  UartIntf vif();
  AxiUartDriver #(BAUD_RATE, START_BYTE, STOP_BYTE, ESCAPE_BYTE) driver;


  //----------------------------------------------------------------------------
  

  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    driver = new(vif);
  endfunction


  task setup();
    svunit_ut.setup();
    driver.start();
  endtask


  task teardown();
    svunit_ut.teardown();
    driver.stop();
  endtask


  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_add_framing)
    t_pkt data_in = '{5, 4, 6, 8};
    t_pkt data_exp = {START_BYTE, data_in, STOP_BYTE};
    t_pkt data_out;

    data_out = driver.add_framing(data_in);
    foreach(data_exp[i])
      `FAIL_IF(data_exp[i] != data_out[i]);
  `SVTEST_END

  `SVTEST(test_remove_framing)
    t_pkt data_in = '{START_BYTE, 5, 4, 6, 8, STOP_BYTE};
    t_pkt data_exp = data_in[1:data_in.size()-2];
    t_pkt data_out;

    data_out = driver.remove_framing(data_in);
    foreach(data_exp[i])
      `FAIL_IF(data_exp[i] != data_out[i]);
  `SVTEST_END


  `SVTEST(test_remove_escape_from_start)
    t_pkt data_in = '{START_BYTE, 5, 4, ESCAPE_BYTE, START_BYTE, 8, STOP_BYTE};
    t_pkt data_exp = '{START_BYTE, 5, 4, START_BYTE, 8, STOP_BYTE};
    t_pkt data_out;

    data_out = driver.remove_escape_chars(data_in);
    foreach(data_exp[i])
      `FAIL_IF(data_exp[i] != data_out[i]);
  `SVTEST_END

  `SVTEST(test_remove_escape_from_stop)
    t_pkt data_in = '{START_BYTE, 5, 4, ESCAPE_BYTE, STOP_BYTE, 8, STOP_BYTE};
    t_pkt data_exp = '{START_BYTE, 5, 4, STOP_BYTE, 8, STOP_BYTE};
    t_pkt data_out;

    data_out = driver.remove_escape_chars(data_in);
    foreach(data_exp[i])
      `FAIL_IF(data_exp[i] != data_out[i]);
  `SVTEST_END

  `SVTEST(test_remove_escape_from_escape)
    t_pkt data_in = '{START_BYTE, 5, 4, ESCAPE_BYTE, ESCAPE_BYTE, 8, STOP_BYTE};
    t_pkt data_exp = '{START_BYTE, 5, 4, ESCAPE_BYTE, 8, STOP_BYTE};
    t_pkt data_out;

    data_out = driver.remove_escape_chars(data_in);
    foreach(data_exp[i])
      `FAIL_IF(data_exp[i] != data_out[i]);
  `SVTEST_END

  `SVTEST(test_remove_escape_from_consecutive_escape)
    t_pkt data_in = '{START_BYTE, 5, 4, ESCAPE_BYTE, ESCAPE_BYTE, ESCAPE_BYTE, STOP_BYTE, 8, STOP_BYTE};
    t_pkt data_exp = '{START_BYTE, 5, 4, ESCAPE_BYTE, STOP_BYTE, 8, STOP_BYTE};
    t_pkt data_out;

    data_out = driver.remove_escape_chars(data_in);
    foreach(data_exp[i])
      `FAIL_IF(data_exp[i] != data_out[i]);
  `SVTEST_END


  `SVTEST(test_add_escape_to_start)
    t_pkt data_in = '{5, 4, START_BYTE, 8};
    t_pkt data_exp = '{5, 4, ESCAPE_BYTE, START_BYTE, 8};
    t_pkt data_out;

    data_out = driver.add_escape_chars(data_in);
    foreach(data_exp[i])
      `FAIL_IF(data_exp[i] != data_out[i]);
  `SVTEST_END

  `SVTEST(test_add_escape_to_stop)
    t_pkt data_in = '{5, 4, STOP_BYTE, 8} ;
    t_pkt data_exp = '{5, 4, ESCAPE_BYTE, STOP_BYTE, 8};
    t_pkt data_out;

    data_out = driver.add_escape_chars(data_in);
    foreach(data_exp[i])
      `FAIL_IF(data_exp[i] != data_out[i]);
  `SVTEST_END

  `SVTEST(test_add_escape_to_escape)
    t_pkt data_in = '{5, 4, ESCAPE_BYTE, 8};
    t_pkt data_exp = '{5, 4, ESCAPE_BYTE, ESCAPE_BYTE, 8};
    t_pkt data_out;

    data_out = driver.add_escape_chars(data_in);
    foreach(data_exp[i])
      `FAIL_IF(data_exp[i] != data_out[i]);
  `SVTEST_END

  `SVTEST(test_add_escape_to_consecutive_escape)
    t_pkt data_in = '{5, 4, ESCAPE_BYTE, STOP_BYTE, 8};
    t_pkt data_exp = '{5, 4, ESCAPE_BYTE, ESCAPE_BYTE, ESCAPE_BYTE, STOP_BYTE, 8};
    t_pkt data_out;

    data_out = driver.add_escape_chars(data_in);
    foreach(data_exp[i])
      `FAIL_IF(data_exp[i] != data_out[i]);
  `SVTEST_END

  `SVTEST(test_add_escape_to_first)
    t_pkt data_in = '{STOP_BYTE, 5, 4, 8};
    t_pkt data_exp = '{ESCAPE_BYTE, STOP_BYTE, 5, 4, 8};
    t_pkt data_out;

    data_out = driver.add_escape_chars(data_in);
    foreach(data_exp[i])
      `FAIL_IF(data_exp[i] != data_out[i]);
  `SVTEST_END


  //----------------------------------------------------------------------------
  `SVTEST(test_make_addr_pkt)
    t_pkt_id pkt_id = READ_ADDR;
    int addr = 'hDEADBEEF;
    int length = 16;
    t_pkt data_out;

    data_out = driver.make_addr_pkt(pkt_id, addr, length);
    $display("%p", data_out);

    // foreach(data_exp[i])
    //   `FAIL_IF(data_exp[i] != data_out[i]);
  `SVTEST_END

  `SVTEST(test_pack_data_no_offset)
    t_pkt_id pkt_id = WRITE_DATA;
    int offset = 0;
    t_pkt data_in = '{0, 1, 2, 3, 4, 5, 6, 7};
    t_pkts data_out;

    data_out = driver.pack_data(pkt_id, data_in, offset);
    $display ("%p", data_out);
  `SVTEST_END

  `SVTEST(test_pack_data_offset)
    t_pkt_id pkt_id = WRITE_DATA;
    int offset = 1;
    t_pkt data_in = '{0, 1, 2, 3, 4, 5, 6, 7};
    t_pkts data_out;

    data_out = driver.pack_data(pkt_id, data_in, offset);
    $display ("%p", data_out);
  `SVTEST_END


  //----------------------------------------------------------------------------
  `SVTEST(test_write)
    int addr = 8;
    bit [7:0] data [4] = '{1, 2, 3, 4};

    driver.write(addr, data);
    $display("%p", driver.tx.tx_queue);

    #1ms;
  `SVTEST_END




  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
