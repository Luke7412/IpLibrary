

`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi4s_uart_tx_unit_test;
  import svunit_pkg::svunit_testcase;
  string name = "axi4s_uart_tx_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import uart_pkg::*;
  import axi4s_pkg::*;

  localparam real BAUD_RATE = 1000000;
  localparam real BIT_PERIOD = 1s/BAUD_RATE;

  localparam real ACLK_FREQUENCY = 100000000;
  localparam int ACLK_PERIOD = 1s/ACLK_FREQUENCY;

  logic        aclk;
  logic        aresetn;
  logic        tx_byte_tready;
  logic        tx_byte_tvalid;
  logic [7:0]  tx_byte_tdata;
  logic [0:0]  tx_byte_tkeep;
  logic        rx_byte_tvalid;
  logic        rx_byte_tready;
  logic [7:0]  rx_byte_tdata;

  Uart_Intf uart_intf();
  Uart_Receiver #(BAUD_RATE) receiver;
  Axi4s_Intf axi4s_intf(aclk, aresetn);
  Axi4s_Master master;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  axi4s_uart_tx #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE      (BAUD_RATE),
    .BAUD_RATE_SIM  (BAUD_RATE)
  ) DUT (
    // Clock and Reset
    .aclk           (aclk),
    .aresetn        (aresetn),
    .uart_txd       (uart_intf.rxd),
    // Axi4-Stream TxByte Interface
    .tx_byte_tvalid (axi4s_intf.tvalid),
    .tx_byte_tready (axi4s_intf.tready),
    .tx_byte_tdata  (axi4s_intf.tdata),
    .tx_byte_tkeep  (axi4s_intf.tkeep)
  );


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    master = new(axi4s_intf);
    receiver = new(uart_intf);
  endfunction


  task setup();
    svunit_ut.setup();
    master.start();
    receiver.start();

    aresetn <= '0;
    wait_tics(5);
    aresetn <= '1;
    wait_tics(5);
  endtask


  task teardown();
    svunit_ut.teardown();
    master.stop();
    receiver.stop();

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

  `SVTEST(test_transmit_single)
    master.send_beat(.tdata('h45), .tkeep('1));

    #(20*BIT_PERIOD);
    `FAIL_IF(receiver.rx_queue.size() != 1);
    `FAIL_IF(receiver.rx_queue.pop_front() != 'h45);
  `SVTEST_END

  `SVTEST(test_transmit_two_consecutive)
    master.send_beat(.tdata('h45), .tkeep('1), .blocking(0));
    master.send_beat(.tdata('h56), .tkeep('1), .blocking(0));

    #(40*BIT_PERIOD);
    `FAIL_IF(receiver.rx_queue.size() != 2);
    `FAIL_IF(receiver.rx_queue.pop_front() != 'h45);
    `FAIL_IF(receiver.rx_queue.pop_front() != 'h56);
  `SVTEST_END

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule