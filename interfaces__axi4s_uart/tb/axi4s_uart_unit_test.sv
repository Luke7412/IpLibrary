//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi4s_uart_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "axi4s_uart_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import uart_pkg::*;

  localparam real BAUD_RATE = 9600;
  localparam real BIT_PERIOD = 1s/BAUD_RATE;

  localparam real ACLK_FREQUENCY = 200000000;
  localparam int ACLK_PERIOD = 1s/ACLK_FREQUENCY;

  UartIntf uart_intf();
  UartTransmitter #(BAUD_RATE) transmitter;
  UartReceiver #(BAUD_RATE) receiver;

  logic        aclk;
  logic        aresetn;
  logic        txbyte_tready;
  logic        txbyte_tvalid;
  logic [7:0]  txbyte_tdata;
  logic [0:0]  txbyte_tkeep;
  logic        rxbyte_tvalid;
  logic        rxbyte_tready;
  logic [7:0]  rxbyte_tdata;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  axi4s_uart #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE (BAUD_RATE),
    .BAUD_RATE_SIM (BAUD_RATE)
  ) DUT (
    // Clock and Reset
    .aclk (aclk),
    .aresetn (aresetn),
    // Uart Interface
    .uart_txd (uart_intf.rxd),
    .uart_rxd (uart_intf.txd),
    // Axi4-Stream TxByte Interface
    .txbyte_tvalid (txbyte_tvalid),
    .txbyte_tready (txbyte_tready),
    .txbyte_tdata (txbyte_tdata),
    .txbyte_tkeep (txbyte_tkeep),
    // Axi4-Stream RxByte Interface
    .rxbyte_tvalid (rxbyte_tvalid),
    .rxbyte_tready (rxbyte_tready),
    .rxbyte_tdata (rxbyte_tdata)
  );


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

  `SVTEST(test2)

  `SVTEST_END

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule