

module dest_packetizer_wpr (
  input        aclk,
  input        aresetn,
  input        rx_frame_tvalid,
  output       rx_frame_tready,
  input        rx_frame_tlast,
  input  [7:0] rx_frame_tdata,
  output       tx_frame_tvalid,
  input        tx_frame_tready,
  output       tx_frame_tlast,
  output [7:0] tx_frame_tdata,
  output       rx_packet_tvalid,
  input        rx_packet_tready,
  output       rx_packet_tlast,
  output [7:0] rx_packet_tdata,
  output [2:0] rx_packet_tid,
  input        tx_packet_tvalid,
  output       tx_packet_tready,
  input        tx_packet_tlast,
  input  [7:0] tx_packet_tdata,
  input  [2:0] tx_packet_tid
);


  //----------------------------------------------------------------------------
  dest_packetizer i_dest_packetizer (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .rx_frame_tvalid  (rx_frame_tvalid),
    .rx_frame_tready  (rx_frame_tready),
    .rx_frame_tlast   (rx_frame_tlast),
    .rx_frame_tdata   (rx_frame_tdata),
    .tx_frame_tvalid  (tx_frame_tvalid),
    .tx_frame_tready  (tx_frame_tready),
    .tx_frame_tlast   (tx_frame_tlast),
    .tx_frame_tdata   (tx_frame_tdata),
    .rx_packet_tvalid (rx_packet_tvalid),
    .rx_packet_tready (rx_packet_tready),
    .rx_packet_tlast  (rx_packet_tlast),
    .rx_packet_tdata  (rx_packet_tdata),
    .rx_packet_tid    (rx_packet_tid),
    .tx_packet_tvalid (tx_packet_tvalid),
    .tx_packet_tready (tx_packet_tready),
    .tx_packet_tlast  (tx_packet_tlast),
    .tx_packet_tdata  (tx_packet_tdata),
    .tx_packet_tid    (tx_packet_tid)
  );

endmodule
