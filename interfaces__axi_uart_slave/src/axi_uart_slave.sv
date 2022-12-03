

module axi_uart_slave #(
  parameter int ACLK_FREQUENCY      = 200000000,
  parameter int BAUD_RATE           = 9600,
  parameter int BAUD_RATE_SIM       = 50000000,
  paramater logic [7:0] ESCAPE_BYTE = 'h7F,
  paramater logic [7:0] START_BYTE  = 'h7D,
  paramater logic [7:0] STOP_BYTE   = 'h7E
)(
  // Clock and Reset
  input  logic        aclk,
  input  logic        aresetn,
  // Uart Interface
  output logic        uart_txd,
  input  logic        uart_rxd,
  // Axi4 Interface
  output logic        m_axi_awvalid,
  input  logic        m_axi_awready,
  output logic [31:0] m_axi_awaddr,
  output logic [7:0]  m_axi_awlen,
  output logic [2:0]  m_axi_awsize,
  output logic [1:0]  m_axi_awburst,
  output logic [0:0]  m_axi_awlock,
  output logic [3:0]  m_axi_awcache,
  output logic [2:0]  m_axi_awprot,
  output logic [3:0]  m_axi_awqos,
  output logic        m_axi_wvalid,
  input  logic        m_axi_wready,
  output logic [31:0] m_axi_wdata,
  output logic [3:0]  m_axi_wstrb,
  output logic        m_axi_wlast,
  input  logic        m_axi_bvalid,
  output logic        m_axi_bready,
  input  logic [1:0]  m_axi_bresp,
  output logic        m_axi_arvalid,
  input  logic        m_axi_arready,
  output logic [31:0] m_axi_araddr,
  output logic [7:0]  m_axi_arlen,
  output logic [2:0]  m_axi_arsize,
  output logic [1:0]  m_axi_arburst,
  output logic [0:0]  m_axi_arlock,
  output logic [3:0]  m_axi_arcache,
  output logic [2:0]  m_axi_arprot,
  output logic [3:0]  m_axi_arqos,
  input  logic        m_axi_rvalid,
  output logic        m_axi_rready,
  input  logic [31:0] m_axi_rdata,
  input  logic [1:0]  m_axi_rresp,
  input  logic        m_axi_rlast   
);


  //----------------------------------------------------------------------------
  logic       rx_byte_tvalid, tx_byte_tvalid;
  logic       rx_byte_tready, tx_byte_tready;
  logic [7:0] rx_byte_tdata , tx_byte_tdata ;
  
  logic       rx_frame_tvalid, tx_frame_tvalid;
  logic       rx_frame_tready, tx_frame_tready;
  logic       rx_frame_tlast , tx_frame_tlast ;
  logic [7:0] rx_frame_tdata , tx_frame_tdata ;
   
  logic       rx_packet_tvalid, tx_packet_tvalid;
  logic       rx_packet_tready, tx_packet_tready;
  logic       rx_packet_tlast , tx_packet_tlast ;
  logic [7:0] rx_packet_tdata , tx_packet_tdata ;
  logic [2:0] rx_packet_tid   , tx_packet_tid   ;
  
  
  //----------------------------------------------------------------------------
  axi4s_uart #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE      (BAUD_RATE),
    .BAUD_RATE_SIM  (BAUD_RATE_SIM),
  ) i_axi4s_uart (
    // Clock and Reset
    .aclk           (aclk),
    .aresetn        (aresetn),
    // UART Iterface
    .uart_txd       (uart_txd),
    .uart_rxd       (uart_rxd),
    // Axi4-Stream TxByte Interface
    .tx_byte_tvalid (tx_byte_tvalid),
    .tx_byte_tready (tx_byte_tready),
    .tx_byte_tdata  (tx_byte_tdata),
    // Axi4-Stream RxByte Interface
    .rx_byte_tvalid (rx_byte_tvalid),
    .rx_byte_tready (rx_byte_tready),
    .rx_byte_tdata  (rx_byte_tdata)
  );


  framing #(
    .ESCAPE_BYTE (ESCAPE_BYTE),
    .START_BYTE  (START_BYTE),
    .STOP_BYTE   (STOP_BYTE)
  ) i_framing (
    // Clock and Reset
    .aclk             (aclk),
    .aresetn          (aresetn),
    // Axi4-Stream RxByte Interface
    .rx_byte_tvalid   (rx_byte_tvalid),
    .rx_byte_tready   (rx_byte_tready),
    .rx_byte_tdata    (rx_byte_tdata)
    // Axi4-Stream RxFrame Interface
    .rx_frame_tvalid  (rx_frame_tvalid),
    .rx_frame_tready  (rx_frame_tready),
    .rx_frame_tdata   (rx_frame_tdata),
    .rx_frame_tlast   (rx_frame_tlast),
    // Axi4-Stream TxByte Interface
    .tx_byte_tvalid   (tx_byte_tvalid),
    .tx_byte_tready   (tx_byte_tready),
    .tx_byte_tdata    (tx_byte_tdata),
    // Axi4-Stream TxFrame Interface
    .tx_frame_tvalid  (tx_frame_tvalid),
    .tx_frame_tready  (tx_frame_tready),
    .tx_frame_tdata   (tx_frame_tdata),
    .tx_frame_tlast   (tx_frame_tlast),
  );


  destpacketizer i_destpacketizer (
    // Clock and reset
    .aclk             (aclk),
    .aresetn          (aresetn),
    // Axi4-Stream RxFrame interface
    .rx_frame_tvalid  (rx_frame_tvalid),
    .rx_frame_tready  (rx_frame_tready),
    .rx_frame_tdata   (rx_frame_tdata),
    .rx_frame_tlast   (rx_frame_tlast),
    // Axi4-Stream TxFrame interface
    .tx_frame_tvalid  (tx_frame_tvalid),
    .tx_frame_tready  (tx_frame_tready),
    .tx_frame_tdata   (tx_frame_tdata),
    .tx_frame_tlast   (tx_frame_tlast),
    // Axi4-Stream RxPacket interface
    .rx_packet_tvalid (rx_packet_tvalid),
    .rx_packet_tready (rx_packet_tready),
    .rx_packet_tlast  (rx_packet_tlast),
    .rx_packet_tdata  (rx_packet_tdata),
    .rx_packet_tid    (rx_packet_tid),
    // Axi4-Stream TxPacket interface
    .tx_packet_tvalid (tx_packet_tvalid),
    .tx_packet_tready (tx_packet_tready),
    .tx_packet_tlast  (tx_packet_tlast),
    .tx_packet_tdata  (tx_packet_tdata),
    .tx_packet_tid    (tx_packet_tid)
    );


  axi4s_to_mem_mapped i_axi4s_to_mem_mapped (
    // Clock and Reset
    .aclk             (aclk),
    .aresetn          (aresetn),
    // Axi4-Stream RxPacket interface
    .rx_packet_tvalid (rx_packet_tvalid),
    .rx_packet_tready (rx_packet_tready),
    .rx_packet_tlast  (rx_packet_tlast),
    .rx_packet_tdata  (rx_packet_tdata),
    .rx_packet_tid    (rx_packet_tid),
    // Axi4-Stream TxPacket interface
    .tx_packet_tvalid (tx_packet_tvalid),
    .tx_packet_tready (tx_packet_tready),
    .tx_packet_tlast  (tx_packet_tlast),
    .tx_packet_tdata  (tx_packet_tdata),
    .tx_packet_tid    (tx_packet_tid),
    // Axi4 Interface
    .m_axi_awvalid    (m_axi_awvalid),
    .m_axi_awready    (m_axi_awready),
    .m_axi_awaddr     (m_axi_awaddr),
    .m_axi_awlen      (m_axi_awlen),
    .m_axi_awsize     (m_axi_awsize),
    .m_axi_awburst    (m_axi_awburst),
    .m_axi_awlock     (m_axi_awlock),
    .m_axi_awcache    (m_axi_awcache),
    .m_axi_awprot     (m_axi_awprot),
    .m_axi_awqos      (m_axi_awqos),
    .m_axi_wvalid     (m_axi_wvalid),
    .m_axi_wready     (m_axi_wready),
    .m_axi_wdata      (m_axi_wdata),
    .m_axi_wstrb      (m_axi_wstrb),
    .m_axi_wlast      (m_axi_wlast),
    .m_axi_bvalid     (m_axi_bvalid),
    .m_axi_bready     (m_axi_bready),
    .m_axi_bresp      (m_axi_bresp),
    .m_axi_arvalid    (m_axi_arvalid),
    .m_axi_arready    (m_axi_arready),
    .m_axi_araddr     (m_axi_araddr),
    .m_axi_arlen      (m_axi_arlen),
    .m_axi_arsize     (m_axi_arsize),
    .m_axi_arburst    (m_axi_arburst),
    .m_axi_arlock     (m_axi_arlock),
    .m_axi_arcache    (m_axi_arcache),
    .m_axi_arprot     (m_axi_arprot),
    .m_axi_arqos      (m_axi_arqos),
    .m_axi_rvalid     (m_axi_rvalid),
    .m_axi_rready     (m_axi_rready),
    .m_axi_rdata      (m_axi_rdata),
    .m_axi_rresp      (m_axi_rresp),
    .m_axi_rlast      (m_axi_rlast)
  );


endmodule;
