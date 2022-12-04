//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
module framing #(
  parameter bit [7:0] ESCAPE_BYTE = 8'h7F,
  parameter bit [7:0] START_BYTE  = 8'h7D,
  parameter bit [7:0] STOP_BYTE   = 8'h7E
)(
  // Clock and Reset
  input  logic        aclk,
  input  logic        aresetn,
  // Axi4-Stream RxByte Interface
  input  logic        rx_byte_tvalid,
  output logic        rx_byte_tready,
  input  logic [7:0]  rx_byte_tdata,
  // Axi4-Stream RxFrame Interface
  output logic        rx_frame_tvalid,
  input  logic        rx_frame_tready,
  output logic [7:0]  rx_frame_tdata,
  output logic        rx_frame_tlast,
  // Axi4-Stream TxByte Interface
  output logic        tx_byte_tvalid,
  input  logic        tx_byte_tready,
  output logic [7:0]  tx_byte_tdata,
  // Axi4-Stream TxFrame Interface
  input  logic        tx_frame_tvalid,
  output logic        tx_frame_tready,
  input  logic [7:0]  tx_frame_tdata,
  input  logic        tx_frame_tlast
);


  //----------------------------------------------------------------------------
  logic       escaped_tvalid, deframed_tvalid;
  logic       escaped_tready, deframed_tready;
  logic [7:0] escaped_tdata , deframed_tdata;
  logic       escaped_tlast , deframed_tlast;


  //----------------------------------------------------------------------------
  deframer #(
    .ESCAPE_BYTE      (ESCAPE_BYTE),
    .START_BYTE       (START_BYTE),
    .STOP_BYTE        (STOP_BYTE)
  ) i_deframer ( 
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (rx_byte_tvalid),
    .target_tready    (rx_byte_tready),
    .target_tdata     (rx_byte_tdata),
    .initiator_tvalid (deframed_tvalid),
    .initiator_tready (deframed_tready),
    .initiator_tdata  (deframed_tdata),
    .initiator_tlast  (deframed_tlast)
  );


  deescaper #(
    .ESCAPE_BYTE      (ESCAPE_BYTE)
  ) i_deescaper (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (deframed_tvalid),
    .target_tready    (deframed_tready),
    .target_tdata     (deframed_tdata),
    .target_tlast     (deframed_tlast),
    .initiator_tvalid (rx_frame_tvalid),
    .initiator_tready (rx_frame_tready),
    .initiator_tdata  (rx_frame_tdata),
    .initiator_tlast  (rx_frame_tlast)
    );


  //----------------------------------------------------------------------------
  escaper #(
    .ESCAPE_BYTE      (ESCAPE_BYTE),
    .START_BYTE       (START_BYTE),
    .STOP_BYTE        (STOP_BYTE)
  ) i_escaper (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (tx_frame_tvalid),
    .target_tready    (tx_frame_tready),
    .target_tdata     (tx_frame_tdata),
    .target_tlast     (tx_frame_tlast),
    .initiator_tvalid (escaped_tvalid),
    .initiator_tready (escaped_tready),
    .initiator_tdata  (escaped_tdata),
    .initiator_tlast  (escaped_tlast)
  );


  framer #(
    .START_BYTE       (START_BYTE),
    .STOP_BYTE        (STOP_BYTE)
  ) i_framer ( 
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (escaped_tvalid),
    .target_tready    (escaped_tready),
    .target_tdata     (escaped_tdata),
    .target_tlast     (escaped_tlast),
    .initiator_tvalid (tx_byte_tvalid),
    .initiator_tready (tx_byte_tready),
    .initiator_tdata  (tx_byte_tdata) 
  );


endmodule