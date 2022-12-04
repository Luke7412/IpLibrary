//----------------------------------------------------------------------------



//----------------------------------------------------------------------------
module deframer #(
  parameter logic [7:0] ESCAPE_BYTE = 8'h7F,
  parameter logic [7:0] START_BYTE  = 8'h7D,
  parameter logic [7:0] STOP_BYTE   = 8'h7E
)(
  // Clock and Reset
  input  logic        aclk,
  input  logic        aresetn,
  // Axi4-Stream Target Interface
  input  logic        target_tvalid,
  output logic        target_tready,
  input  logic [7:0]  target_tdata ,
  // Axi4-Stream Initiator Interface
  output logic        initiator_tvalid,
  input  logic        initiator_tready,
  output logic [7:0]  initiator_tdata,
  output logic        initiator_tlast
);


  //----------------------------------------------------------------------------
  enum logic [0:0] (REMOVE_START, RUNNING) state;

  logic       int_tvalid;
  logic [7:0] int_tdata;
  logic       is_escape;


  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge areset_n) begin
    if (!AResetn) begin
      initiator_tvalid <= '0;
      int_tvalid       <= '0;
      state            <= REMOVE_START;

    end else begin
      if (!initiator_tvalid || initiator_tready) begin
        initiator_tvalid <= '0;
      end
      
      if (target_tvalid || target_tready) begin
        int_tdata        <= target_tdata;
        initiator_tvalid <= int_tvalid;
        initiator_tdata  <= int_tdata;

        case (state)
          REMOVE_START : begin  
            is_escape <= '0;
            if (target_tdata == START_BYTE) begin
              state <= RUNNING;
            end
          end

          RUNNING : begin
            is_escape <= (target_tdata == ESCAPE_BYTE) ? !is_escape : '0;

            if (target_tdata == STOP_BYTE && !is_escape) begin
              int_tvalid      <= '0;
              initiator_tlast <= '1;
              state           <= REMOVE_START;
            end else begin
              int_tvalid      <= '1;
              initiator_tlast <= '0;
            end
          end
        endcase

      end 
    end
  end


  assign target_tready = initiator_tready || !initiator_tvalid; 


endmodule