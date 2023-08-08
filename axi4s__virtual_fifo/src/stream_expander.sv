module stream_expander #(
  parameter int TDATA_BYTES = 8,
  parameter int TKEEP_WIDTH = TDATA_BYTES,
  parameter int TID_WIDTH   = 4,
  parameter int TDEST_WIDTH = 1
)( 
  input  logic aclk,
  input  logic aresetn,
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
  localparam int BYTE_CNT_SIZE = $clog2(TDATA_BYTES);

  function logic [TKEEP_WIDTH-1:0] set_keep(logic [BYTE_CNT_SIZE-1:0] nr);
    logic [TKEEP_WIDTH-1:0] keep;
    int cnt;

    keep = '0;
    cnt = nr;
    for (int i=0; i<$size(keep); i++) begin
      keep[i] = '1;
      if (cnt == 0)
        return keep;
      else
        cnt--;
    end
    return keep;
  endfunction;


  logic [BYTE_CNT_SIZE-1:0] tkeep_cnt;
  logic [7:0]               beat_cnt;

  enum logic [0:0] {FIRST, DATA} state;


  //----------------------------------------------------------------------------
  assign target_tready = initiator_tready || !initiator_tvalid;


  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      initiator_tvalid <= '0;
      state            <= FIRST;

    end else begin
      if (initiator_tvalid && initiator_tready) begin
        initiator_tvalid <= '0;
        initiator_tlast  <= '0;
      end

      if (target_tvalid && target_tready) begin
        initiator_tdata <= target_tdata;
        
        case (state) 
          FIRST : begin
            initiator_tid   <= target_tdata[TID_WIDTH-1 :0]; 
            initiator_tdest <= target_tdata[TDEST_WIDTH+8-1:8];
            beat_cnt        <= target_tdata[23:16];
            tkeep_cnt       <= target_tdata[$size(tkeep_cnt)+24-1:24];
            state           <= DATA;
          end

          DATA : begin
            initiator_tvalid <= '1;
            beat_cnt <= beat_cnt - 1;
            if (beat_cnt == 0) begin
              initiator_tkeep <= set_keep(tkeep_cnt);
              initiator_tlast <= '1;
              state <= FIRST;
            end else begin
              initiator_tkeep <= '1;
              initiator_tlast <= '0;         
            end
          end

        endcase
      end
    end
  end

endmodule
