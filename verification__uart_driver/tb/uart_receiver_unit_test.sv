//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns;


module uart_receiver_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "uart_receiver_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import uart_pkg::*;

  localparam real BAUD_RATE = 9600;
  localparam real BIT_PERIOD = 1s/BAUD_RATE;

  UartIntf uart_intf();
  UartReceiver #(BAUD_RATE) receiver;


  //----------------------------------------------------------------------------
  assign uart_intf.rx = uart_intf.tx;


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    receiver = new(uart_intf);
  endfunction


  task setup();
    svunit_ut.setup();
    receiver.start();
    uart_intf.tx <= '1;
    #(5*BIT_PERIOD);
  endtask


  task teardown();
    svunit_ut.teardown();
    receiver.stop();
  endtask


  //----------------------------------------------------------------------------
  task send_bytes(byte values []);
    logic [9:0] bits;

    foreach(values[i]) begin
      bits = {1'b1, values[i], 1'b0};
      for (int i=0; i<$size(bits); i++) begin
        uart_intf.tx <= bits[i];
        #(BIT_PERIOD); 
      end
    end
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN

  `SVTEST(test_receive_single_byte)
    byte values [1] = '{'h05}; 
    send_bytes(values);

    `FAIL_IF(receiver.rx_queue.size() != 1);
    `FAIL_IF(receiver.rx_queue.pop_front() != values[0]);
  `SVTEST_END


  `SVTEST(test_receive_byte_stream)
    byte values [8] = '{'h05, 'h06, 'h78, 'h96, 'hFF, 'h35, 'hED, 'h96};  
    send_bytes(values);

    `FAIL_IF(receiver.rx_queue.size() != 8);
    foreach (values[i])
      `FAIL_IF(receiver.rx_queue.pop_front() != values[i]);
  `SVTEST_END

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule