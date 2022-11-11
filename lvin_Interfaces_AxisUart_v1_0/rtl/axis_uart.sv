//----------------------------------------------------------------------------



//----------------------------------------------------------------------------
module axis_uart #(
  parameter int ACLK_FREQUENCY = 200000000,
  parameter int BAUD_RATE      = 9600,
  parameter int BAUD_RATESIM   = 50000000
)(
  // Clock and Reset
  input  logic        AClk,
  input  logic        AResetn,
  // Uart Interface
  output logic        Uart_TxD,
  input  logic        Uart_RxD,
  // Axi4-Stream TxByte Interface
  input  logic        TxByte_TValid,
  output logic        TxByte_TReady,
  input  logic [7:0]  TxByte_TData,
  input  logic [0:0]  TxByte_TKeep,
  // Axi4-Stream RxByte Interface
  output logic        RxByte_TValid,
  input  logic        RxByte_TReady,
  output logic [7:0]  RxByte_TData
);


  //--------------------------------------------------------------------------  
  uart_rx i_uart_rx #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE      (BAUD_RATE),
    .BAUD_RATESIM   (BAUD_RATESIM)
  )( 
    .aclk           (aclk),
    .aresetn        (aresetn),
    .uart_rxd       (uart_rxd),
    .rxbyte_tvalid  (rxbyte_tvalid),
    .rxbyte_tready  (rxbyte_tready),
    .rxbyte_tdata   (rxbyte_tdata)
  );


  uart_tx i_uart_tx #(
    .ACLK_FREQUENCY (ACLK_FREQUENCY),
    .BAUD_RATE      (BAUD_RATE),
    .BAUD_RATESIM   (BAUD_RATESIM)
  )( 
    .aclk           (aclk),
    .aresetn        (aresetn),
    .uart_txd       (uart_txd),
    .txbyte_tvalid  (txbyte_tvalid),
    .txbyte_tready  (txbyte_tready),
    .txbyte_tdata   (txbyte_tdata),
    .txbyte_tkeep   (txbyte_tkeep) 
  );


endmodule