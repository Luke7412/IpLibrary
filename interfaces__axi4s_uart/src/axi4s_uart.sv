

module axi4s_uart #(
  parameter int ACLK_FREQUENCY = 200000000,
  parameter int BAUD_RATE      = 9600,
  parameter int BAUD_RATE_SIM  = 50000000
)(
  // Clock and Reset
  input  logic        aclk,
  input  logic        aresetn,
  // Uart Interface
  output logic        uart_txd,
  input  logic        uart_rxd,
  // Axi4-Stream TxByte Interface
  input  logic        tx_byte_tvalid,
  output logic        tx_byte_tready,
  input  logic [7:0]  tx_byte_tdata,
  input  logic [0:0]  tx_byte_tkeep,
  // Axi4-Stream RxByte Interface
  output logic        rx_byte_tvalid,
  input  logic        rx_byte_tready,
  output logic [7:0]  rx_byte_tdata
);


  //--------------------------------------------------------------------------  
  axi4s_uart_rx #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE      (BAUD_RATE),
    .BAUD_RATE_SIM  (BAUD_RATE_SIM)
  ) i_axi4s_uart_rx ( 
    .aclk           (aclk),
    .aresetn        (aresetn),
    .uart_rxd       (uart_rxd),
    .rx_byte_tvalid (rx_byte_tvalid),
    .rx_byte_tready (rx_byte_tready),
    .rx_byte_tdata  (rx_byte_tdata)
  );


  axi4s_uart_tx #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE      (BAUD_RATE),
    .BAUD_RATE_SIM  (BAUD_RATE_SIM)
  ) i_axi4s_uart_tx ( 
    .aclk           (aclk),
    .aresetn        (aresetn),
    .uart_txd       (uart_txd),
    .tx_byte_tvalid (tx_byte_tvalid),
    .tx_byte_tready (tx_byte_tready),
    .tx_byte_tdata  (tx_byte_tdata),
    .tx_byte_tkeep  (tx_byte_tkeep) 
  );


endmodule