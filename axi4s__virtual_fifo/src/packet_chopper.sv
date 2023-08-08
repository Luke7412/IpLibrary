module packet_chopper #(
  parameter int TDATA_BYTES   = 8,
  parameter int TKEEP_WIDTH   = TDATA_BYTES,
  parameter int TID_WIDTH     = 4,
  parameter int TDEST_WIDTH   = 1,
  parameter int MAX_BURST_LEN = 256
)(
  // Clock and Reset
  input  logic aclk,
  input  logic aresetn,
  // AXI4-Stream target interface
  input  logic                      target_tvalid,
  output logic                      target_tready,
  input  logic [8*TDATA_BYTES-1:0]  target_tdata,
  input  logic [TKEEP_WIDTH-1:0]    target_tkeep,
  input  logic [TID_WIDTH-1:0]      target_tid,
  input  logic [TDEST_WIDTH-1:0]    target_tdest,
  input  logic                      target_tlast,
  // AXI4-Stream initiator interface
  output logic                      initiator_tvalid,
  input  logic                      initiator_tready,
  output logic [8*TDATA_BYTES-1:0]  initiator_tdata,
  output logic [TKEEP_WIDTH-1:0]    initiator_tkeep,
  output logic                      initiator_tlast,
  // AXI4-Stream meta interface
  output logic                      meta_tvalid,
  input  logic                      meta_tready,
  output logic [15:0]               meta_tdata,
  output logic [TID_WIDTH-1:0]      meta_tid,
  output logic [TDEST_WIDTH-1:0]    meta_tdest
);


  //----------------------------------------------------------------------------
  logic [7:0] beat_cnt;


  //----------------------------------------------------------------------------
  assign target_tready = (!initiator_tvalid || initiator_tready) && 
    !(meta_tvalid && !meta_tready && target_tlast);


  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      initiator_tvalid <= '0;
      meta_tvalid      <= '0;
      beat_cnt         <= '0;

    end else begin
      
      if (meta_tvalid && meta_tready) begin
        meta_tvalid <= '0;
      end

      if (initiator_tvalid && initiator_tready) begin
        initiator_tvalid <= '0;
      end

      if (target_tvalid && target_tready) begin
        initiator_tvalid <= '1;
        initiator_tdata  <= target_tdata; 
        initiator_tkeep  <= target_tkeep; 
        initiator_tlast  <= target_tlast;
        beat_cnt         <= beat_cnt + 1;

        if (beat_cnt == MAX_BURST_LEN-1 || target_tlast) begin
          initiator_tlast  <= '1;
          beat_cnt         <= '0;
          meta_tvalid      <= '1;
          meta_tdata[7:0]  <= beat_cnt;
          meta_tdata[15:8] <= $countones(target_tkeep);
          meta_tid         <= target_tid;
          meta_tdest       <= target_tdest;
        end
        
      end
    end
  end

endmodule