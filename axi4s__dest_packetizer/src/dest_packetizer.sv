
module dest_packetizer (
  // Clock and reset
  input  logic       aclk,
  input  logic       aresetn,
  // Axi4-Stream RxFrame interface
  input  logic       rx_frame_tvalid,
  output logic       rx_frame_tready,
  input  logic       rx_frame_tlast,
  input  logic [7:0] rx_frame_tdata,
  // Axi4-Stream TxFrame interface
  output logic       tx_frame_tvalid,
  input  logic       tx_frame_tready,
  output logic       tx_frame_tlast,
  output logic [7:0] tx_frame_tdata,
  // Axi4-Stream RxPacket interface
  output logic       rx_packet_tvalid,
  input  logic       rx_packet_tready,
  output logic       rx_packet_tlast,
  output logic [7:0] rx_packet_tdata,
  output logic [2:0] rx_packet_tid,
  // Axi4-Stream TxPacket interface
  input  logic       tx_packet_tvalid,
  output logic       tx_packet_tready,
  input  logic       tx_packet_tlast,
  input  logic [7:0] tx_packet_tdata,
  input  logic [2:0] tx_packet_tid
);


  //----------------------------------------------------------------------------
  dest_extract i_dest_extract (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (rx_frame_tvalid),
    .target_tready    (rx_frame_tready),
    .target_tlast     (rx_frame_tlast),
    .target_tdata     (rx_frame_tdata),
    .initiator_tvalid (rx_packet_tvalid),
    .initiator_tready (rx_packet_tready),
    .initiator_tlast  (rx_packet_tlast),
    .initiator_tdata  (rx_packet_tdata),
    .initiator_tid    (rx_packet_tid)
  );

  dest_insert i_dest_insert (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (tx_packet_tvalid),
    .target_tready    (tx_packet_tready),
    .target_tlast     (tx_packet_tlast),
    .target_tdata     (tx_packet_tdata),
    .target_tid       (tx_packet_tid),
    .initiator_tvalid (tx_frame_tvalid),
    .initiator_tready (tx_frame_tready),
    .initiator_tlast  (tx_frame_tlast),
    .initiator_tdata  (tx_frame_tdata)
  );

endmodule
