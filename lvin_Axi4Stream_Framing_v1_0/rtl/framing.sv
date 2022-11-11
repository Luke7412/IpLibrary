//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
module framing #(
  localparam logic [7:0] ESCAPE_BYTE = 8'h7F,
  localparam logic [7:0] START_BYTE  = 8'h7D,
  localparam logic [7:0] STOP_BYTE   = 8'h7E
)(
  // Clock and Reset
  input  logic        aclk,
  input  logic        aresetn,
  // Axi4-Stream RxByte Interface
  input  logic        rxbyte_tvalid,
  output logic        rxbyte_tready,
  input  logic [7:0]  rxbyte_tdata,
  // Axi4-Stream RxFrame Interface
  output logic        rxframe_tvalid,
  input  logic        rxframe_tready,
  output logic [7:0]  rxframe_tdata,
  output logic        rxframe_tlast,
  // Axi4-Stream TxByte Interface
  output logic        txbyte_tvalid,
  input  logic        txbyte_tready,
  output logic [7:0]  txbyte_tdata,
  // Axi4-Stream TxFrame Interface
  input  logic        txframe_tvalid,
  output logic        txframe_tready,
  input  logic [7:0]  txframe_tdata,
  input  logic        txframe_tlast
);


  //----------------------------------------------------------------------------
  logic       escaped_tvalid;
  logic       escaped_tready;
  logic [7:0] escaped_tdata;
  logic       escaped_tlast;
  logic 
  logic       deframed_tvalid;
  logic       deframed_tready;
  logic [7:0] deframed_tdata;
  logic       deframed_tlast;


  //----------------------------------------------------------------------------
  deframer i_deframer #(
    .ESCAPE_BYTE      (ESCAPE_BYTE),
    .START_BYTE       (START_BYTE ),
    .STOP_BYTE        (STOP_BYTE  )
  )( 
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (rxbyte_tvalid),
    .target_tready    (rxbyte_tready),
    .target_tdata     (rxbyte_tdata),
    .initiator_tvalid (deframed_tvalid),
    .initiator_tready (deframed_tready),
    .initiator_tdata  (deframed_tdata),
    .initiator_tlast  (deframed_tlast)
  );


  deescaper i_deescaper #(
    .ESCAPE_BYTE      (ESCAPE_BYTE)
  )(
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (deframed_tvalid),
    .target_tready    (deframed_tready),
    .target_tdata     (deframed_tdata),
    .target_tlast     (deframed_tlast),
    .initiator_tvalid (rxframe_tvalid),
    .initiator_tready (rxframe_tready),
    .initiator_tdata  (rxframe_tdata),
    .initiator_tlast  (rxframe_tlast)
    );


  //----------------------------------------------------------------------------
  escaper i_escaper #(
    .ESCAPE_BYTE      (ESCAPE_BYTE),
    .START_BYTE       (START_BYTE ),
    .STOP_BYTE        (STOP_BYTE  )
  )(
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (txframe_tvalid),
    .target_tready    (txframe_tready),
    .target_tdata     (txframe_tdata),
    .target_tlast     (txframe_tlast),
    .initiator_tvalid (escaped_tvalid),
    .initiator_tready (escaped_tready),
    .initiator_tdata  (escaped_tdata),
    .initiator_tlast  (escaped_tlast)
  );


  framer i_framer #(
    .START_BYTE       (START_BYTE ),
    .STOP_BYTE        (STOP_BYTE  )
  )( 
    .aclk             (aclk,
    .aresetn          (aresetn,
    .target_tvalid    (escaped_tvalid,
    .target_tready    (escaped_tready,
    .target_tdata     (escaped_tdata,
    .target_tlast     (escaped_tlast,
    .initiator_tvalid (txbyte_tvalid,
    .initiator_tready (txbyte_tready,
    .initiator_tdata  (txbyte_tdata 
    );


endmodule