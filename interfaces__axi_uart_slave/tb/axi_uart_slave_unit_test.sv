//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi_uart_slave_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "axi_uart_slave_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import axi_uart_pkg::*;

  localparam int ACLK_FREQUENCY    = 200000000;
  localparam int BAUD_RATE         = 9600;
  localparam int BAUD_RATE_SIM     = 50000000;
  localparam bit[7:0] START_BYTE  = 'h7D;
  localparam bit[7:0] STOP_BYTE   = 'h7E;
  localparam bit[7:0] ESCAPE_BYTE = 'h7F;
 
  localparam int ACLK_PERIOD = 1s/ACLK_FREQUENCY;

  logic        aclk;
  logic        aresetn;
  logic        awvalid, awready;
  logic        wvalid , wready;
  logic        bvalid , bready;
  logic        arvalid, arready;
  logic        rvalid , rready;

  typedef struct packed {
    logic [31:0] addr;
    logic [7:0]  len;
    logic [2:0]  size;
    logic [1:0]  burst;
    logic [0:0]  lock;
    logic [3:0]  cache;
    logic [2:0]  prot;
    logic [3:0]  qos;
  } t_aw;

  typedef struct packed {
    logic [31:0] data;
    logic [3:0]  strb;
    logic        last;
  } t_w;

  typedef struct packed {
    logic [1:0]  resp;
  } t_b;

  typedef struct packed {
    logic [31:0] addr;
    logic [7:0]  len;
    logic [2:0]  size;
    logic [1:0]  burst;
    logic [0:0]  lock;
    logic [3:0]  cache;
    logic [2:0]  prot;
    logic [3:0]  qos;
  } t_ar;

  typedef struct packed {
    logic [31:0] data;
    logic [1:0]  resp;
    logic        last; 
  } t_r;

  t_aw bus_aw;
  t_w  bus_w;
  t_b  bus_b;
  t_ar bus_ar;
  t_r  bus_r;

  UartIntf uart_intf();
  AxiUartDriver #(START_BYTE, STOP_BYTE, ESCAPE_BYTE) driver;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  axi_uart_slave #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE      (BAUD_RATE),
    .BAUD_RATE_SIM  (BAUD_RATE_SIM),
    .ESCAPE_BYTE    (ESCAPE_BYTE),
    .START_BYTE     (START_BYTE),
    .STOP_BYTE      (STOP_BYTE)
  ) DUT (
    // Clock and Reset
    .aclk           (aclk),
    .aresetn        (aresetn),
    // Uart Interface
    .uart_txd       (uart_intf.rxd),
    .uart_rxd       (uart_intf.txd),
    // Axi4 Interface
    .m_axi_awvalid  (awvalid),
    .m_axi_awready  (awready),
    .m_axi_awaddr   (bus_aw.addr),
    .m_axi_awlen    (bus_aw.len),
    .m_axi_awsize   (bus_aw.size),
    .m_axi_awburst  (bus_aw.burst),
    .m_axi_awlock   (bus_aw.lock),
    .m_axi_awcache  (bus_aw.cache),
    .m_axi_awprot   (bus_aw.prot),
    .m_axi_awqos    (bus_aw.qos),
    .m_axi_wvalid   (wvalid),
    .m_axi_wready   (wready),
    .m_axi_wdata    (bus_w.data),
    .m_axi_wstrb    (bus_w.strb),
    .m_axi_wlast    (bus_w.last),
    .m_axi_bvalid   (bvalid),
    .m_axi_bready   (bready),
    .m_axi_bresp    (bus_b.resp),
    .m_axi_arvalid  (arvalid),
    .m_axi_arready  (arready),
    .m_axi_araddr   (bus_ar.addr),
    .m_axi_arlen    (bus_ar.len),
    .m_axi_arsize   (bus_ar.size),
    .m_axi_arburst  (bus_ar.burst),
    .m_axi_arlock   (bus_ar.lock),
    .m_axi_arcache  (bus_ar.cache),
    .m_axi_arprot   (bus_ar.prot),
    .m_axi_arqos    (bus_ar.qos),
    .m_axi_rvalid   (rvalid),
    .m_axi_rready   (rready),
    .m_axi_rdata    (bus_r.data),
    .m_axi_rresp    (bus_r.resp),
    .m_axi_rlast    (bus_r.last)   
  );


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    driver = new(uart_intf);
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


  


  //----------------------------------------------------------------------------
  `SVTEST(test_write)

  `SVTEST_END




  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
