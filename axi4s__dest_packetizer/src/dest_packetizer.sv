
module dest_packetizer (
  // Clock and reset
  input  logic       aclk,
  input  logic       aresetn,
  // Axi4-Stream RxFrame interface
  input  logic       rxframe_tvalid,
  output logic       rxframe_tready,
  input  logic       rxframe_tlast,
  input  logic [7:0] rxframe_tdata,
  // Axi4-Stream TxFrame interface
  output logic       txframe_tvalid,
  input  logic       txframe_tready,
  output logic       txframe_tlast,
  output logic [7:0] txframe_tdata,
  // Axi4-Stream RxPacket interface
  output logic       rxpacket_tvalid,
  input  logic       rxpacket_tready,
  output logic       rxpacket_tlast,
  output logic [7:0] rxpacket_tdata,
  output logic [2:0] rxpacket_tid,
  // Axi4-Stream TxPacket interface
  input  logic       txpacket_tvalid,
  output logic       txpacket_tready,
  input  logic       txpacket_tlast,
  input  logic [7:0] txpacket_tdata,
  input  logic [2:0] txpacket_tid
);


  //----------------------------------------------------------------------------
  dest_extract i_dest_extract (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (rxframe_tvalid),
    .target_tready    (rxframe_tready),
    .target_tlast     (rxframe_tlast),
    .target_tdata     (rxframe_tdata),
    .initiator_tvalid (rxpacket_tvalid),
    .initiator_tready (rxpacket_tready),
    .initiator_tlast  (rxpacket_tlast),
    .initiator_tdata  (rxpacket_tdata),
    .initiator_tid    (rxpacket_tid)
  );

  dest_insert i_dest_insert (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (txpacket_tvalid),
    .target_tready    (txpacket_tready),
    .target_tlast     (txpacket_tlast),
    .target_tdata     (txpacket_tdata),
    .target_tid       (txpacket_tid),
    .initiator_tvalid (txframe_tvalid),
    .initiator_tready (txframe_tready),
    .initiator_tlast  (txframe_tlast),
    .initiator_tdata  (txframe_tdata)
  );

endmodule
