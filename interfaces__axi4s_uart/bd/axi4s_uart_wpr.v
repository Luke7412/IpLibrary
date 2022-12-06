//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module axi4s_uart_wpr #(
  parameter int ACLK_FREQUENCY = 200000000,
  parameter int BAUD_RATE      = 9600,
  parameter int BAUD_RATE_SIM  = 50000000
)(
  // Clock and Reset
  input         aclk,
  input         aresetn,
  // Uart Interface
  output        uart_txd,
  input         uart_rxd,
  // Axi4-Stream TxByte Interface
  input         tx_byte_tvalid,
  output        tx_byte_tready,
  input  [7:0]  tx_byte_tdata,
  input  [0:0]  tx_byte_tkeep,
  // Axi4-Stream RxByte Interface
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
    // Clock and Reset
    .aclk           (aclk),
    .aresetn        (aresetn),
    // Uart Interface
    .uart_txd       (uart_txd),
    .uart_rxd       (uart_rxd),
    // Axi4-Stream TxByte Interface
    .tx_byte_tvalid (tx_byte_tvalid),
    .tx_byte_tready (tx_byte_tready),
    .tx_byte_tdata  (tx_byte_tdata),
    .tx_byte_tkeep  (tx_byte_tkeep),
    // Axi4-Stream RxByte Interface
    .rx_byte_tvalid (rx_byte_tvalid),
    .rx_byte_tready (rx_byte_tready),
    .rx_byte_tdata  (rx_byte_tdata)
  );


endmodule