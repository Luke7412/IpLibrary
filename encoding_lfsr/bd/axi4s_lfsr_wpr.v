

module axi4s_lfsr_wpr #(
  parameter int                   POLY_DEGREE    = 7,                  
  parameter bit [POLY_DEGREE-1:0] POLYNOMIAL     = 7'b1100000,
  parameter bit [POLY_DEGREE-1:0] SEED           = 1,
  parameter int                   TDATA_WIDTH    = 8,
  parameter string                IMPLEMENTATION = "galois",  // can be "galois" or "fibonacci"
  parameter bit                   CHK_NOT_GEN    = 0          // 0: generator, 1: checker
)(
  input  aclk,
  input  aresetn,

  input                     target_tvalid,
  output                    target_tready,
  input  [TDATA_WIDTH-1:0]  target_tdata,
  input                     target_tlast,

  output                    initiator_tvalid,
  input                     initiator_tready,
  output [TDATA_WIDTH-1:0]  initiator_tdata,
  output                    initiator_tlast
);


  axi4s_lfsr #(
    .POLY_DEGREE    (POLY_DEGREE),
    .POLYNOMIAL     (POLYNOMIAL),
    .SEED           (SEED),
    .TDATA_WIDTH    (TDATA_WIDTH),
    .IMPLEMENTATION (IMPLEMENTATION),
    .CHK_NOT_GEN    (CHK_NOT_GEN)
  ) i_axi4s_lfsr (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (target_tvalid),
    .target_tready    (target_tready),
    .target_tdata     (target_tdata),
    .target_tlast     (target_tlast),
    .initiator_tvalid (initiator_tvalid),
    .initiator_tready (initiator_tready),
    .initiator_tdata  (initiator_tdata),
    .initiator_tlast  (initiator_tlast)
  );

endmodule