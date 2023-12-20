

module axi4s_lfsr #(
  parameter int                     POLY_DEGREE  = 16,                  
  parameter logic [POLY_DEGREE-1:0] POLYNOMIAL   = 16'b0110100000000001,
  parameter logic [POLY_DEGREE-1:0] SEED         = 1,
  parameter int                     TDATA_WIDTH  = 8
)(
  input  logic aclk,
  input  logic aresetn,

  input  logic                    target_tvalid,
  output logic                    target_tready,
  input  logic [TDATA_WIDTH-1:0]  target_tdata,
  input  logic                    target_tlast,

  output logic                    initiator_tvalid,
  input  logic                    initiator_tready,
  output logic [TDATA_WIDTH-1:0]  initiator_tdata,
  output logic                    initiator_tlast
);


  //----------------------------------------------------------------------------
  logic [POLY_DEGREE-1:0] state;
  logic [POLY_DEGREE-1:0] next_state;
  logic [TDATA_WIDTH-1:0] lfsr_data;
 

  //----------------------------------------------------------------------------
  lfsr_core #(
    .POLY_DEGREE   (POLY_DEGREE ),
    .POLYNOMIAL    (POLYNOMIAL  ),
    .OUTPUT_WIDTH  (TDATA_WIDTH)           
  ) i_lfsr_core (
    .state      (state),
    .next_state (next_state),
    .data       (lfsr_data)
  );


  assign target_tready = initiator_tready;


  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      state <= SEED;
      initiator_tvalid <= '0;
      initiator_tdata <= '0;

    end else begin
      if (initiator_tvalid && initiator_tready) begin
        initiator_tvalid <= '0;
      end

      if (target_tready && target_tready) begin
        initiator_tvalid <= '1;
        initiator_tdata <= lfsr_data ^ target_tdata;
        initiator_tlast <= target_tlast;

        state <= next_state;
        if (target_tlast) begin
          state <= SEED;
        end
      end

    end
  end


endmodule
