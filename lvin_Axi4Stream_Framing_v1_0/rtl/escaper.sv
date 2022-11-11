//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
module escaper #(
  parameter logic [7:0] ESCAPE_BYTE = 8'h7F,
  parameter logic [7:0] START_BYTE  = 8'h7D,
  parameter logic [7:0] STOP_BYTE   = 8'h7E
)(
  // Clock and Reset
  logic input         aclk,
  logic input         aresetn,
  // Axi4Stream Target Interface
  logic input         target_tvalid,
  logic output        target_tready,
  logic input [7:0]   target_tdata,
  logic input         target_tlast,
  // Axi4Stream Initiator Interface
  logic output        initiator_tvalid,
  logic input         initiator_tready,
  logic output [7:0]  initiator_tdata,
  logic output        initiator_tlast
);


  //----------------------------------------------------------------------------  
  logic match;
  logic is_from_packet;
  logic istopacket;

  logic insert_tvalid;
  logic insert_tready;

  //----------------------------------------------------------------------------  
  assing match = target_tdata inside {START_BYTE, STOP_BYTE, ESCAPE_BYTE};


  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      is_from_packet <= '1;
    end else begin
      if (target_tvalid && target_tready) begin
        is_from_packet <= '1;
      end
      if (insert_tvalid && insert_tready) begin
        is_from_packet <= '0;
      end
    end
  end


  // Identify bytes to escape
  assign is_to_packet = (target_tvalid && match)

  // Make Insert packet when the transition of packets is found
  assign insert_tvalid = is_from_packet && is_to_packet;
 
  // Mux packet, priority goes to Insert
  assign initiator_tvalid = target_tvalid || insert_tvalid;
  assign initiator_tdata  = insert_tvalid ? ESCAPE_BYTE : target_tdata;
  assign initiator_tlast  = insert_tvalid ? '0          : target_tlast;
  
  // Demux TReady, priority goes to Insert
  assign insert_tready    = insert_tvalid ? initiator_tready : '0;
  assign target_tready    = insert_tvalid ? '0               : initiator_tready;
  

endmodule