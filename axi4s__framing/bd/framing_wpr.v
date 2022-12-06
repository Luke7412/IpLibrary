//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module framing_wpr #(
  parameter int START_BYTE  = 125,
  parameter int STOP_BYTE   = 126,
  parameter int ESCAPE_BYTE = 127
)(
  input         aclk,
  input         aresetn,
  input         rx_byte_tvalid,
  output        rx_byte_tready,
  input  [7:0]  rx_byte_tdata,
  output        rx_frame_tvalid,
  input         rx_frame_tready,
  output [7:0]  rx_frame_tdata,
  output        rx_frame_tlast,
  output        tx_byte_tvalid,
  input         tx_byte_tready,
  output [7:0]  tx_byte_tdata,
  input         tx_frame_tvalid,
  output        tx_frame_tready,
  input  [7:0]  tx_frame_tdata,
  input         tx_frame_tlast
);


  //----------------------------------------------------------------------------
  framing #(
    .ESCAPE_BYTE (ESCAPE_BYTE),
    .START_BYTE  (START_BYTE),
    .STOP_BYTE   (STOP_BYTE)
  ) i_framing (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .rx_byte_tvalid   (rx_byte_tvalid),
    .rx_byte_tready   (rx_byte_tready),
    .rx_byte_tdata    (rx_byte_tdata),
    .rx_frame_tvalid  (rx_frame_tvalid),
    .rx_frame_tready  (rx_frame_tready),
    .rx_frame_tdata   (rx_frame_tdata),
    .rx_frame_tlast   (rx_frame_tlast),
    .tx_byte_tvalid   (tx_byte_tvalid),
    .tx_byte_tready   (tx_byte_tready),
    .tx_byte_tdata    (tx_byte_tdata),
    .tx_frame_tvalid  (tx_frame_tvalid),
    .tx_frame_tready  (tx_frame_tready),
    .tx_frame_tdata   (tx_frame_tdata),
    .tx_frame_tlast   (tx_frame_tlast)
  );


endmodule