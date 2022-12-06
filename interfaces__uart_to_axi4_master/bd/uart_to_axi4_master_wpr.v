//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module uart_to_axi4_master_wpr #(
  parameter int ACLK_FREQUENCY = 200000000,
  parameter int BAUD_RATE      = 9600,
  parameter int BAUD_RATE_SIM  = 50000000,
  parameter int START_BYTE     = 125,
  parameter int STOP_BYTE      = 126,
  parameter int ESCAPE_BYTE    = 127
)(
  input         aclk,
  input         aresetn,
  output        uart_txd,
  input         uart_rxd,
  output        m_axi_awvalid,
  input         m_axi_awready,
  output [31:0] m_axi_awaddr,
  output [7:0]  m_axi_awlen,
  output [2:0]  m_axi_awsize,
  output [1:0]  m_axi_awburst,
  output [0:0]  m_axi_awlock,
  output [3:0]  m_axi_awcache,
  output [2:0]  m_axi_awprot,
  output [3:0]  m_axi_awqos,
  output        m_axi_wvalid,
  input         m_axi_wready,
  output [31:0] m_axi_wdata,
  output [3:0]  m_axi_wstrb,
  output        m_axi_wlast,
  input         m_axi_bvalid,
  output        m_axi_bready,
  input  [1:0]  m_axi_bresp,
  output        m_axi_arvalid,
  input         m_axi_arready,
  output [31:0] m_axi_araddr,
  output [7:0]  m_axi_arlen,
  output [2:0]  m_axi_arsize,
  output [1:0]  m_axi_arburst,
  output [0:0]  m_axi_arlock,
  output [3:0]  m_axi_arcache,
  output [2:0]  m_axi_arprot,
  output [3:0]  m_axi_arqos,
  input         m_axi_rvalid,
  output        m_axi_rready,
  input  [31:0] m_axi_rdata,
  input  [1:0]  m_axi_rresp,
  input         m_axi_rlast   
);


  //----------------------------------------------------------------------------
  uart_to_axi4_master #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE      (BAUD_RATE),
    .BAUD_RATE_SIM  (BAUD_RATE_SIM),
    .START_BYTE     (START_BYTE),
    .STOP_BYTE      (STOP_BYTE),
    .ESCAPE_BYTE    (ESCAPE_BYTE)
  ) i_uart_to_axi4_master (
    .aclk           (aclk),
    .aresetn        (aresetn),
    .uart_txd       (uart_txd),
    .uart_rxd       (uart_rxd),
    .m_axi_awvalid  (m_axi_awvalid),
    .m_axi_awready  (m_axi_awready),
    .m_axi_awaddr   (m_axi_awaddr),
    .m_axi_awlen    (m_axi_awlen),
    .m_axi_awsize   (m_axi_awsize),
    .m_axi_awburst  (m_axi_awburst),
    .m_axi_awlock   (m_axi_awlock),
    .m_axi_awcache  (m_axi_awcache),
    .m_axi_awprot   (m_axi_awprot),
    .m_axi_awqos    (m_axi_awqos),
    .m_axi_wvalid   (m_axi_wvalid),
    .m_axi_wready   (m_axi_wready),
    .m_axi_wdata    (m_axi_wdata),
    .m_axi_wstrb    (m_axi_wstrb),
    .m_axi_wlast    (m_axi_wlast),
    .m_axi_bvalid   (m_axi_bvalid),
    .m_axi_bready   (m_axi_bready),
    .m_axi_bresp    (m_axi_bresp),
    .m_axi_arvalid  (m_axi_arvalid),
    .m_axi_arready  (m_axi_arready),
    .m_axi_araddr   (m_axi_araddr),
    .m_axi_arlen    (m_axi_arlen),
    .m_axi_arsize   (m_axi_arsize),
    .m_axi_arburst  (m_axi_arburst),
    .m_axi_arlock   (m_axi_arlock),
    .m_axi_arcache  (m_axi_arcache),
    .m_axi_arprot   (m_axi_arprot),
    .m_axi_arqos    (m_axi_arqos),
    .m_axi_rvalid   (m_axi_rvalid),
    .m_axi_rready   (m_axi_rready),
    .m_axi_rdata    (m_axi_rdata),
    .m_axi_rresp    (m_axi_rresp),
    .m_axi_rlast    (m_axi_rlast)   
  );

endmodule
