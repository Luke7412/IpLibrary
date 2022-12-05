//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi4s_uart_rx_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "axi4s_uart_rx_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import uart_pkg::*;
  import axi4s_pkg::*;

  localparam real BAUD_RATE = 9600;
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

  UartIntf uart_intf();
  UartTransmitter #(BAUD_RATE) transmitter;
  AXI4S_Intf axi4s_intf(aclk, aresetn);
  AXI4S_Slave slave;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  axi4s_uart_rx #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE      (BAUD_RATE),
    .BAUD_RATE_SIM  (BAUD_RATE)
  ) DUT (
    // Clock and Reset
    .aclk           (aclk),
    .aresetn        (aresetn),
    // Uart Interface
    .uart_rxd       (uart_intf.txd),
    // Axi4-Stream RxByte Interface
    .rx_byte_tvalid (axi4s_intf.tvalid),
    .rx_byte_tready (axi4s_intf.tready),
    .rx_byte_tdata  (axi4s_intf.tdata)
  );


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    slave = new(axi4s_intf);
    transmitter = new(uart_intf);
  endfunction


  task setup();
    svunit_ut.setup();
    slave.start();
    transmitter.start();

    aresetn <= '0;
    wait_tics(5);
    aresetn <= '1;
    wait_tics(5);
  endtask


  task teardown();
    svunit_ut.teardown();
    slave.stop();
    transmitter.stop();

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

  `SVTEST_END

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule