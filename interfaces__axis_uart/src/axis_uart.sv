//----------------------------------------------------------------------------



//----------------------------------------------------------------------------
module axis_uart #(
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
  input  logic        txbyte_tvalid,
  output logic        txbyte_tready,
  input  logic [7:0]  txbyte_tdata,
  input  logic [0:0]  txbyte_tkeep,
  // Axi4-Stream RxByte Interface
  output logic        rxbyte_tvalid,
  input  logic        rxbyte_tready,
  output logic [7:0]  rxbyte_tdata
);


  //--------------------------------------------------------------------------  
  axis_uart_rx #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE      (BAUD_RATE),
    .BAUD_RATE_SIM  (BAUD_RATE_SIM)
  ) i_axis_uart_rx ( 
    .aclk           (aclk),
    .aresetn        (aresetn),
    .uart_rxd       (uart_rxd),
    .rxbyte_tvalid  (rxbyte_tvalid),
    .rxbyte_tready  (rxbyte_tready),
    .rxbyte_tdata   (rxbyte_tdata)
  );


  axis_uart_tx #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE      (BAUD_RATE),
    .BAUD_RATE_SIM  (BAUD_RATE_SIM)
  ) i_axis_uart_tx ( 
    .aclk           (aclk),
    .aresetn        (aresetn),
    .uart_txd       (uart_txd),
    .txbyte_tvalid  (txbyte_tvalid),
    .txbyte_tready  (txbyte_tready),
    .txbyte_tdata   (txbyte_tdata),
    .txbyte_tkeep   (txbyte_tkeep) 
  );


endmodule