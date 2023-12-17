

module framer #(
  parameter bit [7:0] START_BYTE = 8'h7D,
  parameter bit [7:0] STOP_BYTE  = 8'h7E
)(
  // Clock and Reset
  input  logic        aclk,
  input  logic        aresetn,
  // Axi4-Stream Target Interface
  input  logic        target_tvalid,
  output logic        target_tready,
  input  logic [7:0]  target_tdata,
  input  logic        target_tlast,
  // Axi4-Stream Initiator Interface
  output logic        initiator_tvalid,
  input  logic        initiator_tready,
  output logic [7:0]  initiator_tdata
);


  //----------------------------------------------------------------------------
  enum logic [1:0] {INSERT_START, RUNNING, INSERT_STOP} state;


  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      initiator_tvalid <= '0;
      state            <= INSERT_START;

    end else begin
      if (initiator_tvalid && initiator_tready) begin
        initiator_tvalid <= '0;
      end

      case (state)
        INSERT_START : begin
          if (target_tvalid && (!initiator_tvalid || initiator_tready)) begin
            initiator_tvalid <= '1;
            initiator_tdata  <= START_BYTE;
            state            <= RUNNING;
          end
        end

        RUNNING : begin
          if (target_tvalid && target_tready) begin
            initiator_tvalid <= '1;
            initiator_tdata  <= target_tdata;
            if (target_tlast) begin
              state <= INSERT_STOP;
            end
          end
        end

        INSERT_STOP : begin
          if (initiator_tvalid && initiator_tready) begin
            initiator_tvalid <= '1;
            initiator_tdata  <= STOP_BYTE;
            state            <= INSERT_START;
          end
        end

      endcase
    end
  end


  assign target_tready = state == RUNNING ? initiator_tready : '0;


endmodule