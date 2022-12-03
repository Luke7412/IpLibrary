//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axis_uart_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "axis_uart_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import uart_pkg::*;

  localparam real BAUD_RATE = 9600;
  localparam real BIT_PERIOD = 1s/BAUD_RATE;

  UartIntf uart_intf();
  UartTransmitter #(BAUD_RATE) transmitter;
  UartReceiver #(BAUD_RATE) receiver;


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    transmitter = new(uart_intf);
    receiver = new(uart_intf);
  endfunction


  task setup();
    svunit_ut.setup();
    transmitter.start();
    receiver.start();
  endtask


  task teardown();
    svunit_ut.teardown();
    transmitter.stop();
    receiver.stop();
  endtask


  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN

  `SVTEST(test)

  `SVTEST_END

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule