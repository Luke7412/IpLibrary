
module header_insert #(
  parameter int TDATA_BYTES = 8,
  parameter int TKEEP_WIDTH = TDATA_BYTES,
  parameter int TID_WIDTH   = 4,
  parameter int TDEST_WIDTH = 0
)(
  // Clock and Reset
  input logic aclk,
  input logic aresetn,
  // AXI4-Stream target interface
  input  logic                      target_tvalid,
  output logic                      target_tready,
  input  logic [8*TDATA_BYTES-1:0]  target_tdata,
  input  logic [TKEEP_WIDTH-1:0]    target_tkeep,
  input  logic                      target_tlast,
  // AXI4-Stream initiator interface
  output logic                      initiator_tvalid,
  input  logic                      initiator_tready,
  output logic [8*TDATA_BYTES-1:0]  initiator_tdata,
  output logic [7:0]                initiator_tuser,
  output logic [TKEEP_WIDTH-1:0]    initiator_tkeep,
  output logic                      initiator_tlast,
  // AXI4-Stream meta interface
  input  logic                      meta_tvalid,
  output logic                      meta_tready,
  input  logic [15:0]               meta_tdata,
  input  logic [TID_WIDTH-1:0]      meta_tid,
  input  logic [TDEST_WIDTH-1:0]    meta_tdest
);


  //----------------------------------------------------------------------------
  localparam int BeatCntShift = $clog2(TDATA_BYTES);

  enum logic {FIRST, DATA} state;


  //----------------------------------------------------------------------------
  assign target_tready = initiator_tready && state == DATA;


  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      initiator_tvalid <= '0;
      meta_tready      <= '1;
    
    end else begin

      if (meta_tvalid && meta_tready) begin
        meta_tready <= '0;
      end

      if (initiator_tvalid && initiator_tready) begin
        initiator_tvalid <= '0;
      end

      case (state) 
        FIRST : begin
          if ((meta_tvalid && meta_tready) && (!initiator_tvalid || initiator_tready)) begin
            initiator_tvalid       <= '1;
            initiator_tdata[31:16] <= meta_tdata;
            initiator_tdata[15:0]  <= '0;
            // initiator_tid          <= meta_tid;
            // initiator_tdest        <= meta_tdest;
            initiator_tuser        <= meta_tdata[7:0];
            initiator_tkeep        <= '1;
            initiator_tlast        <= '0;
            state                  <= DATA;
          end
        end

        DATA : begin
          if (target_tvalid && target_tready) begin
            initiator_tvalid <= '1;
            initiator_tdata  <= target_tdata;
            initiator_tkeep  <= target_tkeep;
            initiator_tlast  <= target_tlast;

            if (target_tlast) begin
              meta_tready <= '1;
              state <= FIRST;
            end
          end
        end

      endcase

    end
  end


endmodule
