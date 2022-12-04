//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module uart_transmitter_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "uart_transmitter_ut";
  svunit_testcase svunit_ut;
  
  
  //----------------------------------------------------------------------------
  import uart_pkg::*;

  localparam real BAUD_RATE = 9600;
  localparam real BIT_PERIOD = 1s/BAUD_RATE;

  typedef bit [7:0] u8;

  UartIntf uart_intf();
  UartTransmitter #(BAUD_RATE) transmitter;

  u8 rx_queue [$];


  //----------------------------------------------------------------------------
  assign uart_intf.rxd = uart_intf.txd;

  initial begin
    logic [9:0] bits;
    
    forever begin
      @ (negedge uart_intf.rxd);
      #(BIT_PERIOD/2);
      bits[0] = uart_intf.rxd;
      for (int i=1; i<$size(bits); i++) begin
        #(BIT_PERIOD);
        bits[i] = uart_intf.rxd;
      end
      if (!bits[0] && bits[9]) begin
        rx_queue.push_back(bits[8:1]);
      end
    end
  end


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    transmitter = new(uart_intf);
  endfunction


  task setup();
    svunit_ut.setup();
    transmitter.start();
    rx_queue.delete();

    #(5*BIT_PERIOD);
  endtask


  task teardown();
    svunit_ut.teardown();
    transmitter.stop();
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN

  `SVTEST(test_send_single_byte)
    u8 value = 'h05;  
    transmitter.send_byte(value);

    #(10*BIT_PERIOD);
    `FAIL_IF(rx_queue.size() != 1);
    `FAIL_IF(rx_queue.pop_front() != value);
  `SVTEST_END


  `SVTEST(test_send_byte_stream)
    u8 values [8] = '{'h05, 'h06, 'h78, 'h96, 'hFF, 'h35, 'hED, 'h96};  
    transmitter.send_bytes(values);

    #(10*BIT_PERIOD);
    `FAIL_IF(rx_queue.size() != 8);
    foreach (values[i])
      `FAIL_IF(rx_queue.pop_front() != values[i]);
  `SVTEST_END


  `SVTEST(test_send_single_byte_non_blocking)
    u8 value = 'h05;  
    transmitter.send_byte(value);

    #(10*BIT_PERIOD);
    `FAIL_IF(rx_queue.size() != 1);
    `FAIL_IF(rx_queue.pop_front() != value);
  `SVTEST_END


  `SVTEST(test_send_byte_stream_non_blocking)
    u8 values [8] = '{'h05, 'h06, 'h78, 'h96, 'hFF, 'h35, 'hED, 'h96};  
    transmitter.send_bytes(values);

    #(8*10*BIT_PERIOD);
    `FAIL_UNLESS_LOG(8 == rx_queue.size(), 
      $sformatf("Exp: %d, Got: %d", 8, rx_queue.size())
    );
    foreach (values[i])
      `FAIL_IF(rx_queue.pop_front() != values[i]);
  `SVTEST_END


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule