module data_fifo #(
  parameter int TDATA_BYTES = 8,
  parameter int TKEEP_WIDTH = TDATA_BYTES
)(
  input  logic                      aclk,
  input  logic                      aresetn,

  input  logic                      target_tvalid,
  output logic                      target_tready,
  input  logic [8*TDATA_BYTES-1:0]  target_tdata,
  input  logic [TKEEP_WIDTH-1:0]    target_tkeep,
  input  logic                      target_tlast,

  output logic                      initiator_tvalid,
  input  logic                      initiator_tready,
  output logic [8*TDATA_BYTES-1:0]  initiator_tdata,
  output logic [TKEEP_WIDTH-1:0]    initiator_tkeep,
  output logic                      initiator_tlast
);




endmodule
