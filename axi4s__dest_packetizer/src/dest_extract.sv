//------------------------------------------------------------------------------
// Description:
//    Extracts the TID from incomming AXI4-Stream packets. TID is located on 
//    first TDATA beat of packet.
//------------------------------------------------------------------------------


module dest_extract (
  // Clock and reset
  input  logic       aclk,
  input  logic       aresetn,
  // Axi4-Stream Target interface
  input  logic       target_tvalid,
  output logic       target_tready,
  input  logic       target_tlast,
  input  logic [7:0] target_tdata,
  // Axi4-Stream Initiator interface
  output logic       initiator_tvalid,
  input  logic       initiator_tready,
  output logic       initiator_tlast,
  output logic [7:0] initiator_tdata,
  output logic [2:0] initiator_tid
);
 

  //----------------------------------------------------------------------------
  logic is_first;


  //----------------------------------------------------------------------------
  always_ff @ (posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      is_first      <= '1;
      initiator_tid <= '0;

    end else if (target_tvalid && target_tready) begin
      is_first <= target_tlast;
      
      if (is_first) begin
        initiator_tid <= target_tdata;
      end
    end
  end


  assign initiator_tvalid = is_first ? '0 : target_tvalid;
  assign target_tready    = is_first ? '1 : initiator_tready;
  assign initiator_tlast  = target_tlast;
  assign initiator_tdata  = is_first ? '0 : target_tdata;
  

endmodule
