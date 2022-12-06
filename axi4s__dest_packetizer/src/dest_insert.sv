//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module dest_insert (
  // Clock and Reset
  input  logic       aclk,
  input  logic       aresetn,
  // Axi4-Stream Target interface
  input  logic       target_tvalid,
  output logic       target_tready,
  input  logic       target_tlast,
  input  logic [7:0] target_tdata,
  input  logic [2:0] target_tid,
  // Axi4-Stream Initiator interface
  output logic       initiator_tvalid,
  input  logic       initiator_tready,
  output logic       initiator_tlast,
  output logic [7:0] initiator_tdata
);


  //----------------------------------------------------------------------------
  logic is_first;
  enum logic [0:0] {FEEDTHROUGH, INSERT_ID} state, nxt_state;


  //----------------------------------------------------------------------------
  always_ff @ (posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      is_first <= '1;
      state    <= FEEDTHROUGH;

    end else begin
      if (target_tvalid && target_tready) begin
        is_first <= target_tlast;
      end

      if (initiator_tvalid && initiator_tready) begin
        state <= nxt_state;
      end
    end
  end


  always_comb begin
    case (state)
      FEEDTHROUGH : nxt_state = (target_tvalid && is_first) ? INSERT_ID : FEEDTHROUGH;
      INSERT_ID   : nxt_state = FEEDTHROUGH;
    endcase
  end


  assign target_tready    = nxt_state == INSERT_ID ? '0         : initiator_tready;
  assign initiator_tvalid = nxt_state == INSERT_ID ? '1         : target_tvalid;
  assign initiator_tlast  = nxt_state == INSERT_ID ? '0         : target_tlast;
  assign initiator_tdata  = nxt_state == INSERT_ID ? target_tid : target_tdata;
  

endmodule
