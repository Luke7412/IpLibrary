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

  localparam int ACLK_FREQUENCY    = 100000000;
  localparam int BAUD_RATE         = 9600;
  localparam int BAUD_RATE_SIM     = 1000000;
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

  t_aw queue_aw [$];
  t_w  queue_w  [$];
  t_b  queue_b  [$];
  t_ar queue_ar [$];
  t_r  queue_r  [$];

  UartIntf uart_intf();
  AxiUartDriver #(BAUD_RATE_SIM, START_BYTE, STOP_BYTE, ESCAPE_BYTE) driver;


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
  int length;

  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      awready <= '1;
      wready  <= '0; 
      bvalid  <= '0;
      arready <= '1;
      rvalid  <= '0;
      queue_aw.delete();
      queue_w.delete();
      queue_b.delete();
      queue_ar.delete();
      queue_r.delete();

    end else begin
      if (awvalid && awready) begin
        awready <= '0;
        wready  <= '1;

        queue_aw.push_back('{
          addr :bus_aw.addr, len:bus_aw.len, size :bus_aw.size, 
          burst:bus_aw.burst, lock :bus_aw.lock, cache:bus_aw.cache,
          prot :bus_aw.prot, qos:bus_aw.qos
        });
      end

      if (wvalid && wready) begin
        if (bus_w.last) begin
          wready <= '0;
          bvalid <= '1;
        end

        queue_w.push_back('{
          data:bus_w.data, strb:bus_w.strb, last:bus_w.last
        });
      end

      if (bvalid && bready) begin
        bvalid  <= '0;
        awready <= '1;

        queue_b.push_back('{resp:bus_b.resp});
      end

      if (arvalid && arready) begin
        arready <= '0;
        rvalid  <= '1;
        length  <= bus_ar.len; 

        queue_ar.push_back('{
          addr:bus_ar.addr, len:bus_ar.len, size:bus_ar.size,
          burst:bus_ar.burst, lock:bus_ar.lock, cache:bus_ar.cache,
          prot:bus_ar.prot, qos:bus_ar.qos    
        }); 
      end

      if (rvalid && rready) begin
        length <= length - 1;
        if (bus_r.last) begin
          rvalid  <= '0;
          arready <= '1;
        end

        queue_r.push_back('{
          data:bus_r.data, resp:bus_r.resp, last:bus_r.last
        });
      end
    
    end
  end

  assign bus_r.data = length;
  assign bus_r.last = rvalid && length == 0;


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
    driver = new(uart_intf);
  endfunction


  task setup();
    svunit_ut.setup();
    driver.start();

    aresetn <= '0;
    wait_tics(5);
    aresetn <= '1;
    wait_tics(5);
  endtask


  task teardown();
    svunit_ut.teardown();
    driver.stop();

    #(5*ACLK_PERIOD);
    aresetn <= '0;
  endtask


  //----------------------------------------------------------------------------
  task wait_tics(int tics=1);
    repeat(tics)
      @(posedge aclk);
  endtask;

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  


  //----------------------------------------------------------------------------
  `SVTEST(test_write)
    int addr = 8;
    bit [7:0] data [4] = '{1, 2, 3, 4};

    driver.write(addr, data);

    $display("%p", queue_aw);
    $display("%p", queue_w); 
    $display("%p", queue_b); 
    $display("%p", queue_ar);
    $display("%p", queue_r); 
  `SVTEST_END


  `SVTEST(test_read)
    int addr = 8;
    bit [7:0] data [8];

    driver.read(addr, $size(data), data);

    $display("%p", queue_aw);
    $display("%p", queue_w); 
    $display("%p", queue_b); 
    $display("%p", queue_ar);
    $display("%p", queue_r); 

    $display("%p", data); 
  `SVTEST_END



  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
