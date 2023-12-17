

module axi4s_uart_wpr #(
  parameter ACLK_FREQUENCY = 200000000,
  parameter BAUD_RATE      = 9600,
  parameter BAUD_RATE_SIM  = 50000000
)(
  input         aclk,
  input         aresetn,
  output        uart_txd,
  input         uart_rxd,
  input         tx_byte_tvalid,
  output        tx_byte_tready,
  input  [7:0]  tx_byte_tdata,
  input  [0:0]  tx_byte_tkeep,
  output        rx_byte_tvalid,
  input         rx_byte_tready,
  output [7:0]  rx_byte_tdata
);


  //----------------------------------------------------------------------------  
  axi4s_uart  #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE      (BAUD_RATE),
    .BAUD_RATE_SIM  (BAUD_RATE_SIM)
  ) i_axi4s_uart_wpr (
    .aclk           (aclk),
    .aresetn        (aresetn),
    .uart_txd       (uart_txd),
    .uart_rxd       (uart_rxd),
    .tx_byte_tvalid (tx_byte_tvalid),
    .tx_byte_tready (tx_byte_tready),
    .tx_byte_tdata  (tx_byte_tdata),
    .tx_byte_tkeep  (tx_byte_tkeep),
    .rx_byte_tvalid (rx_byte_tvalid),
    .rx_byte_tready (rx_byte_tready),
    .rx_byte_tdata  (rx_byte_tdata)
  );


endmodule