//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
module deescaper #(
  localparam logic [7:0] ESCAPE_BYTE = 8'h7F,
)(
  // Clock and Reset
  input  logic        aclk,
  input  logic        aresetn,
  // Axi4Stream Target Interface
  input  logic        target_tvalid,
  output logic        target_tready,
  input  logic [7:0]  target_tdata,
  input  logic        target_tlast,
  // Axi4Stream Initiator Interface
  output logic        initiator_tvalid,
  input  logic        initiator_tready,
  output logic [7:0]  initiator_tdata,
  output logic        initiator_tlast
);


  //----------------------------------------------------------------------------
  enum logic [0:0] (REMOVE_ESCAPE, FEED_THROUGH) state;


  //----------------------------------------------------------------------------
  assign target_tready = initiator_tready;


  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      state <= REMOVE_ESCAPE;

    end else begin
      if (target_tvalid && target_tready) begin //TODO: check this
        case (state)
          REMOVE_ESCAPE : begin
            if (target_tdata == ESCAPE_BYTE) begin
              state <= FEED_THROUGH;
            end
          end

          FEED_THROUGH : begin
            state <= REMOVE_ESCAPE;
          end

        endcase
      end
    end
  end


  assign initiator_tvalid = (state == FEED_THROUGH or target_tdata != ESCAPE_BYTE) ? target_tvalid : '0;
  assign initiator_tdata  = target_tdata;
  assign initiator_tlast  = target_tlast;


endmodule