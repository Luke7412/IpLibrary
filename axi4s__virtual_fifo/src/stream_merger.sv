module stream_merger #(
  parameter int TDATA_BYTES = 8,
  parameter int TKEEP_WIDTH = TDATA_BYTES,
  parameter int TID_WIDTH   = 4,
  parameter int TDEST_WIDTH = 1
)( 
  input  logic                      aclk,
  input  logic                      aresetn,
  input  logic                      target_tvalid,
  output logic                      target_tready,
  input  logic [8*TDATA_BYTES-1:0]  target_tdata,
  output logic                      initiator_tvalid,
  input  logic                      initiator_tready,
  output logic [8*TDATA_BYTES-1:0]  initiator_tdata,
  output logic [TKEEP_WIDTH-1:0]    initiator_tkeep,
  output logic [TID_WIDTH-1:0]      initiator_tid,
  output logic [TDEST_WIDTH-1:0]    initiator_tdest,
  output logic                      initiator_tlast
);


  //---------------------------------------------------------------------------- 
  localparam int  NOF_HEADER_BYTES = 4;

  logic [$size(target_tdata)-8*NOF_HEADER_BYTES-1:0] buff_data;
  logic buff_valid;

  logic  is_first;
  logic [15:0] nof_bytes;


  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      is_first <= '1;
      target_tready <= '0;

    end else begin 
      target_tready <= '1;
      
      if (target_tvalid && target_tready) begin
        buff_valid <= '1;
        buff_data  <= target_tdata[$high(target_tdata) : 8*NOF_HEADER_BYTES];
        if (is_first) begin
          initiator_tid   <= target_tdata[3:0]; 
          initiator_tdest <= target_tdata[11:8];
          nof_bytes       <= target_tdata[31:16];
        end
      end
    end
  end

endmodule
